#! /usr/bin/env perl
# GW
use strict;
use warnings;
use File::Basename;
use File::Find;
use File::MimeInfo::Magic qw(mimetype extensions);
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Data::Dumper;

use Piecescomptables::Schema;

my $schema = Piecescomptables::Schema->connect('dbi:SQLite:pieces-comptables.db', '', '',{ sqlite_unicode => 1});
my $nb_pdf;

sub get_volume {
	return File::Spec->rootdir($_);
}	

sub compute_md5_file {
	my $filename = shift;
	open (my $fh, '<', $filename) or die "Can't open '$filename': $!";
	binmode ($fh);
	return Digest::MD5->new->addfile($fh)->hexdigest;
}

my @record_pc=();
my @record_file=();

sub read_dir {
#	my $rows2insert;
	if ( -f $File::Find::name ) {
	 	my($filename, $path, $ext) = fileparse($File::Find::name);
	 	my($vol) =('/'); # will get my get_vol command later
	 	if ( mimetype($File::Find::name) eq 'application/pdf' ) {
			$nb_pdf++;
			my $md5 = compute_md5_file($File::Find::name); 
			# then insert into db by checking row doesn't exist
			my $io = (stat($File::Find::name))[1];

			push @record_pc,[ $io, $md5 ];
			push @record_file,[ $io, $filename, $ext, $path, $vol]
		}	
	}
=begin comment
	
					my $rec_file = {};

	   			$rec_file->{md5}				= compute_md5_file($File::Find::name); 
	   			$rec_file->{filename}			= $filename;
	   			$rec_file->{path}				= $path;
	   			$rec_file->{ext}				= $ext;
	   			$rec_file->{file_volume}		=
	   			$rec_file->{file_pieceid}		=
	   			
#	   			print "NB_OCC: ",$rec_file->{nb_occ}	,"\n";
	   			$rec_file->{space}				= $exifTool_object->GetValue('FileSize', 'ValueConv');	
#	   			print "SIZE: ",$rec_file->{space}	,"\n";
	   				
				
				$rec_file->{mime_type}			= $exifTool_object->GetValue('MIMEType', 'ValueConv');		
#				print "MIME_TYPE: ",$rec_file->{mime_type}		,"\n";
				$rec_file->{mtime} 				= $mtime;
#				print "TIME: ",$rec_file->{mtime}	,"\n";

	 			$rec_file->{locations} = [ { ('file',$filename, 'dir',$dir,'ext',$ext) } ];
	 			
#	 			print "FILENAME: ",$rec_file->{locations}[0]->{file},"\n";
#				print "PATH: ",$rec_file->{locations}[0]->{dir},"\n";
#	 			print "EXT: ",$rec_file->{locations}[0]->{ext},"\n";
	 			
	 			$REC_REPORT{$report_id}{nb_total_space}+= $rec_file->{space};	
	 					
    			$REC_FILE{ $rec_file->{id} } = $rec_file;
			
			
	
	$schema->populate_more(
        Source1 => {
                fields => [qw/ column belongs_to has_many/],
                data => {
                        key_1 => ['value', $row, \@rows ],
                }
        },
        Source2 => {
                fields => [qw/ column belongs_to has_many/],
                data => {
                        key_1 => ['value', $row, \@rows ],
                }
        },
	);


=end comment
=cut 

}

my @inputs;
$nb_pdf = 0;

for my $arg (0 .. $#ARGV) {
	print $ARGV[$arg],"\t";
	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
}	

# Read input dirs then build array for database entry
if ( $#inputs != -1) {

	find(\&read_dir, @inputs);
	print "pdf files number : ",$nb_pdf,"\n";
}

 	my $test_insert = $schema->resultset('Piececomptable')->populate([[qw/piececomptable_id piececomptable_md5/], @record_pc ]);
# 	my $test_insert2 = $schema->resultset('Piececomptable')->populate([[qw/piececomptable_id piececomptable_md5/], @test_record2]);