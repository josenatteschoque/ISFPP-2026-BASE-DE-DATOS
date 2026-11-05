SET search_path TO "mdA_educacion";
--///////////////// CARRERA //////////////////////////////////////////
SELECT DISTINCT "Target" FROM data;
  
--cargamos la tabla carrera desde la tabla data 
INSERT INTO carrera (id_carrera, modalidad_horaria)
SELECT DISTINCT
  "Course"::NUMERIC::SMALLINT,--se hace un pasaje a numeric ya que acepta valores con punto decima y luego de ahi hacemos el pasaje a smaillint
  "Daytime/evening attendance"::NUMERIC::SMALLINT
FROM data;


SELECT * FROM carrera ORDER BY id_carrera;

--//////////////// DATOS_FAMILIA //////////////////////////////////////////

INSERT INTO datos_familia (id_familia, nivel_educativo_madre, nivel_educativo_padre,ocupacion_laboral_madre, ocupacion_laboral_padre)
SELECT
  ROW_NUMBER() OVER (ORDER BY nm, np,om,op), nm, np,om,op
FROM (
  SELECT DISTINCT
    "Mother's qualification"::NUMERIC::INT AS nm,
    "Father's qualification"::NUMERIC::INT AS np,
    "Mother's occupation"::NUMERIC::INT    AS om,
    "Father's occupation"::NUMERIC::INT    AS op
  FROM data
) t;

SELECT * FROM datos_familia;

--///////////////// ECONOMIA /////////////////////////////////////////////////////
-- tabla en la cual vamos a insertar datos ,y las columnas que vamos a completar
INSERT INTO economia (id_economia,tasa_inflacion,tasa_desempleo,gdp)

SELECT
	-- genera un numero
    ROW_NUMBER() OVER (ORDER BY tasa_inflacion, tasa_desempleo, gdp
    ),
    tasa_inflacion,
    tasa_desempleo,
    gdp

FROM (
    SELECT DISTINCT
        "Inflation rate"::NUMERIC(4,2) AS tasa_inflacion,
        "Unemployment rate"::NUMERIC(4,2) AS tasa_desempleo,
        "GDP"::NUMERIC(4,2) AS gdp
    FROM data
) AS datos_economicos;

SELECT * FROM economia;

--////////////////// ESTUDIANTE //////////////////////////////////////////////////
-- cargamos la tabla estudiante desde la tabla data
INSERT INTO estudiante (id_estudiante,becario,genero,nacionalidad,estado_civil,
    necesidades_educativas_especiales,desplazado_trasladado,estado_academico,
    id_economia,id_familia)
SELECT
    d.id_estudent, -- id que generamos en la tabla data
    d."Scholarship holder"::NUMERIC::SMALLINT,
    d."Gender"::NUMERIC::SMALLINT,
    d."Nacionality"::NUMERIC::INT,
    d."Marital status"::NUMERIC::INT,
    d."Educational special needs"::NUMERIC::SMALLINT,
    d."Displaced"::NUMERIC::SMALLINT,
	
    CASE d."Target"
        WHEN 'Graduate' THEN 'Graduado'
        WHEN 'Enrolled' THEN 'Estudiando'
        WHEN 'Dropout' THEN 'Abandono'
    END,
	
    e.id_economia, 
    f.id_familia
	
FROM data AS d -- le asignamos a la tabla data un alias d
JOIN datos_familia AS f
    ON f.nivel_educativo_madre = d."Mother's qualification"::NUMERIC::INT
    AND f.nivel_educativo_padre = d."Father's qualification"::NUMERIC::INT
    AND f.ocupacion_laboral_madre = d."Mother's occupation"::NUMERIC::INT
    AND f.ocupacion_laboral_padre = d."Father's occupation"::NUMERIC::INT

-- Relacionamos los datos económicos
JOIN economia AS e
    ON e.tasa_inflacion = d."Inflation rate"::NUMERIC(4,2)
    AND e.tasa_desempleo = d."Unemployment rate"::NUMERIC(4,2)
    AND e.gdp = d."GDP"::NUMERIC(4,2);

-- Comprobamos los registros insertados
SELECT *FROM estudiante
ORDER BY id_estudiante;

--////////////////// RENDIMIENTO_ACADEMICO //////////////////////////////////////////////////
-- cargamos la tabla rendimiento_academico desde la tabla data
delete from rendimiento_academico
INSERT INTO rendimiento_academico(id_estudiante,nro_semestre,materias_acreditadas,materias_inscriptas,materias_aprobadas,promedio_notas)
-- Datos del primer semestre
SELECT
    id_estudent,1,
    "Curricular units 1st sem (credited)"::INT,
    "Curricular units 1st sem (enrolled)"::INT,
    "Curricular units 1st sem (approved)"::INT,
    "Curricular units 1st sem (grade)"::NUMERIC(4,2)
FROM data

UNION -- las tablas a unir tienen el mismo grado (cant_columnas)

-- Datos del segundo semestre
SELECT
    id_estudent,2,
    "Curricular units 2nd sem (credited)"::INT,
    "Curricular units 2nd sem (enrolled)"::INT,
    "Curricular units 2nd sem (approved)"::INT,
    "Curricular units 2nd sem (grade)"::NUMERIC(4,2)
FROM data;

-- Comprobamos los datos insertados
SELECT * FROM rendimiento_academico
ORDER BY id_estudiante, nro_semestre;

