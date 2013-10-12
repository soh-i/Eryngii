package Metadata::Generator;

use strict;
use warnings;
use Carp;

sub new {
    my ($class, $call, $id) = @_;
    
    my $self = {
                call => $call,
                ID => $id,
                URL => 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi',
               };
    bless $self, $class;
}

sub fetch_xml {
    my $self = shift;
    return $self->{call}->_fetch_xml();
}
    


1;

