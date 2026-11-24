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


--///////////////// TRIGGER /////////////////////////////////////////////////////
SET search_path TO "mdA_educacion";

CREATE OR REPLACE PROCEDURE EliminarEstudiante(id_del_estudiante int)
LANGUAGE plpgsql
AS $$
DECLARE

BEGIN
--primero se valida que el id del estudiante ingreasado pertenezca ala tabla estudiante 
--y sino se corta el procedimiento con una exception y muestra un mensaje
	if not exists(	select 1 from estudiante E where E.id_estudiante = id_del_estudiante) then
		raise exception 'error no se encontro ningun estudiante con ese id: %', id_del_estudiante;
	end if;
--despues de que se valide el id se guarda  en la tabla estudiante_historial id_estudiante , datos_anteriores ,tipo_operacion
--esto se inserta apartir del resultado de la siguiente consulta que me devuelve el id_estudiante el jsonb(E) y en eltipo de operacion el 'DELETE'
--la funcion to_jsonb(E) devuelve un json por cada fila pasada que esta lo toma con el indice E
--el formato del json es {"clave":valor,"nombre de la columna":valor}

	insert into estudiante_historial(id_estudiante,datos_anteriores,tipo_operacion)
	select E.id_estudiante, to_jsonb(E), 'DELETE'
	from estudiante E
	where E.id_estudiante = id_del_estudiante;
	
	--se elimina primero las filas de las tablas que tienen como fk el id estudiante 
	delete from alertas_riesgo R where R.id_estudiante = id_del_estudiante;
	delete from rendimiento_academico A where A.id_estudiante = id_del_estudiante;
	delete from inscripcion  B where  B.id_estudiante = id_del_estudiante;
	--una ves eliminadas las filas de las otras tablas eliminamos la fila del estudiante de la tabla estudiante
	delete from estudiante S where S.id_estudiante = id_del_estudiante;
	--se muestra un mensaje de que el estudiante fue eliminado dorrectamente
	RAISE NOTICE 'se elimino correctamente el estudiante con el id: %', id_del_estudiante;


END;
$$;

	select * from rendimiento_academico A where A.id_estudiante = 1500;
	select * from inscripcion  B where  B.id_estudiante = 1500;
	select * from estudiante S where S.id_estudiante = 1502;
	select * from estudiante_historial where id_estudiante = 1500;
	select * from estudiante_historial where id_estudiante = 1501;



-- llamada del procedimiento
CALL EliminarEstudiante(999999);
CALL EliminarEstudiante(1500);
CALL EliminarEstudiante(1502



-- esta consulta calcula la tasa de aprobacion promedio (materias aprobadas / materias inscriptas) 
-- agrupada por estado academico (Graduado, Estudiando,Abandono)
-- sus resultados se usaron como referencia para definir el umbral de riesgo (0.5) del trigger
SELECT e.estado_academico,
       ROUND(AVG(r.materias_aprobadas::numeric / r.materias_inscriptas), 2) AS tasa_aprobacion
FROM rendimiento_academico r JOIN estudiante e ON (e.id_estudiante = r.id_estudiante)
WHERE r.materias_inscriptas > 0
GROUP BY e.estado_academico;


CREATE TABLE alertas_riesgo (
    id_alerta     SERIAL PRIMARY KEY,
    id_estudiante SMALLINT NOT NULL REFERENCES estudiante(id_estudiante),
    nro_semestre  SMALLINT NOT NULL   
		CONSTRAINT chk_alerta_nro_semestre 
		CHECK (nro_semestre IN (1, 2)),
    motivo        VARCHAR(100),
    fecha_alerta  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,-- si no se indica se guarda la fecha y hora en que se creo la alerta
    UNIQUE (id_estudiante, nro_semestre)  -- evita alertas duplicadas para el mismo estudiante y semestre
);


CREATE OR REPLACE FUNCTION fn_alerta_riesgo()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
 	--aca pregunta en si e alumno que fue insertado o modificado de la tabla rendimiento_academico
	--su estado esta en "Estudiando" si no es asi ya que esta en "Abandono" o "Graduado" el programa no hace nd
    IF NOT EXISTS (SELECT 1 FROM estudiante E WHERE E.id_estudiante = NEW.id_estudiante AND E.estado_academico = 'Estudiando') THEN
        RETURN NEW;
    END IF;

    IF (NEW.materias_inscriptas = 0) THEN-- si las materia inscriptas son iguales a cero para no dividir por cero hacemos que sean un nuevo tipo de riesgo
        INSERT INTO alertas_riesgo (id_estudiante, nro_semestre, motivo)--insertamos en la tabla riesgo
        VALUES (NEW.id_estudiante, NEW.nro_semestre, 'no se inscribió a ninguna materia en el semestre')--insertamos los valores de la fila cambiada y el motivo que en este caso es 'no se inscribió a ninguna materia en el semestre' 
        ON CONFLICT (id_estudiante, nro_semestre)-- si esta fila choca con la unique en si
        DO UPDATE SET motivo = EXCLUDED.motivo;  -- es dejar el resto de la fila de la tabla tal y como esta y solo modificar la columna motivo

    ELSIF (NEW.materias_aprobadas::NUMERIC / NEW.materias_inscriptas < 0.5 )THEN --si la tasa de aprobacion es menor al umbral 
        INSERT INTO alertas_riesgo (id_estudiante, nro_semestre, motivo)
        VALUES (NEW.id_estudiante, NEW.nro_semestre, 'Aprobó menos de la mitad de las materias inscriptas')
        ON CONFLICT (id_estudiante, nro_semestre)-- si esta fila choca con la unique en si
        DO UPDATE SET motivo = EXCLUDED.motivo;  -- es dejar el resto de la fila de la tabla tal y como esta y solo modificar la columna motivo

    ELSE--si al modificar dicha fila ya no cumple con los requerimientos para estar en alerta de riesgo se eliminan de manera automatica de dicha tabla
        DELETE FROM alertas_riesgo
        WHERE id_estudiante = NEW.id_estudiante
          AND nro_semestre = NEW.nro_semestre;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_alerta_riesgo
AFTER INSERT OR UPDATE OF materias_inscriptas, materias_aprobadas
ON rendimiento_academico
FOR EACH ROW
EXECUTE FUNCTION fn_alerta_riesgo();


-- esto se uso par ala carga de los datos previamente cargados en dicha tabla para que se disparen con el update y como asignamos lo mism no se cambio los valores del data set original
UPDATE rendimiento_academico
SET materias_aprobadas = materias_aprobadas;

select * from alertas_riesgo where id_estudiante = 167

UPDATE rendimiento_academico
SET materias_inscriptas = 0
WHERE id_estudiante = 167
  AND nro_semestre = 2;				
