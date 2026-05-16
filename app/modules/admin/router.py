from fastapi import APIRouter, Depends, File, UploadFile, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.dependencies import get_current_staff
from app.database.models.auth import UsuarioStaff
from app.modules.admin import service
from app.modules.admin.schemas import CargaExcelResponse, CargaExcelDetalleResponse, CargaDetalleResponse

router = APIRouter()


@router.post(
    "/upload",
    response_model=CargaExcelResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Cargar archivo Excel de gestantes",
    description=(
        "Sube un archivo .xlsx con el formato de la plantilla GMI. "
        "Procesa las hojas: gestantes, controles, exámenes, ecografías, "
        "vacunas, remisiones y desenlaces. Retorna el resumen de la carga."
    ),
)
async def upload_excel(
    file: UploadFile = File(...),
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    # return await service.upload_and_process(db, file, "a1b2c3d4-0000-0000-0000-000000000001")
    return await service.upload_and_process(db, file, staff.id)


@router.get(
    "/",
    response_model=list[CargaExcelResponse],
    summary="Historial de cargas masivas",
    description="Lista todas las cargas de Excel realizadas, ordenadas por fecha descendente.",
)
async def list_cargas(
    # staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    return await service.get_all_cargas(db)


@router.get(
    "/{carga_id}",
    response_model=CargaExcelDetalleResponse,
    summary="Detalle de una carga",
    description="Retorna el resumen y el detalle fila a fila de una carga específica, incluyendo errores.",
)
async def get_carga_detail(
    carga_id: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    carga, detalles = await service.get_carga_with_details(db, carga_id)
    return CargaExcelDetalleResponse(
        **CargaExcelResponse.model_validate(carga).model_dump(),
        detalles=[CargaDetalleResponse.model_validate(d) for d in detalles],
    )