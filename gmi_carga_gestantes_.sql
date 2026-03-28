-- Habilitar extensión para public.gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
SET search_path TO gmi, gmi_catalogo, gmi_auth, public;

-- ============================================================
-- GMI - Carga Gestantes Junio 2025  (v4 - DEFINITIVO)
-- Total: 97 gestantes | 4 EAPBs
-- CORRECCIONES v4 vs v3:
--  1. Catálogos sin UNIQUE → INSERT WHERE NOT EXISTS (no duplicados)
--  2. Mapa remisiones CORREGIDO: col 191=Odon, 189=Nutri, 193=Psico, 197=Gine
--  3. Estado nutricional normalizado: Delgadez→Bajo peso, Sobrepesp→Sobrepeso
--  4. formula_obstetrica: gestaciones se ajusta a max(g, p+c+a)
--  5. signos_vitales: estado_nutricional resuelto en variable, no en JOIN
-- ============================================================

-- ============================================================
-- CATÁLOGOS (idempotentes con INSERT WHERE NOT EXISTS)
-- ============================================================

INSERT INTO gmi_catalogo.cat_ips (codigo, nombre, nivel, activo)
SELECT 'ESE-PC','ESE Hospital De Puerto Colombia',1,TRUE
WHERE NOT EXISTS (SELECT 1 FROM gmi_catalogo.cat_ips WHERE codigo='ESE-PC');

INSERT INTO gmi_catalogo.cat_eapb (codigo, nombre, regimen, activo)
SELECT 'NE-001','Nueva EPS','Subsidiado',TRUE
WHERE NOT EXISTS (SELECT 1 FROM gmi_catalogo.cat_eapb WHERE codigo='NE-001');
INSERT INTO gmi_catalogo.cat_eapb (codigo, nombre, regimen, activo)
SELECT 'MS-001','Mutual Ser','Subsidiado',TRUE
WHERE NOT EXISTS (SELECT 1 FROM gmi_catalogo.cat_eapb WHERE codigo='MS-001');
INSERT INTO gmi_catalogo.cat_eapb (codigo, nombre, regimen, activo)
SELECT 'CJ-001','Cajacopi','Subsidiado',TRUE
WHERE NOT EXISTS (SELECT 1 FROM gmi_catalogo.cat_eapb WHERE codigo='CJ-001');
INSERT INTO gmi_catalogo.cat_eapb (codigo, nombre, regimen, activo)
SELECT 'SN-001','Sanitas','Subsidiado',TRUE
WHERE NOT EXISTS (SELECT 1 FROM gmi_catalogo.cat_eapb WHERE codigo='SN-001');

INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'HEMO_CLAS','Hemoclasificación',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='HEMO_CLAS');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'HEMOGLOB','Hemoglobina','g/dL',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='HEMOGLOB');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'HEMATO','Hematocrito','%',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='HEMATO');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'ORINA','Parcial de orina',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='ORINA');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'UROCULT','Urocultivo',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='UROCULT');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'GLICEMIA','Glicemia','mg/dL',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='GLICEMIA');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'CITOLOGIA','Citología',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='CITOLOGIA');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'FROTIS','Frotis vaginal',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='FROTIS');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'TOXO_IGG','Toxoplasma IgG',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='TOXO_IGG');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'TOXO_IGM','Toxoplasma IgM',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='TOXO_IGM');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'HB_AG','Antígeno superficie Hepatitis B',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='HB_AG');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'PTOG','Prueba tolerancia oral a glucosa','mg/dL',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='PTOG');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'VIH_PRES','VIH presuntiva (ELISA/Rápida)',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='VIH_PRES');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'VIH_CONF','VIH confirmatoria',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='VIH_CONF');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'CARGA_VIH','Carga viral VIH','copias/mL',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='CARGA_VIH');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'VDRL','VDRL',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='VDRL');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'TREP','Prueba treponémica',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='TREP');
INSERT INTO gmi_catalogo.cat_tipo_examen (codigo, nombre, unidad, activo)
SELECT 'STREP_B','Cultivo rectovaginal Streptococo B',NULL,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_tipo_examen WHERE codigo='STREP_B');

INSERT INTO gmi_catalogo.cat_estado_nutricional (nombre, activo)
SELECT 'Bajo peso',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_estado_nutricional WHERE nombre='Bajo peso');
INSERT INTO gmi_catalogo.cat_estado_nutricional (nombre, activo)
SELECT 'Normal',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_estado_nutricional WHERE nombre='Normal');
INSERT INTO gmi_catalogo.cat_estado_nutricional (nombre, activo)
SELECT 'Sobrepeso',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_estado_nutricional WHERE nombre='Sobrepeso');
INSERT INTO gmi_catalogo.cat_estado_nutricional (nombre, activo)
SELECT 'Obesidad',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_estado_nutricional WHERE nombre='Obesidad');

INSERT INTO gmi_catalogo.cat_vacuna (nombre, dosis_esperadas, activo)
SELECT 'TT/Td',3,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_vacuna WHERE nombre='TT/Td');
INSERT INTO gmi_catalogo.cat_vacuna (nombre, dosis_esperadas, activo)
SELECT 'TdaP (DPT acelular)',1,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_vacuna WHERE nombre='TdaP (DPT acelular)');
INSERT INTO gmi_catalogo.cat_vacuna (nombre, dosis_esperadas, activo)
SELECT 'COVID-19',3,TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_vacuna WHERE nombre='COVID-19');

INSERT INTO gmi_catalogo.cat_micronutriente (nombre, activo)
SELECT 'Calcio',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_micronutriente WHERE nombre='Calcio');
INSERT INTO gmi_catalogo.cat_micronutriente (nombre, activo)
SELECT 'Ácido fólico',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_micronutriente WHERE nombre='Ácido fólico');
INSERT INTO gmi_catalogo.cat_micronutriente (nombre, activo)
SELECT 'Sulfato ferroso',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_micronutriente WHERE nombre='Sulfato ferroso');
INSERT INTO gmi_catalogo.cat_micronutriente (nombre, activo)
SELECT 'ASA',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_micronutriente WHERE nombre='ASA');

INSERT INTO gmi_catalogo.cat_especialidad (nombre, activo)
SELECT 'Odontología',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_especialidad WHERE nombre='Odontología');
INSERT INTO gmi_catalogo.cat_especialidad (nombre, activo)
SELECT 'Nutrición',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_especialidad WHERE nombre='Nutrición');
INSERT INTO gmi_catalogo.cat_especialidad (nombre, activo)
SELECT 'Psicología',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_especialidad WHERE nombre='Psicología');
INSERT INTO gmi_catalogo.cat_especialidad (nombre, activo)
SELECT 'Ginecología',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_especialidad WHERE nombre='Ginecología');
INSERT INTO gmi_catalogo.cat_especialidad (nombre, activo)
SELECT 'Fisioterapia',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_especialidad WHERE nombre='Fisioterapia');

INSERT INTO gmi_catalogo.cat_nacionalidad (nombre, activo)
SELECT 'Colombiana',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_nacionalidad WHERE nombre='Colombiana');
INSERT INTO gmi_catalogo.cat_nacionalidad (nombre, activo)
SELECT 'Venezolana',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_nacionalidad WHERE nombre='Venezolana');
INSERT INTO gmi_catalogo.cat_nacionalidad (nombre, activo)
SELECT 'Otra',TRUE
WHERE NOT EXISTS
(SELECT 1 FROM gmi_catalogo.cat_nacionalidad WHERE nombre='Otra');

