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

