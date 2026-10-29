SET search_path to "mdA_educacion";

-- "mdA_educacion"."data" definition

-- Drop table

-- DROP TABLE "mdA_educacion"."data";

CREATE TABLE "mdA_educacion"."data" (
	"Marital status" varchar NULL,
	"Application mode" varchar NULL,
	"Application order" varchar NULL,
	"Course" varchar NULL,
	"Daytime/evening attendance	" varchar NULL,
	"Previous qualification" varchar NULL,
	"Previous qualification (grade)" varchar NULL,
	"Nacionality" varchar NULL,
	"Mother's qualification" varchar NULL,
	"Father's qualification" varchar NULL,
	"Mother's occupation" varchar NULL,
	"Father's occupation" varchar NULL,
	"Admission grade" varchar NULL,
	"Displaced" varchar NULL,
	"Educational special needs" varchar NULL,
	"Debtor" varchar NULL,
	"Tuition fees up to date" varchar NULL,
	"Gender" varchar NULL,
	"Scholarship holder" varchar NULL,
	"Age at enrollment" varchar NULL,
	"International" varchar NULL,
	"Curricular units 1st sem (credited)" varchar NULL,
	"Curricular units 1st sem (enrolled)" varchar NULL,
	"Curricular units 1st sem (evaluations)" varchar NULL,
	"Curricular units 1st sem (approved)" varchar NULL,
	"Curricular units 1st sem (grade)" varchar NULL,
	"Curricular units 1st sem (without evaluations)" varchar NULL,
	"Curricular units 2nd sem (credited)" varchar NULL,
	"Curricular units 2nd sem (enrolled)" varchar NULL,
	"Curricular units 2nd sem (evaluations)" varchar NULL,
	"Curricular units 2nd sem (approved)" varchar NULL,
	"Curricular units 2nd sem (grade)" varchar NULL,
	"Curricular units 2nd sem (without evaluations)" varchar NULL,
	"Unemployment rate" varchar NULL,
	"Inflation rate" varchar NULL,
	"GDP" varchar NULL,
	"Target" varchar(50) NULL
);

SELECT COUNT(*)
FROM "mdA_educacion".data;

SELECT *
FROM "mdA_educacion".data

SELECT "Nacionality" , "Target" 
FROM "mdA_educacion".data;