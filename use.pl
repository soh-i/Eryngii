#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Perl6::Say;

use lib qw{./lib};
use Metadata::GSE;
use Metadata::GSM;

my $gse_xml = Metadata::GSE->new("GSE32950");
say $gse_xml->title();
say $gse_xml->pmid();
say $gse_xml->gse_id();
say $gse_xml->supp_data();
say $gse_xml->gsm_ids();

my $gsm = Metadata::GSM->new("GSM914095");
say $gsm->iid();
say $gsm->sp();
say $gsm->strain();
say $gsm->tissue();

