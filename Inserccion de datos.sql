SET search_path TO "mdA_educacion";

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

