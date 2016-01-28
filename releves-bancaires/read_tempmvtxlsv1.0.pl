#! /usr/bin/env perl

# Usage : perl -w import-compta.pl excel-filename [sheet-name]

# Works as a basic template

use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;

use strict;
use warnings;
use Data::Dumper;
use Releve::Schema;
use File::Basename;
use Scalar::Util qw(looks_like_number);

#Releve::Schema->load_namespaces;


my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});

my @inputs;
my $spreadsheet;
my $book;

my $input_xls;
$input_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012.xls";

my $output_xls;
my $template;

my $col;
my $row;
my $date;
my $year;

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
	my $table_id = $_[0];
	print "TABLE : ",$table_id;
	my $fieldno	 = $_[1];
	print "\tFIELD NO : ",$fieldno,"\t";
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
}

sub checksheet {
	my $worksheet = shift;
	$year = $worksheet->get_name();
	print "Book year : \t",$worksheet->get_name(),"\n";
	my ($min_row, $max_row) = $worksheet->row_range();
	my ($min_col, $max_col) = $worksheet->col_range();
	print "Min row: ",$min_row,"\t Max row: ",$max_row,"\n";
	print "Min col: ",$min_col,"\t Max col: ",$max_col,"\n";
	foreach $row ($min_row .. $max_row) {
	
		my $line_status 		= 0;
		my $deleteline_status 	= 0;
		my $rejectline_status 	= 0;
		my $constraint_status 	= 0;
		my $checkexo_status 	= 0;
		my $cell_status			= 0;
		# NB COLUMS CHECK
			
		foreach $col ( $min_col .. $max_col ) {
			print "\t ROW : ",$row,"\t COL : ",$col,"\t"; 
		
#			my $cell = $worksheet->get_cell($row, $col);
			# CHECK CELL CONTENT

			$cell_status = checkcell($worksheet,$row, $col);
		}
		# CHECK LINE CONTENT	
	}
	# FINAL CHECK SHEET
}			

sub checkcell {
	my $worksheet	= $_[0];
	my $row			= $_[1];
	my $col 		= $_[2];			
	my $cell = $worksheet->get_cell($row, $col);
	my $val = $cell->value();
	my $status = 0;
	my $type = getcoltyperequired($table,$col);
	# DATE
	if ( $type eq 'date' ) {
		if ( $val =~ /^(\d{2})\.(\d{2})$/ ) {
			$date = $year."-".$2."-".$1;
			print " OK_DATE for Row |\t",$date,"\n";

		}
		else {
			print " ERR_DATE for Row |\t",$val,"\n";
			$status = 1;
		}
	}	
	# TEXT	
	elsif ( $type  eq 'text' ) {
		if ( !(defined $cell) ) {
			print " ERR_TXT for Row |\t",$val,"\n";
			$status = 1;
		}	
		else {
			print " OK_TXT for Row |\t",$val,"\n";
		}
		
	}
	elsif ( $type  eq 'numeric' ) {
		if ( !(defined $cell) ) {
#		if ( !(defined $cell) || $val eq '') ) {
			$val = 0;
			print " OK_NUM for Row |\t",$val,"\n";
		}
		elsif ( looks_like_number($val) ) {
			print " OK_NUM for Row |\t",$val,"\n";
		}
		elsif ($val eq '') {
			$val = 0;
			print " OK_NUM for Row |\t",$val,"\n";
		}
		else {
		# CONVERT TO NUMERIC(9,2) TO ADD 
			print " ERR_NUM for Row |\t",$val,"\n";
			$status = 1;
		}			
	}
	else {
				# Not a field type for this table : DO NOTHING
	}
	return $status;
}
		
=begin comment				
				# ADD FULL ROW CHECKS
				# CHECK CONSTRAIT ON AMOUNTS (MANUAL BECAUSE DONTKNOW
				my $amount_deb = $worksheet->get_cell($row,4)->value();
				my $amount_cred = $worksheet->get_cell($row,5)->value();
				my $exo = $worksheet->get_cell($row,3)->value();
				if ( ($amount_deb + $amount_cred != 0) && ($amount_deb * $amount_cred == 0) ) {
					$constraint_status = 0;
				}
				else {
					$constraint_status = 1;
				}
				# CHECK FOR mvtexo
				if ( ($exo eq '')||($exo eq 'X') ){	
					$checkexo_status = 0;
				}
				else {
					$checkexo_status = 1; 
				}	
				# FINAL CHECK
				if ( $rejectline_status * $constraint_status * $checkexo_status == 0 ) {
				# ERR
				}
				else {
				#OK
				}
=end comment
=cut


# add check of xls file version must be 

my $parser	= Spreadsheet::ParseExcel->new();
$book		= $parser->parse($input_xls);

if ( !defined $book ) {
	die "Got error code ", $parser->error_code, ".\n";
}
checkbookinfo($book);
checksheet($book->worksheets()); # ARRAY CONTAINS O?NLY ONE SHEET
gettableinfo($table);

=begin comment
# THIS SUB WRITES THE RESULTING OUTPUT XLS WITH LIN?E STATUS AND FIRST CAUSE OF REJECT
# EMPTY LINES ARE DELETED 
writeoutput() {

my $outbook = Spreadsheet::WriteExcel->new('perl.xls');
 
# Add a worksheet
$worksheet = $workbook->add_worksheet();
 
#  Add and define a format
$format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_color('red');
$format->set_align('center');
 
# Write a formatted and unformatted string, row and column notation.
$col = $row = 0;
$worksheet->write($row, $col, 'Hi Excel!', $format);
};

# THIS SUB TRY POPULATING Mvtxl table
populatemvtxls() {
};





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