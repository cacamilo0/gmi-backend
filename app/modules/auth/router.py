from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_db
from app.dependencies import get_current_user
from app.modules.auth import service
from app.modules.auth.schemas import (
    GestanteLoginRequest,
    StaffLoginRequest,
    TokenResponse,
    RefreshTokenRequest,
    SecurityQuestionResponse,
    PasswordResetRequest,
    PasswordResetConfirm,
)

router = APIRouter()

@router.post("/login", response_model=TokenResponse)
async def login_gestante(
    request: GestanteLoginRequest,
    db: AsyncSession = Depends(get_db),
):
    return await service.login_gestante(db, request.codigo_gmi, request.respuesta_seguridad)

@router.post("/login/staff", response_model=TokenResponse)
async def login_staff(
    request: StaffLoginRequest,
    db: AsyncSession = Depends(get_db),
):
    return await service.login_staff(db, request.email, request.password)

@router.post("/logout")
async def logout(user: dict = Depends(get_current_user)):
    return {"detail": "Sesión cerrada exitosamente"}

@router.post("/refresh-token", response_model=TokenResponse)
async def refresh_token(
    request: RefreshTokenRequest,
    db: AsyncSession = Depends(get_db),
):
    return await service.refresh_access_token(db, request.refresh_token)

@router.get("/security-question/{codigo_gmi}", response_model=SecurityQuestionResponse)
async def get_security_question(
    codigo_gmi: str,
    db: AsyncSession = Depends(get_db),
):
    return await service.get_security_question(db, codigo_gmi)

@router.post("/password/reset-request")
async def request_password_reset(
    request: PasswordResetRequest,
    db: AsyncSession = Depends(get_db),
):
    # todo: implementar envío de email con token de reset
    return {"detail": "Si el email existe, recibirás instrucciones de restablecimiento"}

@router.post("/password/reset")
async def confirm_password_reset(
    request: PasswordResetConfirm,
    db: AsyncSession = Depends(get_db),
):
    """Confirmar restablecimiento de contraseña con token."""
    # todo: implementar verificación de token y cambio de contraseña
    return {"detail": "Contraseña restablecida exitosamente"}