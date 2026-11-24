SET search_path to "mdA_educacion";

--///////////////// TABLA ESTUDIANTE HISTORIAL ///////////////////////////////////////////
--Creo esta tabla para el guardado del historial de cambio de algun alumno
CREATE TABLE estudiante_historial (
    id_historial SERIAL PRIMARY KEY,
    id_estudiante SMALLINT,
    datos_anteriores JSONB,                     -- ¡Acá se guarda toda la fila vieja de un saque!
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion VARCHAR(20)
);

--///////////////// FUNCION PARA GUARDAR EL HISTORIAL DE CAMBIOS DE UN ALUMNO///////////////////////////////////////////
CREATE OR REPLACE FUNCTION fn_guardar_historial_json()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO estudiante_historial (
        id_estudiante, 
        datos_anteriores, 
        tipo_operacion
    ) 
    VALUES (
        OLD.id_estudiante, 
        to_jsonb(OLD),            --convierte toda la fila en JSON!
        'UPDATE'
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--///////////////// TRIGGER AUDITORIA ESTUDIANTE JSON /////////////////////////////////////////////////////
--Creo un trigger que actue antes de hacer un cambio y gaurde una copia de los datos	
CREATE TRIGGER trg_auditoria_estudiante_json
BEFORE UPDATE ON estudiante
FOR EACH ROW
EXECUTE FUNCTION fn_guardar_historial_json();


--///////////////// PRUEBO EL TRIGGER /////////////////////////////////////////////////////
--Aqui modifique su estado academico a estudiando antes estaba 'Abandono'
UPDATE estudiante
SET estado_academico = 'Estudiando'
WHERE id_estudiante = 1000

--Aqui busque el estudiante cuales datos tenia
SELECT *
from estudiante
Where id_estudiante = 1000

--Y aqui me fije los datos que guardo 
SELECT *
FROM estudiante_historial

--///////////////// VERIFICAR MATERIAS APROBADAS ///////////////////////////////////////////
-- un trigger que evita registrar cantidades de materias aprobadas superiores a las materias inscriptas
-- no guardar datos académicos inconsistentes cuando se cargan o modifican resultados
CREATE OR REPLACE FUNCTION verificar_materias_aprobadas()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.materias_aprobadas > NEW.materias_inscriptas
    THEN
        RAISE EXCEPTION
        'Las materias aprobadas no pueden superar las materias inscriptas';
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_verificar_materias_aprobadas
BEFORE INSERT OR UPDATE
ON rendimiento_academico
FOR EACH ROW
EXECUTE FUNCTION verificar_materias_aprobadas();

-- modifico un estudiante con la misma cantidad de materias aprobadas como inscriptas
UPDATE rendimiento_academico
SET materias_inscriptas = 6,
    materias_aprobadas = 8
WHERE id_estudiante = 300
  AND nro_semestre = 1;


SELECT * FROM rendimiento_academico
WHERE id_estudiante = 300
  AND nro_semestre = 1;

