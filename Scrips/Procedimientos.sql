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


---------------------------------------------------------------------------------------------
-- Procedimiento para registrar un nuevo estudiante a una carrera existente
-- junto con sus datos familiares y su inscripción
CREATE OR REPLACE PROCEDURE RegistrarEstudianteConInscripcion(
     -- Datos familiares
    IN p_id_familia INT,
	IN p_nivel_educativo_madre INT,
    IN p_nivel_educativo_padre INT,
    IN p_ocupacion_laboral_madre INT,
    IN p_ocupacion_laboral_padre INT,

    -- Datos del estudiante
	IN p_id_estudiante INT,
    IN p_becario INT,
    IN p_genero INT,
    IN p_nacionalidad INT,
    IN p_estado_civil INT,
    IN p_necesidades_educativas_especiales INT,
    IN p_desplazado_trasladado INT,

    -- Datos de inscripción
	IN p_id_inscripcion INT,
    IN p_edad_ingreso INT,
    IN p_calificacion_admision FLOAT,
    IN p_nivel_educativo_previo INT,
    IN p_nota_titulacion_previa FLOAT,
    IN p_orden_preferencia INT,

	 IN p_id_carrera INT,
    IN p_id_economia INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    --  Validar los nuevos identificadores
    IF p_id_estudiante IS NULL OR p_id_estudiante <= 0
       OR p_id_familia IS NULL OR p_id_familia <= 0
       OR p_id_inscripcion IS NULL OR p_id_inscripcion <= 0
    THEN
        RAISE EXCEPTION
        'Los identificadores tienen que ser positivos';
    END IF;

     --Validamos si la carrera realmente existe
    IF p_id_carrera IS NULL OR NOT EXISTS (
        SELECT 1 FROM carrera
        WHERE id_carrera = p_id_carrera
    ) THEN
        RAISE EXCEPTION 'La carrera no existe';
    END IF;

    --  Verificar que exista el registro económico
    IF p_id_economia IS NULL OR NOT EXISTS (
        SELECT 1 FROM economia
        WHERE id_economia = p_id_economia
    ) THEN
        RAISE EXCEPTION
        'El registro economico no existe';
    END IF;

    --  Verificar que complete los datos familiares
    IF p_nivel_educativo_madre IS NULL
       OR p_nivel_educativo_padre IS NULL
       OR p_ocupacion_laboral_madre IS NULL
       OR p_ocupacion_laboral_padre IS NULL
    THEN
        RAISE EXCEPTION
        'Debe completar todos los datos familiares';
    END IF;

    --  Verificar que complete los datos de inscripcion
    IF p_edad_ingreso IS NULL
       OR p_calificacion_admision IS NULL
       OR p_nivel_educativo_previo IS NULL
       OR p_nota_titulacion_previa IS NULL
       OR p_orden_preferencia IS NULL
    THEN
        RAISE EXCEPTION
        'Debe completar todos los datos de inscripción';
    END IF;

    --  Registrar los datos familiares
    INSERT INTO datos_familia (id_familia,nivel_educativo_madre,nivel_educativo_padre,ocupacion_laboral_madre,ocupacion_laboral_padre)
    VALUES (p_id_familia,p_nivel_educativo_madre,p_nivel_educativo_padre,p_ocupacion_laboral_madre,p_ocupacion_laboral_padre);

    --  Registrar al estudiante
    -- El estado se le asigna automaticamente
    INSERT INTO estudiante (id_estudiante,becario,genero,nacionalidad,estado_civil,necesidades_educativas_especiales,desplazado_trasladado,estado_academico,id_economia,id_familia)
    VALUES (p_id_estudiante,p_becario,p_genero,p_nacionalidad,p_estado_civil,p_necesidades_educativas_especiales,p_desplazado_trasladado,'Estudiando',p_id_economia,p_id_familia);

    --  Registrar la inscripcion a una carrera
    INSERT INTO inscripcion (id_inscripcion,edad_ingreso,calificacion_admision,nivel_educativo_previo,nota_titulacion_previa,orden_preferencia,id_carrera,id_estudiante)
    VALUES (p_id_inscripcion,p_edad_ingreso,p_calificacion_admision,p_nivel_educativo_previo,p_nota_titulacion_previa,p_orden_preferencia,p_id_carrera,p_id_estudiante);

    RAISE NOTICE
    'El estudiante % fue registrado e inscripto correctamente en la carrera %',
    p_id_estudiante, p_id_carrera;
	
END;
$$;

-- pruebo el procedimiento
CALL RegistrarEstudianteConInscripcion(

    -- Datos familiares
    30000, -- ID familia
    4,     -- Nivel educativo madre
    3,     -- Nivel educativo padre
    5,     -- Ocupación madre
    4,     -- Ocupación padre

    -- Datos del estudiante
    30001, -- ID estudiante
    0,     -- Becario
    1,     -- Género
    1,     -- Nacionalidad
    1,     -- Estado civil
    0,     -- Necesidades educativas especiales
    0,     -- Desplazado/trasladado

    -- Datos de inscripcion
    30002, -- ID inscripcion
    19,    -- Edad de ingreso
    150,   -- Calificación de admision
    1,     -- Nivel educativo previo
    160,   -- Nota titulación previa
    1,     -- Orden de preferencia

    -- Carrera y economia
    9853,  -- ID carrera
    1      -- ID economía
);

