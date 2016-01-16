DROP TABLE IF EXISTS display;
CREATE TABLE IF NOT EXISTS display (
	display_id					TEXT						NOT NULL,
	display_lang				TEXT						NOT NULL DEFAULT 'FR',
	display_value				TEXT						NOT NULL,
	CONSTRAINT ctdisplay UNIQUE (display_id, display_lang, display_value),
	PRIMARY KEY(display_id, display_lang) 
);

DROP TABLE IF EXISTS typepiece;
CREATE TABLE typepiece (
	typepiece_id				TEXT				 		NOT NULL,
	typepiece_lib 				TEXT 						NOT NULL, 
	PRIMARY KEY (typepiece_id)
); 

INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece','FR','Type pièce');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece','EN','Type piece');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece_id','FR','Id');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece_lib','FR','Libellé');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece_lib','EN','Libelle');

INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('F','Facture');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('J','Justificatif règlement');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('E','Echéancier');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('VIR','Virement');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('P','Preuve');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('CHE','Chèque');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('C','Contrat');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('CGV','Conditions générales de vente');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('A','Article');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('Code','Code');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('B','Bon de commande');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('LCR','Lettre de change relève');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('AR','Courier avec AR');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('CS','Courier simple');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('FAX','Facsimilé');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES ('M','Mél');

DROP TABLE IF EXISTS releve;
CREATE TABLE releve (
	releve_id			 		INTEGER 					NOT NULL,
	releve_date 				DATE		 				NOT NULL,
	releve_no					INTEGER 					NOT NULL,
	releve_duration				TEXT						NOT NULL,	
	releve_nbmvt 				INTEGER 					NOT NULL,
	releve_soldedebut 			NUMERIC(2,9) 				NOT NULL,
	releve_soldefin	 			NUMERIC(2,9)				NOT NULL,
	PRIMARY KEY(releve_id)
);

INSERT INTO display (display_id,display_lang,display_value) VALUES ('typepiece_lib','EN','Label');

INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve','FR','Relevés bancaires');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_id','FR','Id');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_date','FR','Date');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_no','FR','N°');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_duration','FR','Période');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_nbmvt','FR','Nb MVT');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_soldedebut','FR','Solde Début');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('releve_soldefin','FR','Solde Fin');

DROP TABLE IF EXISTS banquemvt;
CREATE TABLE banquemvt (
	banquemvt_id		 		INTEGER 					NOT NULL,
	banquemvt_releveid			INTEGER 					NOT NULL,
	banquemvt_date				DATE		 				NOT NULL,
	banquemvt_datevaleur		DATE		 				NOT NULL,
	banquemvt_lib				TEXT						NOT NULL,
	banquemvt_exo				BOOELAN						NOT NULL DEFAULT 'NO',
	banquemvt_type 				TEXT						NOT NULL DEFAULT 'CREDIT',
	banquemvt_amount			NUMERIC(2,9)				NOT NULL,
	FOREIGN KEY(banquemvt_releveid) REFERENCES releve(releve_id),
	PRIMARY KEY(banquemvt_releveid)
);
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt','FR','Mouvements bancaires');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_id','FR','Id');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_releveid','FR','Relevé');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_date','FR','Date');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_datevaleur','FR','Date valeur');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_lib','FR','Libellé');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_exo','FR','Exo');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_type','FR','Type');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('banquemvt_amount','FR','Montant');

DROP TABLE IF EXISTS tempbanquemvt;
CREATE TABLE tempbanquemvt (
	tempbanquemvt_id		 		INTEGER 	PRIMARY KEY		AUTOINCREMENT,
	tempbanquemvt_date				DATE		 				NOT NULL,
	tempbanquemvt_lib				TEXT						NOT NULL,
	tempbanquemvt_devise			BOOELAN						NOT NULL DEFAULT 'EURO',
	tempbanquemvt_debcred 			TEXT						NOT NULL DEFAULT 'C',
	tempbanquemvt_amount			NUMERIC(2,9)				NOT NULL,
	tempbanquemvt_solde				NUMERIC(2,9)				NOT NULL
);
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt','FR','Mouvements 5C');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_id','FR','N°');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_date','FR','Date');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_lib','FR','Détail opération');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_devise','FR','Devise');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_debcred','FR','Débit ou Crédit');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_amount','FR','Montant');
INSERT INTO display (display_id,display_lang,display_value) VALUES ('tempbanquemvt_solde','FR','Solde');