#! /usr/bin/env perl

# 

use Spreadsheet::ParseExcel;

use strict;
use warnings;
use Data::Dumper;
use Releve::Schema;
use File::Basename;
#use List::Collection; # IT WOKS BUT NOTREQUIRED IN THE FOLLOWING


Releve::Schema->load_namespaces;

my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});

my $nb_mvt;
my $nb_ecr;
my $nb_missmvt;
my $nb_missecr;

my @missing_mvtno;
my @missing_ecrno;

# WRONG 
#while ( my $hasmvt = $rs_hasmvt->next ) {
#	print $hasmvt->relecrhmvt_mvtno;
#	push @mvtno_has, $hasmvt->relecrhmvt_mvtno();
#
#}
# RETUNR FULL HASH NOT VALUES : $rec->relecrhmvt_ecrno idem for $rec->relecrhmvt_ecrno() idem for : $rec->{relecrhmvt_mvtno}
#my $nb = 0;

my $rs_hasmvt = $schema->resultset('Relecrhasmvt')->search({});
#while (my $rec = $rs_hasmvt->next) {
#	push	@mvtno_has,$rec->get_column('relecrhmvt_mvtno');
#	push 	@ecrno_has,$rec->get_column('relecrhmvt_ecrno');
#}

my $rs_mvt = $schema->resultset('Mouvement')->search({});
$nb_mvt = $rs_mvt->count();	

# THE FOLLOWING WORKS :
my $rs_missingmvt = $rs_mvt->search({
	mvt_no => { -not_in => $rs_hasmvt->get_column('relecrhmvt_mvtno')->as_query },
});

while (my $mis = $rs_missingmvt->next){
	push @missing_mvtno, $mis->get_column('mvt_no');
}
$nb_missmvt = $rs_missingmvt->count();
# Available mvtno with -in
print "Nb missing mvt : ",$nb_missmvt,"\n";
print "Missing mvtno : ",join(", ",@missing_mvtno),"\n";

my $rs_ecr = $schema->resultset('Relecr')->search({});	
$nb_ecr = $rs_ecr->count();		
my $rs_missingecr = $rs_ecr->search({
	ecr_no => { -not_in => $rs_hasmvt->get_column('relecrhmvt_ecrno')->as_query },
});



while (my $mis = $rs_missingecr->next){
	push @missing_ecrno, $mis->get_column('ecr_no');
}
$nb_missecr = $rs_missingecr->count();
print "Nb missing ecr : ",$nb_missecr,"\n";
# Available mvtno with -in
print "Missing ecrno : ",join(", ",@missing_ecrno),"\n";





# works but unused
#my $rs_mvt_pk = $rs_mvt->hashref_pk;
#foreach my $mvt_pk ( sort (keys { %{ $rs_mvt_pk} }) ) {
#	push @mvtno, $rs_mvt_pk->{$mvt_pk}->{mvt_no};
#}


# works but unused



# works but unused
# my $rs_ecr_pk = $rs_ecr->hashref_pk;
#foreach my $ecr_pk ( sort (keys { %{ $rs_ecr_pk} }) ) {
#	push @ecrno, $rs_ecr_pk->{$ecr_pk}->{ecr_no};
#}

print "CHECK  NB ECR | NB MVT : ", $nb_ecr,"\t |",$nb_mvt,"\n";
