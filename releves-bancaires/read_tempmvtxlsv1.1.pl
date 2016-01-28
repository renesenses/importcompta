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


my $output_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012-OUT.xls";


my $col;
my $row;
my $date;
my $year;

my $table = 'Mvtxl';

my $line = 0;
my %OUTPUT_XLS;

# Struct


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
		my $constraint_status 	= 0;
		my $checkexo_status 	= 0;
		my $cell_status			= 0;
		# NB COLUMS CHECK
		# EMPTY LINE CHECK
		if (checkemptyline($worksheet,$row)) {
		# WE DO NOTHING WE DONT CARE OF THIS ROW
		}
		else {	
			$line++;
			foreach $col ( $min_col .. $max_col ) {
				print "\t ROW : ",$row,"\t COL : ",$col,"\t";
				my $cell_type = getcoltyperequired($table,$col);
				my $cell = $worksheet->get_cell($row, $col);
				$OUTPUT_XLS{$line}{$col}->{type} = $cell_type;
				if ( !(defined($cell)) ) {
					$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
					if ($cell_type eq 'numeric') {$OUTPUT_XLS{$line}{$col}->{value} = 0 } else {$OUTPUT_XLS{$line}{$col}->{value} = ''};
					$OUTPUT_XLS{$line}{$col}->{comment} = 'UNDEF CELL';
				}
				else {
					$cell_status = checkcell($worksheet,$row, $col);
				}	
			}
			# CONSTRAINT ON AMOUNT CHECK
			# IF ERR TWO CELLS IN RED
			if ( checkamountline($worksheet,$row) ){
				$OUTPUT_XLS{$line}{4}->{status} = 'ERR';	
				$OUTPUT_XLS{$line}{4}->{comment} = 'DEB CRED CONSTRAINT ERROR';
				$OUTPUT_XLS{$line}{5}->{status} = 'ERR';	
				$OUTPUT_XLS{$line}{5}->{comment} = 'DEB CRED CONSTRAINT ERROR';
			};
			# CONSTRAINT ON EXO CHECK
			# IF ERR EXO CELL IN RED
			if ( checkexoline($worksheet,$row) ) {
				$OUTPUT_XLS{$line}{3}->{status} = 'ERR';	
				$OUTPUT_XLS{$line}{3}->{comment} = 'EXO VALUE ERROR';
			};
		}	
			
	}
	# FINAL CHECK SHEET
}			

# ADD THE UNDEF CHECK BEFORE $val 
sub checkcell {
	my $worksheet	= $_[0];
	my $row			= $_[1];
	my $col 		= $_[2];			
	my $cell 		= $worksheet->get_cell($row, $col);
	my $val 		= $cell->value();
	my $status 		= 0;
	my $type = getcoltyperequired($table,$col);
	# DATE
	if ( $type eq 'date' ) {
		if ( $val =~ /^(\d{2})\.(\d{2})$/ ) {
			$date = $year."-".$2."-".$1;		
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $date;
			print " OK_DATE for Row |\t",$date,"\n";
		}
		else {
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'ERR_DATE';
			print " ERR_DATE for Row |\t",$val,"\n";
			$status = 1;
		}
	}	
	# TEXT	
	elsif ( $type  eq 'text' ) {
		if ( !(defined $cell) ) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'UNDEF TEXT';
			print " ERR_TXT for Row |\t",$val,"\n";
			$status = 1;
		}	
		else {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			print " OK_TXT for Row |\t",$val,"\n";
		}
	}
	elsif ( $type  eq 'numeric' ) {
		if ( looks_like_number($val) ) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			print " OK_NUM for Row |\t",$val,"\n";
		}
		elsif ($val eq '') {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = 0;
			print " OK_NUM for Row |\t",$val,"\n";
		}
		else {
		# CONVERT TO NUMERIC(9,2) TO ADD 
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'WRONG NUMERIC FORMAT MAYBE A DOT IS PRESENT';
			print " ERR_NUM for Row |\t",$val,"\n";
			$status = 1;
		}			
	}
	else {
		# Not a field type for this table : DO NOTHING
		$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
		$OUTPUT_XLS{$line}{$col}->{value} = $val;
		$OUTPUT_XLS{$line}{$col}->{comment} = 'UNRECOGNIZED TYPE';
		$status = 1;
	}
	return $status;
}

