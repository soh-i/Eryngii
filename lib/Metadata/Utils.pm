package Metadata::Utils;

use strict;
use warnings;
use Carp;

use base q/Exporter/;
our @EXPORT = qw/__clean_up_data/;

sub __clean_up_data {
    my ($data) = @_;
    if ($data) {
        (my $c = $data) =~ s/(\n)|(\s+$)|(^\s+)//g;
        return $c;
    }
};


1;

