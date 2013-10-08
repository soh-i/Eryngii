package Metadata;

use strict;
use warnings;
use Carp;

sub new {
    my ($self, $args) = @_;
    bless $args, $self;
}

sub load {
    my ($self) = @_;
    return $self;
}

1;


