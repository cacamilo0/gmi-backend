import shutil
from pathlib import Path
import tempfile
import tempfile

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.modules.admin.excel.processor import process_excel
from app.database.models.soporte import CargaExcel, CargaExcelDetalle

UPLOAD_DIR = Path(tempfile.gettempdir()) / "gmi_uploads"
UPLOAD_DIR.mkdir(exist_ok=True)

ALLOWED_EXTENSIONS = {".xlsx", ".xls"}


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