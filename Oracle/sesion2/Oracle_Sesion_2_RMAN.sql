-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- SQLPLUS
-- Sentencias para consultar las ruta de disco para los archivos de control y datos.
$ SELECT * FROM V$LOGFILE;
$ SELECT * FROM V$DATAFILE;
$ SELECT VALUE FROM V$PARAMETER WHERE NAME = 'control_files';
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Comando RMAN
-- https://docs.oracle.com/cd/B19306_01/backup.102/b14194/rcmsynta056.htm

-- En consola de windows o bash de linux
$ rman target /

-- Listar los parametros actuales configurados
$ rman show all;

-- Configurar los respaldos a disco por defecto
$ CONFIGURE DEFAULT DEVICE TYPE TO disk;

-- Configurar el conjunto de copias de disco como images(sin comprimir) 
$ CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COPY;

-- Configurar backup automatico al registrar cambios en el metadatos de oracle
$ CONFIGURE CONTROLFILE AUTOBACKUP ON;

-- Ejecutar el full backup
$ rman backup database;

-- backup the database and all archive log files use: 
-- Realiza un backup completo, incluyendo archivos de log
$ rman BACKUP DATABASE PLUS ARCHIVELOG;

-- para verificar el historico del backup realizados
$ rman list backup;

-- Eliminar todo los backup
rman DELETE BACKUP;

-- Eliminar un backup particular
rman DELETE BACKUPSET  1;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
-- Ubicar la zona FRA(Fast Recovery Area)
select * from v$Parameter where name = 'db_recovery_file_dest';

-- Para realizar un recovery de una base de datos Oracle es necesario
-- Herramienta Recovery Manager (RMAN)
-- Tener un historico BACKUP + archivos Redo Logs

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