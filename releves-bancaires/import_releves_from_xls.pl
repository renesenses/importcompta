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

my @inputs;
my $spreadsheet;
my $book;

my $input;

# SUBS

sub seconds_to_time {
	my $seconds = shift;
	my $hours = int($seconds / 3600);
	my $minutes = int(($seconds - 3600 * $hours)/60);
	$seconds = $seconds - (3600 * $hours) - (60 * $minutes);
	return $hours.":".$minutes.":".$seconds;
}

sub time_to_minutes {
	my $time_str = shift;
	my ($hours, $minutes, $seconds) = split(/:/, $time_str);
	return $hours * 60 + $minutes + $seconds / 60;
}

sub time_to_seconds {
	my $time_str = shift;
	my ($hours, $minutes, $seconds) = split(/:/, $time_str);
	return $hours * 3600 + $minutes * 60 + $seconds;
}

sub compute_fract_duration {
	my $nb = shift;
	my $time_str1 = shift;
	my $time_str2 = shift	;
	return seconds_to_time((time_to_seconds($time_str1)+time_to_seconds($time_str2))*$nb);
}	


sub getbookinfo {
	my $book = shift;
	my($filename, $path, $suffix) = fileparse($book);
	print "Book label : \t",$book->get_filename(),"\n";
	my @sheets = $book->worksheets();
	print "Nb of sheets : \t",$book->worksheet_count(),"\n";
}


$input = "/Users/bertrand/MY_GITHUB/pieces-comptables/releves-bancaires/IMPORTS/2016-01-12_RELEVES-HSBC.xls";

# add check of xls file version must be 
if (-e $input) {
	my $parser   = Spreadsheet::ParseExcel->new();
	my $workbook = $parser->parse($input);

	getbookinfo($workbook);

	print "####################################\n";

	for my $worksheet ( $workbook->worksheets() ) {
	
	#	print Dumper($worksheet);
	
		my $table_id 	= $worksheet->get_name();
		my @columns_id;
		
		my ($min_row, $max_row) = $worksheet->row_range();
		my ($min_col, $max_col) = $worksheet->col_range();
		print "COL Range : ",$min_col,"\t", $max_col,"\n";
		foreach my $col ( $min_col .. $max_col ) {
			my $cell = $worksheet->get_cell(0, $col);
#			print Dumper($cell);
			push @columns_id, $cell->value();
		}	
		my $rs 		= $schema->resultset($table_id );
		my $record 	= $schema->resultset($table_id )->new_result({});
		my $source 	= $schema->source($table_id );
		my @fields 	= $source->columns;

		if ( (join(",",@fields)) eq (join(",",@columns_id)) ) {
			print "schema ok \n";
#			my ($min_row, $max_row) = $worksheet->row_range();
#			my ($min_col, $max_col) = $worksheet->col_range();
			foreach my $row ($min_row+1 .. $max_row) {
				my @record=(); 
				foreach my $col ( $min_col .. $max_col )  {
					my $cell = $worksheet->get_cell($row, $col);
					push @record, $cell->value();
				}
				print join(",",@record),"\n";
#				print Dumper(@record);
				$schema->resultset($table_id)->populate([ 
					[ @fields ],[ @record ]
				]);
			}	
		}
		else {
			print "schema NOK \n";
			print "trying another import method \n";
			my @inter = intersect(\@fields,\@columns_id);
			print "Available required fields : ",join(", ",@inter),"\n";
			my @missing = complement(\@columns_id, \@inter);
			print "Missing required fields : ",join(", ",@missing),"\n";
			
		}
	}
}	
else {
	print "Input invalid !\n";
}