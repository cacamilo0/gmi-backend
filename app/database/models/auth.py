import uuid
from datetime import datetime

from sqlmodel import SQLModel, Field


class Rol(SQLModel, table=True):
    __tablename__ = "rol"
    __table_args__ = {"schema": "gmi_auth"}

    id: int | None = Field(default=None, primary_key=True)
    nombre: str = Field(max_length=50, unique=True)
    descripcion: str | None = None
    activo: bool = Field(default=True)


class UsuarioStaff(SQLModel, table=True):
    __tablename__ = "usuario_staff"
    __table_args__ = {"schema": "gmi_auth"}

    id: str = Field(default_factory=lambda: str(uuid.uuid4()), primary_key=True)
    nombre: str = Field(max_length=100)
    email: str = Field(max_length=100, unique=True)
    hash_password: str = Field(max_length=256)
    rol_id: int = Field(foreign_key="gmi_auth.rol.id")
    ips_id: int | None = None # TODO: fk a cat_ips cuando se cree
    activo: bool = Field(default=True)
    ultimo_acceso: datetime | None = None
    created_at: datetime | None = Field(default_factory=datetime.utcnow)