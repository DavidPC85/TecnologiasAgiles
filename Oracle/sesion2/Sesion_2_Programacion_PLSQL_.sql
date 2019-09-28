-- PL/SQL es una extensión de programación a SQL.
-- Es el lenguaje de programación de 4ta generación para base de datos Oracle.

-- Ventajas principales
-- * Permite crear programas modulares.
-- * Integración con herramientas de Oracle.
-- * Portabilidad
-- * Maneja Excepciones

-- Un código en PLSQL puede ser de dos tipos: bloque anónimo y subprogramas.
-- Un bloque anónimo es básicamente aquel que el código fuente reside en el lado
-- cliente y es de una sola ejecución. En cambio un subprograma tiene el código fuente residente en el servidor. 
-- Los subprogramas pueden ser: stored procedures, funciones, triggers y packages.

-- Para ejecutar un script desde en sqlplus, se utiliza la sintaxis
-- SQL > @{path}{file}

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- La tabla DUAL es una tabla especial de una sola columna presente de manera predeterminada en todas 
-- las instalaciones de bases de datos de Oracle. 
-- Se utiliza para seleccionar una seudocolumna de elementos que no forman parte de una tabla o vista.

-- Especifica si la salida del almacenamiento intermedio de mensajes se redirige a una salida estándar.
SET SERVEROUTPUT ON;

-- Bloque anonimo dummy
DECLARE

BEGIN
  NULL;
END;

-- Bloque anonimo para imprimir en consola 'HOLA MUNDO'
DECLARE

  V_CADENA VARCHAR2(20) := 'HOLA MUNDO';
  
BEGIN
  DBMS_OUTPUT.PUT_LINE(V_CADENA);
END;
/

-- Bloque anonimo para sumar 2 numeros decimales
DECLARE
  V_NUM1 NUMBER(4,2) := 10.2;
  V_NUM2 NUMBER(4,2) := 20.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE('LA SUMA ES: '||TO_CHAR(V_NUM1 + V_NUM2));
END;

/
-- Bloque anonimo para concatenar 2 cadenas
DECLARE 
  v_Cadena1 VARCHAR2(100) := 'Texto Pruebas 2';
  v_Cadena2 VARCHAR2(100) := 'Texto Pruebas 2';
