--  Backup Oracle en frío u offline 

-- Para realizar una copia completa de nuestro base de una datos Oracle en frio u offline, 
-- debemps hacer copia de los siguientes ficheros:

-- Ficheros de datos
-- Fichero de control
-- Redo logs
-- Los ficheros archivados de redo log en caso de estar activo
-- Ficheros de passwd. Es recuperable, pero nos facilita la vida, si los tenemos
-- Ficheros de configuración de la red. Es recuperable, pero nos facilita la vida, si los tenemos
-- pfile y spfile. Es recuperable, pero nos facilita la vida, si los tenemos


-- PASOS PARA REALIZAR UNA COPIA DE SEGURIDAD EN FRIO U OFFLINE

-- 1.- Notificar a los usuarios que se desconecten o en su defecto finalizar las sesiones.
-- 2.- Buscar y listar ficheros de control, datos y configuración de la base de datos.

	-- Ubicar los ficheros de datos
	$ select name from v$datafile;
	
	-- Ubicar los ficheros de control
	$ show parameters control_files;
	
	-- Ubicar los ficheros de log
	$ select member from v$logfile;
	
	-- Ubicar los fichero de redo log, en caso de estar habilitado el modo archive log
	$ show parameters archive_dest;

	-- Ubicar el fichero de password, pfile y el spfile, suele estar todos en el mismo directorio
	$ show parameters pfile
	
	-- Detener la base de datos
	$ sqlplus / as sysdba;
	$ shutdown immediate;
	
	-- Realizar la copia de seguridad de los ficheros a un medio fisico
	
	-- Linux
	$ cp /opt/oracle/product/11.2.0/dbhome_1/network/admin/listener.ora /media/backup/backup_20190925
	$ cp /opt/oracle/product/11.2.0/dbhome_1/network/admin/sqlnet.ora /media/backup/backup_20190925
	$ cp /opt/oracle/product/11.2.0/dbhome_1/network/admin/tnsnames.ora /media/backup/backup_20190925
	
	-- Windows
	COPY "C:\ORACLEXE\APP\ORACLE\ORADATA\XE\SYSTEM.DBF" "C:\oracle\backups\20190925"
	
	-- Finalizada la copia de los archivos, para restaurar la base bastaría con poner todos los ficheros 
	-- en los mismos directorios desde donde se copiaron.
	