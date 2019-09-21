-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- verificar ejecucion de servicios de oracle

	-- En linux
	$ ps -ef | grep oracle
 
	-- En windows
	tasklist|findstr /i oracle
 
-- Habilitar conecciones remotas, como usuario SYSTEM ejecutar
EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Conexión a base de datos Oracle
-- sqlplus <username>/<password>@<hostname>:<port>/SID
-- sqlplus SYSTEM/pass2019@127.0.0.1:1521/XE
-- sqlplus SYSTEM as SYSDBA
-- sqlplus SYSTEM/pass2019@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=127.0.0.1)(Port=1521))(CONNECT_DATA=(SID=XE)))
-- sqlplus SYSTEM/pass2019@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=127.0.0.1)(Port=1521))(CONNECT_DATA=(SID=XE))) as SYSDBA

-- CONNECT
-- CONN[ECT] [{logon|/} [AS {SYSOPER | SYSDBA}]]
-- CONN[ECT] [{logon|/|proxy} [AS {SYSOPER | SYSDBA}]]
-- Donde logon: username[/password] [@host]
-- Donde proxy: [username] [/password] [@host]

-- Conectar sql plus remoto
-- sqlplus user/pass@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=hostname.network)(Port=1521))(CONNECT_DATA=(SID=remote_SID))) 
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Obtener informacion de base datos
	$ select * from v$version;
	
-- Obtener oracle Home (12c):
	$ select SYS_CONTEXT ('USERENV','ORACLE_HOME') from dual;
	
-- Para permitir la coneccion de toad como sysdba, ejecutar
	$ grant select on sys.user$ to SYSTEM;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- PARAMETROS
	-- Para cambiar un parametro, necesario reiniciar la base de datos.	
	$ select distinct ISSYS_MODIFIABLE from V$PARAMETER;
	$ select * from V$SPPARAMETER;
	$ select * from V$PARAMETER2;
	$ select * from V$SYSTEM_PARAMETER2;
	$ select * from V$SYSTEM_PARAMETER;
	
	-- Nivel session o Nivel Sistema
	$ ALTER SESSION set NLS_DATE_FORMAT = 'YYYY-MM-DD'
	
	$ ALTER SYSTEM SET NLS_DATE_FORMAT='YYYY-MM-DD' scope=SPFILE;	
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- INICIO/APERTURA BASE DE DATOS

-- Para iniciar/detener una base de datos Oracle por comando haremos lo siguiente:	
	$ sqlplus /nolog

	$ connect {usuario}/{password}@{HOST:PORT}/{SID} [as sysdba]
	
	-- Verificar el estatus de la base de datos
	$ select status from v$instance

	-- Detener la base de datos(commit implicito y desconeccion usuarios conectados)
	$ shutdown immediate
	$ shutdown abort
	$ shutdown normal
	
	-- Checar status del listener.
	$ lsnrctl status


	-- Iniciar base de datos(Inicia la base de datos pero no la monta, útil cuando la base de datos no arranca y hay que ejecutar algún comando de recuperación)
	$ startup nomount
	
	-- Abrir base de datos y montarla
	$ startup mount;
	
	-- Abrir la base de datos y dejar abierta para trasaccionar
	$ ALTER DATABASE OPEN;
	
	-- Reinicar la base de datos:
	srvctl start database -d XE -o mount
	
	-- Checar status instancia
	select instance_name, status from v$instance;
	
	-- Checar modo de la base de dato
	select name, open_mode from v$database;
	
	-- Base de datos en mode lectura;
	$ ALTER DATABASE OPEN READ ONLY;

	-- Base de datos en mode Lectura/Escritura;
	$ ALTER DATABASE OPEN READ WRITE;
			 
	-- Make the parameter of sqlnet.ora file from AUTHENTICATION_SERVICES= (NTS) to AUTHENTICATION_SERVICES= NONE.
	$ SELECT SYS_CONTEXT('USERENV','TERMINAL') 	  FROM dual;
	$ SELECT SYS_CONTEXT('USERENV','HOST') 		  FROM dual;
	$ SELECT SYS_CONTEXT('USERENV','IP_ADDRESS')  FROM dual;
	$ SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Gestion de la instancia de Base de datos

	-- Obtener el usuario actual
	select user from dual;

	-- Nombre de la instancia
	select sys_context('userenv','instance_name') from dual;

	-- Obtener el SID
	SELECT sys_context('USERENV', 'SID') FROM DUAL;


	-- Query para buscar bloqueos de tablas
	select SID,SERIAL# USERNAME from v$SESSION where SID in (select BLOCKING_SESSION FROM v$SESSION);
	
	-- Matar una session desde consola
	ALTER SYSTEM KILL SESSION '<sid>,<serial#>';
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- ADMINISTRACION DE USUARIOS
	-- Granted Roles:
	SELECT *  FROM DBA_ROLE_PRIVS  WHERE GRANTEE = '{usuario}';

	-- Privileges Granted Directly To User:
	SELECT *  FROM DBA_TAB_PRIVS  WHERE GRANTEE = '{usuario}';
	
	-- Privileges Granted to Role Granted to User:
	SELECT *  FROM DBA_TAB_PRIVS 
		WHERE GRANTEE IN (SELECT granted_role FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'USER');

	-- Granted System Privileges:
	SELECT *  FROM DBA_SYS_PRIVS  WHERE GRANTEE = 'USER';
	
	-- ubicar todos los usuarios asignados a un esquema
	SELECT username, account_status, created, lock_date, expiry_date FROM dba_users WHERE account_status != 'OPEN';
 
	-- Eliminar la expiracion del password
	select profile from DBA_USERS where username = 'DESARROLLO';
	 

	SELECT * FROM dba_profiles s WHERE s.profile='DEFAULT' AND resource_name='PASSWORD_LIFE_TIME'; 
	 
	 
	-- Creamos un perfile que hereda los valores por default 
	create profile NO_EXPIRE_PASS limit connect_time 45;
	
	-- Cambiar el Password para SYS/SYSTEM
	-- Conectar con el perfil de SYSDBA
	
	-- $ sqlplus connect as sysdba
	-- $ sqlplus SYS as sysdba
	
	-- Realizar la actualizacion del password
	ALTER USER SYSTEM IDENTIFIED BY newpass2019;
	