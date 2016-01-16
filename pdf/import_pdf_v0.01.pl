#!/usr/bin/env perl

# REM : 
# complete file compare
# idea of real usefull file content only image size compare to image size + metadata for ie) and OS overhead (keywords, metadata

# WITH sparebundle files content take into account
# Check timemachine status active sparebundle or not
# Check process delete files in sparebundle and size reduce
# Build Volumes list

# ENTRY (ARGV) 1 
# ENTRY TYPE : VOL, DIR, FILENAME (dmg, iso, sparebundle, ...)
# ENTRY NAME : OS FULL_FILENAME

# DEPENDENCIES 
#	"file" unix command

use strict;
use warnings;

use Data::Dumper;
use Image::ExifTool;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use File::Compare;
use File::Basename;
use File::Path;
use File::Spec;
use File::Copy;
use File::Find;
use File::MimeInfo::Magic;

use Pdf::Schema;

my $schema = Pdf::Schema->connect('dbi:SQLite:pdf.db', '', '',{ sqlite_unicode => 1});


my %REC_FILE;

my %REC_REPORT;

my %SIGNATURES;

my $report_id;

my $dirs_read;
my $files_read;


sub compute_md5_file {
    my $filename = shift;
    open (my $fh, '<', $filename) or die "Can't open '$filename': $!";
    binmode ($fh);
    return Digest::MD5->new->addfile($fh)->hexdigest;
}

sub compute_report_id {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
			$mon 	+= 1;
			$year 	+= 1900;
			$mday 	= substr("0".$mday,length("0".$mday)-2, 2);
			$mon 	= substr("0".$mon,length("0".$mon)-2, 2);
			$hour 	= substr("0".$hour,length("0".$hour)-2, 2);
			$min 	= substr("0".$min,length("0".$min)-2, 2);
	
			$report_id = join("_", $year, $mon, $mday, join("-", $hour,$min));
}


# report_id : date only
sub init_proc_report {

	
#	my $proc		= $_[1];
#	my $dir			= $_[2];

	my $rec_report = {};
	
	$rec_report->{report_id} 					= $report_id;
#	$rec_report->{proc}							= $proc;
#	$rec_report->{args}							= $dir;
	$rec_report->{report_nbdirsread} 			= 0;
	$rec_report->{report_nbfilesread}			= 0;
	$rec_report->{report_nbdup}					= 0;
	$REC_REPORT{ $rec_report->{report_id} } 	= $rec_report;
	
}		
		
