SET search_path to "mdA_educacion";

--Creo la tabla Economia
CREATE TABLE economia (
id_economia SMALLINT
	CONSTRAINT pk_economia PRIMARY KEY,

--NUMERIC(4,2) permite almacenar hasta 4 dígitos
-- en total, de los cuales 2 son decimales.
tasa_inflacion NUMERIC(4, 2) 
	CONSTRAINT chk_tasa_inflacion 
	CHECK(tasa_inflacion BETWEEN -5 AND 5),

--NUMERIC(4,2) permite almacenar hasta 4 dígitos
-- en total, de los cuales 2 son decimales.
tasa_desempleo NUMERIC(4, 2) 
	CONSTRAINT chk_tasa_desempleo 
	CHECK(tasa_desempleo BETWEEN 5 AND 20),

--NUMERIC(4,2) permite almacenar hasta 4 dígitos
-- en total, de los cuales 2 son decimales.
gdp NUMERIC(4, 2) 
	CONSTRAINT chk_gdp 
	CHECK(gdp BETWEEN -5 AND 5)
);


--Creo la tabla Estudiante
CREATE TABLE estudiante (
id_estudiante SMALLINT
	CONSTRAINT pk_id_estudiante PRIMARY KEY,

becario SMALLINT 
	CONSTRAINT chk_bacario 
	CHECK(becario IN (0, 1)),

genero SMALLINT NOT NULL
	CONSTRAINT chk_genero 
	CHECK( genero IN (0, 1)),
	
nacionalidad iNT NOT NULL
	CONSTRAINT chk_nacionalidad
	CHECK( nacionalidad > 0),
	
estado_civil INT 
	CONSTRAINT chk_estado_civil
	CHECK( estado_civil IN (1, 2, 3, 4)),
	
necesidades_educativas_especiales SMALLINT NOT NULL
	CONSTRAINT chk_necesidades_educativas_especiales
	CHECK( necesidades_educativas_especiales IN (0, 1)),
	
desplazado_trasladado SMALLINT 
	CONSTRAINT chk_desplazado_trasladado 
	CHECK(desplazado_trasladado IN (0, 1)),
	
estado_academico VARCHAR(20) NOT NULL
	CONSTRAINT chk_estado_academico
	CHECK(estado_academico IN ('Graduado', 'Estudiando', 'Abandono')),

id_economia SMALLINT 
	CONSTRAINT fk_id_economia 
	REFERENCES economia(id_economia),

id_familia SMALLINT 
	CONSTRAINT fk_id_familia
	REFERENCES datos_familia(id_familia)
);


--Creo la tabla Datos_familia
CREATE TABLE datos_familia(
id_familia SMALLINT 
	CONSTRAINT pk_id_familia PRIMARY KEY,
	
nivel_educativo_madre INT
	CONSTRAINT chk_nivel_educativo_madre
	CHECK(nivel_educativo_madre > 0),
	
nivel_educativo_padre INT 
	CONSTRAINT chk_nivel_educativo_padre
	CHECK(nivel_educativo_padre > 0),

ocupacion_laboral_padre INT
	CONSTRAINT chk_ocupacion_laboral_padre
	CHECK(ocupacion_laboral_padre >= 0),
	
ocupacion_laboral_madre INT
	CONSTRAINT chk_ocupacion_laboral_madre
	CHECK(ocupacion_laboral_madre >= 0)
);


--Creo la tabla Rendimiento_Academico
CREATE TABLE rendimiento_academico (
id_estudiante SMALLINT,

nro_semestre SMALLINT NOT NULL,

materias_acreditadas INT
	CONSTRAINT chk_materias_acreditadas
	CHECK(materias_acreditadas >= 0),

materias_inscriptas INT
	CONSTRAINT chk_metarias_incirptas
	CHECK(materias_inscriptas >= 0),

materias_aprobadas INT
	CONSTRAINT chk_materias_aprobadas
	CHECK(materias_aprobadas >= 0),
	
promedio_notas NUMERIC(4, 2)
	CONSTRAINT chk_promedio_notas
	CHECK(promedio_notas BETWEEN 0 AND 20),

CONSTRAINT pk_rendimiento_academico
	PRIMARY KEY (id_estudiante, nro_semestre),

CONSTRAINT fk_rendimiento_estudiante
	FOREIGN KEY (id_estudiante)
    REFERENCES estudiante(id_estudiante)
);


--Creo la tabla Carrera
CREATE TABLE carrera(
id_carrera SMALLINT 
	CONSTRAINT pk_id_carrera PRIMARY KEY,

modalidad_horaria SMALLINT NOT NULL
	CONSTRAINT chk_modalidad_horaria
	CHECK(modalidad_horaria IN(0,1 ))
);


--Creo la tabla Inscripcion
CREATE TABLE inscripcion(	
id_inscripcion SMALLINT 
	CONSTRAINT pk_id_inscripcion PRIMARY KEY,
	
edad_ingreso INT
	CONSTRAINT chk_edad_ingreso
	CHECK(edad_ingreso >= 18),
	
calificacion_admision FLOAT
	CONSTRAINT chk_calificacion_admision
	CHECK(calificacion_admision >= 90),
	
nivel_educativo_previo INT
	CONSTRAINT chk_nivel_educativo_previo
	CHECK(nivel_educativo_previo > 0),
	
nota_titulacion_previa FLOAT
	CONSTRAINT chk_nota_titulacion_previa
	CHECK(nota_titulacion_previa >= 100),

orden_preferencia INT
	CONSTRAINT chk_orden_preferencia
	CHECK(orden_preferencia BETWEEN 1 AND 6),

id_carrera SMALLINT 
	CONSTRAINT fk_id_carrera
	REFERENCES carrera(id_carrera),
	
id_estudiante SMALLINT
	CONSTRAINT fk_id_estudiante
	REFERENCES estudiante(id_estudiante)
);
