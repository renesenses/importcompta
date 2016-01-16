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
	my $nbemptycells = 0;
	foreach my $worksheet ( $book->worksheets() ) {
		my ($min_row, $max_row) = $worksheet->row_range();
		my ($min_col, $max_col) = $worksheet->col_range();
		foreach my $row ($min_row .. $max_row) {
			foreach my $col ( $min_col .. $max_col ) {
				my $cell = $worksheet->get_cell($row, $col);
				if ( defined($cell) && ($cell->value() eq '') ) {
					$nbemptycells++;
					print $worksheet->get_name()," :\t(",$row, "\t",$col,")\t:",$cell->value(),"\n";
				};
			}
		}
	}
	print "Nb of empty cells : \t",$nbemptycells,"\n";
}

#$input = "/Users/bertrand/MY_GITHUB/pieces-comptables/releves-bancaires/IMPORTS/2016-01-12_RELEVES-HSBC.xls";
#$input = "/Users/bertrand/MY_GITHUB/pieces-comptables/releves-bancaires/IMPORTS/test-relecr.xls";
$input = "/Users/bertrand/MY_GITHUB/pieces-comptables/releves-bancaires/IMPORTS/last-test-sans-vides.xls";

# add check of xls file version must be 
if (-e $input) {
	my $parser   = Spreadsheet::ParseExcel->new();
	my $workbook = $parser->parse($input);

	getbookinfo($workbook);

	print "####################################\n";

	for my $worksheet ( $workbook->worksheets() ) {
	
	#	print Dumper($worksheet);
	
		my $table_id 	= $worksheet->get_name();
		print "TABLE NAME : ",$table_id,"\n";
		my @columns_id;
		
		my ($min_row, $max_row) = $worksheet->row_range();
		my ($min_col, $max_col) = $worksheet->col_range();
		print "\tCOL Range : ",$min_col,"\t", $max_col,"\n";
		print "\tROW Range : ",$min_row,"\t", $max_row,"\n";
		foreach my $col ( $min_col .. $max_col ) {
			my $cell = $worksheet->get_cell(0, $col);
#			print Dumper($cell);
			push @columns_id, $cell->value();
		}	
		my $rs 		= $schema->resultset($table_id );
		my $record 	= $schema->resultset($table_id )->new_result({});
		my $source 	= $schema->source($table_id );
		my @table_fields 	= $source->columns;
		#$tablefields_pos{$field} return field pos if $field in hash keys

		# We keep field/column pos in list
		my %tablefields_pos;
		for my $ind (0..$#table_fields){
			$tablefields_pos{$table_fields[$ind]} = $ind;
		}	

		print Dumper(%tablefields_pos);

		my %columnsid_pos;
		for my $ind (0..$#columns_id){
			$columnsid_pos{$columns_id[$ind]} = $ind;
		}	

		print Dumper(%columnsid_pos);

# %hash_pk = map { $_->{$pk} => $_ } $hash;
		my @test_union = union(\@table_fields,\@columns_id);
		my @test = subtract(\@table_fields, \@test_union);
		
		if ( @test = "") {
			print "Import requirements ok \n";
		# required fields in column, so let's finds their position in @columns_id
			my @ind_position;
			foreach my $tfield ( @table_fields ) {
				push @ind_position, $columnsid_pos{$tfield}; 
			}	
			foreach my $row ($min_row+1 .. $max_row) {
				my @db_record =();
				my @record=(); 
				foreach my $col ( $min_col .. $max_col )  {
					
					my $cell = $worksheet->get_cell($row, $col);
#					print "(",$row, "\t",$col,")\t:",$cell->value(),"\n";
					push @record, $cell->value();
#					print join(",",@record),"\n";
					# We set @record in good order
#					print Dumper(@record);
				}
				foreach my $pos ( @ind_position ) {
					push @db_record, $record[$pos];
				}
				if ( $table_id eq 'Relecr') {
					print "source",$db_record[$tablefields_pos{ecr_source}],"\n";
					if ( $db_record[$tablefields_pos{ecr_source}] eq 'RELEVE BANCAIRE HSBC' ) { 
						$schema->resultset($table_id)->populate([[ @table_fields ],[ @db_record ]]);
					}	
				}
				else {
					$schema->resultset($table_id)->populate([[ @table_fields ],[ @db_record ]]);
				}
			}
		} else {
			print "schema NOK some required fields are missing\n";
			print "Check if import is possible  \n";
			
			# Missing required fields
			# Available nes fields are already known anf if methods are available
			
			my @inter = intersect(\@table_fields,\@columns_id);
			print "Available required columns : ",join(", ",@inter),"\n";
			my @missing = subtract(\@table_fields, \@inter);
			print "Missing required columns : ",join(", ",@missing),"\n";
			my @avail_fields = subtract(\@columns_id, \@table_fields);
			print "Available new fields : ",join(", ",@avail_fields),"\n";
			
		}
	}
}	
else {
	print "Input invalid !\n";
}