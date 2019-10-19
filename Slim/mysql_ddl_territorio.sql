-- Tabla para guardar la relacion de paises
CREATE TABLE IF NOT EXISTS pais(
	iidpais 	INT NOT NULL AUTO_INCREMENT,
	cclave 		VARCHAR(8) NOT NULL, 
	cnombre 	VARCHAR(128) NOT NULL,
	dtcreacion 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	lactivo		TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY(iidpais)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS entidad_federativa(
	iidentidad 	INT NOT NULL AUTO_INCREMENT,
	cclave		VARCHAR(8) NOT NULL,	
	cnombre 	VARCHAR(128) NOT NULL,	
	dtcreacion 	TIMESTAMP NOT NULL,
	iidpais 	INT NOT NULL,
	lactivo		TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY(iidentidad),
	FOREIGN KEY(iidpais) REFERENCES pais(iidpais)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS municipio(
	iidmunicipio	INT NOT NULL AUTO_INCREMENT,	
	iidentidad 		INT NOT NULL,
	icve_mun		INT NOT NULL,
	cnombre 		VARCHAR(128) NOT NULL,
	dtcreacion 		TIMESTAMP NOT NULL,		
	lactivo		TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY(iidmunicipio),
	FOREIGN KEY(iidentidad) REFERENCES entidad_federativa(iidentidad)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS localidades(
	iidlocalidad	INT NOT NULL AUTO_INCREMENT,	
	iidmunicipio	INT NOT NULL,	
	icodigopostal	INT NOT NULL DEFAULT 0,
	cnombre 		VARCHAR(128) NOT NULL,
	dtcreacion 		TIMESTAMP NOT NULL,	
	lactivo			TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY(iidlocalidad),
	FOREIGN KEY(iidmunicipio) REFERENCES municipio(iidmunicipio)
) ENGINE=InnoDB;
