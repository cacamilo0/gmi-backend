from sqlmodel import SQLModel, Field

class CatModuloClinico(SQLModel, table=True):
    __tablename__ = "cat_modulo_clinico"
    __table_args__ = {"schema": "gmi_catalogo"}

    id: int | None = Field(default=None, primary_key=True)
    codigo: str = Field(max_length=5, unique=True)
    nombre: str = Field(max_length=100)
    semana_eg_inicio: int | None = None
    semana_eg_fin: int | None = None
    descripcion: str | None = None
    activo: bool = Field(default=True)