rm pdf.db
rm -R Pdf
sqlite3 pdf.db < cr-pdfdb.sql
perl -w mk-pdfdb-classes.pl