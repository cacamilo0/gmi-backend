import shutil
from pathlib import Path
import tempfile
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.modules.admin.excel.processor import process_excel
from app.database.models.soporte import CargaExcel, CargaExcelDetalle
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

async def get_catalog_items(db: AsyncSession, catalog_name: str, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_catalog_item(db: AsyncSession, catalog_name: str, data: schemas.CatalogItemCreate):
    _not_implemented()

async def update_catalog_item(db: AsyncSession, catalog_name: str, item_id: str, data: schemas.CatalogItemUpdate):
    _not_implemented()

async def update_catalog_item_status(db: AsyncSession, catalog_name: str, item_id: str, data: schemas.CatalogItemStatusUpdate):
    _not_implemented()


# ---- 11.4 Contenido Educativo ----

async def get_educational_contents(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_educational_content(db: AsyncSession, data: schemas.EducationalContentCreate):
    _not_implemented()

async def update_educational_content(db: AsyncSession, item_id: str, data: schemas.EducationalContentUpdate):
    _not_implemented()

async def update_educational_content_status(db: AsyncSession, item_id: str, data: schemas.EducationalContentStatusUpdate):
    _not_implemented()

async def get_educational_categories(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_educational_category(db: AsyncSession, data: schemas.EducationalCategoryCreate):
    _not_implemented()

async def update_educational_category(db: AsyncSession, item_id: str, data: schemas.EducationalCategoryUpdate):
    _not_implemented()

async def get_checklist_items(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_checklist_item(db: AsyncSession, data: schemas.ChecklistItemCreate):
    _not_implemented()

async def update_checklist_item(db: AsyncSession, item_id: str, data: schemas.ChecklistItemUpdate):
    _not_implemented()

async def update_checklist_item_status(db: AsyncSession, item_id: str, data: schemas.ChecklistItemStatusUpdate):
    _not_implemented()


# ---- 11.5 Preguntas de Seguimiento ----

async def get_follow_up_questions(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_follow_up_question(db: AsyncSession, data: schemas.FollowUpQuestionCreate):
    _not_implemented()

async def update_follow_up_question(db: AsyncSession, item_id: str, data: schemas.FollowUpQuestionUpdate):
    _not_implemented()

async def update_follow_up_question_status(db: AsyncSession, item_id: str, data: schemas.FollowUpQuestionStatusUpdate):
    _not_implemented()

async def get_question_options(db: AsyncSession, question_id: str):
    _not_implemented()

async def create_question_option(db: AsyncSession, question_id: str, data: schemas.QuestionOptionCreate):
    _not_implemented()

async def update_question_option(db: AsyncSession, option_id: str, data: schemas.QuestionOptionUpdate):
    _not_implemented()

async def delete_question_option(db: AsyncSession, option_id: str):
    _not_implemented()


# ---- 11.6 Auditoría y Monitoreo ----

async def get_audit_logs(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def get_system_health(db: AsyncSession):
    _not_implemented()


# ---- 11.7 Exportación ----

async def export_gestantes(db: AsyncSession, format: str = "xlsx"):
    _not_implemented()

async def export_indicators(db: AsyncSession, format: str = "xlsx"):
    _not_implemented()