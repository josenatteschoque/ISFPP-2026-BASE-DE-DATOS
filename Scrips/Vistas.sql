SET search_path to "mdA_educacion";

--Creo una vista para poder ver la cantidad de alumnos y sus estados academicos
CREATE VIEW v_estado_academico AS

--Cuento la cantidad de alumnos que hay
SELECT e.estado_academico, 
	COUNT(*) AS total_estudiantes

--Uso la tabla estudiante
FROM estudiante e

--Los agrupo por su estado_academico
GROUP BY e.estado_academico;

--########################
--Pruebo la vista
SELECT *
FROM v_estado_academico

------------------------------------------

--Esta vista te permite ver cuantos estudiantes tienen o no una beca
CREATE VIEW v_total_becarios AS

SELECT e.becario, 

--Cuanto cuantos estudiantes son
	COUNT(*) AS total_estudiantes

--Uso la tabla estudiante
FROM estudiante e

--Agrupo por los que tiene o no beca
GROUP BY e.becario;

--#################################
--Pruebo la vista
SELECT *
FROM v_total_becarios

------------------------------------------
SET search_path to "mdA_educacion";

--Esta vista te permite ver cuantos estudiantes estan en una carrera aparte su edad de ingreso y su modalidad horaria y sus promedios
CREATE OR REPLACE VIEW v_resumen_ingreso AS
SELECT c.id_carrera, 
	   c.modalidad_horaria,
	   --Con esto tengo la cantidad de alumnos
	   COUNT(e.id_estudiante) AS total_estudiantes,
	   --Con esto tengo el promedio de la calificacion de admision 
	   ROUND(AVG(i.calificacion_admision::NUMERIC), 2) AS promedio_calificacion_admision,
	   --Con esto tengo el promedio de la edad de ingreso
       ROUND(AVG(i.edad_ingreso::NUMERIC), 1) AS edad_promedio_ingreso
FROM carrera c
JOIN inscripcion i
	ON c.id_carrera = i.id_carrera
JOIN estudiante e
	ON i.id_estudiante = e.id_estudiante
GROUP BY c.id_carrera, c.modalidad_horaria;

--Pruebo la vista
SELECT * 
FROM v_resumen_ingreso ORDER BY id_carrera;


------------------------------------------
--Vista que muestra el rendimiento académico agrupado por semestre y estado del estudiante
CREATE OR REPLACE VIEW v_rendimiento_semestre AS
SELECT 
    r.nro_semestre,
    e.estado_academico,
	--Con DISTINCT solo cuenta sin repetir
    COUNT(DISTINCT e.id_estudiante) AS total_estudiantes,
	--Calculo el promedio de las notas
    ROUND(AVG(r.promedio_notas::NUMERIC), 2) AS promedio_general_notas,
	--Calculo el promedio de materias aprobadas
    ROUND(AVG(r.materias_aprobadas::NUMERIC), 2) AS promedio_materias_aprobadas
FROM estudiante e
JOIN rendimiento_academico r 
    ON e.id_estudiante = r.id_estudiante
GROUP BY r.nro_semestre, e.estado_academico;

--Pruebo la vista
SELECT *
FROM v_rendimiento_semestre


--------------------------------------------------------------------------------------------------------------
-- esta vista muestra si aquellos que tenian una calificacion de admision alta tienen mejor promedio o no 
CREATE OR REPLACE VIEW v_calificacion_admision AS
SELECT i.calificacion_admision,r.nro_semestre,
AVG(r.promedio_notas::NUMERIC) AS promedio_academico
from inscripcion i
join rendimiento_academico r 
on i.id_estudiante = r.id_estudiante
group by i.calificacion_admision,r.nro_semestre

-- pruebo la vista
SELECT *
FROM  v_calificacion_admision 
ORDER BY nro_semestre ASC,calificacion_admision DESC;

----------------------------------------------------------------------------------------------------------------
--1 - soltero
--2 – casado
--3 – viudo 
--4 – divorciado
--5 – unión facto
--6 – separado legalmente

-- esta vista muestra el rendimiento academico del estudiante segun el estado civil que tenga 
CREATE OR REPLACE VIEW v_estado_civil AS
SELECT e.estado_civil,AVG(r.promedio_notas :: NUMERIC) AS promedio_academico
from estudiante e 
join rendimiento_academico r 
on e.id_estudiante = r.id_estudiante
group by e.estado_civil;

-- pruebo la vista
SELECT *
FROM v_estado_civil
ORDER BY promedio_academico DESC;

