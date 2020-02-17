#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;
#
# ./bgpscanner ~/MTRdump/latest-bview | cut -d"|" -f 2,3

my $fn = '/tmp/bgp';
open(FH, '<', $fn) or die $!;


my %asn;
my @row;
my $o_as;
my %ascounter;


foreach (<FH>) {
	chomp;

	@row = split(/\|/, $_);

	if($row[1] =~ m/ (\d+)$/){
		$o_as = $1;
	}

	if ($ascounter{$o_as}) {
		$ascounter{$o_as} += 1;
	}else{
		$ascounter{$o_as} = 1;
	}

	push(@{$asn{$row[0]}}, $o_as);
	

	#	print $row[0] . "\t" . $o_as . "\n";
}


my @keys = sort { $ascounter{$b} <=> $ascounter{$a} } keys(%ascounter);
# List the x top number of ASNs
my $i = 10;
my @topx;

foreach (@keys) {

	push(@topx, $_);

	print "AS$_"."\t".$ascounter{$_}."\n";

	if($i-- == 1) {
		last;
	}
}

#
# Check prefix's origin(s) seen match WHOIS/IRR
#
sub checkOrigin {

	my $list = shift;
	my $origin = shift;

	foreach(@{$list}) {
		if(int($_) == int($origin)) {
			next;
		}else{
			print "WARNING: Origin $_ not valid\n";
		}
	}

}

foreach(@topx) {

	foreach(keys(%asn)) {
	
		my $as	

	}

}
