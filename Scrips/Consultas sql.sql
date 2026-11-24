SET search_path TO "mdA_educacion";


--Con este SELECT Busco los limites de esas columnas
SELECT
  MIN("Marital status"::NUMERIC)             AS civil_min,
  MAX("Marital status"::NUMERIC)             AS civil_max,
  MIN("Application order"::NUMERIC)          AS orden_min,
  MAX("Application order"::NUMERIC)          AS orden_max,
  MIN("Age at enrollment"::NUMERIC)          AS edad_min,
  MAX("Age at enrollment"::NUMERIC)          AS edad_max,
  MIN("Previous qualification (grade)"::NUMERIC) AS notaprev_min,
  MAX("Previous qualification (grade)"::NUMERIC) AS notaprev_max,
  MIN("Admission grade"::NUMERIC)            AS adm_min,
  MAX("Admission grade"::NUMERIC)            AS adm_max
FROM data;

--Con este SELECT Busco los limites de esas columnas
SELECT
  MIN("Unemployment rate"::NUMERIC) AS desemp_min,
  MAX("Unemployment rate"::NUMERIC) AS desemp_max,
  MIN("Inflation rate"::NUMERIC)    AS infl_min,
  MAX("Inflation rate"::NUMERIC)    AS infl_max,
  MIN("GDP"::NUMERIC)               AS gdp_min,
  MAX("GDP"::NUMERIC)               AS gdp_max,
  MAX("Curricular units 1st sem (grade)"::NUMERIC) AS prom1_max,
  MAX("Curricular units 2nd sem (grade)"::NUMERIC) AS prom2_max
FROM data;

--esta solo se uso para saber la cantidad de caracteres de los nombres de las columnas
SELECT column_name, LENGTH(column_name) AS largo
FROM information_schema.columns
WHERE table_schema = 'mdA_educacion'
  AND table_name = 'data'
ORDER BY ordinal_position;

--se uso para saber si alguna columna ademas de la de "Daytime/evening attendance	" 
--tengan el nombre de manera correcta sin espacios o tabulaciones de mas asi ala hora de la carga de datos no salta errores que no se a encontrado dicha columna
SELECT column_name, LENGTH(column_name)
FROM information_schema.columns
WHERE table_schema = 'mdA_educacion'
  AND table_name = 'data'
  AND column_name <> TRIM(column_name);


--Con esta consulta agrupo a todos los estudiantes con sus tasas de inflacion
SELECT c.tasa_inflacion, e.estado_academico, COUNT(*)
FROM estudiante e
JOIN economia c 
 ON c.id_economia = e.id_economia
GROUP BY tasa_inflacion, e.estado_academico
ORDER BY 1, 2

--Con esta consulta veo a todos los estudiantes que abandonaron la carrera y sus tasas de inflacion
SELECT e.id_estudiante ,c.tasa_inflacion, e.estado_academico
FROM estudiante e
JOIN economia c 
 ON c.id_economia = e.id_economia
WHERE e.estado_academico = 'Abandono'


--Con esta consulta Comparo la cantidad de estudiantes que abandonaron,graduaron o siguen estudiando, según si reciben una beca o no
SELECT becario,estado_academico,count(*)
FROM estudiante
group by becario,estado_academico
order by 1,2;

--Esta consulta me da una lista de los estudiantes que dejaron la carrera mostrando la educacion de sus padres
SELECT e.id_estudiante, e.estado_academico, d.nivel_educativo_madre, d.nivel_educativo_padre
fROM estudiante e
JOIN datos_familia d
	ON d.id_familia = e.id_familia
WHERE e.estado_academico = 'Abandono'
ORDER BY e.id_estudiante ASC

--Esta consulta me permite ver cuantos estudiantes dejaron la carrera segun su modalidad horaria
SELECT c.modalidad_horaria, e.estado_academico, COUNT(*) AS total_alumnos
FROM estudiante e
JOIN inscripcion i
	ON i.id_estudiante = e.id_estudiante
	JOIN carrera c
		ON c.id_carrera = i.id_carrera
WHERE e.estado_academico = 'Abandono'
GROUP BY e.estado_academico, c.modalidad_horaria


SET search_path TO "mdA_educacion";

--Esta consulta me permite ver los estudiantes que abandonaron y como les fue en su curso usando una vista
SELECT 
    v.nro_semestre,
    v.estado_academico,
    v.total_estudiantes,
    v.promedio_general_notas,
    v.promedio_materias_aprobadas
FROM v_rendimiento_semestre v
WHERE v.estado_academico = 'Abandono'
ORDER BY v.nro_semestre ASC;