-- ============================================================
-- DATOS POR GESTANTE (v4)
-- ============================================================
-- [001/97] NUEVA_EPS | Gabriela Cepeda | 1044424786
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[1] Catálogos faltantes para GMI-NU-1044424786'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044424786', '2007-01-17', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-12', '2025-08-19',
        2024, '2024-12-24', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044424786';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[1] No se pudo crear gestante GMI-NU-1044424786'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-27', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-02-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-03-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-09', 29, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 86.00, 159.00, 34.00, v_en_id, 33.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'B+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', '13.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', '39.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', '87', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'B+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', '11', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', '31.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', '90.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-02', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-27'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-08'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', '2025-02-26'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044424786: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [002/97] NUEVA_EPS | Maryoris Hidalgo | 5148655
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[2] Catálogos faltantes para GMI-NU-5148655'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-5148655', '2001-06-22', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-06', '2025-08-13',
        2024, '2024-12-24', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-5148655';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[2] No se pudo crear gestante GMI-NU-5148655'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-02-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-09', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-16', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-19', 32, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 81.00, 161.00, 31.20, v_en_id, 36.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'O+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', '12.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', '38', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', '73.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'O+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', '10.5', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', '32.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-28', '90.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'O+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', '9.6', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', '29.2', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-26', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-16'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', '2025-05-26'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-5148655: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [003/97] NUEVA_EPS | Maria Santamaria | 1044431554
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[3] Catálogos faltantes para GMI-NU-1044431554'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044431554', '1996-03-19', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-04', '2025-07-11',
        2025, '2025-01-09', 13, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044431554';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[3] No se pudo crear gestante GMI-NU-1044431554'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 4, 1, 0, 2, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-09', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-16', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-17', 36, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 85.00, 164.00, 31.60, v_en_id, 37.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', '12', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', '36', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'o+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '11.2', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '33.6', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-09', '2025-01-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-09', '2025-01-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044431554: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [004/97] NUEVA_EPS | Saireli Bautista | 3483219
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[4] Catálogos faltantes para GMI-NU-3483219'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-3483219', '1999-07-20', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-31', '2025-10-07',
        2025, '2025-01-17', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-3483219';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[4] No se pudo crear gestante GMI-NU-3483219'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-16', 29, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 100.00, 170.00, 37.10, v_en_id, 32.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '9.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '21.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Notmal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '76.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', '9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', '28.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-26'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-17', '2025-03-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-3483219: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [005/97] NUEVA_EPS | Jhanny Lemus | 1044420700
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[5] Catálogos faltantes para GMI-NU-1044420700'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044420700', '2004-05-25', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-03', '2025-12-09',
        2025, '2025-01-14', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044420700';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[5] No se pudo crear gestante GMI-NU-1044420700'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-13', 27, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 70.00, 153.00, 29.90, v_en_id, 31.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'O+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', '11.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', '33', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', '90.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'O+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', '9.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', '27.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-10'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-14', '2025-02-14'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044420700: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [006/97] NUEVA_EPS | SARA PACHECO | 1044430555
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[6] Catálogos faltantes para GMI-NU-1044430555'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044430555', '1995-01-20', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-08', '2025-07-15',
        2025, '2025-01-22', 16, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044430555';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[6] No se pudo crear gestante GMI-NU-1044430555'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-22', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-27', 37, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 85.00, 160.00, 33.20, v_en_id, 42.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '10.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '31.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', '4.1', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'o+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '9.2', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '27.6', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-22', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-22', '2025-05-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-22', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-22', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044430555: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [007/97] NUEVA_EPS | Keyla Pacheco | 1130294945
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[7] Catálogos faltantes para GMI-NU-1130294945'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1130294945', '2008-03-03', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-25', '2025-10-01',
        2025, '2025-01-30', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1130294945';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[7] No se pudo crear gestante GMI-NU-1130294945'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-30', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-27', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-20', 25, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 71.00, 153.00, 30.30, v_en_id, 28.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'O+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', '10.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', '30.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', '77.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'O+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-18', '9.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-18', '25.7', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-07', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', '2025-02-27'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', '2025-02-27'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', '2025-02-27'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1130294945: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [008/97] NUEVA_EPS | Ely Romero | 1044435123
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[8] Catálogos faltantes para GMI-NU-1044435123'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044435123', '1999-08-30', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-07', '2025-08-14',
        2025, '2025-02-13', 14, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044435123';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[8] No se pudo crear gestante GMI-NU-1044435123'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2055-04-11', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-12', 31, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 80.00, 155.00, 33.30, v_en_id, 26.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', '9.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', '26.5', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', '82.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-18', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-11'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-13', '2025-03-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044435123: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [009/97] NUEVA_EPS | Maria Montaño | 1005572675
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[9] Catálogos faltantes para GMI-NU-1005572675'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1005572675', '1994-12-24', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-09', '2025-10-16',
        2025, '2025-02-25', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1005572675';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[9] No se pudo crear gestante GMI-NU-1005572675'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 2, 0, 0, 2, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-27', 24, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 81.00, 161.00, 31.20, v_en_id, 24.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', '11.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', '35.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', '80.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Nergativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', '10.7', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', '30.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-24', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-28'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', '2025-04-22'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', '2025-04-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', '2025-05-22'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1005572675: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [010/97] NUEVA_EPS | Evangely Garcia | 1141153
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[10] Catálogos faltantes para GMI-NU-1141153'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1141153', '2005-04-05', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-31', '2025-10-07',
        2025, '2025-02-10', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1141153';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[10] No se pudo crear gestante GMI-NU-1141153'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-13', 23, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 65.00, 160.00, 22.40, v_en_id, 28.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '9.7', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '28.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-13'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', '2025-06-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1141153: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [011/97] NUEVA_EPS | Leirys Jimenez | 1044424032
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[11] Catálogos faltantes para GMI-NU-1044424032'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044424032', '2006-10-17', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-27', '2025-11-03',
        2025, '2025-03-08', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044424032';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[11] No se pudo crear gestante GMI-NU-1044424032'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-09', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 65.00, 163.00, 24.40, v_en_id, 23.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '11.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '35.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '75.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044424032: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [012/97] NUEVA_EPS | Yaritza Rua | 1044421275
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[12] Catálogos faltantes para GMI-NU-1044421275'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044421275', '2004-10-21', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-06', '2025-10-13',
        2025, '2025-03-05', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044421275';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[12] No se pudo crear gestante GMI-NU-1044421275'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-09', 22, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 75.00, 163.00, 30.00, v_en_id, 26.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'o-', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '12', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '39', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '84', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-24'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-06', '2025-03-06'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-06', '2025-03-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044421275: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [013/97] NUEVA_EPS | Katerin Sanchez | 1001881912
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[13] Catálogos faltantes para GMI-NU-1001881912'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1001881912', '2002-01-17', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-28', '2025-11-04',
        2025, '2025-03-11', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1001881912';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[13] No se pudo crear gestante GMI-NU-1001881912'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-11', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-11', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-12', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 88.00, 151.00, 38.50, v_en_id, 16.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', '11', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', '35', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', '61.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', '2025-03-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', '2025-03-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1001881912: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [014/97] NUEVA_EPS | Keidys Sevilla | 1049318348
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[14] Catálogos faltantes para GMI-NU-1049318348'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1049318348', '2005-05-15', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-20', '2025-09-26',
        2025, '2025-03-17', 12, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1049318348';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[14] No se pudo crear gestante GMI-NU-1049318348'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-10', 24, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 60.00, 159.00, 23.70, v_en_id, 24.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '11.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '35.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '84.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', '11', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', '33', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-01', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-30', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-30', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-10'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', '2025-05-08'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', '2025-06-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1049318348: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [015/97] NUEVA_EPS | Celene Medina | 1235254315
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[15] Catálogos faltantes para GMI-NU-1235254315'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1235254315', '1992-05-30', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-28', '2025-11-04',
        2025, '2025-03-18', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1235254315';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[15] No se pudo crear gestante GMI-NU-1235254315'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-20', 20, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 110.00, 160.00, 42.90, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '13.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '39.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '87.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'CITOLOGIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-21'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-18', '2025-06-20'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1235254315: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [016/97] NUEVA_EPS | Keiti Cumplido | 1129506742
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[16] Catálogos faltantes para GMI-NU-1129506742'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1129506742', '2004-12-05', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-24', '2025-11-14',
        2025, '2025-04-03', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1129506742';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[16] No se pudo crear gestante GMI-NU-1129506742'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 0, 1, 1, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-03', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-02', 12, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 98.00, 151.00, 40.70, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', '0+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', '12.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', '35.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', '87.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-03', '2025-04-22'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-03', '2025-04-22'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1129506742: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [017/97] NUEVA_EPS | Sara Hernandez | 1003070034
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[17] Catálogos faltantes para GMI-NU-1003070034'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1003070034', '1996-10-23', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-13', '2025-11-20',
        2025, '2025-04-11', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1003070034';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[17] No se pudo crear gestante GMI-NU-1003070034'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-11', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 73.00, 154.00, 30.70, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', '2025-04-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1003070034: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [018/97] NUEVA_EPS | Valeria Gutierrez | 6557464
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[18] Catálogos faltantes para GMI-NU-6557464'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-6557464', '2010-01-26', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-06', '2025-10-13',
        2025, '2025-04-15', 14, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-6557464';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[18] No se pudo crear gestante GMI-NU-6557464'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-16', 23, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 55.00, 164.00, 20.40, v_en_id, 16.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', '0+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', '12.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', '35.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', '87.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', '0+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '13', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '40.1', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '82.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-13'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-15', '2025-04-15'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-15', '2025-04-15'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-15', '2025-05-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-6557464: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [019/97] NUEVA_EPS | Maria Santiago | 1044420104
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[19] Catálogos faltantes para GMI-NU-1044420104'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044420104', '1997-02-09', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-20', '2025-10-27',
        2025, '2025-04-30', 14, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044420104';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[19] No se pudo crear gestante GMI-NU-1044420104'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 4, 3, 0, 0, 3, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-30', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-30', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-28', 22, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 70.00, 158.00, 28.00, v_en_id, 24.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-25', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-25', '9.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-25', '27.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', '71.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-15'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-30'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-30', '2025-06-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-30', '2025-06-03'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-30', '2025-06-05'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044420104: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [020/97] NUEVA_EPS | Yohenys Saya | 1083437236
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[20] Catálogos faltantes para GMI-NU-1083437236'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1083437236', '2007-12-22', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-14', '2025-12-19',
        2025, '2025-05-15', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1083437236';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[20] No se pudo crear gestante GMI-NU-1083437236'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-16', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 40.00, 166.00, 14.50, v_en_id, 14.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', '11.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', '34.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', '76.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', '2025-05-15'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1083437236: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [021/97] NUEVA_EPS | Nallelys Hernandez | 1082862049
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[21] Catálogos faltantes para GMI-NU-1082862049'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1082862049', '2002-05-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-01', '2025-01-06',
        2025, '2025-05-30', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1082862049';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[21] No se pudo crear gestante GMI-NU-1082862049'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 4, 1, 0, 2, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-30', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 68.00, 164.00, 25.20, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1082862049: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [022/97] NUEVA_EPS | Maily Maury | 1044424132
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[22] Catálogos faltantes para GMI-NU-1044424132'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-1044424132', '2006-11-12', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-14', '2026-01-19',
        2025, '2025-06-03', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-1044424132';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[22] No se pudo crear gestante GMI-NU-1044424132'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-03', 7, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 71.00, 155.00, 29.50, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-1044424132: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [023/97] NUEVA_EPS | Marcelly Escobar | 29974790
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[23] Catálogos faltantes para GMI-NU-29974790'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-29974790', '1985-07-07', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-05', '2025-10-12',
        2025, '2025-06-11', 22, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-29974790';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[23] No se pudo crear gestante GMI-NU-29974790'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 1)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-11', 22, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 75.00, 158.00, 30.40, v_en_id, 23.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', '9.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', '25.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', '71.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-29974790: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [024/97] NUEVA_EPS | Angely Garcia | 5602179
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'NE-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[24] Catálogos faltantes para GMI-NU-5602179'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-NU-5602179', '2000-12-08', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-09', '2026-01-14',
        2025, '2025-06-10', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-NU-5602179';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[24] No se pudo crear gestante GMI-NU-5602179'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-10', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 80.00, 166.00, 29.00, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Enbarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-10', '2025-06-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-NU-5602179: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [025/97] MUTUAL_SER | Estefania Herrera | 1046696216
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[25] Catálogos faltantes para GMI-MU-1046696216'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1046696216', '2004-05-22', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-05', '2025-07-12',
        2024, '2024-12-17', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1046696216';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[25] No se pudo crear gestante GMI-MU-1046696216'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-02-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-03-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-04-29', 33, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 55.00, 156.00, 23.80, v_en_id, 34.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', '13.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', '39.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', '81.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-12-18', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '13.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '39.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '78.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-18', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1046696216: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [026/97] MUTUAL_SER | Adrianis Padilla | 1044422601
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[26] Catálogos faltantes para GMI-MU-1044422601'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1044422601', '2004-10-26', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-30', '2025-08-06',
        2025, '2025-01-04', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1044422601';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[26] No se pudo crear gestante GMI-MU-1044422601'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-04', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 68.00, 163.00, 28.00, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1044422601: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [027/97] MUTUAL_SER | Yuleidys Silva | 1001824159
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Bajo peso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[27] Catálogos faltantes para GMI-MU-1001824159'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1001824159', '2001-10-28', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-11', '2025-09-02',
        2025, '2025-02-06', 10, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1001824159';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[27] No se pudo crear gestante GMI-MU-1001824159'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-30', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-28', 31, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 50.00, 155.00, 20.80, v_en_id, 28.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'A+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '9.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '28.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'A+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'A+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '10.5', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '30.8', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '69.1', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-11'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-30'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-06', '2025-02-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-06', '2025-03-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-06', '2025-04-03'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1001824159: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [028/97] MUTUAL_SER | Ruth Ramirez | 1047045803
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[28] Catálogos faltantes para GMI-MU-1047045803'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1047045803', '2008-03-07', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-27', '2025-10-03',
        2025, '2008-03-07', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1047045803';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[28] No se pudo crear gestante GMI-MU-1047045803'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-29', 21, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 55.00, 150.00, 24.40, v_en_id, 21.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '8.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '24.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '81.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', '2025-04-29'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1047045803: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [029/97] MUTUAL_SER | Keidys Sevilla | 1049318348
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[29] Catálogos faltantes para GMI-MU-1049318348'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1049318348', '2005-05-15', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-20', '2025-09-26',
        2025, '2025-03-17', 12, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1049318348';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[29] No se pudo crear gestante GMI-MU-1049318348'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-17', 12, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 55.00, 159.00, 21.70, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', '2025-03-17'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-17', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1049318348: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [030/97] MUTUAL_SER | Lescar Rodriguez | 6482732
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[30] Catálogos faltantes para GMI-MU-6482732'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-6482732', '1987-12-10', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-15', '2025-10-22',
        2025, '2025-03-25', 14, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-6482732';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[30] No se pudo crear gestante GMI-MU-6482732'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 1, 0, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-27', 23, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 75.00, 165.00, 27.50, v_en_id, 26.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', '13.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', '41.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', '72.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'CITOLOGIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-26'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-25', '2025-04-25'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-25', '2025-04-14'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-6482732: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [031/97] MUTUAL_SER | Camila Romero | 1103739787
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[31] Catálogos faltantes para GMI-MU-1103739787'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1103739787', '2004-04-25', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-29', '2025-08-05',
        2025, '2025-04-25', 25, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1103739787';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[31] No se pudo crear gestante GMI-MU-1103739787'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-25', 25, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 52.00, 165.00, 19.00, v_en_id, 28.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1103739787: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [032/97] MUTUAL_SER | Francis Rangel | 5876304
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[32] Catálogos faltantes para GMI-MU-5876304'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-5876304', '1998-04-04', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-24', '2025-12-01',
        2025, '2025-04-29', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-5876304';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[32] No se pudo crear gestante GMI-MU-5876304'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-29', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 70.00, 161.00, 27.00, v_en_id, 16.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-5876304: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [033/97] MUTUAL_SER | Julieta Echeverria | 1002011342
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[33] Catálogos faltantes para GMI-MU-1002011342'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1002011342', '1999-06-22', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-05', '2025-07-12',
        2025, '2025-05-10', 31, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1002011342';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[33] No se pudo crear gestante GMI-MU-1002011342'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-10', 31, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 55.00, 153.00, 23.80, v_en_id, 31.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1002011342: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [034/97] MUTUAL_SER | Yenireth Montero | 6958633
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[34] Catálogos faltantes para GMI-MU-6958633'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-6958633', '2004-03-05', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-28', '2025-12-05',
        2025, '2025-05-07', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-6958633';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[34] No se pudo crear gestante GMI-MU-6958633'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 0, 1, 1, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-06', 14, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 75.00, 157.00, 30.40, v_en_id, 14.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '11.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '33.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '85.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-06'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', '2025-05-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', '2025-05-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-6958633: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [035/97] MUTUAL_SER | Josefa Santamaria | 1044433923
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[35] Catálogos faltantes para GMI-MU-1044433923'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1044433923', '1998-10-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-27', '2026-01-01',
        2025, '2025-05-16', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1044433923';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[35] No se pudo crear gestante GMI-MU-1044433923'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-16', 7, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 50.00, 157.00, 20.20, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1044433923: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [036/97] MUTUAL_SER | Jennifer Jimenez | 1221974889
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[36] Catálogos faltantes para GMI-MU-1221974889'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1221974889', '1996-06-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-23', '2025-11-30',
        2025, '2025-05-14', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1221974889';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[36] No se pudo crear gestante GMI-MU-1221974889'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-13', 15, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 60.00, 148.00, 27.30, v_en_id, 17.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'b+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', '11', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', '33', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', '88.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-14', '2025-05-14'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-14', '2025-06-02'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1221974889: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [037/97] MUTUAL_SER | Luxsabeline Berrio | 1127924458
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'MS-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[37] Catálogos faltantes para GMI-MU-1127924458'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-MU-1127924458', '1997-12-09', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-25', '2025-10-01',
        2025, '2025-06-13', 24, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-MU-1127924458';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[37] No se pudo crear gestante GMI-MU-1127924458'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-13', 24, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 76.00, 156.00, 31.20, v_en_id, 28.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '12', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '33.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '81', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Supervision del embarzo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-13', '2025-06-13'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-MU-1127924458: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [038/97] CAJACOPI | Sara Ferrer | 6387527
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[38] Catálogos faltantes para GMI-CA-6387527'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-6387527', '1996-05-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-06', '2025-07-12',
        2024, '2024-10-10', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-6387527';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[38] No se pudo crear gestante GMI-CA-6387527'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-10-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-11-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2024-12-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-01-17', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-02-27', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-03-21', 33, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 95.00, 158.00, 38.05, v_en_id, 40.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', '13', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', '368', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', '92', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', '9.8', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', '27.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', 'Patologico', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-09-30', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-10', '2025-01-20'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-6387527: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [039/97] CAJACOPI | Sharon Santiago | 1044430988
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[39] Catálogos faltantes para GMI-CA-1044430988'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044430988', '1995-03-04', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-08-06', '2025-05-13',
        2024, '2024-10-24', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044430988';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[39] No se pudo crear gestante GMI-CA-1044430988'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 0, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-10-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-12-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-01-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-02-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-03-25', 33, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 80.00, 162.00, 36.00, v_en_id, 36.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', '0+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', '12', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', '32', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', '100', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', '0+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', '12', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', '38', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-10-29', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-14', 'Negatuvo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-10-24', '2025-01-09'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044430988: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [040/97] CAJACOPI | Alejandra Escalante | 1044432179
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[40] Catálogos faltantes para GMI-CA-1044432179'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044432179', '1996-06-08', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-09-03', '2025-06-10',
        2024, '2024-11-06', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044432179';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[40] No se pudo crear gestante GMI-CA-1044432179'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 0, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-11-06', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 66.00, 155.00, 27.40, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', '2024-11-06'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', '2024-11-06'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', '2024-11-06'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044432179: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [041/97] CAJACOPI | Valentina Florez | 1001782228
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[41] Catálogos faltantes para GMI-CA-1001782228'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1001782228', '2001-01-07', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-09-04', '2025-06-11',
        2024, '2024-11-06', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1001782228';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[41] No se pudo crear gestante GMI-CA-1001782228'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-11-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-02-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-09', 31, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 73.00, 164.00, 27.10, v_en_id, 32.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'o-', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', '12.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', '36.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', '90', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-04', 'o-', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', '10.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', '33', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', '64', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-01'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-06', '2025-02-19'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1001782228: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [042/97] CAJACOPI | Andrea De La Cruz | 1002013602
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
    v_ctrl_7_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[42] Catálogos faltantes para GMI-CA-1002013602'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013602', '2002-01-14', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-09-10', '2025-06-17',
        2024, '2024-11-12', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013602';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[42] No se pudo crear gestante GMI-CA-1002013602'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-11-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-12-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-01-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-02-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-03-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-04-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 7, '2025-05-14', 35, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_7_id;

    IF v_ctrl_7_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_7_id, 69.00, 154.00, 29.00, v_en_id, 35.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-13', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-13', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013602: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [043/97] CAJACOPI | Amarelys Perez | 22584968
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[43] Catálogos faltantes para GMI-CA-22584968'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-22584968', '1981-11-11', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-01', '2025-07-08',
        2024, '2024-11-19', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-22584968';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[43] No se pudo crear gestante GMI-CA-22584968'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-11-19', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-12-19', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-01-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-22', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-18', 37, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 65.00, 157.00, 26.30, v_en_id, 36.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '11', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '36', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '69', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', '11.4', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', '31.4', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-04'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-11-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-22584968: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [044/97] CAJACOPI | Ingrid Ortiz | 5819243
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
    v_ctrl_7_id UUID;
    v_ctrl_8_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[44] Catálogos faltantes para GMI-CA-5819243'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-5819243', '1998-02-20', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-03', '2025-07-10',
        2025, '2024-11-25', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-5819243';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[44] No se pudo crear gestante GMI-CA-5819243'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-11-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-12-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-01-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-02-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-03-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-04-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 7, '2025-05-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_7_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 8, '2025-06-19', 37, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_8_id;

    IF v_ctrl_8_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_8_id, 60.00, 154.00, 25.30, v_en_id, 37.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', '0+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', '10.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', '30.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', '100', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativa', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'CITOLOGIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-07', '0+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', '9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', '29', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Positivo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-26'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-11-25', '2025-01-09'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-11-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-11-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-11-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-5819243: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [045/97] CAJACOPI | Yuselyn Cantillo | 1002013416
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[45] Catálogos faltantes para GMI-CA-1002013416'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013416', '2000-12-16', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-11', '2025-08-22',
        2024, '2024-12-24', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013416';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[45] No se pudo crear gestante GMI-CA-1002013416'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-02-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-03-27', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-04-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-05-28', 27, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 75.00, 160.00, 29.30, v_en_id, 31.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', '13', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', '37.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', '110', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '12', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '37', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '70', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-27'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-28'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-12-24', '2025-01-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-12-24', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013416: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [046/97] CAJACOPI | Yulieth Herrera | 1130294997
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[46] Catálogos faltantes para GMI-CA-1130294997'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1130294997', '2009-01-22', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-05', '2024-09-25',
        2024, '2024-12-30', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1130294997';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[46] No se pudo crear gestante GMI-CA-1130294997'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-30', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 59.00, 165.00, 24.20, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-30', '2024-12-30'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-30', '2024-12-30'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-30', '2024-12-30'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1130294997: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [047/97] CAJACOPI | Ivana Ortega | 1002014276
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[47] Catálogos faltantes para GMI-CA-1002014276'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002014276', '2003-04-24', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-29', '2025-08-05',
        2024, '2024-12-31', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002014276';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[47] No se pudo crear gestante GMI-CA-1002014276'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-10-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-16', 32, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 65.00, 160.00, 25.30, v_en_id, 37.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', '12.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', '35.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', '94', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '10.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '30.7', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-08', '71.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-20', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '11', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '34', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-14', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negatvo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-17'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-15'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002014276: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [048/97] CAJACOPI | Elisa Morales | 1044432735
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[48] Catálogos faltantes para GMI-CA-1044432735'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044432735', '1997-06-24', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-15', '2025-08-22',
        2024, '2024-12-31', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044432735';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[48] No se pudo crear gestante GMI-CA-1044432735'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-12-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-06', 15, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 70.00, 175.00, 29.50, v_en_id, 21.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', '13', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', '37', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', '80', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-30', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-06'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', '2024-12-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044432735: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [049/97] CAJACOPI | Maria Collado | 1130295685
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[49] Catálogos faltantes para GMI-CA-1130295685'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1130295685', '2004-03-02', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-02', '2025-08-04',
        2024, '2025-12-18', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1130295685';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[49] No se pudo crear gestante GMI-CA-1130295685'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 0, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-12-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-03', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-15', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-16', 33, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 80.00, 161.00, 30.80, v_en_id, 33.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', '0+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', '10.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', '34.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', '0+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '12', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '39', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-10', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-06', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-15'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-18', '2025-04-03'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-12-18', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1130295685: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [050/97] CAJACOPI | Luz Geronimo | 1044613290
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[50] Catálogos faltantes para GMI-CA-1044613290'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044613290', '2005-09-10', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-02', '2025-08-09',
        2025, '2025-01-08', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044613290';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[50] No se pudo crear gestante GMI-CA-1044613290'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-10-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-01-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-05', 30, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 55.00, 150.00, 24.40, v_en_id, 35.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', '12', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', '36', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', '79', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '12.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '38.3', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Positivo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-09', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-05'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-08', '2025-01-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-08', '2025-03-26'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044613290: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [051/97] CAJACOPI | Adriana Romero | 1044434136
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[51] Catálogos faltantes para GMI-CA-1044434136'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044434136', '1999-01-17', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-26', '2025-09-02',
        2025, '2025-01-30', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044434136';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[51] No se pudo crear gestante GMI-CA-1044434136'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-30', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-14', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-20', 25, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 80.00, 164.00, NULL, v_en_id, 26.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '13', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '38.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '96', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-20'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-30', '2025-03-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044434136: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [052/97] CAJACOPI | Doriannys Brito | 5140567
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[52] Catálogos faltantes para GMI-CA-5140567'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-5140567', '2001-02-06', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-01', '2025-09-07',
        2025, '2025-01-31', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-5140567';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[52] No se pudo crear gestante GMI-CA-5140567'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-02-27', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-19', 28, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 55.00, 154.00, 23.10, v_en_id, 25.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'o-', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', '13.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', '36.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', '85', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'o-', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', '10.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', '31.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '74', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-13'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-10'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-31', '2025-01-31'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-31', '2025-03-15'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-5140567: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [053/97] CAJACOPI | Sheyla Gonzalez | 1044422851
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[53] Catálogos faltantes para GMI-CA-1044422851'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044422851', '2005-02-27', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-30', '2025-09-06',
        2025, '2025-01-14', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044422851';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[53] No se pudo crear gestante GMI-CA-1044422851'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-13', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-21', 29, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 60.00, 154.00, 25.30, v_en_id, 30.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', '12.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', '35.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', '66', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', '10.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', '30.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'o+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', '13', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', '39', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Normal', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-20', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-10'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044422851: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [054/97] CAJACOPI | Luisa Jimenez | 1130294269
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[54] Catálogos faltantes para GMI-CA-1130294269'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1130294269', '2005-05-02', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-15', '2025-09-21',
        2025, '2025-02-03', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1130294269';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[54] No se pudo crear gestante GMI-CA-1130294269'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-03', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-02', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-02', 24, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 65.00, 159.00, 27.70, v_en_id, 27.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-04'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-03', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-03', '2025-03-29'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1130294269: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [055/97] CAJACOPI | Jennifer DeHoyos | 1007129054
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[55] Catálogos faltantes para GMI-CA-1007129054'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1007129054', '2001-05-31', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-02', '2025-10-09',
        2025, '2025-02-20', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1007129054';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[55] No se pudo crear gestante GMI-CA-1007129054'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-22', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-22', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-17', 23, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 68.00, 156.00, 27.90, v_en_id, 25.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', '10.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', '30.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', '66.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-12', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-02-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-02-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1007129054: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [056/97] CAJACOPI | Yanira Ariza | 1044430996
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[56] Catálogos faltantes para GMI-CA-1044430996'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044430996', '1995-02-06', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-06', '2025-10-13',
        2025, '2025-02-25', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044430996';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[56] No se pudo crear gestante GMI-CA-1044430996'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-27', 11, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 85.00, 157.00, 34.40, v_en_id, 12.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '13.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '39.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', '86.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', '2025-02-25'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044430996: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [057/97] CAJACOPI | LEINIS JIMENEZ | 1002014221
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[57] Catálogos faltantes para GMI-CA-1002014221'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002014221', '2003-02-09', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-04', '2025-10-11',
        2025, '2025-02-28', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002014221';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[57] No se pudo crear gestante GMI-CA-1002014221'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-29', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 68.00, 149.00, 30.60, v_en_id, 20.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '11.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '35.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '82', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', '11', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', '34', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Positivo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-19', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-28'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-28', '2025-03-28'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002014221: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [058/97] CAJACOPI | Margelys Carreño | 1291199
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[58] Catálogos faltantes para GMI-CA-1291199'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1291199', '1994-11-06', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-01', '2025-09-07',
        2025, '2025-01-29', 4, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1291199';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[58] No se pudo crear gestante GMI-CA-1291199'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-01-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-07', 26, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 68.00, 164.00, 25.20, v_en_id, 30.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', '11.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '35.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', '112', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '9.8', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '31.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Positivo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-08'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-06'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', '2025-04-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-01-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1291199: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [059/97] CAJACOPI | Yulenis Gonzalez | 1002013838
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[59] Catálogos faltantes para GMI-CA-1002013838'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013838', '1999-11-11', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-25', '2025-09-01',
        2025, '2025-02-10', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013838';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[59] No se pudo crear gestante GMI-CA-1002013838'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-16', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-17', 29, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 79.00, 164.00, 29.30, v_en_id, 36.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', '12', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', '31', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', '77', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', '11.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', '35.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-20', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-03-10'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-08'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', '2025-04-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-10', '2025-04-02'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013838: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [060/97] CAJACOPI | Corina Arteta | 1002013830
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[60] Catálogos faltantes para GMI-CA-1002013830'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013830', '2003-05-10', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-10', '2025-07-17',
        2025, '2025-02-08', 17, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013830';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[60] No se pudo crear gestante GMI-CA-1002013830'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 1, 0, 1, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-04-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-05-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-06-05', 35, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 75.00, 158.00, 30.00, v_en_id, 39.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '11.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '36.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '63', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'No  patologivo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-07', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-08'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-04-04'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-08', '2025-05-05'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-08', '2025-05-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013830: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [061/97] CAJACOPI | Maria Ariza | 1002014523
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[61] Catálogos faltantes para GMI-CA-1002014523'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002014523', '2001-08-16', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-12', '2025-10-19',
        2025, '2025-02-20', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002014523';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[61] No se pudo crear gestante GMI-CA-1002014523'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-20', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 60.00, 165.00, 22.00, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', '11.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', '33.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', '85.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002014523: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [062/97] CAJACOPI | Natalia Bolaño | 1082570253
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[62] Catálogos faltantes para GMI-CA-1082570253'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1082570253', '2004-11-08', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-09-16', '2025-06-23',
        2025, '2025-02-18', 22, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1082570253';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[62] No se pudo crear gestante GMI-CA-1082570253'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-18', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-06', 37, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 55.00, 164.00, 20.40, v_en_id, 27.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', '11.5', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', '35', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', '82.1', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'No patologico', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-16', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-13', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-02-18'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-03-18'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-18', '2025-02-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-18', '2025-03-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-18', '2025-02-25'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-18', '2025-06-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1082570253: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [063/97] CAJACOPI | Valeri Torrez | 6416157
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[63] Catálogos faltantes para GMI-CA-6416157'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-6416157', '2001-12-30', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-03', '2025-09-09',
        2025, '2025-03-08', 13, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-6416157';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[63] No se pudo crear gestante GMI-CA-6416157'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-08', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 56.00, 154.00, 23.60, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', '12.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', '39.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', '78.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-11', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', '2025-03-08'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', '2025-03-10'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-6416157: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [064/97] CAJACOPI | Saray Utria | 1050005177
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Bajo peso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[64] Catálogos faltantes para GMI-CA-1050005177'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1050005177', '2005-08-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-18', '2025-10-15',
        2025, '2025-03-07', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1050005177';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[64] No se pudo crear gestante GMI-CA-1050005177'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-05', 21, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 45.00, 157.00, 18.20, v_en_id, 21.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '11.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '36', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', '71.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-18', 'Negativa', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'CITOLOGIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '11.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '34.9', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', '67', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-18', 'Normal', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'CITOLOGIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Mo patologico', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-22'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', '2025-02-28'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', '2025-03-05'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1050005177: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [065/97] CAJACOPI | Any Gonzalez | 1047049054
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[65] Catálogos faltantes para GMI-CA-1047049054'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1047049054', '2002-11-02', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-31', '2025-10-07',
        2025, '2025-03-07', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1047049054';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[65] No se pudo crear gestante GMI-CA-1047049054'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-28', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 110.00, 157.00, 44.60, v_en_id, 20.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '13.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '36', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Positivo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', '2025-03-07'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1047049054: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [066/97] CAJACOPI | MARIA PRATO | 1002014470
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[66] Catálogos faltantes para GMI-CA-1002014470'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002014470', '2001-02-28', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-29', '2025-10-05',
        2025, '2025-03-05', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002014470';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[66] No se pudo crear gestante GMI-CA-1002014470'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-05', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 67.00, 170.00, 23.10, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-05', '2025-03-05'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-05', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-05', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-05', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002014470: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [067/97] CAJACOPI | Yelitza Contreras | 7996432
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[67] Catálogos faltantes para GMI-CA-7996432'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-7996432', '2007-09-21', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-27', '2025-11-03',
        2025, '2025-03-11', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-7996432';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[67] No se pudo crear gestante GMI-CA-7996432'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-11', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-11', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-06-12', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;

    IF v_ctrl_4_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_4_id, 60.00, 158.00, 24.00, v_en_id, 25.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '11.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '35.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-27', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', '89.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-27'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', '2025-03-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', '2025-03-14'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', '2025-03-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-7996432: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [068/97] CAJACOPI | YARID PEREZ | 1044423457
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[68] Catálogos faltantes para GMI-CA-1044423457'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044423457', '2006-06-18', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-03', '2025-11-10',
        2025, '2025-03-19', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044423457';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[68] No se pudo crear gestante GMI-CA-1044423457'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-19', 6, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 68.00, 167.00, 25.28, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044423457: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [069/97] CAJACOPI | Franchesca Madera | 1064608053
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[69] Catálogos faltantes para GMI-CA-1064608053'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1064608053', '2007-07-21', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-11', '2025-10-18',
        2025, '2025-03-31', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1064608053';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[69] No se pudo crear gestante GMI-CA-1064608053'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-03-31', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-04-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-19', 21, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 65.00, 158.00, 26.00, v_en_id, 21.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', '12.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', '37', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-03', 'No patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', '75', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', '12.7', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', '40.1', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', '77', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-01', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-22', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-31', '2025-04-08'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-08', '2025-04-02'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-31', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1064608053: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [070/97] CAJACOPI | Yasmin Guerrero | 1002012785
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[70] Catálogos faltantes para GMI-CA-1002012785'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002012785', '2000-05-27', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-13', '2025-10-24',
        2025, '2025-04-02', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002012785';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[70] No se pudo crear gestante GMI-CA-1002012785'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 2, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-02', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-11', 20, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 55.00, 160.00, 21.40, v_en_id, 22.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', '11.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', '33.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', '77.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-25', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-02', '2025-06-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-02', '2025-06-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-02', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-02', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002012785: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [071/97] CAJACOPI | Lidubina Gonzalez | 1002013152
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[71] Catálogos faltantes para GMI-CA-1002013152'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013152', '2000-09-24', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-25', '2025-12-02',
        2025, '2025-04-04', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013152';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[71] No se pudo crear gestante GMI-CA-1002013152'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-04', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-05', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-05', 14, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 71.00, 150.00, 31.50, v_en_id, 16.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '11.,2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '33.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-16', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-24', 'Patologico', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', '78.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-06', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-05'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-04', '2025-04-04'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-04', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-04', '2025-04-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013152: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [072/97] CAJACOPI | Gueillys Saya | 1044421158
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[72] Catálogos faltantes para GMI-CA-1044421158'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044421158', '2004-09-10', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-06', '2025-11-13',
        2025, '2025-04-11', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044421158';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[72] No se pudo crear gestante GMI-CA-1044421158'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-11', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 63.00, 151.00, 27.60, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-11', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044421158: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [073/97] CAJACOPI | Adriana Burgos | 1002012490
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[73] Catálogos faltantes para GMI-CA-1002012490'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002012490', '2000-02-20', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-06', '2025-07-18',
        2025, '2025-04-10', 30, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002012490';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[73] No se pudo crear gestante GMI-CA-1002012490'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-10', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-06-11', 32, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 90.00, 162.00, 34.20, v_en_id, 39.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', '11.6', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', '36.1', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', '71', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-14', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-05-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-10', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002012490: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [074/97] CAJACOPI | Daniela Guzman | 1044432604
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[74] Catálogos faltantes para GMI-CA-1044432604'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044432604', '1996-08-15', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-05', '2025-12-10',
        2025, '2025-04-28', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044432604';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[74] No se pudo crear gestante GMI-CA-1044432604'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-28', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-14', 14, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 56.00, 159.00, 22.10, v_en_id, 23.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'b+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '11.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '33.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '87.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'b+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '12', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '36.1', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '79', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-14'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-28', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044432604: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [075/97] CAJACOPI | Leidis Torrenegra | 1044429793
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[75] Catálogos faltantes para GMI-CA-1044429793'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044429793', '1994-04-23', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-05', '2025-12-10',
        2025, '2025-05-08', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044429793';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[75] No se pudo crear gestante GMI-CA-1044429793'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-09', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 68.00, 156.00, 27.90, v_en_id, 14.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '11.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '33.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', '69.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-27', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-15', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-08', '2025-05-23'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-08', '2025-05-23'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-08', '2025-05-27'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044429793: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [076/97] CAJACOPI | WENDY MORA | 1002014309
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[76] Catálogos faltantes para GMI-CA-1002014309'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002014309', '2003-05-23', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-24', '2025-12-29',
        2025, '2025-05-07', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002014309';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[76] No se pudo crear gestante GMI-CA-1002014309'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 1, 1, 1, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-07', 6, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 70.00, 163.00, 26.30, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-07', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002014309: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [077/97] CAJACOPI | Sheila Altahona | 1044423279
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[77] Catálogos faltantes para GMI-CA-1044423279'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044423279', '2006-04-30', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-02-28', '2025-12-06',
        2025, '2025-05-06', 9, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044423279';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[77] No se pudo crear gestante GMI-CA-1044423279'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-06', 9, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 80.00, 167.00, 28.60, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044423279: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [078/97] CAJACOPI | Dayana Butron | 1044424057
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[78] Catálogos faltantes para GMI-CA-1044424057'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044424057', '1988-09-27', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-23', '2025-12-30',
        2025, '2025-05-12', 15, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044424057';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[78] No se pudo crear gestante GMI-CA-1044424057'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 6, 4, 0, 1, 4, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-12', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-12', 20, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 76.00, 156.00, 31.20, v_en_id, 20.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', '11.5', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', '35.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-30', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', '83', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-30', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-12'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-12', '2025-05-12'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044424057: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [079/97] CAJACOPI | Kelly Fontalvo | 52894942
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[79] Catálogos faltantes para GMI-CA-52894942'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-52894942', '1982-02-03', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-25', '2025-12-30',
        2025, '2025-05-19', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-52894942';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[79] No se pudo crear gestante GMI-CA-52894942'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 6, 4, 0, 1, 4, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-19', 7, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 46.00, 147.00, 21.60, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-19', '2025-05-19'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-19', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-52894942: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [080/97] CAJACOPI | Mariluz Gomez | 1002227460
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[80] Catálogos faltantes para GMI-CA-1002227460'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002227460', '2001-07-23', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-01-24', '2025-10-31',
        2025, '2025-05-16', 16, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002227460';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[80] No se pudo crear gestante GMI-CA-1002227460'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-16', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-17', 20, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 70.00, 157.00, 28.40, v_en_id, 21.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', 'a+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', '11.4', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', '35', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', '74', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-09', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-06-17'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', '2025-05-16'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', '2025-06-17'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002227460: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [081/97] CAJACOPI | Ivixi Yguaran | 6015774
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[81] Catálogos faltantes para GMI-CA-6015774'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-6015774', '2000-03-16', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-11-11', '2025-08-18',
        2025, '2025-05-16', 26, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-6015774';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[81] No se pudo crear gestante GMI-CA-6015774'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-16', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-17', 31, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 80.00, 157.00, 32.40, v_en_id, 32.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'a+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', '8.8', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', '25.2', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Normal', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', '1900-03-26 21:36:00', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-21', '2025-05-21 00:00:00', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', '2025-05-16'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', '2025-06-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-16', '2025-06-11'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-6015774: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [082/97] CAJACOPI | Lissete Mancilla | 1234090762
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[82] Catálogos faltantes para GMI-CA-1234090762'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1234090762', '1997-12-02', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-16', '2025-12-21',
        2025, '2025-05-15', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1234090762';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[82] No se pudo crear gestante GMI-CA-1234090762'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-15', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 81.00, 172.00, 27.30, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-15', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1234090762: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [083/97] CAJACOPI | Ivanna Valbuena | 1431989
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Venezolana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[83] Catálogos faltantes para GMI-CA-1431989'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1431989', '1980-08-28', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-10-13', '2025-07-20',
        2025, '2025-05-23', 30, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1431989';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[83] No se pudo crear gestante GMI-CA-1431989'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-23', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-16', 35, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 68.00, 153.00, 29.00, v_en_id, 38.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'a+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', '12.9', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', '36.9', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', '68', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-10', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-23'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-23', '2025-05-23'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-23', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-23', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-23', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1431989: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [084/97] CAJACOPI | Leidys Vargas | 1002012493
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Bajo peso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[84] Catálogos faltantes para GMI-CA-1002012493'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002012493', '1999-04-25', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-04', '2026-01-09',
        2025, '2025-05-21', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002012493';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[84] No se pudo crear gestante GMI-CA-1002012493'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-17', 11, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 48.00, 166.00, 17.40, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', 'ab+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', '12.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', '36.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', '93.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-05', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-21', '2025-05-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-21', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-21', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-21', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002012493: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [085/97] CAJACOPI | Yoleidis Garcia | 1082476376
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[85] Catálogos faltantes para GMI-CA-1082476376'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1082476376', '1981-06-20', v_nat_id, v_eapb_id,
        'Subsidiado', '2024-12-07', '2025-09-16',
        2025, '2025-05-20', 21, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1082476376';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[85] No se pudo crear gestante GMI-CA-1082476376'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 6, 3, 0, 2, 3, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-20', 27, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 70.00, 163.00, 26.30, v_en_id, 32.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '11.5', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '38', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '65', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-28', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-21'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-16'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-20', '2025-06-20'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1082476376: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [086/97] CAJACOPI | Kelly Pajaro | 1041850225
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[86] Catálogos faltantes para GMI-CA-1041850225'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1041850225', '1999-09-30', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-10', '2025-12-15',
        2025, '2025-05-30', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1041850225';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[86] No se pudo crear gestante GMI-CA-1041850225'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 5, 0, 1, 3, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-30', 11, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 61.00, 159.00, 24.10, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', '11.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', '33.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', '73.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-04', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-30', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1041850225: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [087/97] CAJACOPI | Paula Peña | 1001878587
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Bajo peso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[87] Catálogos faltantes para GMI-CA-1001878587'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1001878587', '1997-10-01', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-04', '2025-12-09',
        2025, '2025-05-29', 12, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1001878587';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[87] No se pudo crear gestante GMI-CA-1001878587'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-05-29', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-06-28', 16, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 45.00, 159.00, 17.80, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '9.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '28.1', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '87.9', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-29', '2025-05-29'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-05-29', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1001878587: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [088/97] CAJACOPI | Keyla Gallardo | 1002013993
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[88] Catálogos faltantes para GMI-CA-1002013993'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002013993', '2002-06-11', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-08', '2026-01-13',
        2025, '2025-06-09', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002013993';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[88] No se pudo crear gestante GMI-CA-1002013993'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 4, 0, 2, 1, 2, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-09', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 73.00, 167.00, 23.80, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-09', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002013993: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [089/97] CAJACOPI | Asly Mora | 1002012964
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[89] Catálogos faltantes para GMI-CA-1002012964'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1002012964', '2000-11-19', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-22', '2026-01-27',
        2025, '2025-06-06', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1002012964';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[89] No se pudo crear gestante GMI-CA-1002012964'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 3, 0, 1, 1, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-06', 6, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 50.00, 161.00, 19.20, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-06', '2025-06-06'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-06', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1002012964: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [090/97] CAJACOPI | Yoreinis Herrera | 1044421322
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[90] Catálogos faltantes para GMI-CA-1044421322'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044421322', '2004-09-28', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-28', '2026-01-10',
        2025, '2025-06-14', 10, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044421322';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[90] No se pudo crear gestante GMI-CA-1044421322'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 1, 0, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-14', 10, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 70.00, 162.00, 26.60, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '12.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '35.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', '89.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-17', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044421322: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [091/97] CAJACOPI | Darli Ochoa | 1044426076
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[91] Catálogos faltantes para GMI-CA-1044426076'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-1044426076', '2007-05-23', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-04-15', '2026-01-20',
        2025, '2025-06-14', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-1044426076';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[91] No se pudo crear gestante GMI-CA-1044426076'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 0, 1, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-14', 8, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 58.00, 159.00, 22.90, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', '10.2', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', '30.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', '83.4', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-19', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', '2025-06-18'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', '2025-06-18'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-14', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-1044426076: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [092/97] CAJACOPI | Daniela Camejo | 5612960
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'CJ-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[92] Catálogos faltantes para GMI-CA-5612960'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-CA-5612960', '2000-06-11', v_nat_id, v_eapb_id,
        'Subsidiado', '2025-03-11', '2025-12-12',
        2025, '2025-06-12', 13, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-CA-5612960';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[92] No se pudo crear gestante GMI-CA-5612960'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-12', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 55.00, 166.00, 19.90, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', 'a+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', '8.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', '24.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', '75.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-16', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riego sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-12', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-CA-5612960: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [093/97] SANITAS | Laura Mendoza | 1044434594
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'SN-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Otra';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[93] Catálogos faltantes para GMI-SA-1044434594'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-SA-1044434594', '1999-06-28', v_nat_id, v_eapb_id,
        'Sudsidiado', '2024-06-19', '2025-03-25',
        2024, '2024-08-08', 7, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-SA-1044434594';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[93] No se pudo crear gestante GMI-SA-1044434594'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2024-08-08', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2024-11-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2024-12-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-01-07', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-02-07', 33, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;

    IF v_ctrl_5_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_5_id, 70.00, 169.00, 23.90, v_en_id, 35.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'O+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', '13.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', '36.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', '73.8', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'O+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-11-14', '11', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-11-14', '35', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-11-14', '80', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'O+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', '12', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-09', '36', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-15', 'Normal', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-16', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-12-16', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-08-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-11-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-23', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2024-11-14', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-01-23', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2024-11-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-08-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-08-08', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2024-08-08', '2024-08-08'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-02-08'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-SA-1044434594: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [094/97] SANITAS | Melanye Gonzalez | 1130294808
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
    v_ctrl_4_id UUID;
    v_ctrl_5_id UUID;
    v_ctrl_6_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'SN-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[94] Catálogos faltantes para GMI-SA-1130294808'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-SA-1130294808', '2008-01-23', v_nat_id, v_eapb_id,
        'Sudsidiado', '2024-12-27', '2025-10-03',
        2025, '2025-02-20', 5, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-SA-1130294808';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[94] No se pudo crear gestante GMI-SA-1130294808'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 1, 0, 0, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-20', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-06', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-03-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 4, '2025-04-24', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_4_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 5, '2025-05-26', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_5_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 6, '2025-06-27', 26, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_6_id;

    IF v_ctrl_6_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_6_id, 59.00, 154.00, 24.80, v_en_id, 30.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', '10.6', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', '31.5', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', '77', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'o+', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '14.2', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', '40.6', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'o+', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '10.3', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '30.4', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', '77.6', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-02-24', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Negativo', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-06-03', 'Negativo', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-25', 'Positiva', 2
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-23', 'Positiva', 3
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TREP';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-04-07'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;
    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '2da dosis', '2025-06-27'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-03-26'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-02-28'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', '2025-02-20'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-20', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-SA-1130294808: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [095/97] SANITAS | LAURID MAZA | 1002012464
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
    v_ctrl_3_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'SN-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Obesidad';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[95] Catálogos faltantes para GMI-SA-1002012464'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-SA-1002012464', '1999-11-07', v_nat_id, v_eapb_id,
        'Sudsidiado', '2025-01-04', '2025-10-11',
        2025, '2025-02-21', 6, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-SA-1002012464';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[95] No se pudo crear gestante GMI-SA-1002012464'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 0, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-02-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-03-21', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 3, '2025-05-21', 19, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_3_id;

    IF v_ctrl_3_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_3_id, 86.00, 161.00, 33.10, v_en_id, 22.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '13', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '36', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Normal', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'ORINA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', '73', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-04-12', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-03-06', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.vacunacion (gestante_id, vacuna_id, dosis, fecha_aplicacion)
    SELECT v_gest_id, vc.id, '1ra dosis', '2025-05-05'
    FROM gmi_catalogo.cat_vacuna vc WHERE vc.nombre = 'TT/Td' LIMIT 1;

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-21', '2025-02-21'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-21', '2025-03-13'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-02-21', '2025-03-13'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-03-13', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-SA-1002012464: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [096/97] SANITAS | Karen Hernandez | 1129575441
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
    v_ctrl_2_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'SN-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Sobrepeso';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[96] Catálogos faltantes para GMI-SA-1129575441'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-SA-1129575441', '1987-03-04', v_nat_id, v_eapb_id,
        'Sudsidiado', '2025-02-25', '2025-12-02',
        2025, '2025-04-25', 8, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-SA-1129575441';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[96] No se pudo crear gestante GMI-SA-1129575441'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-04-25', 0, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;
    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 2, '2025-05-29', 13, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_2_id;

    IF v_ctrl_2_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_2_id, 61.00, 165.00, 22.40, v_en_id, 14.00);
    END IF;

    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'o+', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMO_CLAS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '11.3', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMOGLOB';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '33.7', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HEMATO';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'UROCULT';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', '72', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'GLICEMIA';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'FROTIS';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'TOXO_IGM';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'HB_AG';
    INSERT INTO gmi.examen_laboratorio
        (gestante_id, tipo_examen_id, fecha_toma, resultado, trimestre)
    SELECT v_gest_id, te.id, '2025-05-22', 'Negativo', 1
    FROM gmi_catalogo.cat_tipo_examen te WHERE te.codigo = 'VIH_PRES';

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', '2025-04-25'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', '2025-05-25'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-04-25', '2025-05-16'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-SA-1129575441: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- [097/97] SANITAS | DAYANA GERONIMO | 1130294761
DO $$
DECLARE
    v_gest_id    UUID;
    v_ips_id     INT;
    v_eapb_id    INT;
    v_nat_id     INT;
    v_en_id      INT;
    v_ctrl_1_id UUID;
