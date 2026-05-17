from datetime import datetime
from typing import Optional, Any
from pydantic import BaseModel


# ---- 11.2 Carga Masiva Excel ----
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


# ---- 11.1 Usuarios y Roles ----

class RoleResponse(BaseModel):
    id: str
    nombre: str
    descripcion: Optional[str] = None
    
    class Config:
        from_attributes = True

class UserCreate(BaseModel):
    email: str
    nombres: str
    apellidos: str
    rol_id: str
    password: str

class UserUpdate(BaseModel):
    nombres: Optional[str] = None
    apellidos: Optional[str] = None
    rol_id: Optional[str] = None

class UserStatusUpdate(BaseModel):
    activo: bool

class UserResponse(BaseModel):
    id: str
    email: str
    nombres: str
    apellidos: str
    rol_id: str
    activo: bool
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


# ---- 11.3 Catálogos ----

class CatalogItemCreate(BaseModel):
    codigo: str
    nombre: str
    descripcion: Optional[str] = None

class CatalogItemUpdate(BaseModel):
    nombre: Optional[str] = None
    descripcion: Optional[str] = None

class CatalogItemStatusUpdate(BaseModel):
    activo: bool

class CatalogItemResponse(BaseModel):
    id: str
    codigo: str
    nombre: str
    descripcion: Optional[str] = None
    activo: bool

    class Config:
        from_attributes = True


# ---- 11.4 Contenido Educativo ----

class EducationalCategoryCreate(BaseModel):
    nombre: str
    descripcion: Optional[str] = None

class EducationalCategoryUpdate(BaseModel):
    nombre: Optional[str] = None
    descripcion: Optional[str] = None

class EducationalCategoryResponse(BaseModel):
    id: str
    nombre: str
    descripcion: Optional[str] = None

    class Config:
        from_attributes = True

class EducationalContentCreate(BaseModel):
    titulo: str
    tipo: str # video, articulo, infografia
    url: str
    categoria_id: str
    semana_gestacional_min: Optional[int] = None
    semana_gestacional_max: Optional[int] = None

class EducationalContentUpdate(BaseModel):
    titulo: Optional[str] = None
    tipo: Optional[str] = None
    url: Optional[str] = None
    categoria_id: Optional[str] = None
    semana_gestacional_min: Optional[int] = None
    semana_gestacional_max: Optional[int] = None

class EducationalContentStatusUpdate(BaseModel):
    activo: bool

class EducationalContentResponse(BaseModel):
    id: str
    titulo: str
    tipo: str
    url: str
    categoria_id: str
    semana_gestacional_min: Optional[int] = None
    semana_gestacional_max: Optional[int] = None
    activo: bool

    class Config:
        from_attributes = True

class ChecklistItemCreate(BaseModel):
    texto: str
    categoria: str

class ChecklistItemUpdate(BaseModel):
    texto: Optional[str] = None
    categoria: Optional[str] = None

class ChecklistItemStatusUpdate(BaseModel):
    activo: bool

class ChecklistItemResponse(BaseModel):
    id: str
    texto: str
    categoria: str
    activo: bool

    class Config:
        from_attributes = True


# ---- 11.5 Preguntas de Seguimiento ----

class FollowUpQuestionCreate(BaseModel):
    texto: str
    tipo: str # unica, multiple, abierta
    modulo_id: Optional[int] = None

class FollowUpQuestionUpdate(BaseModel):
    texto: Optional[str] = None
    tipo: Optional[str] = None
    modulo_id: Optional[int] = None

class FollowUpQuestionStatusUpdate(BaseModel):
    activo: bool

class FollowUpQuestionResponse(BaseModel):
    id: str
    texto: str
    tipo: str
    modulo_id: Optional[int] = None
    activo: bool

    class Config:
        from_attributes = True

class QuestionOptionCreate(BaseModel):
    texto: str
    valor: str
    alerta: bool = False

class QuestionOptionUpdate(BaseModel):
    texto: Optional[str] = None
    valor: Optional[str] = None
    alerta: Optional[bool] = None

class QuestionOptionResponse(BaseModel):
    id: str
    pregunta_id: str
    texto: str
    valor: str
    alerta: bool

    class Config:
        from_attributes = True


# ---- 11.6 Auditoría y Monitoreo ----

class AuditLogResponse(BaseModel):
    id: str
    usuario_id: str
    accion: str
    entidad: str
    entidad_id: Optional[str] = None
    detalles: Optional[Any] = None
    created_at: datetime

    class Config:
        from_attributes = True

class SystemHealthResponse(BaseModel):
    status: str
    database: str
    version: str
    uptime: str