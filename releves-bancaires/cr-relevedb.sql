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
INSERT INTO status (statusofprove_code, statusofprove_lib) VALUES ('N', 'Nouveau'); 
INSERT INTO status (statusofprove_code, statusofprove_lib) VALUES ('A', 'A déterminer');
INSERT INTO status (statusofprove_code, statusofprove_lib) VALUES ('V', 'Validé');

CREATE TABLE statusofreglement (
	statusofreg_code				CHAR(1) 		PRIMARY KEY			NOT NULL,
	statusofreg_lib					TEXT								NOT NULL			
);

INSERT INTO statusofreglement (statusofreg_code, statusofreg_lib) VALUES ('E', 'En cours'); 
INSERT INTO statusofreglement (statusofreg_code, statusofreg_lib) VALUES ('P', 'Payé');
INSERT INTO statusofreglement (statusofreg_code, statusofreg_lib) VALUES ('I', 'Impayé');
INSERT INTO statusofreglement (statusofreg_code, statusofreg_lib) VALUES ('A', 'Annulé');

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
	FOREIGN KEY(compte_banquelib) REFERENCES banque(banque_lib)
);

INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('0b000010000000000000000001', 'HSBC BANQUE DIRECTE','EUR0094909490130787','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('0b000020000000000000000001', 'BNP PARIBAS','PERSO BC','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('0b000020000000000000000002', 'BNP PARIBAS','PERSO AD','COMPTE COURANT' );
INSERT INTO compte (compte_id,compte_banquelib,compte_no,compte_lib) VALUES ('0b000020000000000000000003', 'BNP PARIBAS','PERSO BC','COMPTE COURANT' );
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

DROP TABLE IF EXISTS typeofmodereglement;
CREATE TABLE typeofmodereglement (
	typeofmr_id					INTEGER 	PRIMARY KEY			NOT NULL,
	typeofmr_type				TEXT 							NOT NULL,
	typeofmr_lib				TEXT 							NOT NULL,
	CONSTRAINT cttypeofmr UNIQUE (typeofmr_type)
);
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (3,'CB','Carte bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (1,'ESP','Espèces');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (2,'CHEQUE','Chèque bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (6,'LCR','Lettre de change relève');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (4,'VIREMENT','Virement bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (5,'PRELEVEMENT','Prélèvement bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (7,'PAYPAL','Paiement compte paypal');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (8,'GANDI','Paiement compte gandi');

DROP TABLE IF EXISTS modereglement;
CREATE TABLE modereglement (
	modreg_id				INTEGER 		PRIMARY KEY		NOT NULL,
	modreg_type				TEXT 							NOT NULL,
	modreg_lib				TEXT 							NOT NULL,
	modreg_compteid		B	INARY(24) 						NOT NULL,
	CONSTRAINT ctmodreg UNIQUE (modreg_id, modreg_compteid),
	FOREIGN KEY(modreg_type) REFERENCES typeofmodereglement(typeofmr_type),
	FOREIGN KEY(modreg_compteid) REFERENCES compte(compte_id)
);

INSERT INTO modereglement (modreg_id,modreg_type,modreg_lib,modreg_compteid) VALUES (3,'CB','Carte bancaire AC N° X','000020000000000000000002');
INSERT INTO modereglement (modreg_id,modreg_type,modreg_lib,modreg_compteid) VALUES (2,'CB','Carte bancaire AD N° Y','000020000000000000000002');
INSERT INTO modereglement (modreg_id,modreg_type,modreg_lib,modreg_compteid) VALUES (1,'CB','Carte bancaire BC N° Z','000020000000000000000001');

DROP TABLE IF EXISTS tiers;
CREATE TABLE tiers (
	tiers_id					INTEGER 		PRIMARY KEY			NOT NULL,
	tiers_type					CHAR(1)								NOT NULL DEFAULT 'e' CHECK(tiers_type in ('p','e')),
	tiers_lib					TEXT								NOT NULL
);

DROP TABLE IF EXISTS entreprise;
CREATE TABLE entreprise (
	entreprise_id 				INTEGER 		PRIMARY KEY			NOT NULL,
	entreprise_tierstype		CHAR(1)								NOT NULL DEFAULT 'e' CHECK(entreprise_tierstype = 'e'),
	entreprise_lib				TEXT								NOT NULL,
	FOREIGN KEY(entreprise_id, entreprise_tierstype) REFERENCES tiers(tiers_id, tiers_type)
);

CREATE TABLE particulier (
	particulier_id				INTEGER 		PRIMARY KEY			NOT NULL,	
	particulier_tierstype		CHAR(1)								NOT NULL DEFAULT 'p' CHECK(particulier_tierstype = 'p'),
	particulier_lib				TEXT								NOT NULL,
	FOREIGN KEY(particulier_id, particulier_tierstype) REFERENCES tiers(tiers_id, tiers_type)
); 

DROP TABLE IF EXISTS reglement;
CREATE TABLE reglement (
	reg_id				INTEGER 		PRIMARY KEY			NOT NULL,
	reg_type			CHAR(1)								NOT NULL DEFAULT 'p' CHECK(reg_type in ('p','e')),
	reg_date			DATE								NOT NULL,
	reg_amount			NUMERIC(9,2)						NOT NULL,
	reg_comment			TEXT								NOT NULL DEFAULT '',
	reg_tiersid			TEXT								NOT NULL,
	CONSTRAINT ctregtype UNIQUE (reg_id, reg_type, reg_tiersid),
	FOREIGN KEY(reg_tiersid) REFERENCES tiers(tiers_id)
);

DROP TABLE IF EXISTS reglementp;
CREATE TABLE reglementp (
	regp_id				INTEGER 		PRIMARY KEY			NOT NULL,
	regp_type			CHAR(1)								NOT NULL DEFAULT 'p' CHECK(regp_type = 'p'),
	regp_modreglib		TEXT 								NOT NULL,
	regp_lib			TEXT 								NOT NULL,
	CONSTRAINT ctregp UNIQUE (regp_id, regp_type),
	FOREIGN KEY(regp_id, regp_type) REFERENCES reglement(reg_id, reg_type),
	FOREIGN KEY(regp_modreglib) REFERENCES modereglement(modreg_lib)
);

DROP TABLE IF EXISTS statusreglement;
CREATE TABLE statusreglement (
	statreg_regid		INTEGER 							NOT NULL,
	statreg_seq			INTEGER								NOT NULL,
	statreg_code		CHAR(1)								NOT NULL,
	statreg_date		DATE								NOT NULL,
	statreg_comment		TEXT								NOT NULL DEFAULT '',
	CONSTRAINT ctstatreg UNIQUE (statreg_regid,statreg_seq,statreg_code,statreg_date),
	FOREIGN KEY(statreg_regid) REFERENCES reglement(reg_id),
	FOREIGN KEY(statreg_code) REFERENCES statusofreg(statusofreg_code)	
);

DROP TABLE IF EXISTS relecr;
CREATE TABLE relecr (
	ecr_no				INTEGER			PRIMARY KEY		NOT NULL,
	ecr_date			DATE							NOT NULL,
	ecr_year			INTEGER							NOT NULL CHECK(ecr_year >= 2000 AND ecr_year <= 2099),
	ecr_month			INTEGER							NOT NULL CHECK(ecr_month >= 1 AND ecr_month <= 12),
	ecr_day				INTEGER							NOT NULL CHECK(ecr_day >= 1 AND ecr_month <= 31),
	ecr_lib				TEXT							NOT NULL,
	ecr_amount			NUMERIC(9,2)					NOT NULL,
	ecr_deborcred			CHAR(1)							NOT NULL DEFAULT 'd' CHECK(ecr_deborcred in ('c','d')),
	ecr_solde			NUMERIC(9,2)					NOT NULL,
	ecr_source			TEXT							NOT NULL CHECK(ecr_source='RELEVE BANCAIRE HSBC')	
);

DROP TABLE IF EXISTS relecrhasmvt;
CREATE TABLE relecrhasmvt (
	relecrhmvt_ecrno		INTEGER							NOT NULL,
	relecrhmvt_mvtid		BINARY(44) 						NOT NULL,
	relecrhmvt_mvtno		INTEGER							NOT NULL,
	PRIMARY KEY (relecrhmvt_ecrno, relecrhmvt_mvtid),
	CONSTRAINT relecthmvt UNIQUE (relecrhmvt_ecrno, relecrhmvt_mvtid, relecrhmvt_mvtno)
	FOREIGN KEY(relecrhmvt_ecrno) REFERENCES relecr(ecr_no),
	FOREIGN KEY(relecrhmvt_mvtid) REFERENCES mouvement(mvt_id),
	FOREIGN KEY(relecrhmvt_mvtno) REFERENCES mouvement(mvt_no)
);