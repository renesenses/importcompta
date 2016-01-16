#! /usr/bin/env perl

SELECT 


use Spreadsheet::ParseExcel;
#use Spreadsheet::WriteExcel

use strict;
use warnings;
use Data::Dumper;
use Releve::Schema;
use File::Basename;

Releve::Schema->load_namespaces;


my $schema = Releve::Schema->connect('dbi:SQLite:relevebanque.db', '', '',{ sqlite_unicode => 1});


#my $rs_ecr = $schema->resultset('Relecr')->search({ ecr_source => 'RELEVE BANCAIRE HSBC' });
my $rs_ecr = $schema->resultset('Relecr')->search({});
my $nb_ecr = $rs_ecr->count();

my $rs_mvt = $schema->resultset('Mouvement')->search({});
=begin comment
my $rs_found = $rs_mvt->search({
				mvt_lib 		=> { '=' => $rs_ecr->get_column('ecr_lib')->as_query },
				mvt_date  		=> { '=' => $rs_ecr->get_column('ecr_date')->as_query },
				mvt_amount  	=> { '=' => $rs_ecr->get_column('ecr_amount')->as_query },
				mvt_deborcred 	=> { '=' => $rs_ecr->get_column('ecr_deborcred')->as_query },
});	
=end comment
=cut
my $nb_ok;
foreach (my $ecr = $rs_ecr->next){
	my $rs_found = $rs_mvt->search({
				mvt_lib 		=> { '=' => $rs_ecr->get_column('ecr_lib')->as_query },
#				mvt_date  		=> { '=' => $rs_ecr->get_column('ecr_date')->as_query },
#				mvt_amount  	=> { '=' => $rs_ecr->get_column('ecr_amount')->as_query },
#				mvt_deborcred 	=> { '=' => $rs_ecr->get_column('ecr_deborcred')->as_query },
	});
	
	print $rs_found ->count(),"\n";
	if ($rs_found->count() ==1) { $nb_ok++;}
}
			
print $nb_ok;
	
if ( $nb_ok == $nb_ecr ) {
	print "OK\n";
}
else {
	print "NOK\n";
}		
=begin comment
# OK all in rerlation so we populate
	while (my $ecr = $rs_ecr->next) {
		my $hasmvt = $schema->resultset('Relecrhasmvt')->find_or_new({
					relecrhmvt_ecrno	=> $ecr->get_column('ecr_no'),
					relecrhmvt_mvtid	=> $mvt_found->mvt_id,
					relecrhmvt_mvtno	=> $mvt_found->mvt_no});			
		if( !$hasmvt->in_storage ) {
			$hasmvt->insert;
		}
	}
} else {
	# NOT OK computing missing one
	
	print "Not OK\n";  
}
=end comment
=cut