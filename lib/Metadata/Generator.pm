package Metadata::Generator;

use strict;
use warnings;
use Carp;

use lib qw{./lib/};
use Metadata::GEO::GSE;
use Metadata::GEO::GSM;
use Metadata::SRA::SRA;
use Metadata::Utils;

sub new {
    my ($class, $args) = @_;
    bless $class, $args;
}

1;


