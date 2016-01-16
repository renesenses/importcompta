CREATE TABLE piece (
	piece_id					INTEGER				 		NOT NULL,
	piece_date					DATE			 			NOT NULL,
	piece_type 					INTEGER 					NOT NULL, 
	PRIMARY KEY (piece_id)
); 

CREATE TABLE type-piece (
	type-piece_id				TEXT				 		NOT NULL,
	type-piece_lib 				TEXT 						NOT NULL, 
	PRIMARY KEY (type-piece_id)
); 


CREATE TABLE autres (
	autre_id					INTEGER				 		NOT NULL,
	autre_lib 					TEXT 						NOT NULL, 
	PRIMARY KEY (autre_id)
);

CREATE TABLE facture (
	facture_id					INTEGER		PRIMARY KEY 	NOT NULL,
	facture_fournisseur-id 		INTEGER 					NOT NULL, 
	facture_client-id			TEXT 						NOT NULL, 
	facture_lib					TEXT						NOT NULL,
	facture_montant-HT			TEXT						NOT NULL,
	facture_montant-TTC			TEXT						NOT NULL,
	facture_date-echeance		TEXT						NOT NULL,
	facture_mode-reglement-id	INTEGER						NOT NULL,
	FOREIGN KEY (facture_fournisseur-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY (facture_client-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY (facture_mode-reglement-id) REFERENCES mode-reglement(mode-reglement_id),
  	PRIMARY KEY (facture_id)
);  	

CREATE TABLE mode-reglement (
	mode-reglement_id			INTEGER				 		NOT NULL,
	mode-reglement_lib 			TEXT 						NOT NULL, 
	PRIMARY KEY (mode-reglement_id)
); 

CREATE TABLE justificatif_paiement (
	jus_id					INTEGER				 		NOT NULL,
	jus_type-id				INTEGER				 		NOT NULL,
	jus_lib					TEXT				 		NOT NULL,
	jus_date				DATE				 		NOT NULL,
	jus_client-id			INTEGER						NOT NULL,
	jus_fournisseur-id		INTEGER						NOT NULL,
	jus_montant				TEXT						NOT NULL, //FLOAT
	jus_mode-reglement-id	INTEGER						NOT NULL,
	FOREIGN KEY (jus_type-id) REFERENCES type-piece(type-piece_id),
	FOREIGN KEY (jus_client-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY (jus_fournisseur-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY (jus_mode-reglement-id) REFERENCES mode-reglement(mode-reglement_id),
  	PRIMARY KEY (jus_id)
);

CREATE TABLE contrat (
	contrat_id					INTEGER				 		NOT NULL,
	contrat_date				DATE				 		NOT NULL,
	contrat_contractant-1-id	INTEGER						NOT NULL,
	contrat_contractant-2-id	INTEGER						NOT NULL,
	contrat_redacteur-id		INTEGER						NOT NULL,
	contrat_lib					TEXT						NOT NULL,
	contrat_debut				DATE				 		NULL,
	contrat_fin					DATE				 		NULL,
	
	FOREIGN KEY(contrat_contractant-1-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY(contrat_contractant-2-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY(contrat_redacteur-id) REFERENCES entreprise(entreprise_id),
	PRIMARY KEY(contrat_id)
);

CREATE TABLE RELEVE (
	RELEVE_ID			 		INTEGER 					NOT NULL,
	RELEVE_DATE 				DATE(YYYYMMDD) 				NOT NULL,
	RELEVE_NO					INTEGER 					NOT NULL,
	RELEVE_DURATION				TEXT						NOT NULL,	
	RELEVE_NBMVT 				INTEGER 					NOT NULL,
	RELEVE_SOLDEDEBUT 			NUMERIC(2,9) 				NOT NULL,
	RELEVE_SOLDEFIN	 			NUMERIC(2,9)				NOT NULL,
	PRIMARY KEY(RELEVE_ID)
);

CREATE TABLE BANQUEMVT (
	BANQUEMVT_ID		 		INTEGER 					NOT NULL,
	BANQUEMVT_RELEVEID			INTEGER 					NOT NULL,
	BANQUEMVT_DATE				DATE 						NOT NULL,
	BANQUEMVT_DATEVDEVALEUR		DATE 						NOT NULL,
	BANQUEMVT_LIB				TEXT						NOT NULL,
	BANQUEMVT_EXO				BOOELAN						NOT NULL, // DEFAULT YES OR NO
	BANQUEMVT_TYPE 				TEXT						NOT NULL, // DEBIT ou CREDIT
	BANQUEMVT_AMOUNT			NUMERIC(2,9)				NOT NULL,
	FOREIGN KEY(BANQUEMVT_RELEVEID) REFERENCES RELEVE(RELEVE_ID),
	PRIMARY KEY(BANQUEMVT_RELEVEID)
);


CREATE TABLE entreprise (
	entreprise_id 				INTEGER						NOT NULL,
	entreprise_lib				TEXT						NOT NULL,
	entreprise_adresse			TEXT						NOT NULL,
	entreprise_TVA				TEXT						NOT NULL,
	entreprise_APE				TEXT						NOT NULL,
	entreprise_SIREN			TEXT						NOT NULL,
	entreprise_rem				TEXT						NULL,
	FOREIGN KEY(entreprise_APE) REFERENCES code-APE(code-APE_id),
	PRIMARY KEY(entreprise_id)
); 

CREATE TABLE code-APE (
	code-APE_id					TEXT						NOT NULL,
	code-APE_lib				TEXT						NOT NULL,
	code-APE_version			TEXT						NOT NULL,
	PRIMARY KEY(code-APE_id)
);

CREATE TABLE verification (
	verif_id					INTEGER						NOT NULL,
	verif_lib					TEXT						NOT NULL,
	verif_type-id				INTEGER						NOT NULL,
	verif_contractant-id 		INTEGER						NOT NULL,
	FOREIGN KEY(verif_contractant-id) REFERENCES entreprise(entreprise_id),
	FOREIGN KEY(verif_type-id) REFERENCES verif-type(verif-type_id),
	PRIMARY KEY(verif_id)
);

CREATE TABLE verif-type (
	verif-type_id					INTEGER						NOT NULL,
	verif-type_lib					TEXT						NOT NULL,
	PRIMARY KEY(verif-type_id)
);

CREATE TABLE suivi-verif (
	suivi-verif_id					INTEGER						NOT NULL,
	suivi-verif_verif-id			INTEGER						NOT NULL,
	suiiv-verif_date				TEXT						NOT NULL,
	suivi-verif_status				TEXT						NOT NULL,
	suivi-verif_rem					TEXT						NOT NULL,
	FOREIGN KEY(suiiv-verif_verif-id) REFERENCES verification(verif_id),
	PRIMARY KEY(verif-type_id)
);

CREATE TABLE DISPLAY  (
	DISPLAY_FIELD					TEXT						NOT NULL,
	DISPLAY_TABLE					TEXT						NOT NULL,
	DISPLAY_NAME					TEXT						NOT NULL,
	PRIMARY KEY(DISPLAY_FIELD)
);
