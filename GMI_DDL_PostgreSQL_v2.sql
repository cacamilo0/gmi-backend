-- ============================================================
-- GUÍA MATERNA INTELIGENTE (GMI)
-- DDL Completo - PostgreSQL 16
-- Versión 2.0 - Marzo 2026
-- 61 tablas: 8 dominios + catálogos + autenticación
-- ============================================================

-- Habilitar extensión UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- SCHEMAS
-- ============================================================
CREATE SCHEMA IF NOT EXISTS gmi;
CREATE SCHEMA IF NOT EXISTS gmi_catalogo;
CREATE SCHEMA IF NOT EXISTS gmi_auth;

-- ============================================================
-- CATÁLOGOS (gmi_catalogo)
-- ============================================================

CREATE TABLE gmi_catalogo.cat_modulo_clinico (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(5) UNIQUE NOT NULL,       -- 'M1', 'M2', 'M3', 'M4'
    nombre      VARCHAR(100) NOT NULL,             -- 'Primer Trimestre', etc.
    semana_eg_inicio INT,                          -- 0, 14, 28, NULL(M4)
    semana_eg_fin    INT,                          -- 13, 27, NULL(M3+), NULL(M4)
    descripcion TEXT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_prioridad_alerta (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(10) UNIQUE NOT NULL,       -- 'verde', 'amarillo', 'rojo'
    nombre      VARCHAR(50) NOT NULL,
    color_hex   VARCHAR(7),                        -- '#4CAF50', '#FFC107', '#F44336'
    requiere_accion_inmediata BOOLEAN DEFAULT FALSE,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_tipo_alerta (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(30) UNIQUE NOT NULL,       -- 'clinica', 'administrativa', 'educativa', 'seguimiento', 'inasistencia'
    nombre      VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_ips (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(20) UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    nivel       INT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_eapb (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(20) UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    regimen     VARCHAR(20),
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_tipo_examen (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(20) UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    unidad      VARCHAR(20),
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_tipo_ecografia (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_estado_nutricional (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_hemoclasificacion (
    id          SERIAL PRIMARY KEY,
    grupo       VARCHAR(5) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_diagnostico_cie10 (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(10) UNIQUE NOT NULL,
    nombre      VARCHAR(200) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_vacuna (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    dosis_esperadas INT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_micronutriente (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_tipo_profesional (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_especialidad (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_metodo_anticonceptivo (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_nacionalidad (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_pertenencia_etnica (
    id          SERIAL PRIMARY KEY,
    codigo      VARCHAR(10),
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_catalogo.cat_grupo_poblacional (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- AUTENTICACIÓN (gmi_auth)
-- ============================================================

CREATE TABLE gmi_auth.rol (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi_auth.permiso (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT
);

CREATE TABLE gmi_auth.rol_permiso (
    rol_id      INT NOT NULL REFERENCES gmi_auth.rol(id),
    permiso_id  INT NOT NULL REFERENCES gmi_auth.permiso(id),
    PRIMARY KEY (rol_id, permiso_id)
);

CREATE TABLE gmi_auth.usuario_staff (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre          VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    hash_password   VARCHAR(256) NOT NULL,
    rol_id          INT NOT NULL REFERENCES gmi_auth.rol(id),
    ips_id          INT REFERENCES gmi_catalogo.cat_ips(id),
    activo          BOOLEAN DEFAULT TRUE,
    ultimo_acceso   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi_auth.audit_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id      UUID REFERENCES gmi_auth.usuario_staff(id),
    gestante_id     UUID,  -- FK se agrega después de crear gmi.gestante
    accion          VARCHAR(50) NOT NULL,
    tabla_afectada  VARCHAR(50),
    registro_id     UUID,
    ip_address      VARCHAR(45),
    detalle         JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 1: IDENTIDAD Y ACCESO (gmi)
-- ============================================================

CREATE TABLE gmi.gestante (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_gmi                  VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento            DATE NOT NULL,
    nacionalidad_id             INT REFERENCES gmi_catalogo.cat_nacionalidad(id),
    eapb_id                     INT REFERENCES gmi_catalogo.cat_eapb(id),
    tipo_regimen                VARCHAR(20),
    pertenencia_etnica_id       INT REFERENCES gmi_catalogo.cat_pertenencia_etnica(id),
    grupo_poblacional_id        INT REFERENCES gmi_catalogo.cat_grupo_poblacional(id),
    fecha_ultima_menstruacion   DATE NOT NULL,
    fecha_probable_parto        DATE,
    anio_ingreso                INT NOT NULL,
    fecha_ingreso_cpn           DATE,
    semanas_eg_ingreso          INT,
    activa                      BOOLEAN DEFAULT TRUE,
    modulo_activo_id            INT REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    created_at                  TIMESTAMPTZ DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ DEFAULT NOW(),
    created_by                  UUID REFERENCES gmi_auth.usuario_staff(id)
);

-- Agregar FK de audit_log a gestante (referencia circular)
ALTER TABLE gmi_auth.audit_log
    ADD CONSTRAINT fk_audit_gestante
    FOREIGN KEY (gestante_id) REFERENCES gmi.gestante(id);

CREATE TABLE gmi.pregunta_seguridad (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID UNIQUE NOT NULL REFERENCES gmi.gestante(id),
    pregunta        VARCHAR(200) NOT NULL,
    hash_respuesta  VARCHAR(256) NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.consentimiento_informado (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    hash_consentimiento VARCHAR(256) NOT NULL,
    version             VARCHAR(10) NOT NULL,
    estado              VARCHAR(20) NOT NULL,
    fecha_aceptacion    TIMESTAMPTZ NOT NULL,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.historial_modulo (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    modulo_anterior_id  INT REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    modulo_nuevo_id     INT NOT NULL REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    motivo              TEXT,
    origen              VARCHAR(20),  -- 'sistema', 'clinico', 'admin'
    created_by          UUID REFERENCES gmi_auth.usuario_staff(id),
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 2: PERFIL CLÍNICO BASE
-- ============================================================

CREATE TABLE gmi.perfil_clinico (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id             UUID UNIQUE NOT NULL REFERENCES gmi.gestante(id),
    enfermedades_cronicas   TEXT,
    alergias                TEXT,
    habitos                 TEXT,
    condiciones_riesgo      TEXT,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.formula_obstetrica (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID UNIQUE NOT NULL REFERENCES gmi.gestante(id),
    gestaciones     INT NOT NULL DEFAULT 0,
    partos          INT NOT NULL DEFAULT 0,
    cesareas        INT NOT NULL DEFAULT 0,
    abortos         INT NOT NULL DEFAULT 0,
    vivos           INT NOT NULL DEFAULT 0,
    mortinatos      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT chk_formula CHECK (gestaciones >= partos + cesareas + abortos)
);

CREATE TABLE gmi.antecedente_patologico (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    tipo_condicion      VARCHAR(100) NOT NULL,
    descripcion         TEXT,
    fecha_diagnostico   DATE,
    controlada          BOOLEAN,
    tratamiento_actual  TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 3: SEGUIMIENTO GESTACIONAL
-- ============================================================

CREATE TABLE gmi.control_prenatal (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    numero_control      INT NOT NULL,
    fecha_control       DATE NOT NULL,
    semana_gestacion    INT NOT NULL,
    trimestre           INT GENERATED ALWAYS AS (
                            CASE
                                WHEN semana_gestacion <= 13 THEN 1
                                WHEN semana_gestacion <= 27 THEN 2
                                ELSE 3
                            END
                        ) STORED,
    ips_id              INT REFERENCES gmi_catalogo.cat_ips(id),
    tipo_profesional_id INT REFERENCES gmi_catalogo.cat_tipo_profesional(id),
    tipo_consulta       VARCHAR(50),
    observaciones       TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          UUID REFERENCES gmi_auth.usuario_staff(id)
);

CREATE TABLE gmi.signos_vitales (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    control_prenatal_id     UUID UNIQUE NOT NULL REFERENCES gmi.control_prenatal(id),
    peso_kg                 DECIMAL(5,2) NOT NULL,
    talla_cm                DECIMAL(5,1),
    imc                     DECIMAL(4,2),
    estado_nutricional_id   INT REFERENCES gmi_catalogo.cat_estado_nutricional(id),
    altura_uterina          DECIMAL(4,1),
    presion_sistolica       INT,
    presion_diastolica      INT,
    fcf                     INT,
    created_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.examen_laboratorio (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    control_prenatal_id UUID REFERENCES gmi.control_prenatal(id),
    tipo_examen_id      INT NOT NULL REFERENCES gmi_catalogo.cat_tipo_examen(id),
    fecha_toma          DATE NOT NULL,
    resultado           VARCHAR(100) NOT NULL,
    resultado_numerico  DECIMAL(10,2),
    unidad              VARCHAR(20),
    trimestre           INT,
    semana_gestacion    INT,
    observaciones       TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          UUID REFERENCES gmi_auth.usuario_staff(id)
);

CREATE TABLE gmi.ecografia (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    tipo_ecografia_id   INT REFERENCES gmi_catalogo.cat_tipo_ecografia(id),
    fecha               DATE NOT NULL,
    semana_gestacion    INT,
    resultado           TEXT,
    plan_manejo         TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.sintoma_reportado (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    modulo_origen   VARCHAR(5),
    descripcion     TEXT NOT NULL,
    severidad       VARCHAR(20),
    fecha_reporte   TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.pregunta_seguimiento (
    id                          SERIAL PRIMARY KEY,
    texto_pregunta              TEXT NOT NULL,
    tipo_respuesta              VARCHAR(30) NOT NULL,  -- 'si_no', 'opcion_multiple', 'texto_libre', 'escala_1_5'
    modulo_id                   INT REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    frecuencia                  VARCHAR(20),           -- 'diaria', 'semanal', 'por_control'
    es_signo_alarma             BOOLEAN DEFAULT FALSE,
    prioridad_alerta_default_id INT REFERENCES gmi_catalogo.cat_prioridad_alerta(id),
    orden                       INT,
    activo                      BOOLEAN DEFAULT TRUE,
    created_at                  TIMESTAMPTZ DEFAULT NOW(),
    created_by                  UUID REFERENCES gmi_auth.usuario_staff(id)
);

CREATE TABLE gmi.opcion_pregunta_seguimiento (
    id              SERIAL PRIMARY KEY,
    pregunta_id     INT NOT NULL REFERENCES gmi.pregunta_seguimiento(id),
    texto_opcion    VARCHAR(200) NOT NULL,
    valor_numerico  INT,
    es_alarma       BOOLEAN DEFAULT FALSE,
    prioridad_alerta_id INT REFERENCES gmi_catalogo.cat_prioridad_alerta(id),
    orden           INT
);

CREATE TABLE gmi.respuesta_seguimiento (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    pregunta_id         INT NOT NULL REFERENCES gmi.pregunta_seguimiento(id),
    respuesta_texto     TEXT,
    respuesta_booleana  BOOLEAN,
    respuesta_numerica  INT,
    opcion_id           INT REFERENCES gmi.opcion_pregunta_seguimiento(id),
    semana_gestacion    INT,
    alerta_id           UUID,  -- FK se agrega después de crear gmi.alerta
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 4: RIESGO Y ALERTAS
-- ============================================================

CREATE TABLE gmi.clasificacion_riesgo (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id                 UUID NOT NULL REFERENCES gmi.gestante(id),
    control_prenatal_id         UUID REFERENCES gmi.control_prenatal(id),
    tipo_riesgo                 VARCHAR(30) NOT NULL,  -- 'obstetrico', 'biosicosocial'
    nivel                       VARCHAR(10) NOT NULL,  -- 'alto', 'bajo'
    clasificacion_ia            VARCHAR(10),           -- 'verde', 'amarillo', 'rojo'
    diagnostico_texto           TEXT,
    situaciones_biosicosocial   TEXT,
    explicacion_ia              TEXT,
    fecha_evaluacion            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at                  TIMESTAMPTZ DEFAULT NOW(),
    created_by                  UUID REFERENCES gmi_auth.usuario_staff(id)
);

CREATE TABLE gmi.alerta (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id                 UUID NOT NULL REFERENCES gmi.gestante(id),
    clasificacion_riesgo_id     UUID REFERENCES gmi.clasificacion_riesgo(id),
    tipo_alerta_id              INT NOT NULL REFERENCES gmi_catalogo.cat_tipo_alerta(id),
    prioridad_id                INT NOT NULL REFERENCES gmi_catalogo.cat_prioridad_alerta(id),
    estado                      VARCHAR(20) NOT NULL,  -- 'activa', 'leida', 'resuelta', 'escalada'
    modulo_origen               VARCHAR(5),
    descripcion                 TEXT,
    resuelta_por                UUID REFERENCES gmi_auth.usuario_staff(id),
    fecha_resolucion            TIMESTAMPTZ,
    created_at                  TIMESTAMPTZ DEFAULT NOW()
);

-- Agregar FK de respuesta_seguimiento a alerta (referencia circular)
ALTER TABLE gmi.respuesta_seguimiento
    ADD CONSTRAINT fk_respuesta_alerta
    FOREIGN KEY (alerta_id) REFERENCES gmi.alerta(id);

CREATE TABLE gmi.referencia (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    alerta_id           UUID REFERENCES gmi.alerta(id),
    ips_origen_id       INT REFERENCES gmi_catalogo.cat_ips(id),
    ips_destino_id      INT REFERENCES gmi_catalogo.cat_ips(id),
    estado              VARCHAR(20) NOT NULL,
    motivo              TEXT NOT NULL,
    fecha_referencia    TIMESTAMPTZ NOT NULL,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.contrareferencia (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referencia_id   UUID UNIQUE NOT NULL REFERENCES gmi.referencia(id),
    respuesta       TEXT NOT NULL,
    diagnostico     TEXT,
    indicaciones    TEXT,
    fecha_atencion  TIMESTAMPTZ NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 5: DESENLACE
-- ============================================================

CREATE TABLE gmi.parto (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID UNIQUE NOT NULL REFERENCES gmi.gestante(id),
    tipo_parto      VARCHAR(20) NOT NULL,
    fecha_parto     DATE NOT NULL,
    complicaciones  TEXT,
    uci_materna     BOOLEAN DEFAULT FALSE,
    muerte_materna  BOOLEAN DEFAULT FALSE,
    causa_muerte    TEXT,
    fecha_muerte    DATE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.recien_nacido (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parto_id        UUID NOT NULL REFERENCES gmi.parto(id),
    vivo            BOOLEAN NOT NULL,
    peso_gramos     DECIMAL(6,1),
    talla_cm        DECIMAL(4,1),
    uci_neonatal    BOOLEAN DEFAULT FALSE,
    observaciones   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.puerperio (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    dias_posparto   INT NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    complicaciones  TEXT,
    observaciones   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.evaluacion_salud_mental (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    instrumento     VARCHAR(20) NOT NULL,  -- 'EPDS', 'GAD7', 'PHQ9'
    puntaje         INT NOT NULL,
    fecha           DATE NOT NULL,
    recomendaciones TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.anticoncepcion_posparto (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    metodo_id       INT REFERENCES gmi_catalogo.cat_metodo_anticonceptivo(id),
    fecha_aplicacion DATE NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 6: EVENTOS COMPLEMENTARIOS
-- ============================================================

CREATE TABLE gmi.vacunacion (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    vacuna_id       INT NOT NULL REFERENCES gmi_catalogo.cat_vacuna(id),
    dosis           VARCHAR(20) NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.suministro_micronutriente (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    micronutriente_id   INT NOT NULL REFERENCES gmi_catalogo.cat_micronutriente(id),
    suministrado        BOOLEAN NOT NULL,
    fecha_inicio        DATE,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.remision_interdisciplinaria (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    especialidad_id     INT NOT NULL REFERENCES gmi_catalogo.cat_especialidad(id),
    fecha_remision      DATE NOT NULL,
    fecha_atencion      DATE,
    semana_gestacion    INT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 7: SOPORTE DEL SISTEMA
-- ============================================================

CREATE TABLE gmi.carga_excel (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    archivo_nombre  VARCHAR(200) NOT NULL,
    estado          VARCHAR(30) NOT NULL,
    total_gestantes INT,
    nuevas          INT,
    actualizadas    INT,
    errores         INT,
    usuario_id      UUID REFERENCES gmi_auth.usuario_staff(id),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.carga_excel_detalle (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    carga_id        UUID NOT NULL REFERENCES gmi.carga_excel(id),
    fila_numero     INT NOT NULL,
    hoja            VARCHAR(50) NOT NULL,
    estado          VARCHAR(20) NOT NULL,
    mensaje_error   TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.llamada_emergencia (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    alerta_id       UUID REFERENCES gmi.alerta(id),
    motivo          TEXT,
    destino         VARCHAR(100),
    duracion_seg    INT,
    resultado       VARCHAR(20),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.cita_medica (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    ips_id          INT REFERENCES gmi_catalogo.cat_ips(id),
    fecha_hora      TIMESTAMPTZ NOT NULL,
    tipo_cita       VARCHAR(50),
    estado          VARCHAR(20) NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.notificacion (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    canal           VARCHAR(20) NOT NULL,
    contenido       TEXT,
    estado_entrega  VARCHAR(20),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.chat_ia (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id     UUID NOT NULL REFERENCES gmi.gestante(id),
    rol             VARCHAR(20) NOT NULL,
    contenido       TEXT NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DOMINIO 8: EDUCACIÓN Y CONTENIDOS
-- ============================================================

CREATE TABLE gmi.cat_categoria_educativa (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    descripcion TEXT,
    icono       VARCHAR(100),
    orden       INT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi.contenido_educativo (
    id                  SERIAL PRIMARY KEY,
    categoria_id        INT REFERENCES gmi.cat_categoria_educativa(id),
    titulo              VARCHAR(200) NOT NULL,
    descripcion         TEXT,
    tipo_contenido      VARCHAR(30),   -- 'texto', 'video', 'audio', 'infografia', 'interactivo'
    cuerpo_texto        TEXT,
    url_recurso         VARCHAR(500),
    url_imagen          VARCHAR(500),
    modulo_id           INT REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    semana_eg_inicio    INT,
    semana_eg_fin       INT,
    duracion_minutos    INT,
    orden               INT,
    activo              BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          UUID REFERENCES gmi_auth.usuario_staff(id)
);

CREATE TABLE gmi.pregunta_educativa (
    id              SERIAL PRIMARY KEY,
    contenido_id    INT NOT NULL REFERENCES gmi.contenido_educativo(id),
    texto_pregunta  TEXT NOT NULL,
    tipo_pregunta   VARCHAR(30),   -- 'opcion_multiple', 'verdadero_falso'
    orden           INT,
    activo          BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi.opcion_respuesta_educativa (
    id              SERIAL PRIMARY KEY,
    pregunta_id     INT NOT NULL REFERENCES gmi.pregunta_educativa(id),
    texto_opcion    TEXT NOT NULL,
    es_correcta     BOOLEAN NOT NULL,
    orden           INT
);

CREATE TABLE gmi.respuesta_educativa_gestante (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id             UUID NOT NULL REFERENCES gmi.gestante(id),
    pregunta_id             INT NOT NULL REFERENCES gmi.pregunta_educativa(id),
    opcion_seleccionada_id  INT REFERENCES gmi.opcion_respuesta_educativa(id),
    es_correcta             BOOLEAN,
    created_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.checklist_item (
    id          SERIAL PRIMARY KEY,
    texto       VARCHAR(200) NOT NULL,
    modulo_id   INT REFERENCES gmi_catalogo.cat_modulo_clinico(id),
    semana_eg   INT,
    orden       INT,
    activo      BOOLEAN DEFAULT TRUE
);

CREATE TABLE gmi.checklist_gestante (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    checklist_item_id   INT NOT NULL REFERENCES gmi.checklist_item(id),
    completado          BOOLEAN DEFAULT FALSE,
    fecha_completado    TIMESTAMPTZ,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE gmi.progreso_educativo (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gestante_id         UUID NOT NULL REFERENCES gmi.gestante(id),
    contenido_id        INT NOT NULL REFERENCES gmi.contenido_educativo(id),
    completado          BOOLEAN DEFAULT FALSE,
    fecha_completado    TIMESTAMPTZ,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ÍNDICES
-- ============================================================

-- Dominio 1
CREATE INDEX idx_gestante_codigo ON gmi.gestante(codigo_gmi);
CREATE INDEX idx_gestante_modulo ON gmi.gestante(modulo_activo_id) WHERE activa = TRUE;
CREATE INDEX idx_gestante_eapb ON gmi.gestante(eapb_id);
CREATE INDEX idx_consentimiento_gestante ON gmi.consentimiento_informado(gestante_id);
CREATE INDEX idx_historial_modulo_gestante ON gmi.historial_modulo(gestante_id);

-- Dominio 3
CREATE INDEX idx_control_gestante ON gmi.control_prenatal(gestante_id);
CREATE INDEX idx_control_fecha ON gmi.control_prenatal(fecha_control);
CREATE INDEX idx_examen_gestante ON gmi.examen_laboratorio(gestante_id);
CREATE INDEX idx_examen_tipo ON gmi.examen_laboratorio(tipo_examen_id);
CREATE INDEX idx_examen_fecha ON gmi.examen_laboratorio(fecha_toma);
CREATE INDEX idx_ecografia_gestante ON gmi.ecografia(gestante_id);
CREATE INDEX idx_sintoma_gestante ON gmi.sintoma_reportado(gestante_id);
CREATE INDEX idx_respuesta_seg_gestante ON gmi.respuesta_seguimiento(gestante_id);
CREATE INDEX idx_pregunta_seg_modulo ON gmi.pregunta_seguimiento(modulo_id) WHERE activo = TRUE;

-- Dominio 4
CREATE INDEX idx_riesgo_gestante ON gmi.clasificacion_riesgo(gestante_id);
CREATE INDEX idx_alerta_gestante ON gmi.alerta(gestante_id);
CREATE INDEX idx_alerta_estado ON gmi.alerta(estado) WHERE estado = 'activa';
CREATE INDEX idx_alerta_prioridad ON gmi.alerta(prioridad_id);
CREATE INDEX idx_referencia_gestante ON gmi.referencia(gestante_id);

-- Dominio 5
CREATE INDEX idx_parto_gestante ON gmi.parto(gestante_id);
CREATE INDEX idx_rn_parto ON gmi.recien_nacido(parto_id);
CREATE INDEX idx_puerperio_gestante ON gmi.puerperio(gestante_id);
CREATE INDEX idx_salud_mental_gestante ON gmi.evaluacion_salud_mental(gestante_id);

-- Dominio 6
CREATE INDEX idx_vacuna_gestante ON gmi.vacunacion(gestante_id);
CREATE INDEX idx_micronutriente_gestante ON gmi.suministro_micronutriente(gestante_id);
CREATE INDEX idx_remision_gestante ON gmi.remision_interdisciplinaria(gestante_id);

-- Dominio 7
CREATE INDEX idx_carga_detalle_carga ON gmi.carga_excel_detalle(carga_id);
CREATE INDEX idx_llamada_gestante ON gmi.llamada_emergencia(gestante_id);
CREATE INDEX idx_cita_gestante ON gmi.cita_medica(gestante_id);
CREATE INDEX idx_cita_fecha ON gmi.cita_medica(fecha_hora);
CREATE INDEX idx_notificacion_gestante ON gmi.notificacion(gestante_id);
CREATE INDEX idx_chat_gestante ON gmi.chat_ia(gestante_id);

-- Dominio 8
CREATE INDEX idx_contenido_modulo ON gmi.contenido_educativo(modulo_id) WHERE activo = TRUE;
CREATE INDEX idx_contenido_categoria ON gmi.contenido_educativo(categoria_id);
CREATE INDEX idx_progreso_gestante ON gmi.progreso_educativo(gestante_id);
CREATE INDEX idx_checklist_gestante ON gmi.checklist_gestante(gestante_id);
CREATE INDEX idx_respuesta_edu_gestante ON gmi.respuesta_educativa_gestante(gestante_id);

-- Auditoría
CREATE INDEX idx_audit_usuario ON gmi_auth.audit_log(usuario_id);
CREATE INDEX idx_audit_gestante ON gmi_auth.audit_log(gestante_id);
CREATE INDEX idx_audit_fecha ON gmi_auth.audit_log(created_at);

-- ============================================================
-- DATOS INICIALES DE CATÁLOGOS
-- ============================================================

-- Módulos clínicos
INSERT INTO gmi_catalogo.cat_modulo_clinico (codigo, nombre, semana_eg_inicio, semana_eg_fin, descripcion) VALUES
('M1', 'Primer Trimestre', 0, 13, 'Identificación inicial de riesgo materno-fetal (0 a 13+6 semanas)'),
('M2', 'Segundo Trimestre', 14, 27, 'Vigilancia del desarrollo fetal y ajuste del plan de cuidado (14 a 27+6 semanas)'),
('M3', 'Tercer Trimestre', 28, NULL, 'Detección de riesgo severo y preparación para parto (≥28 semanas hasta parto)'),
('M4', 'Parto y Puerperio', NULL, NULL, 'Continuidad del cuidado materno y neonatal (parto hasta 42 días posparto)');

-- Prioridades de alerta
INSERT INTO gmi_catalogo.cat_prioridad_alerta (codigo, nombre, color_hex, requiere_accion_inmediata) VALUES
('verde', 'Riesgo bajo', '#4CAF50', FALSE),
('amarillo', 'Riesgo moderado', '#FFC107', FALSE),
('rojo', 'Riesgo alto', '#F44336', TRUE);

-- Tipos de alerta
INSERT INTO gmi_catalogo.cat_tipo_alerta (codigo, nombre, descripcion) VALUES
('clinica', 'Alerta clínica', 'Generada por hallazgos clínicos o clasificación de riesgo'),
('administrativa', 'Alerta administrativa', 'Generada por eventos administrativos del sistema'),
('seguimiento', 'Alerta de seguimiento', 'Generada por respuestas a preguntas de seguimiento diario'),
('inasistencia', 'Alerta de inasistencia', 'Generada por no asistencia a citas programadas'),
('educativa', 'Alerta educativa', 'Generada por falta de adherencia a contenidos educativos');

-- Tipos de examen de laboratorio
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad) VALUES
('HEMO_CLAS', 'Hemoclasificación', NULL),
('HEMOGLOB', 'Hemoglobina', 'g/dL'),
('HEMATO', 'Hematocrito', '%'),
('ORINA', 'Parcial de orina', NULL),
('UROCULT', 'Urocultivo', NULL),
('GLICEMIA', 'Glicemia', 'mg/dL'),
('CITOLOGIA', 'Citología', NULL),
('FROTIS', 'Frotis vaginal', NULL),
('TOXO_IGG', 'Toxoplasma IgG', NULL),
('TOXO_IGM', 'Toxoplasma IgM', NULL),
('HB_AG', 'Antígeno superficie Hepatitis B', NULL),
('PTOG', 'Prueba tolerancia oral a glucosa', 'mg/dL'),
('VIH_PRES', 'VIH presuntiva (ELISA/Rápida)', NULL),
('VIH_CONF', 'VIH confirmatoria', NULL),
('CARGA_VIH', 'Carga viral VIH', 'copias/mL'),
('VDRL', 'VDRL', NULL),
('TREP', 'Prueba treponémica', NULL),
('STREP_B', 'Cultivo rectovaginal Streptococo B', NULL);

-- Estados nutricionales
INSERT INTO gmi_catalogo.cat_estado_nutricional (nombre) VALUES
('Bajo peso'), ('Normal'), ('Sobrepeso'), ('Obesidad');

-- Hemoclasificación
INSERT INTO gmi_catalogo.cat_hemoclasificacion (grupo) VALUES
('A+'), ('A-'), ('B+'), ('B-'), ('AB+'), ('AB-'), ('O+'), ('O-');

-- Vacunas
INSERT INTO gmi_catalogo.cat_vacuna (nombre, dosis_esperadas) VALUES
('TT/Td', 3), ('TdaP (DPT acelular)', 1), ('COVID-19', 3);

-- Micronutrientes
INSERT INTO gmi_catalogo.cat_micronutriente (nombre) VALUES
('Calcio'), ('Ácido fólico'), ('Sulfato ferroso'), ('ASA');

-- Tipos de profesional
INSERT INTO gmi_catalogo.cat_tipo_profesional (nombre) VALUES
('Médico'), ('Enfermera'), ('Obstetra'), ('Ginecólogo');

-- Especialidades interdisciplinarias
INSERT INTO gmi_catalogo.cat_especialidad (nombre) VALUES
('Odontología'), ('Nutrición'), ('Psicología'), ('Ginecología'), ('Fisioterapia');

-- Métodos anticonceptivos
INSERT INTO gmi_catalogo.cat_metodo_anticonceptivo (nombre) VALUES
('DIU'), ('Implante subdérmico'), ('Inyectable'), ('Ligadura de trompas'), ('Preservativo'), ('Otro');

-- Tipos de ecografía
INSERT INTO gmi_catalogo.cat_tipo_ecografia (nombre) VALUES
('Translucencia nucal (sem 10.6-13.6)'), ('Detalle anatómico (sem 18-23.6)'), ('Obstétrica de seguimiento'), ('Doppler');

-- Nacionalidades (principales)
INSERT INTO gmi_catalogo.cat_nacionalidad (nombre) VALUES
('Colombiana'), ('Venezolana'), ('Otra');

-- Roles del sistema
INSERT INTO gmi_auth.rol (nombre, descripcion) VALUES
('gestante', 'Gestante que usa la app móvil'),
('clinico', 'Profesional de salud del hospital'),
('admin', 'Administrador del sistema'),
('investigador', 'Investigador con acceso a datos anonimizados');
