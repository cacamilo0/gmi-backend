from typing import Optional
from fastapi import APIRouter, Depends, File, UploadFile, status, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.dependencies import get_current_staff
from app.database.models.auth import UsuarioStaff
from app.modules.admin import service
from app.modules.admin import schemas

router = APIRouter()


# ---- 11.1 Usuarios y Roles ----

@router.get("/users", response_model=list[schemas.UserResponse])
async def list_staff(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar staff"""
    return await service.get_staff_users(db, page, size, sort)

@router.post("/users", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
async def create_staff(
    request: schemas.UserCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear staff"""
    return await service.create_staff_user(db, request)

@router.put("/users/{userId}", response_model=schemas.UserResponse)
async def update_staff(
    userId: str,
    request: schemas.UserUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar staff"""
    return await service.update_staff_user(db, userId, request)

@router.patch("/users/{userId}/status", response_model=schemas.UserResponse)
async def update_staff_status(
    userId: str,
    request: schemas.UserStatusUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Activar/desactivar staff"""
    return await service.update_staff_user_status(db, userId, request)

@router.get("/roles", response_model=list[schemas.RoleResponse])
async def list_roles(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar roles"""
    return await service.get_roles(db, page, size, sort)


# ---- 11.2 Carga Masiva Excel ----

@router.post("/upload/gestantes", response_model=schemas.CargaExcelResponse, status_code=status.HTTP_201_CREATED)
async def upload_excel(
    file: UploadFile = File(...),
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Subir Excel (modo: validar_solo | procesar)"""
    return await service.upload_and_process(db, file, staff.id)

@router.get("/upload/gestantes/history", response_model=list[schemas.CargaExcelResponse])
async def list_cargas(
    db: AsyncSession = Depends(get_db),
):
    """Historial de cargas"""
    return await service.get_all_cargas(db)

@router.get("/upload/gestantes/template")
async def download_template(
    staff: UsuarioStaff = Depends(get_current_staff),
):
    """Descargar plantilla Excel"""
    # Placeholder for template download
    return service._not_implemented()

@router.get("/upload/gestantes/{cargaId}", response_model=schemas.CargaExcelResponse)
async def get_carga_status(
    cargaId: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Estado de carga"""
    carga, _ = await service.get_carga_with_details(db, cargaId)
    return carga

@router.get("/upload/gestantes/{cargaId}/detail", response_model=schemas.CargaExcelDetalleResponse)
async def get_carga_detail(
    cargaId: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Detalle fila por fila"""
    carga, detalles = await service.get_carga_with_details(db, cargaId)
    return schemas.CargaExcelDetalleResponse(
        **schemas.CargaExcelResponse.model_validate(carga).model_dump(),
        detalles=[schemas.CargaDetalleResponse.model_validate(d) for d in detalles],
    )


# ---- 11.3 Catálogos ----

@router.get("/catalogs/{catalogName}", response_model=list[schemas.CatalogItemResponse])
async def list_catalog_items(
    catalogName: str,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar ítems"""
    return await service.get_catalog_items(db, catalogName, page, size, sort)

@router.post("/catalogs/{catalogName}", response_model=schemas.CatalogItemResponse, status_code=status.HTTP_201_CREATED)
async def create_catalog_item(
    catalogName: str,
    request: schemas.CatalogItemCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear ítem"""
    return await service.create_catalog_item(db, catalogName, request)

@router.put("/catalogs/{catalogName}/{id}", response_model=schemas.CatalogItemResponse)
async def update_catalog_item(
    catalogName: str,
    id: str,
    request: schemas.CatalogItemUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar ítem"""
    return await service.update_catalog_item(db, catalogName, id, request)

@router.patch("/catalogs/{catalogName}/{id}/status", response_model=schemas.CatalogItemResponse)
async def update_catalog_item_status(
    catalogName: str,
    id: str,
    request: schemas.CatalogItemStatusUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Activar/desactivar ítem"""
    return await service.update_catalog_item_status(db, catalogName, id, request)


# ---- 11.4 Contenido Educativo ----

@router.get("/educational-content", response_model=list[schemas.EducationalContentResponse])
async def list_educational_contents(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar contenidos"""
    return await service.get_educational_contents(db, page, size, sort)

@router.post("/educational-content", response_model=schemas.EducationalContentResponse, status_code=status.HTTP_201_CREATED)
async def create_educational_content(
    request: schemas.EducationalContentCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear contenido"""
    return await service.create_educational_content(db, request)

@router.put("/educational-content/{id}", response_model=schemas.EducationalContentResponse)
async def update_educational_content(
    id: str,
    request: schemas.EducationalContentUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar contenido"""
    return await service.update_educational_content(db, id, request)

@router.patch("/educational-content/{id}/status", response_model=schemas.EducationalContentResponse)
async def update_educational_content_status(
    id: str,
    request: schemas.EducationalContentStatusUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Activar/desactivar"""
    return await service.update_educational_content_status(db, id, request)

@router.get("/educational-categories", response_model=list[schemas.EducationalCategoryResponse])
async def list_educational_categories(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar categorías"""
    return await service.get_educational_categories(db, page, size, sort)

@router.post("/educational-categories", response_model=schemas.EducationalCategoryResponse, status_code=status.HTTP_201_CREATED)
async def create_educational_category(
    request: schemas.EducationalCategoryCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear categoría"""
    return await service.create_educational_category(db, request)

@router.put("/educational-categories/{id}", response_model=schemas.EducationalCategoryResponse)
async def update_educational_category(
    id: str,
    request: schemas.EducationalCategoryUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar categoría"""
    return await service.update_educational_category(db, id, request)

@router.get("/checklist-items", response_model=list[schemas.ChecklistItemResponse])
async def list_checklist_items(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar checklist"""
    return await service.get_checklist_items(db, page, size, sort)

@router.post("/checklist-items", response_model=schemas.ChecklistItemResponse, status_code=status.HTTP_201_CREATED)
async def create_checklist_item(
    request: schemas.ChecklistItemCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear ítem checklist"""
    return await service.create_checklist_item(db, request)

@router.put("/checklist-items/{id}", response_model=schemas.ChecklistItemResponse)
async def update_checklist_item(
    id: str,
    request: schemas.ChecklistItemUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar ítem"""
    return await service.update_checklist_item(db, id, request)

@router.patch("/checklist-items/{id}/status", response_model=schemas.ChecklistItemResponse)
async def update_checklist_item_status(
    id: str,
    request: schemas.ChecklistItemStatusUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Activar/desactivar ítem"""
    return await service.update_checklist_item_status(db, id, request)


# ---- 11.5 Preguntas de Seguimiento ----

@router.get("/follow-up-questions", response_model=list[schemas.FollowUpQuestionResponse])
async def list_follow_up_questions(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar preguntas"""
    return await service.get_follow_up_questions(db, page, size, sort)

@router.post("/follow-up-questions", response_model=schemas.FollowUpQuestionResponse, status_code=status.HTTP_201_CREATED)
async def create_follow_up_question(
    request: schemas.FollowUpQuestionCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Crear pregunta"""
    return await service.create_follow_up_question(db, request)

@router.put("/follow-up-questions/{id}", response_model=schemas.FollowUpQuestionResponse)
async def update_follow_up_question(
    id: str,
    request: schemas.FollowUpQuestionUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar pregunta"""
    return await service.update_follow_up_question(db, id, request)

@router.patch("/follow-up-questions/{id}/status", response_model=schemas.FollowUpQuestionResponse)
async def update_follow_up_question_status(
    id: str,
    request: schemas.FollowUpQuestionStatusUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Activar/desactivar"""
    return await service.update_follow_up_question_status(db, id, request)

@router.get("/follow-up-questions/{id}/options", response_model=list[schemas.QuestionOptionResponse])
async def list_question_options(
    id: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Listar opciones"""
    return await service.get_question_options(db, id)

@router.post("/follow-up-questions/{id}/options", response_model=schemas.QuestionOptionResponse, status_code=status.HTTP_201_CREATED)
async def create_question_option(
    id: str,
    request: schemas.QuestionOptionCreate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Agregar opción"""
    return await service.create_question_option(db, id, request)

@router.put("/follow-up-questions/options/{optionId}", response_model=schemas.QuestionOptionResponse)
async def update_question_option(
    optionId: str,
    request: schemas.QuestionOptionUpdate,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Actualizar opción"""
    return await service.update_question_option(db, optionId, request)

@router.delete("/follow-up-questions/options/{optionId}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_question_option(
    optionId: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Eliminar opción"""
    await service.delete_question_option(db, optionId)


# ---- 11.6 Auditoría y Monitoreo ----

@router.get("/audit-log", response_model=list[schemas.AuditLogResponse])
async def list_audit_log(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    sort: str = "fecha_desc",
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Bitácora de auditoría"""
    return await service.get_audit_logs(db, page, size, sort)

@router.get("/system/health", response_model=schemas.SystemHealthResponse)
async def get_system_health(
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Salud del sistema (auth admin)"""
    return await service.get_system_health(db)


# ---- 11.7 Exportación ----

@router.get("/export/gestantes")
async def export_gestantes(
    format: str = Query("xlsx", pattern="^(xlsx|csv)$"),
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Exportar gestantes"""
    return await service.export_gestantes(db, format)

@router.get("/export/indicators")
async def export_indicators(
    format: str = Query("xlsx", pattern="^(xlsx|csv)$"),
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Exportar indicadores"""
    return await service.export_indicators(db, format)