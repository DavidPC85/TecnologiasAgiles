-- Url donde se encuentra la documentacion para las auditorias
-- https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_4007.htm

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Verificar si esta habiltiado el parametro AUDIT_TRAIL
$ select name, value from v$parameter where name like 'audit_trail';

$ show PARAMETER AUDIT;

-- Para habilitar la auditoria
$ alter system set audit_trail='DB','EXTENDED' scope=spfile;

-- Para deshabilitar la auditoría 
$ ALTER SYSTEM SET audit_trail='NONE' SCOPE=SPFILE;

-- Para ambos casos en necesario reiniciar la base de datos

$ shutdown immediate;

$ startup;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- La tabla SYS.AUD$ es la estructura de datos para registrar todos los eventos de auditoria. 
-- varias vistas se basan en esta tabla:
$ select * from SYS.AUD$ order by NTIMESTAMP# desc;

-- Consulta para listar la vistas de auditoria para toda la base de datos
$ select view_name FROM dba_views WHERE view_name LIKE '%AUDIT%' ORDER BY view_name;

-- guarda la información relativa a la auditoría de objetos
$ select * from DBA_AUDIT_OBJECT;

-- guarda la información relativa a la auditoría de los inicios de sesión de los usuarios.
$ select * from DBA_AUDIT_SESSION;

--muestra la auditoría estándar (de la tabla AUD$)
$ select * from DBA_AUDIT_TRAIL;

-- muestra la auditoría estándar (de la tabla AUD$) relativa al usuario actual
$ select * from USER_AUDIT_TRAIL;

-- muestra información de auditoría de grano fino(obtenida de FGA_LOG$)
$ select * from DBA_FGA_AUDIT_TRAIL;
 
-- La vista DBA_COMMON_AUDIT_TRAIL combina los registros log de auditoría estándar y detallada
$ select * from DBA_COMMON_AUDIT_TRAIL;

-- Verificar los registros de auditorias generados
$ select s.AUDIT_TYPE, s.SESSION_ID, to_char(s.EXTENDED_TIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') as FechaOper, 
	s.DB_USER,COMMENT_TEXT, s.SQL_TEXT, s.PRIV_USED
	from DBA_COMMON_AUDIT_TRAIL s
	where EXTENDED_TIMESTAMP > (CURRENT_DATE - 1) order by EXTENDED_TIMESTAMP desc;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		
-- Habilitar la auditoria para acciones de dba
$ ALTER SYSTEM SET audit_sys_operations=true SCOPE=spfile;

-- Habilitamos la auditoria de sentencias DML 
$ AUDIT SELECT, INSERT, UPDATE, DELETE ON DESARROLLO.TBL_CONFIGURACION BY ACCESS WHENEVER SUCCESSFUL;

-- Deshabilitar la auditoria por DML especifico
$ NOAUDIT SELECT ON DESARROLLO.TBL_CONFIGURACION WHENEVER SUCCESSFUL; 

-- Ejemplos de auditorias de privilegios de sistema
$ AUDIT select any table, create any trigger

$ AUDIT select any table by DESARROLLO by session;

-- Ejemplo de auditoria por objeto
$ AUDIT UPDATE, DELETE ON DESARROLLO.TBL_CONFIGURACION BY ACCESS;

-- consultas para verificar que opciones y privilegios estan actualmente activos
$ SELECT * FROM dba_stmt_audit_opts;
$ SELECT * FROM dba_priv_audit_opts;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Auditorías de inicio de sesión:

-- Auditar tanto los intentos fallidos como los aciertos.
$ audit session;

-- Auditar intentos fallidos 
$ audit session whenever not successful;

-- Auditar intentos exitosos
$ audit session whenever successful;

-- Habilitar auditoria para un usuario en particular
$ audit update table, delete table, insert table by DESARROLLO by access;

-- consulta para obtener las auditorias por inicio de sesión:
$ select OS_Username Usuario_SO, 
	Username Usuario_Oracle, Terminal ID_Terminal,
	DECODE (Returncode, '0', 'Conectado', '1005', 'Fallo - Null', 
	1017, 'Fallo', Returncode) Tipo_Suceso,
	TO_CHAR(Timestamp, 'DD-MM-YY HH24:MI:SS') Hora_Inicio_Sesion,
	TO_CHAR(Logoff_Time, 'DD-MM-YY HH24:MI:SS') Hora_Fin_Sesion
from DBA_AUDIT_SESSION;

-- Deshabilitar auditoria de session por usuario
$ NOAUDIT CREATE SESSION BY DESARROLLO;

-- Deshabilitar auditoria para todos los usuarios 
$ NOAUDIT CREATE SESSION;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Auditorías de acción:

-- Habilitar la auditoria para DELETE en las tablas 
$ AUDIT DELETE ANY TABLE BY ACCESS;
	
-- Habilitar la auditoria para los insert, update, delete y ejecucion de procedures
$ AUDIT INSERT TABLE, DELETE TABLE, UPDATE TABLE, EXECUTE PROCEDURE BY DESARROLLO BY ACCESS;
	
-- consulta par auditoría de acción:
$ select OS_Username Usuario_SO, 
    Username Usuario_Oracle, Terminal ID_Terminal,
    Owner Propietario_Objeto,
    Obj_Name Nombre_Objeto, 
    Action_Name Accion,
    DECODE (Returncode, '0', 'Realizado', 'Returncode') Tipo_Suceso,
    TO_CHAR (EXTENDED_TIMESTAMP,  'DD-MM-YY HH24:MI:SS') Hora
from DBA_AUDIT_OBJECT ORDER BY EXTENDED_TIMESTAMP desc;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- AUDITORIAS DETALLADAS

-- Ejemplo de una politica granular detallada
$ begin
	dbms_fga.add_policy(
		object_schema => 'DESARROLLO',
		object_name => 'MUNICIPIOS_YUC',
		policy_name => 'audit_dml_municipios',
		audit_condition => 'IIDMUNICIPIO > 0',
		audit_column => 'SNOMBRE,SDESCRIPCION,DTFECHA_MOD',
		handler_schema => null,
		handler_module => null,
		enable => true,
		statement_types => 'INSERT, UPDATE'
	);
end;
/

-- http://www.dba-oracle.com/art_so_oracle_standard_enterprise_edition.htm

-- Deshabilitar una politica
$ dbms_fga.disable_policy('DESARROLLO', 'TBLCONFIGURACION', 'audit_dml_config');

-- DBMS_FGA.DROP_POLICY(object_schema  VARCHAR2, object_name    VARCHAR2, policy_name    VARCHAR2);
$ DBMS_FGA.ENABLE_POLICY('DESARROLLO', 'MUNICIPIOS_YUC', 'audit_dml_municipios', TRUE);

	
 
 
