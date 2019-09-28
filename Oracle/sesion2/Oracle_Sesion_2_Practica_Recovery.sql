-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Caso practico para elaboracion de un backup y recuperacion de una caida de disco fisico
-- Generar el escenario para pruebas

-- Crear un table space en una unidad extraible
CREATE TABLESPACE TBS_PRUEBA DATAFILE 'H:\DF_PRUEBA.DBF' SIZE 3M; 

-- Generar una tabla para efectos de pruebas
CREATE TABLE TBL_DATOS_PRUEBA(
	IID INTEGER NOT NULL, 
	SDESCRIPCION VARCHAR(64), 
	CONSTRAINT PK_DATOS_PRUEBA PRIMARY KEY (ID)
) TABLESPACE TBS_PRUEBA;

-- Poblar la tabla con 10000 registros
INSERT INTO TBL_DATOS_PRUEBA(IID, SDESCRIPCION) 
SELECT LEVEL, 'AAA'|| LEVEL as DESCRIP 
FROM DUAL CONNECT BY LEVEL <= 10000;

commit work;

-- Contar la totalidad de registros insertados
select count(1) from TBL_DATOS_PRUEBA;

-- Realizar CHECKPOINT y forzar a bajar a disco la informacion almacenada en buffer y memoria
ALTER SYSTEM CHECKPOINT;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- PROCESO DE RECUPERACION CON (RMAN)
-- Son necesario 2 comandos : Restore y Recovery

-- Comando para restaurar estructuras de base de datos
$ rman RESTORE TABLESPACE TBS_PRUEBA;

-- Comando para recuperar el contenido/datos de la tablespace restaurado
$ rman RECOVER TABLESPACE TBS_PRUEBA;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Comandos sql para manejo de tablespace

-- Habilitar tablespace
ALTER TABLESPACE TBS_PRUEBA ONLINE;

-- Deshabilitar tablespace
ALTER TABLESPACE TBS_PRUEBA OFFLINE;

-- Remover un tablespace con todo y data
DROP TABLESPACE TBS_PRUEBA INCLUDING CONTENTS AND DATAFILES;
--- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Para recuperar la base de datos de una caida.

-- iniciar la instancia de base de datos pero evitar montarla
rman startup nomount;

-- restaurar completamente la base de datos de una caida
rman restore controlfile from autobackup;

-- Montar la base de datos despues de la recuperacion del control file
rman alter database mount;

-- Finalizada la base de datos montada, restaurar la estructura de datos
rman restore database;

-- Finalmente recuperar la data y poblar la estructuras
rman recover database;

-- Abrir la base de datos y reinicar los logs
rman alter database open resetlogs;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 