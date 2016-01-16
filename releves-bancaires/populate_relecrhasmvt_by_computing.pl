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


my @relecr = $schema->resultset('Relecr')->search({})->all();

#print Dumper(@relecr);



foreach my $_relecr ( @relecr ) {

#=begin comment
#	my $found = $schema->resultset('Mouvement')->find(
#			{
#				mvt_lib 	=> $_relecr->{ecr_lib},
#				mvt_date  	=> $_relecr->{ecr_date},
#			});
	my $rs_foundmvt = $schema->resultset('Mouvement')->search(
			{
				mvt_lib 		=> $_relecr->ecr_lib(),
				mvt_date  		=> $_relecr->ecr_date(),
				mvt_amount		=> $_relecr->ecr_amount(),
				mvt_deborcred	=> $_relecr->ecr_deborcred(),
			});		
#	print "Found : ",$rs_foundmvt->count(),"\n";  		
	if ( $rs_foundmvt->count() == 1 ) {
#		print "Adding : ",$_relecr->ecr_no(),"\n"; 
		my $mvt_found = $rs_foundmvt->single;	 
#		print Dumper($rs_foundmvt->single);
#		print "\t Values : ", $mvt_found->mvt_id,"\t",$mvt_found->mvt_no,"\n";
#		my $hasmvt = $schema->resultset('Relecrhasmvt')->create({
#					relecrhmvt_ecrno	=> $_relecr->ecr_no(),
#					relecrhmvt_mvtid	=> $mvt_found->mvt_id,
#					relecrhmvt_mvtno	=> $mvt_found->mvt_no});
					
		my $hasmvt = $schema->resultset('Relecrhasmvt')->find_or_new({
					relecrhmvt_ecrno	=> $_relecr->ecr_no(),
					relecrhmvt_mvtid	=> $mvt_found->mvt_id,
					relecrhmvt_mvtno	=> $mvt_found->mvt_no});			
		if( !$hasmvt->in_storage ) {
			$hasmvt->insert;
		}
	}
	elsif ( $rs_foundmvt->count() > 1 ) {
		while (my $mvt_found = $rs_foundmvt->next) {;	 
#		print Dumper($rs_foundmvt->single);
#		print "\t Values : ", $mvt_found->mvt_id,"\t",$mvt_found->mvt_no,"\n";
#		my $hasmvt = $schema->resultset('Relecrhasmvt')->create({
#					relecrhmvt_ecrno	=> $_relecr->ecr_no(),
#					relecrhmvt_mvtid	=> $mvt_found->mvt_id,
#					relecrhmvt_mvtno	=> $mvt_found->mvt_no});
					
			my $hasmvt = $schema->resultset('Relecrhasmvt')->find_or_new({
					relecrhmvt_ecrno	=> $_relecr->ecr_no(),
					relecrhmvt_mvtid	=> $mvt_found->mvt_id,
					relecrhmvt_mvtno	=> $mvt_found->mvt_no});			
			if( !$hasmvt->in_storage ) {
				$hasmvt->insert;
			}
		}
	}	
	else {	
		print $_relecr->ecr_no(),"\n";
	}
#=end comment
#=cut 
}
# checking results

my $nb_mvt 		= $schema->resultset('Mouvement')->search({});
my $nb_relecr 	= $schema->resultset('Relecr')->search({});
my $nb_hasmvt 	= $schema->resultset('Relecrhasmvt')->search({});

#my $status;
#if (($nb_mvt = $nb_hasmvt) && ($nb_mvt = $nb_relecr)) { my $status = 1; } else { $status = 0;}
 
print "RESULT : \t",$nb_mvt->count(),"|" ,$nb_relecr->count(),"|",$nb_relecr->count(),"/ NB MVT | NB RELECR | NB HASMVT\n";  

