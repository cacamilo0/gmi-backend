from datetime import datetime
from typing import Optional
from pydantic import BaseModel


class CargaDetalleResponse(BaseModel):
    fila_numero: int
    hoja: str
    estado: str
    mensaje_error: Optional[str]

    class Config:
        from_attributes = True


class CargaExcelResponse(BaseModel):
    id: str
    archivo_nombre: str
    estado: str
    total_gestantes: Optional[int]
    nuevas: Optional[int]
    actualizadas: Optional[int]
    errores: Optional[int]
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class CargaExcelDetalleResponse(CargaExcelResponse):
    detalles: list[CargaDetalleResponse] = []