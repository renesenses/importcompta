#! /usr/bin/env perl

# Usage : perl -w import-compta.pl excel-filename [sheet-name]

# Works as a basic template

use Spreadsheet::ParseExcel;
#use Spreadsheet::WriteExcel

use strict;
use warnings;
use Data::Dumper;
use Releve::Schema;
use File::Basename;
use List::Collection;


Releve::Schema->load_namespaces;


my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});

my $rs_ecr = $schema->resultset('Relecr')->search({})->hashref_pk;
my $rs_mvt = $schema->resultset('Mouvement')->search({})->hashref_pk;	


foreach my $ecr_pk ( sort ( keys { %{ $rs_ecr} }) ) {
	my $ecrno = $rs_ecr->{$ecr_pk}->{ecr_no};
	
	foreach my $mvt_pk ( sort ( keys { %{ $rs_mvt} }) ) {
		my $mvtid = $rs_mvt->{$mvt_pk}->{mvt_id};
		print "ID : ",$mvtid,"\t"; 
		my $mvtno = $rs_mvt->{$mvt_pk}->{mvt_no};
		print "NO : ",$mvtno,"\n"; 
		my $rs_hasmvt = $schema->resultset('Relecrhasmvt')->search({
			relecrhmvt_ecrno => $ecrno,
			relecrhmvt_mvtid => $mvtid,
		});				
		if( $rs_hasmvt->count() == 1 ) {
			print $mvtno, " OK \n";
		} else {			
			print "Missing mvt_no : ",$mvtno,"\n";
		}
	}
}
