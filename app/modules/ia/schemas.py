from datetime import datetime
from sqlmodel import SQLModel


# ---- Chat ----

class ChatMessageRequest(SQLModel):
    mensaje: str


class ChatMessageResponse(SQLModel):
    id: str
    rol: str
    contenido: str
    created_at: datetime


class ChatHistoryResponse(SQLModel):
    mensajes: list[ChatMessageResponse]
    total: int


# ---- Risk Summary ----

class RiskSummaryResponse(SQLModel):
    assessment_id: str
    nivel_riesgo: str
    resumen: str
    factores_riesgo: list[str]
    recomendaciones: list[str]
    explicacion_ia: str
    semana_gestacion: int


# ---- Recommendations ----

class RecommendationResponse(SQLModel):
    semana_gestacion: int
    modulo: str
    recomendaciones: list[str]
    mensaje_motivacional: str


# ---- Triage ----

class TriageRequest(SQLModel):
    sintomas: list[str]
    respuestas_recientes: list[str] | None = None


class TriageResponse(SQLModel):
    nivel_urgencia: str        # inmediata, urgente, no_urgente
    descripcion: str
    acciones_recomendadas: list[str]
    requiere_llamada_emergencia: bool


# ---- Clinical Summary (para staff) ----

class ClinicalSummaryResponse(SQLModel):
    codigo_gmi: str
    semana_gestacion: int
    modulo_activo: str
    resumen_clinico: str
    alertas_activas: int
    puntos_clave: list[str]
    sugerencias_clinico: list[str]


# ---- Explainability ----

class ExplainabilityResponse(SQLModel):
    assessment_id: str
    nivel_riesgo: str
    explicacion: str
    factores_determinantes: list[str]
    datos_utilizados: list[str]