BEGIN

    SELECT id INTO v_ips_id  FROM gmi_catalogo.cat_ips  WHERE codigo = 'ESE-PC';
    SELECT id INTO v_eapb_id FROM gmi_catalogo.cat_eapb WHERE codigo = 'SN-001';
    SELECT id INTO v_nat_id  FROM gmi_catalogo.cat_nacionalidad WHERE nombre = 'Colombiana';
    SELECT id INTO v_en_id FROM gmi_catalogo.cat_estado_nutricional WHERE nombre = 'Normal';

    IF v_eapb_id IS NULL OR v_ips_id IS NULL THEN
        RAISE WARNING '[97] Catálogos faltantes para GMI-SA-1130294761'; RETURN;
    END IF;

    INSERT INTO gmi.gestante (
        id, codigo_gmi, fecha_nacimiento, nacionalidad_id, eapb_id,
        tipo_regimen, fecha_ultima_menstruacion, fecha_probable_parto,
        anio_ingreso, fecha_ingreso_cpn, semanas_eg_ingreso, activa, created_at
    ) VALUES (
        public.gen_random_uuid(), 'GMI-SA-1130294761', '2007-11-02', v_nat_id, v_eapb_id,
        'Sudsidiado', '2025-03-30', '2026-01-04',
        2025, '2025-06-21', 11, TRUE, NOW()
    ) ON CONFLICT (codigo_gmi) DO NOTHING
    RETURNING id INTO v_gest_id;
    IF v_gest_id IS NULL THEN
        SELECT id INTO v_gest_id FROM gmi.gestante WHERE codigo_gmi = 'GMI-SA-1130294761';
    END IF;
    IF v_gest_id IS NULL THEN RAISE WARNING '[97] No se pudo crear gestante GMI-SA-1130294761'; RETURN; END IF;

    INSERT INTO gmi.formula_obstetrica
        (gestante_id, gestaciones, partos, cesareas, abortos, vivos, mortinatos)
    VALUES (v_gest_id, 2, 0, 1, 0, 1, 0)
    ON CONFLICT (gestante_id) DO NOTHING;

    INSERT INTO gmi.control_prenatal
        (gestante_id, numero_control, fecha_control,
         semana_gestacion, ips_id, tipo_consulta, created_at)
    VALUES (v_gest_id, 1, '2025-06-21', 11, v_ips_id, 'Control prenatal', NOW())
    RETURNING id INTO v_ctrl_1_id;

    IF v_ctrl_1_id IS NOT NULL THEN
        INSERT INTO gmi.signos_vitales
            (control_prenatal_id, peso_kg, talla_cm, imc, estado_nutricional_id, altura_uterina)
        VALUES (v_ctrl_1_id, 58.00, 148.00, 26.40, v_en_id, 0.00);
    END IF;

    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, diagnostico_texto, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'obstetrico', 'alto', 'Embarazo de alto riesgo sin otra especificacion', NOW(), NOW());
    INSERT INTO gmi.clasificacion_riesgo
        (gestante_id, tipo_riesgo, nivel, fecha_evaluacion, created_at)
    VALUES (v_gest_id, 'biosicosocial', 'bajo', NOW(), NOW());

    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Calcio';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Ácido fólico';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'Sulfato ferroso';
    INSERT INTO gmi.suministro_micronutriente
        (gestante_id, micronutriente_id, suministrado, fecha_inicio)
    SELECT v_gest_id, mn.id, TRUE, CURRENT_DATE
    FROM gmi_catalogo.cat_micronutriente mn WHERE mn.nombre = 'ASA';

    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-21', '2025-06-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Odontología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-21', '2025-06-24'
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Nutrición' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-21', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Psicología' LIMIT 1;
    INSERT INTO gmi.remision_interdisciplinaria
        (gestante_id, especialidad_id, fecha_remision, fecha_atencion)
    SELECT v_gest_id, es.id, '2025-06-21', NULL
    FROM gmi_catalogo.cat_especialidad es WHERE es.nombre = 'Ginecología' LIMIT 1;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'Error en gestante GMI-SA-1130294761: % | Detalle: %', SQLERRM, SQLSTATE;
