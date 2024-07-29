#! /usr/bin/perl
#
# reblock
#
# Created by Raymond Stricklin on 10/13/12.
# Copyright 2012 Typewritten Software. All rights reserved.
#
#
# Reads unblocked data from a file, with blocksize metadata stored in 
# a different file. Outputs blocked data for tape.
#
# Use with Typewritten Software style tape images; one file per tape file
# with blocksize metadata stored in a separate, matching block map text file
#

use strict;
#use feature ":5.10";
use Data::Dumper;

use vars qw($if $of $df $bf $args $dfh $bfh $ofh $debug);


$debug = 0;
parse_argv(@ARGV);
die "Could not open data file $df: $!"		unless open($dfh, '<', $df);
die "Could not open blocks file $bf: $!"	unless open($bfh, '<', $bf);
die "Could not open tape $of: $!"		unless open($ofh, '>', $of);

while (<$bfh>) {
	my $bs = "";
	my $buf = "";
	my $line = $_;
	
	next unless($line =~ /^read.+?=\s(\d+)$/);
	$bs = $1;

	die "garbled line: $line" if($bs eq "");
	print STDERR "reading blocksize $bs\n" if ($debug > 0);
	
	sysread($dfh, $buf, $bs);
	die "short read: expected $bs, got " . length($buf) if (length($buf) != $bs);
	print STDERR "====block data (" . length($buf) . ")====\n" if ($debug > 1);
	print STDERR Dumper($buf) if ($debug > 1);

	syswrite($ofh, $buf);
}

# End of program flow
# =================================================================================

sub parse_argv {
	while ( my $arg = shift ) {
		#given($arg) {
		#	when (/of=(.+)/)	{ $of = $1; shift; }
		#	when (/if=(.+)/)	{ $df = $1; shift }
		#	when (/bf=(.+)/)	{ $bf = $1; shift; }
		#	when ("-d")		{ $debug = 1; }
		#	when ("-dd")		{ $debug = 2; }
		#}
		$bf=$1   if ($arg =~ /^bf=(.+)/);
		$of=$1   if ($arg =~ /^of=(.+)/);
		$df=$1   if ($arg =~ /^if=(.+)/);
		$debug=1 if ($arg eq "-d");
		$debug=2 if ($arg eq "-dd");
	}

	if ($df eq "" or $bf eq "") {
		print STDERR "Usage:\n if=<datafile> bf=<blocksizefile> of=<tape>\n\n";
		exit(1);
	}
		
}
