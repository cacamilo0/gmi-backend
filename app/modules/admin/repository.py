"""
Operaciones de escritura en BD para el pipeline de carga masiva.
"""
import uuid
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database.models.gestante import Gestante
from app.database.models.perfil import FormulaObstetrica
from app.database.models.control import ControlPrenatal, SignosVitales
from app.database.models.examenes import ExamenLaboratorio, Ecografia
from app.database.models.complementarios import Vacunacion, RemisionInterdisciplinaria
from app.database.models.desenlace import Parto, RecienNacido, AnticoncepcionPosparto
from app.database.models.riesgo import ClasificacionRiesgo
from app.database.models.soporte import CargaExcel, CargaExcelDetalle


# gestante

async def upsert_gestante(
    db: AsyncSession, data: dict, formula: dict
) -> str:
    """Inserta o actualiza la gestante. Retorna 'nueva' o 'actualizada'."""
    codigo_gmi = data.get("codigo_gmi")
    existing = None

    if codigo_gmi:
        result = await db.execute(
            select(Gestante).where(Gestante.codigo_gmi == codigo_gmi)
        )
        existing = result.scalar_one_or_none()

    if existing:
        for k, v in data.items():
            if v is not None:
                setattr(existing, k, v)
        db.add(existing)
        await db.flush()
        gestante_id = existing.id
        accion = "actualizada"
    else:
        gestante = Gestante(**data)
        db.add(gestante)
        await db.flush()
        gestante_id = gestante.id
        accion = "nueva"

    # fórmula obstétrica (upsert)
    res_f = await db.execute(
        select(FormulaObstetrica).where(FormulaObstetrica.gestante_id == gestante_id)
    )
    fo = res_f.scalar_one_or_none()
    if fo:
        for k, v in formula.items():
            setattr(fo, k, v)
    else:
        fo = FormulaObstetrica(gestante_id=gestante_id, **formula)
    db.add(fo)
    await db.commit()

    return accion


async def get_gestante_map(db: AsyncSession) -> dict[str, str]:
    """Retorna {codigo_gmi: id} para todas las gestantes."""
    result = await db.execute(select(Gestante.codigo_gmi, Gestante.id))
    return {row.codigo_gmi: row.id for row in result.all()}



# control prenatal

async def insert_control(
    db: AsyncSession,
    gestante_id: str,
    control_data: dict,
    signos_data: dict,
    riesgo_obs: str | None,
    dx_riesgo: str | None,
    riesgo_bio: str | None,
    sit_bio: str | None,
):
    control = ControlPrenatal(gestante_id=gestante_id, **control_data)
    db.add(control)
    await db.flush()

    signos = SignosVitales(control_prenatal_id=control.id, **signos_data)
    db.add(signos)

    if riesgo_obs:
        cr_obs = ClasificacionRiesgo(
            gestante_id=gestante_id,
            control_prenatal_id=control.id,
            tipo_riesgo="obstetrico",
            nivel=riesgo_obs.lower(),
            diagnostico_texto=dx_riesgo,
        )
        db.add(cr_obs)

    if riesgo_bio:
        cr_bio = ClasificacionRiesgo(
            gestante_id=gestante_id,
            control_prenatal_id=control.id,
            tipo_riesgo="biosicosocial",
            nivel=riesgo_bio.lower(),
            situaciones_biosicosocial=sit_bio,
        )
        db.add(cr_bio)

    await db.commit()


# exámenes

async def insert_examen(db: AsyncSession, gestante_id: str, data: dict):
    examen = ExamenLaboratorio(gestante_id=gestante_id, **data)
    db.add(examen)
    await db.commit()


# ecografías

async def insert_ecografia(db: AsyncSession, gestante_id: str, data: dict):
    eco = Ecografia(gestante_id=gestante_id, **data)
    db.add(eco)
    await db.commit()


# vacunas

async def insert_vacuna(db: AsyncSession, gestante_id: str, data: dict):
    vac = Vacunacion(gestante_id=gestante_id, **data)
    db.add(vac)
    await db.commit()


# remisiones

async def insert_remision(db: AsyncSession, gestante_id: str, data: dict):
    rem = RemisionInterdisciplinaria(gestante_id=gestante_id, **data)
    db.add(rem)
    await db.commit()


# desenlaces  

async def insert_desenlace(
    db: AsyncSession,
    gestante_id: str,
    parto_data: dict,
    rn_data: dict,
    anticoncepcion_data: dict,
):
    result = await db.execute(
        select(Parto).where(Parto.gestante_id == gestante_id)
    )
    parto = result.scalar_one_or_none()

    if parto:
        # Actualizar campos del parto existente
        for k, v in parto_data.items():
            setattr(parto, k, v)
    else:
        parto = Parto(gestante_id=gestante_id, **parto_data)
        db.add(parto)

    await db.flush()  # necesario para tener parto.id antes de los hijos

    # --- Recién nacido (upsert por parto_id) ---
    result_rn = await db.execute(
        select(RecienNacido).where(RecienNacido.parto_id == parto.id)
    )
    rn = result_rn.scalar_one_or_none()

    if rn:
        for k, v in rn_data.items():
            setattr(rn, k, v)
    else:
        rn = RecienNacido(parto_id=parto.id, **rn_data)
        db.add(rn)

    # --- Anticoncepción posparto (upsert por gestante_id) ---
    if anticoncepcion_data.get("aplicada"):
        result_anti = await db.execute(
            select(AnticoncepcionPosparto).where(
                AnticoncepcionPosparto.gestante_id == gestante_id
            )
        )
        anti = result_anti.scalar_one_or_none()

        if anti:
            anti.metodo_id       = anticoncepcion_data.get("metodo_id")
            anti.fecha_aplicacion = anticoncepcion_data["fecha_aplicacion"]
        else:
            anti = AnticoncepcionPosparto(
                gestante_id=gestante_id,
                metodo_id=anticoncepcion_data.get("metodo_id"),
                fecha_aplicacion=anticoncepcion_data["fecha_aplicacion"],
            )
            db.add(anti)

    await db.commit()


# registro de carga

async def create_carga_excel(db: AsyncSession, **kwargs) -> CargaExcel:
    carga = CargaExcel(**kwargs)
    db.add(carga)
    await db.commit()
    await db.refresh(carga)
    return carga


async def create_carga_detalles(
    db: AsyncSession, carga_id: str, detalles: list[dict]
):
    for d in detalles:
        detalle = CargaExcelDetalle(
            carga_id=carga_id,
            fila_numero=d["fila"],
            hoja=d["hoja"],
            estado=d["estado"],
            mensaje_error=d["mensaje"] if d["estado"] == "error" else None,
        )
        db.add(detalle)
    await db.commit()