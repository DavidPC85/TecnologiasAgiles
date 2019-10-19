CREATE SEQUENCE DESARROLLO.seq_id_pais START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE DESARROLLO.seq_id_entidad START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE DESARROLLO.seq_id_municipio START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE DESARROLLO.seq_id_localidad START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- Tabla para guardar la relacion de paises
CREATE TABLE DESARROLLO.pais(
	iidpais 	INT NOT NULL ,
	cclave 		VARCHAR(8) NOT NULL, 
	cnombre 	VARCHAR(128) NOT NULL,
	dtcreacion 	DATE DEFAULT SYSDATE,
	lactivo		NUMBER(1,0) DEFAULT 1,
	CONSTRAINT PK_PAIS PRIMARY KEY (iidpais)
);

CREATE TABLE DESARROLLO.entidad_federativa(
	iidentidad 	INT NOT NULL ,
	cclave		VARCHAR(8) NOT NULL,	
	cnombre 	VARCHAR(128) NOT NULL,	
	dtcreacion 	DATE DEFAULT SYSDATE,
	iidpais 	INT NOT NULL,
	lactivo		NUMBER(1,0) DEFAULT 1,
	CONSTRAINT PK_ENTIDAD PRIMARY KEY (iidentidad),	
	CONSTRAINT fk_pais_entidad FOREIGN KEY (iidpais) REFERENCES pais(iidpais)
);

CREATE TABLE DESARROLLO.municipio(
	iidmunicipio	INT NOT NULL ,	
	iidentidad 		INT NOT NULL,
	icve_mun		INT NOT NULL,
	cnombre 		VARCHAR(128) NOT NULL,
	dtcreacion 		DATE DEFAULT SYSDATE,		
	lactivo			NUMBER(1,0) DEFAULT 1,
	CONSTRAINT PK_PAIS_MUNICIPIO PRIMARY KEY (iidmunicipio),
	CONSTRAINT fk_entidad_municipio FOREIGN KEY (iidentidad) REFERENCES entidad_federativa(iidentidad)
);


CREATE TABLE DESARROLLO.localidades(
	iidlocalidad	INT NOT NULL ,	
	iidmunicipio	INT NOT NULL,	
	icodigopostal	INT DEFAULT 0,
	cnombre 		VARCHAR(128) NOT NULL,
	dtcreacion 		DATE DEFAULT SYSDATE,	
	lactivo			NUMBER(1,0) DEFAULT 1,
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY (iidlocalidad),
	CONSTRAINT fk_municipio_localidad FOREIGN KEY (iidmunicipio) REFERENCES municipio(iidmunicipio)
);

