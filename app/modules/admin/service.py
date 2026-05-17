import shutil
from pathlib import Path
import tempfile
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.modules.admin.excel.processor import process_excel
from app.database.models.soporte import CargaExcel, CargaExcelDetalle
from app.modules.admin import schemas

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

async def get_staff_users(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()

async def create_staff_user(db: AsyncSession, data: schemas.UserCreate):
    _not_implemented()

async def update_staff_user(db: AsyncSession, user_id: str, data: schemas.UserUpdate):
    _not_implemented()

async def update_staff_user_status(db: AsyncSession, user_id: str, data: schemas.UserStatusUpdate):
    _not_implemented()

async def get_roles(db: AsyncSession, page: int = 1, size: int = 20, sort: str = "fecha_desc"):
    _not_implemented()


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