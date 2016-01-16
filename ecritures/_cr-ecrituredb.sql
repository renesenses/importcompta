DROP TABLE IF EXISTS ecr;

CREATE TABLE ecr (

	ecr_no						INTEGER		PRIMARY KEY		NOT NULL,
	ecr_date					DATE						NOT NULL,
	ecr_lib						TEXT						NOT NULL,
	ecr_devise					TEXT						NOT NULL DEFAULT 'EUR' CHECK(ecr_devise in ('EUR','USD')),
	ecr_deb						NUMERIC(9,2)				NOT NULL,
	ecr_cred					NUMERIC(9,2)				NOT NULL,
	ecr_solde					NUMERIC(9,2)				NOT NULL,
	ecr_comptamode				TEXT						NOT NULL DEFAULT 'PRO' CHECK(ecr_devise in ('PRO','PERSO')),
	ecr_rem						TEXT						NOT NULL,
	ecr_statusofreg				TEXT						NOT NULL DEFAULT '' CHECK(ecr_statusofreg in ('PAYE','IMPAYE','OK','')),
	ecr_typeofmrabrev			TEXT						NOT NULL CHECK(ecr_typeofmrabrev in ('PAY','GAN','CB','ESP','CHE','PRE','VIR','PRL','PRVL','IMP','REM','RET','LCR','REJ')),
	ecr_payeur	
	ecr_check	
	ecr_piececomptableref	
	ecr_typepiecelib	
	ecr_source	
	ecr_ttc					
	ecr_tauxtva					NUMERIC(,2)
	ecr_tva	
	ecr_ht	
	ecr_projectlib	
	ecr_tierslib	
	ecr_comptacodelib	
	ecr_comptacode	
	ecr_temp
	
	CONSTRAINT ctlocation UNIQUE
	FOREIGN KEY(ecr_devise) REFERENCES cst_devise(devise_lib)
);

DROP TABLE IF EXISTS cst_devise;
CREATE TABLE cst_devise (
	devise_lib 				TEXT	PRIMARY KEY			NOT NULL
);

DROP TABLE IF EXISTS cst_devise;
CREATE TABLE cst_devise (
	devise_lib 				TEXT	PRIMARY KEY			NOT NULL
);

statusofreg				TEXT						NOT NULL DEFAULT '' CHECK(ecr_statusofreg in ('PAYE','IMPAYE','OK','')),