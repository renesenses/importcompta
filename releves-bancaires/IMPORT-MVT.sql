DROP TABLE IF EXISTS mvtxls;
CREATE TABLE mvtxls (
	mvtxls_no					INTEGER			PRIMARY KEY			NOT NULL CHECK(mvtxls_no >= 1 AND mvtxls_no <= 9999),
	mvtxls_date					DATE 								NOT NULL,
	mvtxls_lib					TEXT								NOT NULL,
	mvtxls_datevaleur			DATE 								NOT NULL,
	mvtxls_exo					TEXT								NOT NULL DEFAULT '' CHECK(mvtxls_exo in ('','x')),
	mvtxls_amountdeb			NUMERIC(9,2)						NULL,
	mvtxls_amountcred			NUMERIC(9,2)						NULL,			
	CONSTRAINT ctamount CHECK (mvtxls_amountdeb OR mvtxls_amountcred NOT NULL)
);
