SET search_path to 'mdA_educacion'

--Creo esta tabla auxiliar
CREATE TABLE datos_crudos (
    "Marital status" VARCHAR,
    "Application mode" VARCHAR,
    "Application order" VARCHAR,
    "Course" VARCHAR,
    "Daytime/evening attendance" VARCHAR,
    "Previous qualification" VARCHAR,
    "Previous qualification (grade)" VARCHAR,
    "Nacionality" VARCHAR,
    "Mother's qualification" VARCHAR,
    "Father's qualification" VARCHAR,
    "Mother's occupation" VARCHAR,
    "Father's occupation" VARCHAR,
    "Admission grade" VARCHAR,
    "Displaced" VARCHAR,
    "Educational special needs" VARCHAR,
    "Debtor" VARCHAR,
    "Tuition fees up to date" VARCHAR,
    "Gender" VARCHAR,
    "Scholarship holder" VARCHAR,
    "Age at enrollment" VARCHAR,
    "International" VARCHAR,
    "Curricular units 1st sem (credited)" VARCHAR,
    "Curricular units 1st sem (enrolled)" VARCHAR,
    "Curricular units 1st sem (evaluations)" VARCHAR,
    "Curricular units 1st sem (approved)" VARCHAR,
    "Curricular units 1st sem (grade)" VARCHAR,
    "Curricular units 1st sem (without evaluations)" VARCHAR,
    "Curricular units 2nd sem (credited)" VARCHAR,
    "Curricular units 2nd sem (enrolled)" VARCHAR,
    "Curricular units 2nd sem (evaluations)" VARCHAR,
    "Curricular units 2nd sem (approved)" VARCHAR,
    "Curricular units 2nd sem (grade)" VARCHAR,
    "Curricular units 2nd sem (without evaluations)" VARCHAR,
    "Unemployment rate" VARCHAR,
    "Inflation rate" VARCHAR,
    "GDP" VARCHAR,
    "Target" VARCHAR
);

--Chekeo si estan los datos cargados
SELECT *
FROM datos_crudos

SELECT na."Nacionality"
FROM datos_crudos na