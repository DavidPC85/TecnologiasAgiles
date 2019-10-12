CREATE TABLE seguridad.oauth_clients (
  client_id             VARCHAR(80)   NOT NULL,
  client_secret         VARCHAR(80),
  redirect_uri          VARCHAR(2000),
  grant_types           VARCHAR(80),
  scope                 VARCHAR(4000),
  user_id               VARCHAR(80),
  dtfechacreacion       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (client_id)
);

CREATE TABLE seguridad.oauth_access_tokens (
  access_token         VARCHAR(40)    NOT NULL,
  client_id            VARCHAR(80)    NOT NULL,
  user_id              VARCHAR(80),
  expires              TIMESTAMP      NOT NULL,
  scope                VARCHAR(4000),
  dtfechacreacion       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (access_token)
);

CREATE TABLE seguridad.oauth_authorization_codes (
  authorization_code  VARCHAR(40)     NOT NULL,
  client_id           VARCHAR(80)     NOT NULL,
  user_id             VARCHAR(80),
  redirect_uri        VARCHAR(2000),
  expires             TIMESTAMP       NOT NULL,
  scope               VARCHAR(4000),
  id_token            VARCHAR(1000),
  dtfechacreacion       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (authorization_code)
);

CREATE TABLE seguridad.oauth_refresh_tokens (
  refresh_token       VARCHAR(40)     NOT NULL,
  client_id           VARCHAR(80)     NOT NULL,
  user_id             VARCHAR(80),
  expires             TIMESTAMP       NOT NULL,
  scope               VARCHAR(4000),
  dtfechacreacion       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (refresh_token)
);

CREATE TABLE seguridad.oauth_users (
  username            VARCHAR(80),
  password            VARCHAR(80),
  first_name          VARCHAR(80),
  last_name           VARCHAR(80),
  email               VARCHAR(80),
  email_verified      BOOLEAN,
  scope               VARCHAR(4000),
    dtfechacreacion       TIMESTAMP  DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY (username)
);

CREATE TABLE seguridad.oauth_scopes (
    scope               VARCHAR(80)     NOT NULL,
    is_default          BOOLEAN,
    dtfechacreacion      TIMESTAMP  DEFAULT CURRENT_TIMESTAMP
    PRIMARY KEY (scope)
);

CREATE TABLE seguridad.oauth_jwt (
    client_id           VARCHAR(80)     NOT NULL,
    subject             VARCHAR(80),
    public_key          VARCHAR(2000)   NOT NULL
    dtfechacreacion     TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
);

