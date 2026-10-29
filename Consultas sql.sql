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
