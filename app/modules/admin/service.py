import shutil
import csv
import io
from pathlib import Path
import tempfile
import uuid
from datetime import datetime

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from openpyxl import Workbook

from app.modules.admin.excel.processor import process_excel
from app.database.models.soporte import CargaExcel, CargaExcelDetalle
from app.database.models.gestante import Gestante
from app.database.models.riesgo import ClasificacionRiesgo
from app.modules.admin import schemas, repository
from app.core.security import hash_password
from app.core.exceptions import NotFoundException, ConflictException

UPLOAD_DIR = Path(tempfile.gettempdir()) / "gmi_uploads"
UPLOAD_DIR.mkdir(exist_ok=True)

ALLOWED_EXTENSIONS = {".xlsx", ".xls"}


# ---- 11.2 Carga Masiva Excel ----

async def upload_and_process(
    db: AsyncSession, file: UploadFile, usuario_id: str
) -> CargaExcel:
    ext = Path(file.filename).suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=f"Formato no soportado '{ext}'. Solo se aceptan archivos .xlsx o .xls.",
        )

    tmp_path = UPLOAD_DIR / f"{usuario_id}_{file.filename}"
    with open(tmp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    try:
        carga = await process_excel(
            db=db,
            file_path=tmp_path,
            archivo_nombre=file.filename,
            usuario_id=usuario_id,
        )
    finally:
        tmp_path.unlink(missing_ok=True)

    return carga


async def get_carga_with_details(
    db: AsyncSession, carga_id: str
) -> tuple[CargaExcel, list[CargaExcelDetalle]]:
    result = await db.execute(
        select(CargaExcel).where(CargaExcel.id == carga_id)
    )
    carga = result.scalar_one_or_none()
    if not carga:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Carga no encontrada.",
        )
    detalles_result = await db.execute(
        select(CargaExcelDetalle).where(CargaExcelDetalle.carga_id == carga_id)
    )
    return carga, detalles_result.scalars().all()


async def get_all_cargas(db: AsyncSession) -> list[CargaExcel]:
    result = await db.execute(
        select(CargaExcel).order_by(CargaExcel.created_at.desc())
    )
    return result.scalars().all()


def _not_implemented():
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Endpoint en construcción / Modelos de BD pendientes",
    )

# ---- 11.1 Usuarios y Roles ----

