#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request::Common;

my $ID = 'GSM914117';
my $url = 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi';
my %param = ('acc'  => $ID,
             'form' => 'xml',
             'view' => 'full'
            );
my $req = POST($url, \%param);
my $ua = LWP::UserAgent->new();
my $res = $ua->request($req);

print $res->content();
