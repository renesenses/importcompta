DROP TABLE IF EXISTS typeofmodereglement;
CREATE TABLE typeofmodereglement (
	typeofmr_id				INTEGER 		PRIMARY KEY			NOT NULL,
	typeofmr_type				TEXT 							NOT NULL,
	typeofmr_lib				TEXT 							NOT NULL,
	CONSTRAINT cttypeofmr UNIQUE (typeofmr_type),
);
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (3,'CB','Carte bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (1,'ESP','Espèces');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (2,'CHEQUE','Chèque bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (6,'LCR','Lettre de change relève');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (4,'VIREMENT','Virement bancaire');
INSERT INTO typeofmodereglement (typeofmr_id,typeofmr_type,typeofmr_lib) VALUES (5,'PRELEVEMENT','Prélèvement bancaire');

DROP TABLE IF EXISTS modereglement;
CREATE TABLE modereglement (
	modreg_id				INTEGER 		PRIMARY KEY		NOT NULL,
	modreg_type				TEXT 							NOT NULL,
	modreg_lib				TEXT 							NOT NULL,
	modreg_compteid		B	INARY(24) 						NOT NULL,
	CONSTRAINT ctcompte UNIQUE (compte_id, compte_banquelib),
	FOREIGN KEY(modreg_type) REFERENCES typeofmodereglement(typeofmr_type),
	FOREIGN KEY(modreg_compteid) REFERENCES compte(compte_id)
);

INSERT INTO modereglement (modreg_id,modereg_type,modereg_lib,modreg_compteid) VALUES (3,'CB','Carte bancaire AC N° X','000020000000000000000002');
INSERT INTO modereglement (modreg_id,modereg_type,modereg_lib,modreg_compteid) VALUES (2,'CB','Carte bancaire AD N° Y','000020000000000000000002');
INSERT INTO modereglement (modreg_id,modereg_type,modereg_lib,modreg_compteid) VALUES (1,'CB','Carte bancaire BC N° Z','000020000000000000000001');

CREATE TABLE reglement (
	reg_id				INTEGER 		PRIMARY KEY			NOT NULL,
	reg_type			CHAR(1)								NOT NULL DEFAULT 'p' CHECK(step_type in ('p','e')),
	reg_date			DATE								NOT NULL,
	reg_amount			NUMERIC(9,2)						NOT NULL,
	reg_comment			TEXT								NOT NULL DEFAULT '',
	reg_tiersid			TEXT								NOT NULL,
	CONSTRAINT ctregtype UNIQUE (reg_lib, reg_type),
	FOREIGN KEY(reg_tiersid) REFERENCES tiers(tiers_id)
);

CREATE TABLE reglementp (
	regp_id				INTEGER 		PRIMARY KEY			NOT NULL,
	regp_type			CHAR(1)								NOT NULL DEFAULT 'p' CHECK(regp_type = 'p'),
	regp_modreglib		TEXT 								NOT NULL,
	regp_lib			TEXT 								NOT NULL,
	CONSTRAINT ctcompte UNIQUE (compte_id, compte_banquelib),
	FOREIGN KEY(regp_id, regp_type) REFERENCES reglement(reg_id, reg_type),
	FOREIGN KEY(regp_modreglib) REFERENCES modereglement(modreg_lib)
);

CREATE TABLE tiers (
	tiers_id					INTEGER 		PRIMARY KEY			NOT NULL,
	tiers_type					CHAR(1)								NOT NULL DEFAULT 'e' CHECK(tiers_type in ('p','e')),
	tiers_lib					TEXT								NOT NULL
);

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


DROP TABLE IF EXISTS reglementautres;

CREATE TABLE statusreglement (
	statreg_id
	statreg_regid
	statreg_type
	statreg_provid	
)


