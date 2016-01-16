#! /usr/bin/env perl

# Usage : perl -w import-compta.pl excel-filename [sheet-name]

use Spreadsheet::ParseExcel;
#use Spreadsheet::WriteExcel
use Piecescomptables::Schema;
use File::Basename;
use Data::Dumper;
#use strict;

my @inputs;
my $spreadsheet;
my $book;

my $schema = Pieces::Schema->connect('dbi:SQLite:pieces-comptables.db', '', '',{ sqlite_unicode => 1});

$schema->load_namespaces();
Pieces::Schema->load_classes();
my @source_names= Pieces::Schema->sources;

#print Dumper($schema);

my $source_banquemvt = $schema->source('banquemvt');

print Dumper($schema_banquemvt);

for my $source (@source_names) {
	print $source;
}