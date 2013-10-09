#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

use lib qw{./lib};
use Metadata::GSE;

my $fetch_xml = Metadata::GSE->new("GSE37232");
print $fetch_xml->title();
print $fetch_xml->pmid();
print $fetch_xml->gse_id();
print $fetch_xml->supp_data();
print $fetch_xml->gsm_ids();





