CREATE OR REPLACE PROCEDURE DESARROLLO.sp_welcome (p_name IN VARCHAR2) IS
BEGIN
	dbms_output.put_line ('Welcome '|| p_name);
END;
/