#! /usr/bin/env perl

# Usage : perl -w import-compta.pl excel-filename [sheet-name]
use Spreadsheet::ParseExcel::Simple;
#use Spreadsheet::ParseExcel;
#use Spreadsheet::WriteExcel
use File::Basename;
use Data::Dumper;
use strict;

my @inputs;
my $spreadsheet;
my $book;

# SUBS

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

#my $parser   = Spreadsheet::ParseExcel->new();
#my $workbook = $parser->parse($spreadsheet);

$book = Spreadsheet::ParseExcel::Simple->read($spreadsheet);

#print Dumper($book);
my @sheets = $book->sheets;

print "Nb of sheets : \t",$#sheets,"\n";
		
foreach my $sheet ( @sheets ) {
	print "Dump of sheet :",$sheet,"\t",Dumper($sheet),"\n";
}
#print_book_summary($book, $spreadsheet);
#print_sheet($book,'RELEVES BANCAIRES HSBC')
