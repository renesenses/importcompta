DROP TABLE IF EXISTS typepiece;
CREATE TABLE typepiece (
	typepiece_id				INTEGER		PRIMARY KEY		NOT NULL,
	typepiece_lib 				TEXT 						NOT NULL
); 

INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES (1,'Facture règlement');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES (2,'Justificatif règlement');
INSERT INTO typepiece (typepiece_id,typepiece_lib) VALUES (3,'Facture émise');

DROP TABLE IF EXISTS piececomptable;
CREATE TABLE IF NOT EXISTS piececomptable (
	piececomptable_id			INTEGER		PRIMARY KEY		NOT NULL,
	piececomptable_md5			TEXT						NOT NULL,
	CONSTRAINT ctpiececomptable UNIQUE (piececomptable_id, piececomptable_md5)
);

DROP TABLE IF EXISTS filename;
CREATE TABLE IF NOT EXISTS file (
	file_id						INTEGER		PRIMARY KEY		NOT NULL,
	file_filename				TEXT						NOT NULL,
	file_ext					TEXT						NOT NULL,
	file_dir					TEXT						NOT NULL,
	file_volume					TEXT						NOT NULL,
	file_pieceid				INTEGER						NOT NULL,
	CONSTRAINT ctfilename UNIQUE (file_filename,file_ext,file_dir,file_volume),
	FOREIGN KEY(file_pieceid) REFERENCES piececomptable(piececomptable_id)
);