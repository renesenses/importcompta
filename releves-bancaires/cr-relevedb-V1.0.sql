DROP TABLE IF EXISTS typecompta;
CREATE TABLE typecompta (
	typecompta_code				TEXT 		PRIMARY KEY			NOT NULL,
	typecompta_mode				TEXT 							NOT NULL CHECK(typecompta_mode in ('PRO','PERSO')),
	typecompta_lib				TEXT							NOT NULL
);
INSERT INTO typecompta (typecompta_code, typecompta_mode, typecompta_lib) VALUES ('AC',	'PERSO',	'AC'); 
INSERT INTO typecompta (typecompta_code, typecompta_mode, typecompta_lib) VALUES ('AD',	'PERSO',	'AD'); 
INSERT INTO typecompta (typecompta_code, typecompta_mode, typecompta_lib) VALUES ('BC',	'PERSO',	'BC'); 
INSERT INTO typecompta (typecompta_code, typecompta_mode, typecompta_lib) VALUES ('LNIT','PRO',		'LNIT'); 
INSERT INTO typecompta (typecompta_code, typecompta_mode, typecompta_lib) VALUES ('SAP', 'PRO',		'LNIT Services à la personne'); 

DROP TABLE IF EXISTS statusofprove;
CREATE TABLE status (
	statusofprove_code				CHAR(1) 		PRIMARY KEY			NOT NULL,
	statusofprove_lib				TEXT								NOT NULL
);
INSERT INTO status (status_code, status_lib) VALUES ('n', 'Nouveau'); 
INSERT INTO status (status_code, status_lib) VALUES ('a', 'A déterminer');
INSERT INTO status (status_code, status_lib) VALUES ('v', 'Validé');

DROP TABLE IF EXISTS banque;
CREATE TABLE banque (
	banque_id				BINARY(5) 					NOT NULL,
	banque_lib				TEXT						NOT NULL,	
	PRIMARY KEY(banque_id)
);

INSERT INTO banque (banque_id,banque_lib) VALUES ('00001', 'HSBC BANQUE DIRECTE'); 
INSERT INTO banque (banque_id,banque_lib) VALUES ('00002', 'BNP PARIBAS'); 

DROP TABLE IF EXISTS compte;
CREATE TABLE compte (
	compte_id				BINARY(24)		PRIMARY KEY		NOT NULL,
	compte_banquelib		TEXT 							NOT NULL,
	compte_no				TEXT							NOT NULL,	
	compte_lib				TEXT							NOT NULL,
	CONSTRAINT ctcompte UNIQUE (compte_id, compte_banquelib),
	FOREIGN KEY(compte_banquelib) REFERENCES banque(banque_lib)
);

INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('000010000000000000000001', 'HSBC BANQUE DIRECTE','EUR0094909490130787','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('000020000000000000000001', 'BNP PARIBAS','PERSO BC','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('000020000000000000000001', 'BNP PARIBAS','PERSO AD','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('000020000000000000000001', 'BNP PARIBAS','PERSO BC','COMPTE COURANT' );
DROP TABLE IF EXISTS releve;
CREATE TABLE releve (
	releve_id					BINARY(34) 		PRIMARY KEY			NOT NULL,
	releve_comptelib			TEXT								NOT NULL,
	releve_banquelib			TEXT 								NOT NULL,
	releve_debut 				DATE								NOT NULL,
	releve_fin					DATE								NOT NULL,
	releve_no					TEXT 								NOT NULL,
	releve_soldedeb 			NUMERIC(9,2)						NOT NULL,
	releve_soldefin	 			NUMERIC(9,2)						NOT NULL,
	CONSTRAINT ctreleve UNIQUE (releve_id, releve_comptelib, releve_banquelib),
	CONSTRAINT ctreleve2 UNIQUE (releve_id, releve_no),
	FOREIGN KEY(releve_comptelib) REFERENCES compte(compte_lib),
	FOREIGN KEY(releve_banquelib) REFERENCES banque(banque_lib)
);

DROP TABLE IF EXISTS mouvement;
CREATE TABLE mouvement (
	mvt_id		 			BINARY(44) 		PRIMARY KEY		NOT NULL,
	mvt_no					INTEGER							NOT NULL CHECK(mvt_no >= 1 AND mvt_no <= 9999),
	mvt_releveno			TEXT 						NOT NULL,
	mvt_comptelib			TEXT							NOT NULL,
	mvt_banquelib			TEXT 							NOT NULL,
	mvt_date				DATE 							NOT NULL,
	mvt_datevaleur			DATE 							NOT NULL,
	mvt_lib					TEXT							NOT NULL,
	mvt_exo					INTEGER							NOT NULL DEFAULT 0 CHECK(mvt_exo in (0,1)),
	mvt_deborcred 				CHAR(1)							NOT NULL DEFAULT 'd' CHECK(mvt_deborcred in ('c','d')),
	mvt_amount				NUMERIC(9,2)					NOT NULL,
	CONSTRAINT ctmvt UNIQUE (mvt_id, mvt_lib, mvt_comptelib, mvt_banquelib),
	CONSTRAINT ctmvt2 UNIQUE (mvt_id, mvt_no),
	FOREIGN KEY(mvt_releveno) REFERENCES releve(releve_no),
	FOREIGN KEY(mvt_comptelib) REFERENCES compte(compte_lib),
	FOREIGN KEY(mvt_banquelib) REFERENCES banque(banque_lib)
);

DROP TABLE IF EXISTS explication;
CREATE TABLE explication (
	exp_mvtid		 		BINARY(48) 		PRIMARY KEY		NOT NULL,
	exp_lib					TEXT							NOT NULL DEFAULT '',
	exp_comptatypecode 		TEXT							NOT NULL,
	exp_status				CHAR(1)							NOT NULL,
	FOREIGN KEY(exp_status) REFERENCES status(status_lib),
	FOREIGN KEY(exp_comptatypecode) REFERENCES typecompta(typecompta_code),
	CONSTRAINT ctexp UNIQUE (exp_mvtid, exp_lib)
);

DROP TABLE IF EXISTS has_prove;
CREATE TABLE has_prove (
	prov_expmvtid			BINARY(48) 						NOT NULL,
	prov_pieceid			INTEGER 						NOT NULL,
	prov_status				CHAR(1)							NOT NULL,
	prov_comment			TEXT							NOT NULL DEFAULT '',
	FOREIGN KEY(prov_status) REFERENCES statusofprove(statusofprove_code),
	FOREIGN KEY(prov_expmvtid) REFERENCES explication(exp_mvtid),
	PRIMARY KEY(prov_pieceid, prov_expmvtid)	
);