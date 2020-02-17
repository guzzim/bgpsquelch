#!/usr/bin/perl
#
use Net::IRR;
use Net::Whois::Raw;
use Getopt::Long;

# Lookup prefix in RADB
#

# CLI Tools
my $bgpscanner = '/home/abpb/bgpscanner/build/bgpscanner';
my $cut = '/usr/bin/cut';

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

#print "Autnum $autnum\n";


# Lookup prefix in MRT dump
# Should be able to get away with backticks
# Querying the PAIX bview file
my $output = `/home/abpb/bgpscanner/build/bgpscanner -e $prefix ~/MTRdump/latest-bview | /usr/bin/cut -d"|" -f 3`;

my $list;
@{$list} = split('\n', $output);

foreach(@{$list}) {
	if($_ =~ m/\s+(\d+)$/) {
		if($1 eq $as) {
			# Origin AS Matches
			next;
		}else{
			print "WARNING: Being originated by AS$as\n";
		}
	}
}


# Check prefix against RPKI Validator
# Backticks with rtrclient to query a validator
## is prefix mask within range
#
# Using FORT and pulled the database out to a csv
#
# rtrclient -e -t csv -o /tmp/roa.csv tcp 192.168.86.129 8323
