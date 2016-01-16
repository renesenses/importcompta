#! /usr/bin/env perl

# Usage : perl -w import-compta.pl excel-filename [sheet-name]

use Spreadsheet::ParseExcel;
#use Spreadsheet::WriteExcel
use Pieces::Schema;
use File::Basename;
use Data::Dumper;
#use strict;

my @inputs;
my $spreadsheet;
my $book;

my $schema = Pieces::Schema->connect('dbi:SQLite:pieces-comptables.db', '', '',{ sqlite_unicode => 1});


# SUBS

sub dumpertableidbyname {
	my $table_name = shift;
	
	my $rs_table = $schema->resultset('Display')->search( { display_value => $table_name } )->hashref_pk;
	return Dumper $rs_table;
}

sub checktableidbyname {
	my $table_name = shift;
	
	my $rs_table = $schema->resultset('Display')->search( { display_value => $table_name } )->hashref_pk;
	my @keys = keys %{ $rs_table };
	return $#keys;
	
=begin comment
	
	if ($#results == 1) {
		return ${ $rs_table}{$results[0]}->{display_id};
	} else {
		return 0;
	}
=end comment
=cut
}


for my $arg (0 .. $#ARGV) {
	print "ARG_NO : ", $arg,"\t","ARG_VALUE : ",$ARGV[$arg],"\t";
#	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
	print "RES : ",dumpertableidbyname($ARGV[$arg]),"\n";
}

my @ARGUS = ("Période", "Type piece", "testa", "Id", "Solde Début");
for my $argus ( @ARGUS ) {
	print "ARG_VALUE : ",$argus,"\t";
#	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
	print "RES : ",dumpertableidbyname($argus),"\n";
}