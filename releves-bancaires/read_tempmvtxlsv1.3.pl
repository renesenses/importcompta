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
use Sort::Naturally;

#Releve::Schema->load_namespaces;


my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});

my @inputs;
my $spreadsheet;
my $book;

my $input_xls;

#$input_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2013-MOD.xls"; # OK 
#$input_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012.xls";
$input_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012-MOD2.xls";

#my $output_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2013-LAST.xls";
#my $output_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012-MOD1.xls";
my $output_xls = "/Users/bertrand/MY_GITHUB/importcompta/releves-bancaires/SCANS/2_OCR/2016-01-27_REL-HSBC-2012-LAST.xls";

my $col;
my $row;
my $date;
my $year;

my $table = 'Mvtxl';
my $header = 0;

my $line;
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

# Check if first row from row range is an header row (column names)
# And return 1 for true or 0 false 
sub hasheader {
	my $worksheet		= $_[0];
	my $table_id 		= $_[1];
	my $source 			= $schema->source($table);
	my @table_fields 	= $source->columns;
	# we dont use the PK field 
	shift(@table_fields);
	my ($min_row, $max_row) = $worksheet->row_range();
	my ($min_col, $max_col) = $worksheet->col_range();
	my @columns;
	foreach my $col ( $min_col .. $max_col ) {
		my $cell = $worksheet->get_cell($min_row, $col);
		push @columns, $cell->value();
	}	
	print join(",",@table_fields),"\n";
	print join(",",@columns),"\n";
	if ( (join(",",@table_fields)) eq (join(",",@columns)) ) {
		#print "schema ok \n";
		return 1;
	}
	else {
		return 0;
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
#	print "TABLE : ",$table_id;
	my $fieldno	 = $_[1];
#	print "\tFIELD NO : ",$fieldno,"\t";
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
	# We care if fist row of row range is an header
	$min_row = $min_row + $header;
	print "Min row: ",$min_row,"\t Max row: ",$max_row,"\n";
	print "Min col: ",$min_col,"\t Max col: ",$max_col,"\n";
	$line = 1;
	foreach $row ($min_row .. $max_row) {
		print "ROW : ",$row,"\t"; 
		my $constraint_status 	= 0;
		my $checkexo_status 	= 0;
		my $cell_status			= 0;
		# NB COLUMS CHECK
		# EMPTY LINE CHECK
#		if ( checkemptyline($worksheet,$row) == 0 ) {
		if ( checkemptyline($worksheet,$row) == 0 || checknearemptyline($worksheet,$row) == 0 ) {
		# WE DO NOTHING WE DONT CARE OF THIS ROW
			print "Removed.\n"; 
			$row++;
		}
		else {	
			foreach $col ( $min_col .. $max_col ) {
				print "\tCOL : ",$col,"\t";
				my $cell_type = getcoltyperequired($table,$col);
				my $cell = $worksheet->get_cell($row, $col);
				$OUTPUT_XLS{$line}{$col}->{type} = $cell_type;
				if ( !(defined($cell)) ) {
					$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
					if ($cell_type eq 'numeric') {$OUTPUT_XLS{$line}{$col}->{value} = 0 } else {$OUTPUT_XLS{$line}{$col}->{value} = ''};
					$OUTPUT_XLS{$line}{$col}->{comment} = 'UNDEF CELL';
				}
				else {
					$cell_status = checkcell($worksheet,$row,$col);
				}	
			}
			# CONSTRAINT ON AMOUNT CHECK
			# TODO ONLY IF NO ERROR IN NUMERIC FORMAT
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
			# CONSTRAINT CHECK NEAR EMPTY LINE
			# IF ERR EXO CELL IN RED
			if ( checkexoline($worksheet,$row) ) {
				$OUTPUT_XLS{$line}{3}->{status} = 'ERR';	
				$OUTPUT_XLS{$line}{3}->{comment} = 'EXO VALUE ERROR';
			};
			print "\n";
			$line++;
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
		if ( $val =~ /^(\d{2})[,\.](\d{2})$/ ) {
			$date = $year."-".$2."-".$1;		
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $date;
#			print " OK_DATE for Row |\t",$date,"\n";
		}
		elsif ( $val =~ /^\d{4}-\d{2}-\d{2}$/ ) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
#			print " OK_DATE for Row |\t",$val,"\n";
		}
		elsif ( $val eq ''){
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'EMPTY_DATE';
#			print " ERR_DATE for Row |\t",$val,"\n";
			$status = 1;
		}
		else {
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'ERR_DATE';
#			print " ERR_DATE for Row |\t",$val,"\n";
			$status = 1;
		}
	}	
	# TEXT	
	elsif ( $type  eq 'text' ) {
		if ( !(defined $cell) ) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'UNDEF TEXT';
#			print " ERR_TXT for Row |\t",$val,"\n";
			$status = 1;
		}	
		else {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
#			print " OK_TXT for Row |\t",$val,"\n";
		}
	}
	elsif ( $type  eq 'numeric' ) {
		if ( looks_like_number($val) ) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
#			print "ROW: ",$row,"\tCOL: ",$col, "\tMONTANT: ",$OUTPUT_XLS{$line}{$col}->{value},"\n";
#			print " OK_NUM for Row |\t",$val,"\n";
		}
		elsif ($val eq '') {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = 0;
#			print " OK_NUM for Row |\t",$val,"\n";
		}
		elsif ($val =~ /^(\d+)[\,\.](\d{3}([\.\,]\d{0,2})?)$/) {
			$OUTPUT_XLS{$line}{$col}->{status} = 'OK';	
			$OUTPUT_XLS{$line}{$col}->{value} = $1*1000+$2;
#			print "ROW: ",$row,"\tCOL: ",$col, "\tMONTANT: ",$OUTPUT_XLS{$line}{$col}->{value},"\n";
#			print " OK_NUM for Row |\t",$val,"\n";
		}
		else {
		# CONVERT TO NUMERIC(9,2) TO ADD 
			$OUTPUT_XLS{$line}{$col}->{status} = 'ERR';	
			$OUTPUT_XLS{$line}{$col}->{value} = $val;
			$OUTPUT_XLS{$line}{$col}->{comment} = 'WRONG NUMERIC FORMAT MAYBE A DOT IS PRESENT';
#			print "ROW: ",$row,"\tCOL: ",$col, "\tMONTANT: ",$OUTPUT_XLS{$line}{$col}->{value},"\n";
#			print " ERR_NUM for Row |\t",$val,"\n";
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

# empty line if status = 0
sub checkemptyline {
	my $worksheet			= $_[0];
	my $row					= $_[1];
	my $emptyline_status 	= 0;	
	
	for my $col (0..getnbcolrequired($table)) {
		my $cell 		= $worksheet->get_cell($row, $col);
		if ( defined($cell) ) {
			$emptyline_status 	= 1;
			last;
		}
	}
	return $emptyline_status;
}

# near empty line if status = 0
sub checknearemptyline {
	my $worksheet			= $_[0];
	my $row					= $_[1];
	my $emptyline_status 	= 0;	
	
	for my $col (0..getnbcolrequired($table)) {
		my $type = getcoltyperequired($table,$col);
		my $cell = $worksheet->get_cell($row, $col);
		
		if ( defined($cell) ) {
			if ( ($cell->value() ne '') || (($type eq 'numeric') && ($cell->value() != 0)) ){
				$emptyline_status 	= 1;
				last;
			}
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

sub printkeys() {
	foreach my $row (nsort (keys %OUTPUT_XLS)) {
		print $row,"\n";
	}
}		

sub writexls {
#	print Dumper(%OUTPUT_XLS);
#	printkeys(); 
	my $writebook = shift;
	my $writesheet 		= $writebook->add_worksheet($table);
	$writesheet->set_column(0,0, 20);
	$writesheet->set_column(1,1, 180);
	$writesheet->set_column(2,6, 20);
	# DEFINING CELL FORMATS
	my %font	= (
					font  => 'Arial',
					size  => 12,
	);
	
	
	my $field_format 	= $writebook->add_format(%font, bold => 1, color => 'white', bg_color => 'orange');
	$field_format->set_align('center');
	$field_format->set_border();
	my $date_format 	= $writebook->add_format(num_format => 'yyyy-mm-dd', %font);
	$date_format->set_align('center');
	$date_format->set_border();
	my $num_format 		= $writebook->add_format(num_format => 'General', %font);
	$num_format->set_align('right');
	$num_format->set_border();
	my $default_format	= $writebook->add_format(%font,bold => 0, color => 'black', bg_color => 'white');
	$default_format->set_border();
	my $error_format 	= $writebook->add_format(%font, color => 'white', bold => 1, bg_color => 'red');
	$error_format->set_border();
	my $exo_format	= $writebook->add_format(%font,bold => 0, color => 'black', bg_color => 'white');
	$exo_format->set_align('center');
	$exo_format->set_border();

	# WE WRITE HEADERS
	my $format = $field_format;
	my $source 			= $schema->source($table);
	my @table_fields 	= $source->columns;
	# NO PK
	shift(@table_fields);
	foreach my $col (0 ..getnbcolrequired($table)) {
		$writesheet->write_string(0, $col, $table_fields[$col], $format);
	}

	foreach my $row (keys %OUTPUT_XLS) {
		foreach my $col (0 ..getnbcolrequired($table)) {			
			# FORMATTING CELL
			if ( $OUTPUT_XLS{$row}{$col}->{status} eq 'ERR' ) {$format = $error_format;
			}
			elsif ( $OUTPUT_XLS{$row}{$col}->{type} eq 'numeric' ) { 
				$format = $num_format;
			}
			elsif ( $OUTPUT_XLS{$row}{$col}->{type} eq 'date' ) {
				$format = $date_format;
			}
			else {
				$format = $default_format;
			}
			
			# WRITING
			$writesheet->write($row,$col,$OUTPUT_XLS{$row}{$col}->{value},$format);
			if ( defined($OUTPUT_XLS{$row}{$col}->{comment}) ) {$writesheet->write_comment($row, $col,$OUTPUT_XLS{$row}{$col}->{comment});
			}
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

$header = hasheader($book->worksheets(),$table);
print $header,"\n";
checksheet($book->worksheets()); # ARRAY CONTAINS ONLY ONE SHEET
gettableinfo($table);
my $writebook = Spreadsheet::WriteExcel->new($output_xls);

writexls($writebook);

