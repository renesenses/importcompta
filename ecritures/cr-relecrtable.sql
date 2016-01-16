DROP TABLE IF EXISTS relecr;
CREATE TABLE relecr (
	ecr_no				INTEGER			PRIMARY KEY		NOT NULL,
	ecr_date			DATE							NOT NULL,
	ecr_lib				TEXT							NOT NULL,
	ecr_deb				NUMERIC(9,2)					NOT NULL,
	ecr_cred			NUMERIC(9,2)					NOT NULL,
	ecr_solde			NUMERIC(9,2)					NOT NULL,
	ecr_source			TEXT							NOT NULL CHECK(ecr_source='RELEVE BANCAIRE HSBC')	
);

DROP TABLE IF EXISTS relecrhasmvt;
CREATE TABLE relecrhasmvt (
	relecrhmvt_ecrno		INTEGER							NOT NULL,
	relecrhmvt_mvtid		BINARY(44) 						NOT NULL,
	relecrhmvt_mvtno		INTEGER							NOT NULL,
	PRIMARY KEY (relecrhmvt_ecrno, relecrhmvt_mvtid),
	CONSTRAINT ctrelecrhmvt UNIQUE (relecrhmvt_ecrno, relecrhmvt_mvtid,relecrhmvt_mvtno),
	FOREIGN KEY(relecrhmvt_ecrno) REFERENCES relecr(ecr_no),
	FOREIGN KEY(relecrhmvt_mvtid) REFERENCES mouvement(mvt_id),
	FOREIGN KEY(relecrhmvt_mvtno) REFERENCES mouvement(mvt_no)
);