async def get_staff_users(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc") -> list[schemas.UserResponse]:
    offset = (page - 1) * size
    users = await repository.get_all_staff(db, offset, size)
    return [schemas.UserResponse.model_validate(u) for u in users]


async def create_staff_user(db: AsyncSession, data: schemas.UserCreate) -> schemas.UserResponse:
    existing = await repository.get_staff_by_email(db, data.email)
    if existing:
        raise ConflictException("Ya existe un usuario con ese email.")

    rol = await repository.get_rol_by_id(db, data.rol_id)
    if rol is None:
        raise NotFoundException("Rol no encontrado.")

    user = await repository.create_staff(db, data.nombre, data.email, hash_password(data.password), data.rol_id)
    return schemas.UserResponse.model_validate(user)


async def update_staff_user(db: AsyncSession, user_id: str, data: schemas.UserUpdate) -> schemas.UserResponse:
    if data.rol_id is not None:
        rol = await repository.get_rol_by_id(db, data.rol_id)
        if rol is None:
            raise NotFoundException("Rol no encontrado.")

    user = await repository.update_staff(db, user_id, nombre=data.nombre, rol_id=data.rol_id)
    if user is None:
        raise NotFoundException("Usuario no encontrado.")
    return schemas.UserResponse.model_validate(user)


async def update_staff_user_status(db: AsyncSession, user_id: str, data: schemas.UserStatusUpdate) -> schemas.UserResponse:
    user = await repository.set_staff_status(db, user_id, data.activo)
    if user is None:
        raise NotFoundException("Usuario no encontrado.")
    return schemas.UserResponse.model_validate(user)


async def get_roles(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc") -> list[schemas.RoleResponse]:
    offset = (page - 1) * size
    roles = await repository.get_all_roles(db, offset, size)
    return [schemas.RoleResponse.model_validate(r) for r in roles]


# ---- 11.3 Catálogos ----

def _resolve_catalog(catalog_name: str) -> type:
    model = repository.CATALOG_MAP.get(catalog_name)
    if model is None:
        raise NotFoundException(f"Catálogo '{catalog_name}' no existe. Catálogos válidos: {', '.join(repository.CATALOG_MAP)}")
    return model


async def get_catalog_items(
    db: AsyncSession, catalog_name: str, page: int = 1, size: int = 20
) -> list[schemas.CatalogItemResponse]:
    model = _resolve_catalog(catalog_name)
    offset = (page - 1) * size
    items = await repository.list_catalog_items(db, model, offset, size)
    return [schemas.CatalogItemResponse.model_validate(item) for item in items]


async def create_catalog_item(
    db: AsyncSession, catalog_name: str, data: schemas.CatalogItemCreate
) -> schemas.CatalogItemResponse:
    model = _resolve_catalog(catalog_name)
    payload = data.model_dump(exclude_none=True)
    if "codigo" in payload:
        existing = await repository.get_catalog_item_by_codigo(db, model, payload["codigo"])
        if existing:
            raise ConflictException(f"Ya existe un ítem con codigo '{payload['codigo']}' en {catalog_name}.")
    item = await repository.insert_catalog_item(db, model, payload)
    return schemas.CatalogItemResponse.model_validate(item)


async def update_catalog_item(
    db: AsyncSession, catalog_name: str, item_id: int, data: schemas.CatalogItemUpdate
) -> schemas.CatalogItemResponse:
    model = _resolve_catalog(catalog_name)
    item = await repository.edit_catalog_item(db, model, item_id, data.model_dump(exclude_unset=True))
    if item is None:
        raise NotFoundException("Ítem de catálogo no encontrado.")
    return schemas.CatalogItemResponse.model_validate(item)


async def update_catalog_item_status(
    db: AsyncSession, catalog_name: str, item_id: int, data: schemas.CatalogItemStatusUpdate
) -> schemas.CatalogItemResponse:
    model = _resolve_catalog(catalog_name)
    item = await repository.toggle_catalog_item_status(db, model, item_id, data.activo)
    if item is None:
        raise NotFoundException("Ítem de catálogo no encontrado.")
    return schemas.CatalogItemResponse.model_validate(item)


# ---- 11.4 Contenido Educativo ----

async def get_educational_categories(
    db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"
) -> list[schemas.EducationalCategoryResponse]:
    offset = (page - 1) * size
    items = await repository.get_all_educational_categories(db, offset, limit=size)
    return [schemas.EducationalCategoryResponse.model_validate(c) for c in items]


async def create_educational_category(
    db: AsyncSession, data: schemas.EducationalCategoryCreate
) -> schemas.EducationalCategoryResponse:
    obj = await repository.create_educational_category(
        db,
        nombre=data.nombre,
        descripcion=data.descripcion,
        icono=data.icono,
        orden=data.orden,
    )
    return schemas.EducationalCategoryResponse.model_validate(obj)


async def update_educational_category(
    db: AsyncSession, item_id: int, data: schemas.EducationalCategoryUpdate
) -> schemas.EducationalCategoryResponse:
    obj = await repository.update_educational_category(
        db, item_id,
        nombre=data.nombre,
        descripcion=data.descripcion,
        icono=data.icono,
        orden=data.orden,
    )
    if obj is None:
        raise NotFoundException("Categoría educativa no encontrada.")
    return schemas.EducationalCategoryResponse.model_validate(obj)


async def get_educational_contents(
    db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"
) -> list[schemas.EducationalContentResponse]:
    offset = (page - 1) * size
    items = await repository.get_all_educational_contents(db, offset, limit=size)
    return [schemas.EducationalContentResponse.model_validate(c) for c in items]


async def create_educational_content(
    db: AsyncSession, data: schemas.EducationalContentCreate
) -> schemas.EducationalContentResponse:
    obj = await repository.create_educational_content(
        db,
        categoria_id=data.categoria_id,
        titulo=data.titulo,
        descripcion=data.descripcion,
        tipo_contenido=data.tipo_contenido,
        cuerpo_texto=data.cuerpo_texto,
        url_recurso=data.url_recurso,
        url_imagen=data.url_imagen,
        modulo_id=data.modulo_id,
        semana_eg_inicio=data.semana_eg_inicio,
        semana_eg_fin=data.semana_eg_fin,
        duracion_minutos=data.duracion_minutos,
        orden=data.orden,
    )
    return schemas.EducationalContentResponse.model_validate(obj)


async def update_educational_content(
    db: AsyncSession, item_id: int, data: schemas.EducationalContentUpdate
) -> schemas.EducationalContentResponse:
    obj = await repository.update_educational_content(
        db, item_id,
        categoria_id=data.categoria_id,
        titulo=data.titulo,
        descripcion=data.descripcion,
        tipo_contenido=data.tipo_contenido,
        cuerpo_texto=data.cuerpo_texto,
        url_recurso=data.url_recurso,
        url_imagen=data.url_imagen,
        modulo_id=data.modulo_id,
        semana_eg_inicio=data.semana_eg_inicio,
        semana_eg_fin=data.semana_eg_fin,
        duracion_minutos=data.duracion_minutos,
        orden=data.orden,
    )
    if obj is None:
        raise NotFoundException("Contenido educativo no encontrado.")
    return schemas.EducationalContentResponse.model_validate(obj)


async def update_educational_content_status(
    db: AsyncSession, item_id: int, data: schemas.EducationalContentStatusUpdate
) -> schemas.EducationalContentResponse:
    obj = await repository.set_educational_content_status(db, item_id, data.activo)
    if obj is None:
        raise NotFoundException("Contenido educativo no encontrado.")
    return schemas.EducationalContentResponse.model_validate(obj)


async def get_checklist_items(
    db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"
) -> list[schemas.ChecklistItemResponse]:
    offset = (page - 1) * size
    items = await repository.get_all_checklist_items(db, offset, limit=size)
    return [schemas.ChecklistItemResponse.model_validate(c) for c in items]


async def create_checklist_item(
    db: AsyncSession, data: schemas.ChecklistItemCreate
) -> schemas.ChecklistItemResponse:
    obj = await repository.create_checklist_item(
        db,
        texto=data.texto,
        modulo_id=data.modulo_id,
        semana_eg=data.semana_eg,
        orden=data.orden,
    )
    return schemas.ChecklistItemResponse.model_validate(obj)


async def update_checklist_item(
    db: AsyncSession, item_id: int, data: schemas.ChecklistItemUpdate
) -> schemas.ChecklistItemResponse:
    obj = await repository.update_checklist_item(
        db, item_id,
        texto=data.texto,
        modulo_id=data.modulo_id,
        semana_eg=data.semana_eg,
        orden=data.orden,
    )
    if obj is None:
        raise NotFoundException("Ítem de checklist no encontrado.")
    return schemas.ChecklistItemResponse.model_validate(obj)


async def update_checklist_item_status(
    db: AsyncSession, item_id: int, data: schemas.ChecklistItemStatusUpdate
) -> schemas.ChecklistItemResponse:
    obj = await repository.set_checklist_item_status(db, item_id, data.activo)
    if obj is None:
        raise NotFoundException("Ítem de checklist no encontrado.")
    return schemas.ChecklistItemResponse.model_validate(obj)


# ---- 11.5 Preguntas de Seguimiento ----

async def get_follow_up_questions(
    db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"
) -> list[schemas.FollowUpQuestionResponse]:
    offset = (page - 1) * size
    items = await repository.get_all_followup_questions(db, offset, size)
    return [schemas.FollowUpQuestionResponse.model_validate(q) for q in items]


async def create_follow_up_question(
    db: AsyncSession, data: schemas.FollowUpQuestionCreate
) -> schemas.FollowUpQuestionResponse:
    obj = await repository.create_followup_question(
        db,
        texto_pregunta=data.texto_pregunta,
        tipo_respuesta=data.tipo_respuesta,
        modulo_id=data.modulo_id,
        frecuencia=data.frecuencia,
        es_signo_alarma=data.es_signo_alarma,
        prioridad_alerta_default_id=data.prioridad_alerta_default_id,
        orden=data.orden,
    )
    return schemas.FollowUpQuestionResponse.model_validate(obj)


async def update_follow_up_question(
    db: AsyncSession, item_id: int, data: schemas.FollowUpQuestionUpdate
) -> schemas.FollowUpQuestionResponse:
    obj = await repository.update_followup_question(
        db, item_id,
        texto_pregunta=data.texto_pregunta,
        tipo_respuesta=data.tipo_respuesta,
        modulo_id=data.modulo_id,
        frecuencia=data.frecuencia,
        es_signo_alarma=data.es_signo_alarma,
        prioridad_alerta_default_id=data.prioridad_alerta_default_id,
        orden=data.orden,
    )
    if obj is None:
        raise NotFoundException("Pregunta de seguimiento no encontrada.")
    return schemas.FollowUpQuestionResponse.model_validate(obj)


async def update_follow_up_question_status(
    db: AsyncSession, item_id: int, data: schemas.FollowUpQuestionStatusUpdate
) -> schemas.FollowUpQuestionResponse:
    obj = await repository.set_followup_question_status(db, item_id, data.activo)
    if obj is None:
        raise NotFoundException("Pregunta de seguimiento no encontrada.")
    return schemas.FollowUpQuestionResponse.model_validate(obj)


async def get_question_options(
    db: AsyncSession, question_id: int
) -> list[schemas.QuestionOptionResponse]:
    items = await repository.get_options_by_question_id(db, question_id)
    return [schemas.QuestionOptionResponse.model_validate(o) for o in items]


async def create_question_option(
    db: AsyncSession, question_id: int, data: schemas.QuestionOptionCreate
) -> schemas.QuestionOptionResponse:
    obj = await repository.create_option(
        db,
        pregunta_id=question_id,
        texto_opcion=data.texto_opcion,
        valor_numerico=data.valor_numerico,
        es_alarma=data.es_alarma,
        prioridad_alerta_id=data.prioridad_alerta_id,
        orden=data.orden,
    )
    return schemas.QuestionOptionResponse.model_validate(obj)


async def update_question_option(
    db: AsyncSession, option_id: int, data: schemas.QuestionOptionUpdate
) -> schemas.QuestionOptionResponse:
    obj = await repository.update_option(
        db, option_id,
        texto_opcion=data.texto_opcion,
        valor_numerico=data.valor_numerico,
        es_alarma=data.es_alarma,
        prioridad_alerta_id=data.prioridad_alerta_id,
        orden=data.orden,
    )
    if obj is None:
        raise NotFoundException("Opción no encontrada.")
    return schemas.QuestionOptionResponse.model_validate(obj)


async def delete_question_option(
    db: AsyncSession, option_id: int
) -> None:
    deleted = await repository.delete_option(db, option_id)
    if not deleted:
        raise NotFoundException("Opción no encontrada.")


# ---- 11.6 Auditoría y Monitoreo ----

async def get_audit_logs(
    db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"
) -> list[schemas.AuditLogResponse]:
    offset = (page - 1) * size
    items = await repository.get_all_audit_logs(db, offset, size, sort)
    return [schemas.AuditLogResponse.model_validate(a) for a in items]


async def get_system_health(db: AsyncSession) -> schemas.SystemHealthResponse:
    try:
        await db.execute(select(1))
        db_status = "connected"
    except Exception:
        db_status = "disconnected"
    return schemas.SystemHealthResponse(
        status="ok",
        database=db_status,
        version="1.0",
        uptime="running",
    )


# ---- 11.7 Exportación ----

async def export_gestantes(db: AsyncSession, format: str = "xlsx") -> bytes:
    result = await db.execute(select(Gestante).order_by(Gestante.created_at.desc()))
    gestantes = result.scalars().all()

    rows = []
    for g in gestantes:
        rows.append({
            "codigo_gmi": g.codigo_gmi,
            "fecha_nacimiento": str(g.fecha_nacimiento) if g.fecha_nacimiento else "",
            "fecha_ultima_menstruacion": str(g.fecha_ultima_menstruacion) if g.fecha_ultima_menstruacion else "",
            "fecha_probable_parto": str(g.fecha_probable_parto) if g.fecha_probable_parto else "",
            "tipo_regimen": g.tipo_regimen or "",
            "anio_ingreso": g.anio_ingreso,
            "semanas_eg_ingreso": g.semanas_eg_ingreso or "",
            "activa": "Sí" if g.activa else "No",
            "modulo_activo_id": g.modulo_activo_id or "",
            "created_at": str(g.created_at) if g.created_at else "",
        })

    if format == "csv":
        return _rows_to_csv(rows)
    return _rows_to_xlsx(rows, "Gestantes")


async def export_indicators(db: AsyncSession, format: str = "xlsx") -> bytes:
    total = await db.scalar(select(func.count(Gestante.id)))
    activas = await db.scalar(select(func.count(Gestante.id)).where(Gestante.activa == True))

    riesgo_counts = await db.execute(
        select(ClasificacionRiesgo.tipo_riesgo, func.count(ClasificacionRiesgo.id))
        .group_by(ClasificacionRiesgo.tipo_riesgo)
    )
    riesgo_rows = []
    for tipo, cnt in riesgo_counts:
        riesgo_rows.append({"indicador": f"Gestantes riesgo {tipo}", "valor": cnt})

    rows = [
        {"indicador": "Total gestantes", "valor": total or 0},
        {"indicador": "Gestantes activas", "valor": activas or 0},
    ] + riesgo_rows

    if format == "csv":
        return _rows_to_csv(rows)
    return _rows_to_xlsx(rows, "Indicadores")


def _rows_to_xlsx(rows: list[dict], sheet_name: str) -> bytes:
    wb = Workbook()
    ws = wb.active
    ws.title = sheet_name
    if rows:
        ws.append(list(rows[0].keys()))
        for row in rows:
            ws.append(list(row.values()))
    buf = io.BytesIO()
    wb.save(buf)
    buf.seek(0)
    return buf.getvalue()


def _rows_to_csv(rows: list[dict]) -> bytes:
    buf = io.StringIO()
    if rows:
        writer = csv.DictWriter(buf, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)
    return buf.getvalue().encode("utf-8-sig")