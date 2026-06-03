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
    id: int
    nombre: str
    descripcion: Optional[str] = None

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    email: str
    nombre: str
    rol_id: int
    password: str


class UserUpdate(BaseModel):
    nombre: Optional[str] = None
    rol_id: Optional[int] = None


class UserStatusUpdate(BaseModel):
    activo: bool


class UserResponse(BaseModel):
    id: str
    email: str
    nombre: str
    rol_id: int
    activo: bool
    created_at: Optional[datetime] = None

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
    icono: Optional[str] = None
    orden: Optional[int] = None

class EducationalCategoryUpdate(BaseModel):
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    icono: Optional[str] = None
    orden: Optional[int] = None

class EducationalCategoryResponse(BaseModel):
    id: int
    nombre: str
    descripcion: Optional[str] = None
    icono: Optional[str] = None
    orden: Optional[int] = None
    activo: bool

    class Config:
        from_attributes = True

class EducationalContentCreate(BaseModel):
    categoria_id: Optional[int] = None
    titulo: str
    descripcion: Optional[str] = None
    tipo_contenido: Optional[str] = None
    cuerpo_texto: Optional[str] = None
    url_recurso: Optional[str] = None
    url_imagen: Optional[str] = None
    modulo_id: Optional[int] = None
    semana_eg_inicio: Optional[int] = None
    semana_eg_fin: Optional[int] = None
    duracion_minutos: Optional[int] = None
    orden: Optional[int] = None

class EducationalContentUpdate(BaseModel):
    categoria_id: Optional[int] = None
    titulo: Optional[str] = None
    descripcion: Optional[str] = None
    tipo_contenido: Optional[str] = None
    cuerpo_texto: Optional[str] = None
    url_recurso: Optional[str] = None
    url_imagen: Optional[str] = None
    modulo_id: Optional[int] = None
    semana_eg_inicio: Optional[int] = None
    semana_eg_fin: Optional[int] = None
    duracion_minutos: Optional[int] = None
    orden: Optional[int] = None

class EducationalContentStatusUpdate(BaseModel):
    activo: bool

class EducationalContentResponse(BaseModel):
    id: int
    categoria_id: Optional[int] = None
    titulo: str
    descripcion: Optional[str] = None
    tipo_contenido: Optional[str] = None
    cuerpo_texto: Optional[str] = None
    url_recurso: Optional[str] = None
    url_imagen: Optional[str] = None
    modulo_id: Optional[int] = None
    semana_eg_inicio: Optional[int] = None
    semana_eg_fin: Optional[int] = None
    duracion_minutos: Optional[int] = None
    orden: Optional[int] = None
    activo: bool
    created_at: Optional[datetime] = None
    created_by: Optional[str] = None

    class Config:
        from_attributes = True

class ChecklistItemCreate(BaseModel):
    texto: str
    modulo_id: Optional[int] = None
    semana_eg: Optional[int] = None
    orden: Optional[int] = None

class ChecklistItemUpdate(BaseModel):
    texto: Optional[str] = None
    modulo_id: Optional[int] = None
    semana_eg: Optional[int] = None
    orden: Optional[int] = None

class ChecklistItemStatusUpdate(BaseModel):
    activo: bool

class ChecklistItemResponse(BaseModel):
    id: int
    texto: str
    modulo_id: Optional[int] = None
    semana_eg: Optional[int] = None
    orden: Optional[int] = None
    activo: bool

    class Config:
        from_attributes = True


# ---- 11.5 Preguntas de Seguimiento ----

class FollowUpQuestionCreate(BaseModel):
    texto_pregunta: str
    tipo_respuesta: str
    modulo_id: Optional[int] = None
    frecuencia: Optional[str] = None
    es_signo_alarma: bool = False
    prioridad_alerta_default_id: Optional[int] = None
    orden: Optional[int] = None

class FollowUpQuestionUpdate(BaseModel):
    texto_pregunta: Optional[str] = None
    tipo_respuesta: Optional[str] = None
    modulo_id: Optional[int] = None
    frecuencia: Optional[str] = None
    es_signo_alarma: Optional[bool] = None
    prioridad_alerta_default_id: Optional[int] = None
    orden: Optional[int] = None

class FollowUpQuestionStatusUpdate(BaseModel):
    activo: bool

class FollowUpQuestionResponse(BaseModel):
    id: int
    texto_pregunta: str
    tipo_respuesta: str
    modulo_id: Optional[int] = None
    frecuencia: Optional[str] = None
    es_signo_alarma: bool
    prioridad_alerta_default_id: Optional[int] = None
    orden: Optional[int] = None
    activo: bool

    class Config:
        from_attributes = True

class QuestionOptionCreate(BaseModel):
    texto_opcion: str
    valor_numerico: Optional[int] = None
    es_alarma: bool = False
    prioridad_alerta_id: Optional[int] = None
    orden: Optional[int] = None

class QuestionOptionUpdate(BaseModel):
    texto_opcion: Optional[str] = None
    valor_numerico: Optional[int] = None
    es_alarma: Optional[bool] = None
    prioridad_alerta_id: Optional[int] = None
    orden: Optional[int] = None

class QuestionOptionResponse(BaseModel):
    id: int
    pregunta_id: int
    texto_opcion: str
    valor_numerico: Optional[int] = None
    es_alarma: bool
    prioridad_alerta_id: Optional[int] = None
    orden: Optional[int] = None

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