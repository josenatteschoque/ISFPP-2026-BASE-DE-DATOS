SET search_path TO "mdA_educacion";

--Esta funcion devuelve el nombre del nivel educativo

CREATE OR REPLACE FUNCTION nombre_nivel_educativo(p_codigo INT)
RETURNS VARCHAR
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
  RETURN CASE p_codigo
    WHEN 1  THEN 'Educación secundaria - 12.º año o equivalente'
    WHEN 2  THEN 'Educación superior - Licenciatura'
    WHEN 3  THEN 'Educación superior - Título'
    WHEN 4  THEN 'Educación superior - Maestría'
    WHEN 5  THEN 'Educación superior - Doctorado'
    WHEN 6  THEN 'Frecuencia de educación superior'
    WHEN 9  THEN '12.º año de escolaridad - No completado'
    WHEN 10 THEN '11.º año de escolaridad - No completado'
    WHEN 11 THEN '7.º año (antiguo)'
    WHEN 12 THEN 'Otro - 11.º año de escolaridad'
    WHEN 13 THEN 'Curso complementario de 2.º año de bachillerato'
    WHEN 14 THEN '10.º año de escolaridad'
    WHEN 18 THEN 'Curso general de comercio'
    WHEN 19 THEN 'Educación básica 3.er ciclo (9.º/10.º/11.º año) o equivalente'
    WHEN 20 THEN 'Curso complementario de bachillerato'
    WHEN 22 THEN 'Curso técnico-profesional'
    WHEN 25 THEN 'Curso complementario de bachillerato - No concluido'
    WHEN 26 THEN '7.º año de escolaridad'
    WHEN 27 THEN '2.º ciclo del curso general de bachillerato'
    WHEN 29 THEN '9.º año de escolaridad - No completado'
    WHEN 30 THEN '8.º año de escolaridad'
    WHEN 31 THEN 'Curso general de administración y comercio'
    WHEN 33 THEN 'Contabilidad y administración suplementarias'
    WHEN 34 THEN 'Desconocido'
    WHEN 35 THEN 'No sabe leer ni escribir'
    WHEN 36 THEN 'Sabe leer sin haber cursado un 4.º año de escolaridad'
    WHEN 37 THEN 'Educación básica 1.er ciclo (4.º/5.º año) o equivalente'
    WHEN 38 THEN 'Educación básica 2.º ciclo (6.º/7.º/8.º año) o equivalente'
    WHEN 39 THEN 'Curso de especialización tecnológica'
    WHEN 40 THEN 'Educación superior - Grado (1.er ciclo)'
    WHEN 41 THEN 'Curso de estudios superiores especializados'
    WHEN 42 THEN 'Curso técnico superior profesional'
    WHEN 43 THEN 'Educación superior - Máster (2.º ciclo)'
    WHEN 44 THEN 'Educación superior - Doctorado (3.er ciclo)'
    ELSE 'Otro nivel (código ' || COALESCE(p_codigo::TEXT, 'nulo') || ')'
  END;
END;
$$;

select nombre_nivel_educativo(5);