-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Segunda parte para JWT
-- Para generacion de token jwt
/*
CREATE TABLE seguridad.oauth_public_keys (
	client_id VARCHAR(80), 
	public_key VARCHAR(8000), 
	private_key VARCHAR(8000), 
	encryption_algorithm VARCHAR(80) DEFAULT "RS256"
);

-- global keys into the database 
INSERT INTO oauth_public_keys (client_id, public_key, private_key, encryption_algorithm) 
VALUES (NULL, 
"-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuv2lXJfiS74zrXQtuaO1
p9kj2Yq1HAK8vMjakykbTtobiDT0//piKrwgLh5vRwJCebEYmWIdKqzyKBAYyclx
t60nwb0Alf7zBQ/FGcmbs93duEsRqR20I+rFHYNxnTT1AyyrLW1/fLp2a/pslt9u
38tkH91xNVz5l7CEF4JSftDiSRSIcFaRlhcCgsOFkIxlSLMp/TK1aiKHIsRRIM4O
iz3IrCIDxFzCEn01C7EPVMktAE4ix3exq+F15BTUk8F3XdsZ2VCcbxX+iVBnHvt8
giBQ/OEWy9vY60fOrc11nyFCv6qcch6XF2xKZ0idxaHfVFUreIBFnaFTIcvwl0GA
xQIDAQAB
-----END PUBLIC KEY-----", 
"-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAuv2lXJfiS74zrXQtuaO1p9kj2Yq1HAK8vMjakykbTtobiDT0
//piKrwgLh5vRwJCebEYmWIdKqzyKBAYyclxt60nwb0Alf7zBQ/FGcmbs93duEsR
qR20I+rFHYNxnTT1AyyrLW1/fLp2a/pslt9u38tkH91xNVz5l7CEF4JSftDiSRSI
cFaRlhcCgsOFkIxlSLMp/TK1aiKHIsRRIM4Oiz3IrCIDxFzCEn01C7EPVMktAE4i
x3exq+F15BTUk8F3XdsZ2VCcbxX+iVBnHvt8giBQ/OEWy9vY60fOrc11nyFCv6qc
ch6XF2xKZ0idxaHfVFUreIBFnaFTIcvwl0GAxQIDAQABAoIBABHt+EkklyJEHphn
J2tBc02g2Hsnfa4t5QMFD1BFBMVOzI0G5ucUjw0h9MP3Txwz70PT41PxwHIzGxUU
VgwjMLA3/jPpd4DqbUry9CdA2ZkpkPT23b6lhnxbKoNl8yLrzQJ86fz1HuBK0MgR
vw/IZM04p2UWyqAfRh9xYXkPmfFm1BURhpwXOV2OhK707ysdSya4Z+hsO0OICeYH
X6azXXX+t+ErD3njcyTTitputWAgr521RQQOcbAGUv+4y3UPxMdbG6IHhboLFLwi
YcPQ8obYYCUNJ9vqi9U3Eb4eGleMXquzj1eYPYfqPaiW5HaxGdej4ChosmawdsUA
ueFTB5ECgYEA3l/qyYrfdeaIMxmWmVinZJn/3kLpWCO9WXBwT7bReuyKPkdjEROH
d4xOM0KQZ/sAfXP53inyAc+xR1bhj022NGLT3HHcvMYz3vP+NT9ebJbvC+lfZSJ/
JCMMJfjZZQ6+ZgaPE86qYvn0mdhxdHpXE9sbawvhhLpSpp6LVxMVW+sCgYEA10QG
j5LvomqiHEPLEGRcrmPsOPRK1/0YNMhGaXTx0KwOZG4T0g+3Q/6o6MX3wpyCygMW
El8iDSHE1dJNDPqgxyvrQMehL0e65r6VlIimF5YDMfPXNR8UXXLj3pibEscw6HPs
pGACFxphdsHSjkLBPYLFFczkDqRKYK33eqJx2g8CgYAagO4X1VBq2e4TwRH89t8E
k4I2eF0dXy0bMtZ/+bcf4n9biuCY0W4M5pEPdPiHHBhj22XFf9RTOPDVItrBXK7B
saG0nXGEok7eXNBIgmP7p0WYctkm0aS7pt20zOMEM2yn9lIpNzGBmG75wx1Kl6Y3
PJ8Y9BKN4jMlnrHWz/R0vwKBgQDKHgcC+3Wgy/pWC5k4VONook2D1GwJjIwT0w+5
qKH7yfDhfzGBBFyQrSUvGeHdilKLFoa8zTINnm1QTlsmGpSnLad/dXD0Ead9S+jq
Q7ufXay2VDr2l63paBxoPmUsJnbXazD/zV1pD83/UVE/XZJPDN+77lsbHErxp6Y8
MRYxJQKBgH3a1ycpd4K/Geku6Xiu8OsoQOt/cIZiRc+3kC1p4/7+zH9mEWmlCc+s
dsvwYpX6dq0yPfuSanMJ1pzR6cRmH7CyyNspP9yy4Id17RL1MeZOB1SEvvU/Wr8N
bnF+guowiZ3bzm5844uL/m/Ob2R+L/o7kTWOyS1wnG0nAvwAv5SM
-----END RSA PRIVATE KEY-----", 
"RS256");
*/
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@