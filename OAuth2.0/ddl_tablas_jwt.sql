-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Tabla auxiliar para el manejo de los usuarios
CREATE TABLE seguridad.usuario (
  iid int(11) NOT NULL AUTO_INCREMENT,
  cusuario varchar(256) NOT NULL,
  cpassword varchar(1024) COLLATE utf8_unicode_ci NOT NULL,
  dtfechacreacion datetime DEFAULT CURRENT_TIMESTAMP,
  lactivo tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (iid)
) DEFAULT CHARSET=utf8 ;

INSERT INTO seguridad.usuario(cusuario, cpassword, dtfechacreacion, lactivo)
VALUES('david.pech', SHA1('pass2019'), CURRENT_TIMESTAMP, 1);

INSERT INTO seguridad.usuario(cusuario, cpassword, dtfechacreacion, lactivo)
VALUES('dpechcutz', SHA1('pass2019'), CURRENT_TIMESTAMP, 1);

INSERT INTO seguridad.oauth_clients(client_id, client_secret, redirect_uri, grant_types, `scope`, user_id)
VALUES('client_one', 'pass2019', 'http://slim.oauth2.site:8084/pages/recibecode', null, null, null);


CREATE TABLE seguridad.tokens_jwt (
  iidtoken int(11) NOT NULL AUTO_INCREMENT,
  ctoken varchar(1024) NOT NULL,
  iid_usuario int(11) NOT NULL,
  cusuario varchar(1024) NOT NULL,
  dtfecha_expira datetime DEFAULT CURRENT_TIMESTAMP,
  dtfechacreacion datetime DEFAULT CURRENT_TIMESTAMP,
  lactivo tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (iidtoken)
) DEFAULT CHARSET=utf8;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Para interaccion con ORACLE
-- Secuenciador para la columna primary key
CREATE SEQUENCE DESARROLLO.seq_id_usuario START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE DESARROLLO.usuario (
  iid INTEGER NOT NULL,
  cusuario varchar(256) NOT NULL,
  cpassword varchar(1024) NOT NULL,
  dtfechacreacion DATE DEFAULT CURRENT_TIMESTAMP,
  lactivo NUMBER(1,0) DEFAULT 0,
  CONSTRAINT PK_USUARIO PRIMARY KEY (iid)
);

CREATE SEQUENCE DESARROLLO.seq_id_tokenjwt START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE DESARROLLO.tokens_jwt (
  iidtoken INTEGER NOT NULL,
  ctoken varchar(1024) NOT NULL,
  iid_usuario INTEGER NOT NULL,
  cusuario varchar(1024) NOT NULL,
  dtfecha_expira  DATE DEFAULT CURRENT_TIMESTAMP,
  dtfechacreacion DATE DEFAULT CURRENT_TIMESTAMP,
  lactivo NUMBER(1,0) DEFAULT 0,
  CONSTRAINT PK_TOKENJWT PRIMARY KEY (iidtoken)
);
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