BEGIN
  DBMS_OUTPUT.put_line(v_Cadena1 || ' - ' || v_Cadena2);
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(sqlerrm);    
END;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Ejemplo de Procedure, con parametros de entrada
CREATE OR REPLACE PROCEDURE DESARROLLO.SP_OBTENER_FECHA (p_name IN VARCHAR2) IS
BEGIN
	dbms_output.put_line (p_name || ' la fecha/hora es: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(sqlerrm);    
END;
/
exec DESARROLLO.SP_OBTENER_FECHA('juanito');
/

-- Procedure para recibir 2 parametros de tipo caracter y concatenarlos para posterior devolver el resultado
CREATE OR REPLACE PROCEDURE DESARROLLO.SP_CONCATENAR(
  p_cadena1 IN VARCHAR2, 
  p_cadena2 IN VARCHAR2, 
  out_resultado OUT VARCHAR2) IS
BEGIN
  out_resultado := '';
  
  out_resultado := 'El resultado de concatenar es: ' || p_cadena1 ||' ' || p_cadena2;
  
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(sqlerrm);    
END;
/
-- Ejecucion del procedure SP_CONCATENAR
DECLARE 
  v_CADENA  VARCHAR2(256) := '';
BEGIN
  DESARROLLO.SP_CONCATENAR('juanito', 'juanales', v_CADENA);
  dbms_output.put_line(v_CADENA);
END;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Ejemplo de funcioon
CREATE OR REPLACE Function DESARROLLO.FN_SUMA(p_valor1 IN INTEGER, p_valor2 IN INTEGER)
RETURN INTEGER
IS
   iResultado INTEGER := 0;   
BEGIN
  iResultado := p_valor1 + p_valor2;
  RETURN iResultado;
EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;
/
select DESARROLLO.FN_SUMA(2,2) as SUMA from dual;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Declaración de variables

-- <mivar> <tipo_dato>;

-- CHAR, VARCHAR, NUMBER, BINARY_INTEGER, PLSQL_INTEGER, BOOLEAN, BINARY_FLOAT, BINARY_DOUBLE, DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE.

-- Casting entre tipos de datos:TO_NUMBER, TO_CHAR y TO_DATE

-- TO_CHAR => https://www.techonthenet.com/oracle/functions/to_char.php
DECLARE
    dtFecha DATE;
begin
    dtFecha := TO_DATE('2019-09-15', 'YYYY-MM-DD');
    dbms_output.put_line('TO_CHAR(20)=>'|| TO_CHAR(20));
    dbms_output.put_line('TO_CHAR(20.12)=>'|| TO_CHAR(20.12));
    dbms_output.put_line('TO_CHAR(SYSDATE)=>' || TO_CHAR(SYSDATE,'YYYY'));
    dbms_output.put_line('TO_CHAR(SYSDATE)=>' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    dbms_output.put_line('TO_CHAR(SYSDATE)=>' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
   
    dbms_output.put_line('TO_CHAR(SYSDATE)=>' || TO_CHAR(dtFecha, 'YYYY-MM-DD'));
end;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Para indicar que el tipo de dato de una variable será el que tiene una columna
-- de una tabla se hace mediante el operador %type.
DECLARE
  V_FECHA   DESARROLLO.TBL_ALUMNO.DTFECHA_CREACION%TYPE;
BEGIN
    SELECT DTFECHA_CREACION INTO V_FECHA FROM DESARROLLO.TBL_ALUMNO WHERE IIDALUMNO = 1;
    DBMS_OUTPUT.PUT_LINE('LA FECHA DE CREACION DEL REGISTRO FUE: '||TO_CHAR(V_FECHA,'YYYY-MM-DD'));
END;


-- Si un query devuelve una sola fila y con un campo puede ser asignado a una variable:
DECLARE
  V_CONTADOR INTEGER := 0;
  
  V_PKTABLA INTEGER := 0;
  V_SNOMBRE VARCHAR2(256) := '';
  
BEGIN
  -- Asignacion directa de un solo valor
    SELECT COUNT(1) INTO V_CONTADOR FROM DESARROLLO.TBL_ALUMNO;
    dbms_output.put_line('TOTAL REGISTROS: ' || TO_CHAR(V_CONTADOR));
    dbms_output.put_line('');
    
    -- Asignacion multiple para varias columnas
    SELECT IIDALUMNO,SNOMBRE INTO V_PKTABLA,V_SNOMBRE FROM DESARROLLO.TBL_ALUMNO WHERE IIDALUMNO = 1;
    dbms_output.put_line('IDENTIFICADOR:' || TO_CHAR(V_PKTABLA) || '@NOMBRE:' ||V_SNOMBRE);
END;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Estructuras de Control (IF/CASE/LOOP/WHILE/FOR)

-- Ejemplo IF 
DECLARE
  V_CONTADOR INTEGER := 0;
BEGIN
    SELECT COUNT(1) INTO V_CONTADOR FROM DESARROLLO.TBL_ALUMNO;

    IF V_CONTADOR <= 0 THEN
      dbms_output.put_line('La tabla no tiene registros');    
    ELSE
      dbms_output.put_line('TOTAL REGISTROS: ' || TO_CHAR(V_CONTADOR));
    END IF;
END;

-- Ejemplo de CASE
DECLARE
  V_CONTADOR INTEGER := 0;
BEGIN
    SELECT COUNT(1) INTO V_CONTADOR FROM DESARROLLO.TBL_ALUMNO;
    DBMS_OUTPUT.PUT_LINE('TOTAL DE REGISTROS:' || TO_CHAR(V_CONTADOR));
    
    CASE
      WHEN V_CONTADOR = 0 THEN
        DBMS_OUTPUT.PUT_LINE('LA TABLA NO TIENE REGISTROS');
      WHEN (V_CONTADOR > 1) AND (V_CONTADOR < 3) THEN
        DBMS_OUTPUT.PUT_LINE('LA TABLA TIENE ENTRE 1 y 2 REGISTROS');
      ELSE
        DBMS_OUTPUT.PUT_LINE('LA TABLA TIENE 3 O MAS REGISTROS');
    END CASE;
END;

-- Ejemplo de LOOP
DECLARE
  V_NUM NUMBER:=0;
BEGIN
  LOOP V_NUM:=V_NUM + 1;
    DBMS_OUTPUT.PUT_LINE('NUMERO: '||TO_CHAR(V_NUM));
    EXIT WHEN V_NUM >= 10;
  END LOOP;
END;

-- Ejemplo de WHILE
DECLARE
    V_NUM NUMBER := 1;
BEGIN
    WHILE V_NUM<11 LOOP
        DBMS_OUTPUT.PUT_LINE('NUMERO: ' || TO_CHAR(V_NUM));
        V_NUM:=V_NUM+1;
    END LOOP;
END;

-- Ejemplo FOR
BEGIN
    FOR V_NUM IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('NUMERO: '||TO_CHAR(V_NUM));
    END LOOP;
END;

-- Es posible crear estructuras que albergan un conjunto de tipos de datos en oracle.
DECLARE
    TYPE TPERSONA IS RECORD (
        CODIGO NUMBER,
        NOMBRE VARCHAR(100),
        EDAD NUMBER
    );
    
    V_VAR1 TPERSONA;
BEGIN
    V_VAR1.CODIGO := 1;
    V_VAR1.NOMBRE := 'FRANCISCO';
    V_VAR1.EDAD   := 30;
    DBMS_OUTPUT.PUT_LINE('CODIGO: '|| TO_CHAR(V_VAR1.CODIGO) || ' PERSONA: ' || V_VAR1.NOMBRE || ' EDAD: ' || TO_CHAR(V_VAR1.EDAD)||'.');
END;

-- Ejemplo de ROWTYPE
DECLARE
    rec_alumno DESARROLLO.TBL_ALUMNO%ROWTYPE;   
BEGIN
    SELECT * INTO rec_alumno FROM DESARROLLO.TBL_ALUMNO WHERE IIDALUMNO = 1;
    IF (TO_NUMBER(EXTRACT(year FROM rec_alumno.dtfecha_creacion)) = 2019) THEN
        DBMS_OUTPUT.PUT_LINE('El registro fue creado en 2019' );
    END IF;
END;

-- Listas 
DECLARE
    
    TYPE T_LISTA IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    V_LISTA T_LISTA;

BEGIN
    FOR I IN 1..10 LOOP
        V_LISTA(I) := I;
    END LOOP;
    
    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;

-- Array Asociativos por indice numerico
declare
    type t_vector is table of varchar2(30) index by pls_integer;
    v_vector t_vector;
    n pls_integer;
begin
    v_vector(10) := 'Diez';
    v_vector(20) := 'Veinte';
    v_vector(12) := 'Doce';

    for i in v_vector.first .. v_vector.last loop
        if (v_vector.exists(i)) then
            dbms_output.put_line(i ||': '|| v_vector(i));
        end if;
    end loop;

    dbms_output.put_line('count: '|| v_vector.count);

    n := v_vector.first;
    while n is not NULL loop
        dbms_output.put_line(n ||': '|| v_vector(n));
        n := v_vector.next(n);
    end loop;
end;

-- Array Asociativos por indice alfanumerico
declare
    type t_vector is table of number(3) index by varchar2(10);
    v_vector t_vector;
    subind varchar2(10);
begin
    v_vector('Cuarenta') := 40;
    v_vector('cuarenta') := -40;
    v_vector('Cinco') := 5;
    v_vector('Quince') := 15;

    dbms_output.put_line('count: '|| v_vector.count);

    subind := v_vector.first;
    while subind is not NULL loop
        dbms_output.put_line(subind ||': '|| v_vector(subind));
        subind := v_vector.next(subind);
    end loop;
end;

-- Nested Table
DECLARE
    TYPE T_LISTA IS TABLE OF NUMBER;
    V_LISTA T_LISTA:=T_LISTA();
BEGIN
    FOR I IN 1..10 LOOP
        V_LISTA.EXTEND;
        V_LISTA(I):=I;
    END LOOP;

    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;

-- 
declare
    type t_vector is table of varchar2(30);
    v_vector t_vector;
begin
    v_vector := t_vector('Uno', 'Dos', 'Tres');

    v_vector.EXTEND;
    v_vector(4) := 'cuatro';

    for i in v_vector.first .. v_vector.last loop
        dbms_output.put_line(i ||': '|| v_vector(i));
    end loop;
end;

-- Los VARRAY también permiten crear arreglos en PLSQL, pero tienen un tamaño limitado desde su especificación.
DECLARE
    TYPE T_LISTA IS VARRAY(10) OF NUMBER;
    V_LISTA T_LISTA:=T_LISTA();
BEGIN
    FOR I IN 1..10 LOOP
        V_LISTA.EXTEND;
        V_LISTA(I):=I;
    END LOOP;

    FOR I IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;

-- 
DECLARE
    --Definición del Tipo Tabla:
    TYPE typ_varray IS VARRAY(3) OF VARCHAR2(25); -- Este VARRAY puede contener máximo 3 registros.
        

    --Declaramos una Variable del Tipo Tabla: typ_varray
    v_varray     typ_varray;
BEGIN
    --A continuación Inicializamos la variable Tipo Tabla: v_varray, de esta forma podemos darle uso:
    v_varray     :=  typ_varray();

    v_varray.EXTEND;   --EXTEND: Inserta un Registro Nulo a la Tabla.
    v_varray(1)  :=  'Valor para el Indice 1';
    v_varray.EXTEND;
    v_varray(2)  :=  'Valor para el Indice 2';
    v_varray.EXTEND;
    v_varray(3)  :=  'Valor para el Indice 3';

    DBMS_OUTPUT.PUT_LINE(v_varray(1)||', '||v_varray(2)||', '||v_varray(3));
END;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Continuar pagina 25 manejo de cursores
-- CURSORES

-- Los cursores en oracle pueden ser definidios de forma explícita o implícita.
-- En los cursores implícitos, Oracle es responsable de crear el cursor, abrirlo recorrerlo y cerrarlo. 
-- En los cursores explícitos el programdor es responsable de las actividades mencionadas.

-- Ejemplo de cursor explicito
DECLARE
  
  v_sNombre VARCHAR(128) := '';
  v_bContinue number(1)  := 0;
  
BEGIN
    BEGIN
      SELECT SNOMBRE into v_sNombre from DESARROLLO.TBL_ALUMNO where IIDALUMNO = 3;   
      IF SQL%FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Registro ubicado, el nombre es:' || v_sNombre);      
      END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_bContinue := 0;
      -- DBMS_OUTPUT.PUT_LINE('Se presento una excepcion');
      DBMS_OUTPUT.PUT_LINE('No se encontro registro en BD');
    END;
END;

-- Curso implícito 1 
DECLARE

	CURSOR cur_Alumno IS
		select IIDALUMNO, SNOMBRE, SPRIMERAP, SSEGUNDOAP from DESARROLLO.TBL_ALUMNO;

	V_PKAlumno	INTEGER := 0;
	V_NOMBRE    DESARROLLO.TBL_ALUMNO.SNOMBRE%TYPE;
	v_PRIMERAP	DESARROLLO.TBL_ALUMNO.SPRIMERAP%TYPE;
	V_SEGUNGOAP	DESARROLLO.TBL_ALUMNO.SSEGUNDOAP%TYPE;

BEGIN
	
	V_NOMBRE    := '';
	v_PRIMERAP	:= '';
	V_SEGUNGOAP	:= '';

	OPEN cur_Alumno;
	LOOP
		FETCH cur_Alumno INTO V_PKAlumno,  V_NOMBRE, v_PRIMERAP, V_SEGUNGOAP;
		EXIT WHEN cur_Alumno%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('NOMBRE: '||V_NOMBRE||', PRIMER APELLIDO:'||v_PRIMERAP ||', SEGUNDO APELLIDO:'||V_SEGUNGOAP);
	END LOOP;
	CLOSE cur_Alumno;
END;

-- Curso implícito 2
DECLARE

	CURSOR cur_Alumno IS
		select IIDALUMNO, SNOMBRE, SPRIMERAP, SSEGUNDOAP from DESARROLLO.TBL_ALUMNO;
BEGIN	
	-- En este caso, el FOR automáticamente apertura el cursor y lo cierra.
	FOR cur_temp IN cur_Alumno LOOP
		DBMS_OUTPUT.PUT_LINE('NOMBRE: '||cur_temp.SNOMBRE||', PRIMER APELLIDO:'||cur_temp.SPRIMERAP ||', SEGUNDO APELLIDO:'||cur_temp.SSEGUNDOAP);
	END LOOP;
END;

--Los cursores tienen atributos que pueden ayudarnos en el control del mismo.
-- %ISOPEN, %NOTFOUND, %FOUND, %ROWCOUNT 
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- CURSORES CON PARAMETROS

DECLARE
	CURSOR cur_Alumno(p_IdAlumno INTEGER) IS
		select IIDALUMNO, SNOMBRE, SPRIMERAP, SSEGUNDOAP from DESARROLLO.TBL_ALUMNO where IIDALUMNO = p_IdAlumno;
BEGIN
	FOR cur_temp IN cur_Alumno(2) LOOP	
		DBMS_OUTPUT.PUT_LINE('NOMBRE: '||cur_temp.SNOMBRE||', PRIMER APELLIDO:'||cur_temp.SPRIMERAP ||', SEGUNDO APELLIDO:'||cur_temp.SSEGUNDOAP);
	END LOOP;
END;


-- El WHERE CURRENT OF permite actualizar una fila que lo tenemos actualmente
-- apuntando en nuestro cursor. 
-- Como condición el cursor debe tener una sentencia SELECT FOR UPDATE.
DECLARE
	CURSOR cur_Alumno(p_IdAlumno INTEGER) IS
		select IIDALUMNO, SNOMBRE, SPRIMERAP, SSEGUNDOAP 
    from DESARROLLO.TBL_ALUMNO where IIDALUMNO = p_IdAlumno FOR UPDATE;
BEGIN

	FOR cur_temp IN cur_Alumno(2) LOOP	
		DBMS_OUTPUT.PUT_LINE('NOMBRE: '||cur_temp.SNOMBRE||', PRIMER APELLIDO:'||cur_temp.SPRIMERAP ||', SEGUNDO APELLIDO:'||cur_temp.SSEGUNDOAP);
		
		-- Aplicacion del update
		UPDATE DESARROLLO.TBL_ALUMNO SET DTFECHA_MODIFICACION = SYSDATE WHERE CURRENT OF cur_Alumno;
	END LOOP;
	COMMIT;
END;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- CURSORES GENÉRICOS
-- Son aquellos cursores donde en tiempo de ejecución se asignará el query.

-- Cursor dinámico
DECLARE
	
	TYPE T_CURSOR IS REF CURSOR;
	cur_Alumno T_CURSOR;
	V_NOMBRE 	DESARROLLO.TBL_ALUMNO.SNOMBRE%TYPE;

BEGIN
	OPEN cur_Alumno FOR 'select SNOMBRE from DESARROLLO.TBL_ALUMNO';
	LOOP
		FETCH cur_Alumno INTO V_NOMBRE;
		EXIT WHEN cur_Alumno%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('nombre = ' || V_NOMBRE);
	END LOOP;
	CLOSE cur_Alumno;
END;


-- Manipulación de Excepciones
-- El PRAGMA EXCEPTION permite asociar la variable 
-- exception con un código de error de Oracle Database
DECLARE
	EX_PERSONAL	EXCEPTION;
	PRAGMA EXCEPTION_INIT(EX_PERSONAL, -1422);
	V_NOMBRE  VARCHAR2(256) := '';
BEGIN
	select SNOMBRE INTO V_NOMBRE from DESARROLLO.TBL_ALUMNO;
EXCEPTION
	WHEN EX_PERSONAL THEN
		DBMS_OUTPUT.PUT_LINE('EL QUERY DEVUELVE MAS DE UNA FILA');
END;

--- Ejemplo de excepcion
DECLARE
	V_NOMBRE  VARCHAR2(256) := '';
BEGIN
	select SNOMBRE INTO V_NOMBRE from DESARROLLO.TBL_ALUMNO;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrio un error:'||SQLCODE||' ~ERROR~ '||SQLERRM);
END;


-- RAISE_APPLICATION_ERROR:
-- Permite disparar excepciones personalizados a las aplicaciones.
-- Sintaxis: RAISE_APPLICATION_ERROR(­#_ERROR, 'MENSAJE',FALSE|TRUE);
-- Donde Oracle Database nos reserva los códigos que se encuentran en un rango de ­20000 a ­20999.
-- El tercer parámetro que es un tipo de dato boolean, por default es FALSE el cual
-- reemplaza cualquier error que se venga arrastrando y es reemplazado por el texto que se indica. 
-- Si en caso se coloca TRUE, se imprimirá la cola de errores arrastrados incluido el mensaje personalizado.
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
-- PACKAGES
-- Un paquete es una agrupación lógica de variables, funciones y stored procedures.
-- Se divide lógicamente en 2 partes: Espeficicacion y Body
-- En la especificación se define las variables y los subprogramas disponibles para los usuarios.
-- En body va la implementación de cada subprograma definido en la especificación 
-- y adicional otros subprogramas que quizás no necesitamos que se expongan.

-- Espeficicación
CREATE OR REPLACE PACKAGE DESARROLLO.PKG_OPERACIONES IS		
	-- V_NUMERO NUMBER:=0;
	FUNCTION FN_SUMA(X NUMBER, Y NUMBER) RETURN NUMBER;
	FUNCTION FN_MULTIPLICA(X NUMBER, Y NUMBER) RETURN NUMBER;

	PROCEDURE SP_SUMA(p_SUM1 IN NUMBER, p_SUM2 IN NUMBER, out_suma OUT NUMBER);
	PROCEDURE SP_MULTIPLICA(p_FACTOR1 IN NUMBER, p_FACTOR2 IN NUMBER, out_producto OUT NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY DESARROLLO.PKG_OPERACIONES IS
	
	-- V_NUMERO NUMBER:=0;
	PROCEDURE SP_GET_FECHAHORA(p_NOMBRE_OBJETO IN VARCHAR2);

	FUNCTION FN_SUMA(X NUMBER, Y NUMBER) RETURN NUMBER IS
	BEGIN
		RETURN X + Y;
	END;

	FUNCTION FN_MULTIPLICA(X NUMBER, Y NUMBER) RETURN NUMBER IS
	BEGIN
		RETURN X * Y;
	END;

	PROCEDURE SP_SUMA(p_SUM1 IN NUMBER, p_SUM2 IN NUMBER, out_suma OUT NUMBER)
	IS
	BEGIN
		SP_GET_FECHAHORA('SP_SUMA');
		out_suma := p_SUM1 + p_SUM2;
	EXCEPTION WHEN OTHERS THEN
	    dbms_output.put_line(sqlerrm);    
	END;

	PROCEDURE SP_MULTIPLICA(p_FACTOR1 IN NUMBER, p_FACTOR2 IN NUMBER, out_producto OUT NUMBER) IS
	BEGIN
		SP_GET_FECHAHORA('SP_MULTIPLICA');
		out_producto :=  p_FACTOR1*p_FACTOR2;
	EXCEPTION WHEN OTHERS THEN
	    dbms_output.put_line(sqlerrm);  
	END;

	PROCEDURE SP_GET_FECHAHORA(p_NOMBRE_OBJETO IN VARCHAR2) IS
	BEGIN    	
		DBMS_OUTPUT.PUT_LINE(p_NOMBRE_OBJETO ||'=> INICO:' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
	END;

END PKG_OPERACIONES;
/

-- Ejemplo de ejecucion del Package 
SELECT DESARROLLO.PKG_OPERACIONES.FN_SUMA(10, 20) as SUMA FROM SYS.DUAL;
SELECT DESARROLLO.PKG_OPERACIONES.FN_MULTIPLICA(10, 5) as SUMA FROM SYS.DUAL;

DECLARE
  v_RESULTADO NUMBER := 0;
BEGIN
  DESARROLLO.PKG_OPERACIONES.SP_SUMA(5, 10, v_RESULTADO);
  DBMS_OUTPUT.PUT_LINE('EL RESULTADO DE LA SUMA ES:' || TO_CHAR(v_RESULTADO));
  
  DESARROLLO.PKG_OPERACIONES.SP_MULTIPLICA(5, 10, v_RESULTADO);
  DBMS_OUTPUT.PUT_LINE('EL RESULTADO DE LA MULTIPLICACION ES:' || TO_CHAR(v_RESULTADO));
  
END;

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
-- TRIGGERS
--Los triggers son subprogramas que se disparan frente a eventos que ocurren en la base de datos.

CREATE TABLE DESARROLLO.TBL_EXAMPLE (IID NUMBER, SDESCRIPCION VARCHAR2(256));

-- Trigger para antes de insertar un nuevo registro
CREATE OR REPLACE TRIGGER TGR_BEFORE_INS_EXAMPLE
BEFORE INSERT ON TBL_EXAMPLE FOR EACH ROW
DECLARE
	V_DATOS_INSERT	VARCHAR2(512);
BEGIN

	V_DATOS_INSERT := 'IID=' || :new.IID || '|SDESCRIPCION=' || :new.SDESCRIPCION;
	INSERT INTO DESARROLLO.TBL_BITACORA(IIDBITACORA, SIPADDRESS, SUSUARIO, SEVENTO, SDATOS, SCOMENTARIO, DTFECHA_CREACION, DTFECHA_MODIFICACION)
	VALUES(
		DESARROLLO.seq_id_bitacora.nextval, sys_context('USERENV','IP_ADDRESS'), SYS_CONTEXT ('USERENV', 'SESSION_USER'), 'TRIGGER BEFORE INSERT', V_DATOS_INSERT, '', CURRENT_TIMESTAMP, NULL
	);
END;

-- Trigger para despues de insertar el registro
CREATE OR REPLACE TRIGGER TGR_AFTER_INS_EXAMPLE
AFTER INSERT ON TBL_EXAMPLE FOR EACH ROW
DECLARE
	V_DATOS_INSERT	VARCHAR2(512) := '';
BEGIN
	V_DATOS_INSERT := 'IID=' || :new.IID || '|SDESCRIPCION=' || :new.SDESCRIPCION;
	INSERT INTO DESARROLLO.TBL_BITACORA(IIDBITACORA, SIPADDRESS, SUSUARIO, SEVENTO, SDATOS, SCOMENTARIO, DTFECHA_CREACION, DTFECHA_MODIFICACION)
	VALUES(
		DESARROLLO.seq_id_bitacora.nextval, sys_context('USERENV','IP_ADDRESS'), SYS_CONTEXT ('USERENV', 'SESSION_USER'), 'TRIGGER AFTER INSERT', V_DATOS_INSERT, '', CURRENT_TIMESTAMP, NULL
	);
END;

INSERT INTO DESARROLLO.TBL_EXAMPLE VALUES (1, 'DESCRIPCION 1');
commit;

select * from DESARROLLO.TBL_BITACORA;


-- Trigger para despues de eliminar un renglon 
CREATE OR REPLACE TRIGGER TGR_AFTER_DEL_EXAMPLE 
AFTER DELETE ON TBL_EXAMPLE FOR EACH ROW
DECLARE
  V_DATOS_DELETE VARCHAR2(512) := '';
BEGIN

	V_DATOS_DELETE := 'DATOS=>{IID:' || :old.IID || '|SDESCRIPCION:' || :old.SDESCRIPCION || '}';
	INSERT INTO DESARROLLO.TBL_BITACORA(
		IIDBITACORA, SIPADDRESS, SUSUARIO, SEVENTO, SDATOS, SCOMENTARIO, DTFECHA_CREACION, DTFECHA_MODIFICACION)
	VALUES(
		DESARROLLO.seq_id_bitacora.nextval, 
		sys_context('USERENV','IP_ADDRESS'), 
		SYS_CONTEXT ('USERENV', 'SESSION_USER'), 
		'TRIGGER AFTER DELETE', 
		V_DATOS_DELETE, '', 
		SYSDATE, 
		NULL
	);    
END;

-- En el contexto de los triggers tenemos un par de variables => :NEW y :OLD
-- Para INSERT, :OLD = NULL, :NEW = INSERT VALUES
-- Para UPDATE, :OLD = VALUES BEFORE, :NEW = VALUES AFTER
-- Para DELETE, :OLD = VALUES DELETE, :NEW = NULL


-- Habilitar/Deshabilitar triggers
ALTER TRIGGER DESARROLLO.TGR_BEFORE_INS_EXAMPLE ENABLE;
ALTER TRIGGER DESARROLLO.TGR_AFTER_INS_EXAMPLE ENABLE;

ALTER TRIGGER DESARROLLO.TGR_BEFORE_INS_EXAMPLE DISABLE;
ALTER TRIGGER DESARROLLO.TGR_AFTER_INS_EXAMPLE DISABLE;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
-- SINONIMOS

-- Privilegios para crear sinonimos publicos
-- GRANT CREATE SYNONYM, CREATE VIEW, CREATE PUBLIC SYNONYM, DROP PUBLIC SYNONYM TO PROGRAMADOR;

-- Privilegios sobre ejecucion de objetos
-- GRANT EXECUTE ON DESARROLLO.SP_CONCATENAR TO PROGRAMADOR;

-- Privilegios para la tablas
-- GRANT SELECT, INSERT, UPDATE, DELETE ON DESARROLLO.TBL_ALUMNO TO PROGRAMADOR;
-- GRANT ALL ON DESARROLLO.TBL_ALUMNO TO PROGRAMADOR;

-- Privilegios para ejecutar package
grant execute on DESARROLLO.PKG_OPERACIONES to PROGRAMADOR;

-- Sinonimo publico para stored Procedure
CREATE OR REPLACE PUBLIC SYNONYM SP_CONCATENAR FOR DESARROLLO.SP_CONCATENAR; 

-- Sinonimo publico para tabla
CREATE OR REPLACE PUBLIC SYNONYM TBL_ALUMNO FOR DESARROLLO.TBL_ALUMNO; 



-- COALESCE y NVL