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

--Pruebo la vista
SELECT *
FROM v_estado_academico
