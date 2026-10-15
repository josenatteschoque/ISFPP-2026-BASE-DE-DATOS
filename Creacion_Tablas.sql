SET search_path to mdA_educacion;

CREATE TABLE economia(
id_economia SMALLINT
	CONSTRAINT pk_economia PRIMARY KEY,

tasa_inflacion NUMERIC(4, 2) 
	CONSTRAINT chk_tasa_inflacion 
	CHECK(tasa_inflacion BETWEEN -5 AND 5),

tasa_desempleo NUMERIC(4, 2) 
	CONSTRAINT chk_tasa_desempleo 
	CHECK(tasa_desempleo BETWEEN 5 AND 20),

gdp NUMERIC(4, 2) 
	CONSTRAINT chk_gdp 
	CHECK(gdp BETWEEN -5 AND 5)
)