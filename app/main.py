from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.exceptions import GMIException, gmi_exception_handler
from app.config import settings
import app.database.base # noqa: F401 - carga todos los modelos al iniciar

@asynccontextmanager
async def lifespan(app: FastAPI):
    print(f"{settings.APP_NAME} v{settings.APP_VERSION} iniciando...")
    yield
    print(f"{settings.APP_NAME} detenido.")

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="API REST para el seguimiento médico integral de gestantes",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# registrar exception handler
app.add_exception_handler(GMIException, gmi_exception_handler)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/v1/health", tags=["Health"])
async def health_check():
    return {"status": "ok", "app": settings.APP_NAME, "version": settings.APP_VERSION}


# routers
from app.modules.auth.router import router as auth_router
from app.modules.m0.router import router as m0_router
from app.modules.m4.router import router as m4_router

app.include_router(auth_router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(m0_router, prefix="/api/v1/m0", tags=["M0 - Registro y Perfil"])
app.include_router(m4_router, prefix="/api/v1/m4", tags=["M4 - Seguimiento Clínico"])