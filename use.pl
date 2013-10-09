#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Perl6::Say;

use lib qw{./lib};
use Metadata::Generator;

my $gse = Metadata::Generator->new('GSE28040');
say $gse->pmid();
say $gse->title();
say scalar $gse->supp_data();
say scalar $gse->to_gsm_ids();

my $gsm = Metadata::GEO::GSM->new(@);