sub checkemptyline {
	my $worksheet			= $_[0];
	my $row					= $_[1];
	my $emptyline_status 	= 0;	
	
	for my $col (0..getnbcolrequired($table)) {
		my $cell 		= $worksheet->get_cell($row, $col);
		if ( !defined($cell) ) {
			$emptyline_status 	= 1;
			last;
		}
	}
	return $emptyline_status;
}

sub checkamountline {
	my $worksheet			= $_[0];
	my $row					= $_[1];
	my $amount_deb = $OUTPUT_XLS{$line}{4}->{value};
	my $amount_cred = $OUTPUT_XLS{$line}{5}->{value};
	if ( ($amount_deb + $amount_cred != 0) && ($amount_deb * $amount_cred == 0) ) {
		return 0;
	}
	else {
		return 1;
	}
}	

sub checkexoline {
	my $worksheet			= $_[0];
	my $row					= $_[1];
	my $exo = $OUTPUT_XLS{$line}{3}->{value};
	if ( ($exo eq '')||($exo eq 'X') ){	
		return 0;
	}
	else {
		return 1;
	}	
}

# THE WRITE METHOD WILL WRITE THE OUTPUTHASH
# First line is the columns names
# EACH CELL in ERROR has a red background (care of constraint with 2 RED cells)
# EACH CELL IN ERROR MUST HAVE a COMMENT WITH THE ERROR MESSAGE

# COLUMN 1 FORMAT : center with DATE YYYY-MM-DD
# COLUMN 2 FORMAT : left 
# COLUMN 3 FORMAT : center with DATE YYYY-MM-DD 
# COLUMN 4 FORMAT : center
# COLUMN 5 FORMAT : right numeric ###.###,##
# COLUMN 6 FORMAT : right numeric ###.###,##

#
# $worksheet->write_comment(2, 2, 'This is a comment.');




# set_bg_color('red')

sub writexls {
#	print Dumper(%OUTPUT_XLS);
	my $writebook = shift;
	my $writesheet = $writebook->add_worksheet($table);
	my $date_format 	= $writebook->add_format(num_format => 'yyyy-mm-dd');
	my $num_format 		= $writebook->add_format(num_format => '#.##0,00');
#	my $text_format 	= $writebook->add_format(num_format => '#.##0,00');


	# $line = 0 : column names
	my $format;
	my $source 			= $schema->source($table);
	my @table_fields 	= $source->columns;
	foreach my $col (0 ..getnbcolrequired($table)) {
		$writesheet->write_string(0, $col, $table_fields[$col]);
	}

	foreach my $row (keys %OUTPUT_XLS) {
		foreach my $col (0 ..getnbcolrequired($table)) {			
			# FORMATTING CELL
			if ( $OUTPUT_XLS{$row}{$col}->{type} eq 'numeric' ) { $format = $num_format;}
			elsif ( $OUTPUT_XLS{$row}{$col}->{type} eq 'date' ) { $format = $date_format;}
			else {};

			if ( $OUTPUT_XLS{$row}{$col}->{status} eq 'ERR' ) {$format->set_bg_color('red');} else {$format->set_bg_color('green');}
			
			# WRITING
			$writesheet->write($row,$col,$OUTPUT_XLS{$row}{$col}->{value},$format);
			if ( defined($OUTPUT_XLS{$row}{$col}->{comment}) ) {$writesheet->write_comment($row, $col,$OUTPUT_XLS{$row}{$col}->{comment});}
		}	
 	}
}


# add check of xls file version must be 

my $parser	= Spreadsheet::ParseExcel->new();
$book		= $parser->parse($input_xls);

if ( !defined $book ) {
	die "Got error code ", $parser->error_code, ".\n";
}
checkbookinfo($book);
checksheet($book->worksheets()); # ARRAY CONTAINS O?NLY ONE SHEET
gettableinfo($table);
my $writebook = Spreadsheet::WriteExcel->new($output_xls);

writexls($writebook);

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