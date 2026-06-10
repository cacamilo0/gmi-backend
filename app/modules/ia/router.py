from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.database.models.gestante import Gestante
from app.database.models.auth import UsuarioStaff
from app.dependencies import get_current_gestante, get_current_staff
from app.modules.ia import service
from app.modules.ia.schemas import (
    ChatMessageRequest,
    ChatMessageResponse,
    ChatHistoryResponse,
    RiskSummaryResponse,
    RecommendationResponse,
    TriageRequest,
    TriageResponse,
    ClinicalSummaryResponse,
    ExplainabilityResponse,
)
from app.modules.m0.repository import get_gestante_by_id

router = APIRouter()


# ---- Chat ----

@router.post("/chat", response_model=ChatMessageResponse)
async def send_message(
    request: ChatMessageRequest,
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Enviar mensaje al asistente conversacional de IA con memoria del caso clínico."""
    return await service.send_chat_message(db, gestante, request.mensaje)


@router.get("/chat/history", response_model=ChatHistoryResponse)
async def get_chat_history(
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Obtener historial de conversación con el asistente de IA."""
    return await service.get_chat_history(db, gestante.id)


@router.delete("/chat/history")
async def delete_chat_history(
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Limpiar historial de conversación."""
    return await service.delete_chat_history(db, gestante.id)


# ---- Risk Summary ----

@router.get("/risk-summary", response_model=RiskSummaryResponse)
async def get_risk_summary(
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Resumen general de riesgo generado por IA con explicación."""
    return await service.get_risk_summary(db, gestante)


# ---- Recommendations ----

@router.get("/recommendations", response_model=RecommendationResponse)
async def get_recommendations(
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Recomendaciones personalizadas de IA según el contexto clínico actual."""
    return await service.get_recommendations(db, gestante)


# ---- Triage ----

@router.post("/triage", response_model=TriageResponse)
async def run_triage(
    request: TriageRequest,
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Pre-triage automático basado en síntomas y respuestas de seguimiento."""
    return await service.run_triage(db, gestante, request)


# ---- Clinical Summary (staff) ----

@router.get("/clinical-summary/{codigo_gmi}", response_model=ClinicalSummaryResponse)
async def get_clinical_summary(
    codigo_gmi: str,
    staff: UsuarioStaff = Depends(get_current_staff),
    db: AsyncSession = Depends(get_db),
):
    """Resumen clínico de una gestante generado por IA. Solo para personal autorizado."""
    from app.modules.m0 import repository as m0_repo
    gestante = await m0_repo.get_gestante_by_codigo(db, codigo_gmi)
    if gestante is None:
        from app.core.exceptions import NotFoundException
        raise NotFoundException("Gestante no encontrada")
    return await service.get_clinical_summary(db, gestante)


# ---- Explainability ----

@router.get("/explainability/{assessment_id}", response_model=ExplainabilityResponse)
async def get_explainability(
    assessment_id: str,
    gestante: Gestante = Depends(get_current_gestante),
    db: AsyncSession = Depends(get_db),
):
    """Explicación detallada de una clasificación de riesgo específica."""
    return await service.get_explainability(db, gestante, assessment_id)