END $$;

-- ============================================================
-- VERIFICACIÓN POST-CARGA
-- ============================================================
SELECT 'gestantes'                  AS tabla, COUNT(*) AS total FROM gmi.gestante;
SELECT 'formulas_obstetrica'        AS tabla, COUNT(*) AS total FROM gmi.formula_obstetrica;
SELECT 'controles_prenatales'       AS tabla, COUNT(*) AS total FROM gmi.control_prenatal;
SELECT 'signos_vitales'             AS tabla, COUNT(*) AS total FROM gmi.signos_vitales;
SELECT 'examenes_laboratorio'       AS tabla, COUNT(*) AS total FROM gmi.examen_laboratorio;
SELECT 'clasificacion_riesgo'       AS tabla, COUNT(*) AS total FROM gmi.clasificacion_riesgo;
SELECT 'micronutrientes'            AS tabla, COUNT(*) AS total FROM gmi.suministro_micronutriente;
SELECT 'vacunaciones'               AS tabla, COUNT(*) AS total FROM gmi.vacunacion;
SELECT 'remisiones'                 AS tabla, COUNT(*) AS total FROM gmi.remision_interdisciplinaria;

SELECT e.nombre AS eapb, COUNT(g.id) AS gestantes
FROM gmi.gestante g JOIN gmi_catalogo.cat_eapb e ON g.eapb_id = e.id
GROUP BY e.nombre ORDER BY gestantes DESC;