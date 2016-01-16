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

sub getbookinfo {
	my $book = shift;
	return $worksheet->get_name();
}

sub getcolumnnames {
	my $book = shift;
	my $sheet = shift;
	
	my @columns_names;
	
	my ($min_row, $max_row) = $sheet->row_range();
	my ($min_col, $max_col) = $sheet->col_range();
	foreach my $col ($min_col .. $max_col ) {
		my $cell = $sheet->get_cell(0, $col);
#		print $col,"\t",$cell->value(),"\n"; 
		if ( $cell->value() ne '' ) {
			push @columns_names, $cell->value();
		}
	}	
	print join(",",@columns_names),"\n";	
	return @columns_names;
}

# OK

sub getcolumnsid {
	my $book = shift;
	my $sheet = shift;
	
	my @columns_names;
	
	my ($min_row, $max_row) = $sheet->row_range();
	my ($min_col, $max_col) = $sheet->col_range();
	foreach my $col ($min_col .. $max_col ) {
		my $cell = $sheet->get_cell(0, $col);
		push @columns_id, $cell->value();
		}
	}	
	return @columns_id;
}

sub gettableid {
	my $sheet = shift;
	return $worksheet->get_name();
}

# Compute status of given sheet in db
# use of schema

sub isadbtable {
	my $tableid ;
	my @columnsid ;
	
	
}
}

sub gettableidbyname {
	my $table_name = shift;
	my $table_id;
	my $col_id;
#OK		my $table = $schema->resultset('Display')->find($table_name);
#OK		my $table = $schema->resultset('Display')->find( {display_id => $table_name, display_lang => 'FR' } );
#OK		print "NB TABLE ID FOUND : ",$table->display_id,"\t",$table->display_lang,"\t",$table->display_value,"\n";
		
		my $rs_table = $schema->resultset('Display')->search( { display_value => $table_name } )->hashref_pk;
		
#		my $nb_table_results = $rs_table->count();
#		print $nb_table_results,"\n";
		foreach my $row ( keys %{ $rs_table } ) {
#			$table_id = $row->{display_id};
				print $row,"\n";
				
				print "\t",${ $rs_table}{$row}->{display_value};
				print "\t",${ $rs_table}{$row}->{display_lang},"\n";
#			print "TABLE_ID trouvée : ",$table_id,"\n"; 
		}
}

sub checktableidbyname {
	my $table_name = shift;
	
	my $rs_table = $schema->resultset('Display')->search( { display_value => $table_name } )->hashref_pk;
	my @results = keys %{ $rs_table }
	if ($#results == 1) {
		return ${ $rs_table}{$row}->{display_id};
	} else {
		return 0;
	}
}


sub getfieldidbyname {
	my $table_name = shift;
	my $col_name = shift;
	my $table_id;
	my $col_id;
	my $rs_table_id = $schema->resultset('Display')->find( {DISPLAY_VALUE => $table_name, DISPLAY_LANG => 'FR' } );
	print "NB TABLE ID FOUND : ",$rs_table_id->count,"\n";

#	if ( $rs_table_id->count == 1 ) {
#		print Dumper $rs_table_id;	
#		$table_id = $rs_table_id->{DISPLAY_ID};
#		print "TABLE_ID trouvée : ",$table_id,"\n"; 
#	} elsif ( $rs_table_id->count == O ) {
#		 print "Erreur : Aucune table correspondante trouvée !\n";
#	} else {
#		print "Erreur : Plusieurs tables en correspondances trouvées !\n";
#	}
	
#	my $rs_col_id = $schema->resultset('Display')->search( {'DISPLAY_ID' => $col_name} );
#	print print "NB COL ID FOUND : ",$rs_col_id->count,"\n";
	
=begin comment	
	
	if ( $rs_col_id->count == 1 ) {
		print Dumper $rs_col_id;	
#		$col_id = $rs_col_id->{DISPLAY_ID};
#		print "COL_ID trouvée : ",$col_id,"\n"; 
	} elsif ( $rs_col_id->count == O ) {
		return "Erreur : Aucun champ en correspondance trouvé !\n";
	} else {
		# Plusieurs résultats on prend celui dont la valeur correspond à $table_id
		for my $col ($rs_col_id->next ) {
			if ($col->{DISPLAY_ID} =~ /^($table_id)_/ ) {
				$col_id = $col->{DISPLAY_ID};
				print "COL_ID trouvé : ",$col_id,"\n"; 
				last;
			}
			else {
				print "Erreur : Aucun champ parmi les correspondances trouvées !\n";
			}
		}
	}


=end comment
=cut 
}


sub print_book_summary {
		my $refbook = shift;
		my $bookname = shift;
		
		my($filename, $path, $suffix) = fileparse($bookname);
		
		print "Book label : \t",$filename,"\n";
		
		my @sheets = $refbook->sheets;
		
		print "Nb of sheets : \t",$#sheets,"\n";
		
		foreach my $sheet ( @sheets ) {
			print "Dump of $sheet : \t", Dumper($sheet),"\n";
#			print "Nb of row : \t\t", $refbook->[$sheet]->{maxrow},"\n";
#			print "Nb of col : \t\t", $refbook->[$sheet]->{maxcol},"\n";
#	    	print "Empty cells : \t\t",compute_empty_cells($refbook,$sheet),"\n";
		}
}

sub print_sheet {
	my $refbook = shift;
	my $sheet = shift;

	print $refbook->[$sheet]->{label},"\n";
 	foreach my $row (3 .. $refbook->[$sheet]->{maxrow}) {
     	foreach my $col (1 .. $refbook->[$sheet]->{maxcol}) {
        	my $cell = cr2cell ($col, $row);
#OK         		printf "%-5s",$cell;
        	printf "%-10s",$refbook->[$sheet]->{$cell};
#        	printf "%s %s %s  ", $cell, $refbook->[$sheet]->{$cell}[$row][$col];
#            $book->[$sheet]->{attr}[$col][$row]{merged};
         }
		print "\n";
    }
    print "============================================================================\n";
}


for my $arg (0 .. $#ARGV) {
	print "ARG_NO : ", $arg,"\t","ARG_VALUE : ",$ARGV[$arg],"\n";
#	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
	push @inputs, $ARGV[$arg];
}
	
if (-e $inputs[0]) {$spreadsheet = $inputs[0]};

print "SPREADSHEET : ",$spreadsheet,"\n";

#$book = ReadData($spreadsheet, attr => "0", dtfmt => "yyyy-mm-dd");

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($spreadsheet);

#$book = Spreadsheet::ParseExcel::Simple->read($spreadsheet);

#print Dumper($workbook);
# NAME OF SHEET

	getbookinfo();
	for my $worksheet ( $workbook->worksheets() ) {
	


	my @cols = getcolumnnames($workbook,$worksheet);
	print "NAMES : ",getcolumnnames($workbook,$worksheet),"\n";
	
	my $tablename = $worksheet->get_name();
	print "LOOKING FOR ",$tablename, " : ";
	gettableidbyname($tablename);

#	foreach my $colname ( @cols ) {
#		print "LOOKING FOR ",$colname, " : ";
#		getfieldidbyname($worksheet,$colname);
#	print "\n";
}

# COLUMNS 'NAME



#print_book_summary($book, $spreadsheet);
#print_sheet($book,'RELEVES BANCAIRES HSBC')