sub ls_files {
	my $md5;
#	print $File::Find::name,"\n";
	if ( !($_ =~ /^\./) ) {
		if ( -l $_ ) {
		}
		elsif ( -d $_ ) { 
			$dirs_read++;
			$REC_REPORT{$report_id}{report_nbdirsread}++;
			
    	}	
    	elsif (mimetype($_) eq 'application/pdf') {  
#    		print $_,"\n";
    		$files_read++;
    		$REC_REPORT{$report_id}{report_nbfilesread}++;
    		my ($filename,$dir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
			my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($File::Find::name);
	   		   		
	   		my $md5 = compute_md5_file($File::Find::name);
	   		# MD5 already exists
	   		if ( $SIGNATURES{$md5} ) {
	   			# Update (Add new tags ?, set last mtime 
	   			$REC_FILE{$md5}{pdf_nbocc}++;
	   			$REC_REPORT{$report_id}{report_nbdup}++;
	   			push @{ $REC_FILE{$md5}{has_location} }, {
														'loc_fullname'	=> $File::Find::name,
														'loc_filename'	=> $filename,
														'loc_dir'		=>$dir,
														'loc_ext'		=> $ext };
			}	
	   		else {
	   		# new md5
	   			
	   			$SIGNATURES{$md5}++;
	   			my $rec_file = {};
	   			$rec_file->{pdf_id}					= $md5; 
	   			$rec_file->{pdf_nbocc}				= 1;	
				$rec_file->{pdf_mtime} 				= $mtime;
				$rec_file->{has_location}			= [ {
														'loc_fullname'	=> $File::Find::name,
														'loc_filename'	=> $filename,
														'loc_dir'		=>$dir,
														'loc_ext'		=> $ext} ];	 					
    			$REC_FILE{ $rec_file->{pdf_id} } = $rec_file;
			}		
		}		
	}
}

sub print_SIGNATURES {

		foreach my $id (keys %SIGNATURES) {
			print "\t KEYS : ",$SIGNATURES{$id},"\n";
		}
}		

sub print_SIMPLE_REPORT {
	print "[ REPORT FOR : ",$report_id," ] \n";

	print 	"\t NB DIRS: \t", $REC_REPORT{$report_id}{report_nbdirsread},"\n",
			"\t NB FILES: \t", $REC_REPORT{$report_id}{report_nbfilesread},"\n",
			"\t NB DOUBLONS: \t", $REC_REPORT{$report_id}{report_nbdup},"\n"
			
}

sub print_REC_FILES {
	foreach my $id (keys %SIGNATURES) {
		print "[ id : ",$id," ] \t",
				$REC_FILE{$id}{pdf_nbocc},"\t", 
#				"\t ", $REC_FILE{$id}{mime_type},"\n", # ONLY PDF
				$REC_FILE{$id}{pdf_mtime},"\n";

		for my $loc ( 0 .. $#{ $REC_FILE{$id}{has_location} } ) {
			print "[",$loc,"]\t";
			print $REC_FILE{$id}{has_location}[$loc]->{loc_fullname},"|",$REC_FILE{$id}{has_location}[$loc]->{loc_filename},"|",$REC_FILE{$id}{has_location}[$loc]->{loc_dir},"|",$REC_FILE{$id}{has_location}[$loc]->{loc_ext},"\n";
		}	
	}		
}

sub print_DOUBLONS {
	foreach my $id (keys %SIGNATURES) {
		if ( $#{ $REC_FILE{$id}{locations} } > 0) {
			print "[ FILE MD5 : ",$id," ] \n",
				"\t ", $REC_FILE{$id}{nb_occ},"\n", 
#				"\t ", $REC_FILE{$id}{mime_type},"\n", #ONLY PDF
				"\t ", $REC_FILE{$id}{mtime},"\n";

			for my $loc ( 0 .. $#{ $REC_FILE{$id}{locations} } ) {
#				print "LOC : ",$loc,"\n";
				print "\t [ ","FULL : ",$REC_FILE{$id}{locations}[$loc]->{full},"\t","FILE : ",$REC_FILE{$id}{locations}[$loc]->{file},"\t","PATH : ",$REC_FILE{$id}{locations}[$loc]->{dir},"\t","EXT : ",$REC_FILE{$id}{locations}[$loc]->{ext}," ] \n";
			}
		}	
	}		
}

# THIS WORKS BUT DON'T CHECK IF ROW ALREADY EXSITS !
sub db_populate {
	my @rec_pdfs;
	my @rec_files;
	my @rec_report;
	
	foreach my $id (keys %SIGNATURES) {
		push @rec_pdfs, [$id, $REC_FILE{$id}{pdf_nbocc}, $REC_FILE{$id}{pdf_mtime}];
		for my $loc ( 0 .. $#{ $REC_FILE{$id}{has_location} } ) {
#			print $REC_FILE{$id}{has_location}[$loc]->{loc_fullname},"\n";
			push @rec_files, [$id, $REC_FILE{$id}{has_location}[$loc]->{loc_fullname}, $REC_FILE{$id}{has_location}[$loc]->{loc_filename}, $REC_FILE{$id}{has_location}[$loc]->{loc_dir}, $REC_FILE{$id}{has_location}[$loc]->{loc_ext} ];
		}
	}	
	push @rec_report, [ $report_id, $REC_REPORT{$report_id}{report_nbdirsread}, $REC_REPORT{$report_id}{report_nbfilesread}, $REC_REPORT{$report_id}{report_nbdup}];

	my $pdf_insert 		= $schema->resultset('Pdf')->populate([[qw/pdf_id pdf_nbocc pdf_mtime/], @rec_pdfs ]);
	my $location_insert = $schema->resultset('Location')->populate([[qw/loc_id loc_fullname loc_filename loc_dir loc_ext/], @rec_files ]);
	my $report_insert 	= $schema->resultset('Report')->populate([[qw/report_id report_nbdirsread report_nbfilesread/], @rec_report ]);
	
}

# THIS WORKS BUT DON'T CHECK IF ROW ALREADY EXSITS !
sub db_create {

	my @rec_report;
	
	foreach my $id (keys %SIGNATURES) {
		my $import = $schema->resultset('Pdf')->create({
				pdf_id 		=> $id,
				pdf_nbocc 	=> $REC_FILE{$id}{pdf_nbocc},
				pdf_mtime 	=> $REC_FILE{$id}{pdf_mtime},	
		});
	}	
	foreach my $id (keys %SIGNATURES) {
		for my $loc ( 0 .. $#{ $REC_FILE{$id}{has_location} } ) {
			my $import = $schema->resultset('Location')->create({
				loc_id 			=> $id,
				loc_fullname 	=> $REC_FILE{$id}{has_location}[$loc]->{loc_fullname},
				loc_filename 	=> $REC_FILE{$id}{has_location}[$loc]->{loc_filename},
				loc_dir 		=> $REC_FILE{$id}{has_location}[$loc]->{loc_dir},
				loc_ext 		=> $REC_FILE{$id}{has_location}[$loc]->{loc_ext},
			});	
		}
	}	
	my $report_insert 	= $schema->resultset('Report')->populate([[qw/report_id report_nbdirsread report_nbfilesread/], @rec_report ]);	
}

sub db_findorcreate {

	my @rec_report;
	
	foreach my $id (keys %SIGNATURES) {
		my $import = $schema->resultset('Pdf')->find_or_create({
				pdf_id 		=> $id,
				pdf_nbocc 	=> $REC_FILE{$id}{pdf_nbocc},
				pdf_mtime 	=> $REC_FILE{$id}{pdf_mtime},	
		});
	}	
	foreach my $id (keys %SIGNATURES) {
		for my $loc ( 0 .. $#{ $REC_FILE{$id}{has_location} } ) {
			my $import = $schema->resultset('Location')->find_or_create({
				loc_id 			=> $id,
				loc_fullname 	=> $REC_FILE{$id}{has_location}[$loc]->{loc_fullname},
				loc_filename 	=> $REC_FILE{$id}{has_location}[$loc]->{loc_filename},
				loc_dir 		=> $REC_FILE{$id}{has_location}[$loc]->{loc_dir},
				loc_ext 		=> $REC_FILE{$id}{has_location}[$loc]->{loc_ext},
			});	
		}
	}	
	my $report_insert 	= $schema->resultset('Report')->populate([[qw/report_id report_nbdirsread report_nbfilesread/], @rec_report ]);	
}


# MAIN

my @inputs;
for my $arg (0 .. $#ARGV) {
	print $ARGV[$arg],"\t | ";
	if (-d $ARGV[$arg]) {
		$inputs[$arg] = $ARGV[$arg];
		print " dir_OK \t |";
	} else {
		print " Not_dir \t |";
	}
	print "\n";
}

#if ( defined($inputs[0]) ) {
	compute_report_id();
	init_proc_report();
	find(\&ls_files, @inputs);
	db_findorcreate();
#	db_populate();
#	db_create();
#	print Dumper(%REC_FILE);
	print "\n";
#	print_REC_FILES();
	print "\n";
#	print_DOUBLONS();
	print_SIMPLE_REPORT();
#} else {
#	print "No valid inputs \n";
#}		


