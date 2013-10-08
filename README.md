Eryngii
=========

Eryngii: Metadata aggregator for GEO/SRA

![](http://p7.storage.canalblog.com/75/92/290470/30842278_p.jpg)

## Usage
```perl
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
```
