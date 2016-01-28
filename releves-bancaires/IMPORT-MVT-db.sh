rm -R Releve
sqlite3 relevebanque.db < IMPORT-MVT.sql
perl -w mk-relevedb-classes.pl