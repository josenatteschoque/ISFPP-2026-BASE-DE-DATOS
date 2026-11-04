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