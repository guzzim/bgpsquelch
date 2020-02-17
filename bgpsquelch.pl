#!/usr/bin/perl
#
use Net::IRR;
use Net::Whois::Raw;
use Getopt::Long;

my $prefix = '';
GetOptions ("prefix=s" => \$prefix);

if($prefix eq "") {
	print "Enter a preifx";
	exit 1;
}

my $host = 'whois.radb.net';

my $i = Net::IRR->connect( host => $host ) or die "can't connect to $host\n";

$i->sources('radb');


my $rtrobj = $i->route_search($prefix, Net::IRR::EXACT_MATCH);

my $as;

print $rtrobj;

if($rtrobj =~ m/AS(\d+)/) {
	$as = $1;
}

my $queryas = 'AS'."$as";

#my $autnum = $i->match('aut-num',"$queryas");

print "Autnum $autnum\n";

# Lookup prefix in RADB
#


# Lookup prefix in MRT dump


# Check prefix against RPKI Validator
## is prefix mask within range
