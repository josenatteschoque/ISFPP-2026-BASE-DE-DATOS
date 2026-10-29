SET search_path TO "mdA_educacion";

--cambiamos las restricciones ya que si no nos daria algunos fallos ala hora de la carga de datos en si 
--o como rangos no contemplados en los anteriores checks
ALTER TABLE estudiante  DROP CONSTRAINT chk_estado_civil;
ALTER TABLE estudiante  ADD CONSTRAINT chk_estado_civil
  CHECK (estado_civil IN (1,2,3,4,5,6));

ALTER TABLE inscripcion DROP CONSTRAINT chk_orden_preferencia;
ALTER TABLE inscripcion ADD CONSTRAINT chk_orden_preferencia
  CHECK (orden_preferencia BETWEEN 0 AND 9);

ALTER TABLE inscripcion DROP CONSTRAINT chk_edad_ingreso;
ALTER TABLE inscripcion ADD CONSTRAINT chk_edad_ingreso
  CHECK (edad_ingreso >= 17);

ALTER TABLE inscripcion DROP CONSTRAINT chk_nota_titulacion_previa;
ALTER TABLE inscripcion ADD CONSTRAINT chk_nota_titulacion_previa
  CHECK (nota_titulacion_previa >= 95);

--///////////////////////////////////////////
--aca se modifico el nombre de la columna ya que contaba con una tabulacion de mas
ALTER TABLE "mdA_educacion".data
  RENAME COLUMN "Daytime/evening attendance	" TO "Daytime/evening attendance";
--/////////////////////////////////
