SET search_path to "mdA_educacion";

--Este procedimiento actualiza la modalidad_Hoararia de una carrera
CREATE OR REPLACE PROCEDURE ActualizarModalidadHoraria(
    IN p_id_carrera INT,
    IN p_nuevoHorario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    --Validamos que el horario sea estrictamente 0 o 1
    IF p_nuevoHorario = 0 OR p_nuevoHorario = 1 THEN
        
        --Validamos si la carrera realmente existe
        IF EXISTS (SELECT 1 FROM carrera WHERE id_carrera = p_id_carrera) THEN
            
            -- Si pasa las validaciones, hacemos el UPDATE
            UPDATE carrera
            SET modalidad_horaria = p_nuevoHorario   
            WHERE id_carrera = p_id_carrera;
            
            -- En Postgres para devolver un mensaje informativo dentro de un procedure se suele usar RAISE NOTICE
            RAISE NOTICE '¡Éxito! La modalidad horaria fue actualizada correctamente.';
            
        ELSE
            RAISE EXCEPTION 'Error: No se encontró ninguna carrera con el ID %.', p_id_carrera;
        END IF;
        
    ELSE
        RAISE EXCEPTION 'Error: La modalidad horaria solo puede ser 0 (nocturna) o 1 (diurna).';
    END IF;
    
END;
$$;

--Pruebo el procedimiento
--Datos como en el dataset
--id_carre = 9853
--modalidad_Horaria = 1
CALL ActualizarModalidadHoraria(9853, 1);

---------------------------------------------------------------------------

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
	select * from estudiante S where S.id_estudiante = 1500;
	select * from estudiante_historial where id_estudiante = 1500;
	select * from estudiante_historial where id_estudiante = 1501;


-- llamada del procedimiento
CALL EliminarEstudiante(999999);
CALL EliminarEstudiante(1500);
CALL EliminarEstudiante(1501);