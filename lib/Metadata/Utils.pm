package Metadata::Utils;

use strict;
use warnings;
use Carp;

use base q/Exporter/;
our @EXPORT = qw/_clean_up_data
                 _is_GSE
                 _is_GSM
                /;


sub _is_GSE {
    my $id = shift;
    if ($id =~ m/^GSE\d{4}$/) {
        return 1;
    }
}

sub _is_GSM {
    my $id = shift;
    if ($id =~ m/^GSM\d{4}$/) {
        return 1;
    }
}

sub _clean_up_data {
    my ($data) = @_;
    if ($data) {
        (my $c = $data) =~ s/(\n)|(\s+$)|(^\s+)//g;
        return $c;
    }
};



1;

