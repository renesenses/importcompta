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


#Releve::Schema->load_namespaces;


my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});

my @inputs;
my $spreadsheet;
my $book;

my $input;

my $template;

my $table = 'Mvtxl';

# THE SUB FOR GETING INFO ON THE FIELD NAMES $table_id (mvtxls)
# THEN ALSO THE CONSTAINTS 
sub gettableinfo {
	my $table_id 		= shift;
	my $source 			= $schema->source($table_id);
	my @table_fields 	= $source->columns;
	print "Nb col required : ",getnbcolrequired($table),"\n";
	foreach my $ind (0 ..$#table_fields) {
#		print Dumper($source->column_info($col)); # when looping on ->columns
#		print Dumper($source->column_info($table_fields[$ind]));
		print $table_fields[$ind],"\t";
		print $source->column_info($table_fields[$ind])->{'data_type'},"\n";	
	}
}

sub getnbcolrequired {
	my $table_id 		= shift;
	my $source 			= $schema->source($table_id);
	my @table_fields 	= $source->columns;
#	print "Fields : ",join(", ",@table_fields);
# We must minus1 because of PK field 
	return $#table_fields-1;
}

sub getcoltyperequired {
	my $table_id 		= shift;
	my $fieldno			= shift;
	# We care of PK not present in xls
	my $ind = $fieldno +1;
	my $source 			= $schema->source($table_id);
	my @table_fields 	= $source->columns;
	my $coltype			= $source->column_info($table_fields[$ind])->{'data_type'};
#	print "Fields : ",join(", ",@table_fields);
# We must minus1 because of PK field 
	return $coltype;
}

sub checkbookinfo {
	my $book = shift;
	my($filename, $path, $suffix) = fileparse($book);
	print "Book label : \t",$book->get_filename(),"\n";
	my @sheets = $book->worksheets();
	
	if ($book->worksheet_count() != 1 ) {
		die("nb of sheets <> 1\n");
	}
	
	else {
		my $nbemptycells = 0;
		foreach my $worksheet ( $book->worksheets() ) {
		my $year = $worksheet->get_name();
		print "Book year : \t",$worksheet->get_name(),"\n";
			my ($min_row, $max_row) = $worksheet->row_range();
			my ($min_col, $max_col) = $worksheet->col_range();
			print "Min row: ",$min_row,"\t Max row: ",$max_row,"\n";
			print "Min col: ",$min_col,"\t Max col: ",$max_col,"\n";
			foreach my $row ($min_row .. $max_row) {
				if ($max_col != getnbcolrequired($table)) {
					print $row,"| Error col number for Row |\t",$max_col,"/",getnbcolrequired($table),"\n";
				}
				else {
					print $row,"| OK col number for Row |\t",$max_col,"/",getnbcolrequired($table),"\n";
				}
				foreach my $col ( $min_col .. $max_col ) {
					my $date;
					my $cell = $worksheet->get_cell($row, $col);
					# LET'S MAKE CHECKS
					if ( getcoltyperequired($table,$col) eq 'date' ) {
						my $val = $cell->value();
						if ( $val =~ /^(\d{2})\.(\d{2})$/ ) {
							$date = $year."-".$2."-".$1;
							print $row,"\t",$col,"\t","| Error in date for Row |\t",$date,"\n";
						}
						else {
							print $row,"\t",$col,"\t","| OK date for Row |\t",$cell->value(),"\n";
						}
					}		
					if ( defined($cell) && ($cell->value() eq '') ) {
						$nbemptycells++;
#						print $worksheet->get_name()," :\t(",$row, "\t",$col,")\t:",$cell->value(),"\n";
					};
				}
			}
		}
		print "Nb of empty cells : \t",$nbemptycells,"\n";
	}
}


$input = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012.xls";

# add check of xls file version must be 

my $parser	= Spreadsheet::ParseExcel->new();
$book		= $parser->parse($input);

if ( !defined $book ) {
	die "Got error code ", $parser->error_code, ".\n";
}
checkbookinfo($book);
gettableinfo($table);

=begin comment



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

=end comment
=cut