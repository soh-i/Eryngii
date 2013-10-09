package Metadata::GSM;

use strict;
use warnings;
use Carp;
use LWP::Simple;
use HTTP::Request::Common;
use XML::Simple;
use Metadata::Utils;


sub new {
    my $class = shift;
    my $id    = shift;
    
    my $self = {
                GSMID => $id,
                URL => 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi',
               };
    
    my $url = 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi';
    
    my $params = {'acc'  => $self->{GSMID},
                'form' => 'xml',
                'view' => 'full'
               };
    
    $self->{XML} = _fetch_xml(id=>$self->{GSMID}, url=>$self->{URL}, post_params=>$params);
    bless $self, $class;
}

sub iid {
    my $self = shift;
    $self->{XML}->{Sample}->{iid};
}

sub sp {
    my $self = shift;
    $self->{XML}->{Sample}->{Channel}->{Organism}->{content};
}

sub strain {
    my $self = shift;
    _clean_up_data($self->{XML}->{Sample}->{Channel}->{Characteristics}->[0]->{content});
}

sub tissue {
    my $self = shift;
    _clean_up_data($self->{XML}->{Sample}->{Channel}->{Characteristics}->[1]->{content});
}
   
sub age {
    my $self = shift;
    _clean_up_data($self->{XML}->{Sample}->{Channel}->{Characteristics}->[2]->{content});
}

sub gender {
   my $self = shift;
   _clean_up_data($self->{XML}->{Sample}->{Channel}->{Characteristics}->[3]->{content});
}

sub lib_strategy {
    my $self = shift;
    
}

sub platform {
   my $self = shift;
   $self->{XML}->{Sample}->{'Instrument-Model'}->{Predefined};
}

sub srx_ids {
    my $self = shift;
    _get_SRX_ID($self->{XML}->{Sample}->{Relation}->[0]->{target});
}

sub _get_SRX_ID {
    my ($url) = @_;
    $url =~ m/\?term\=(SRX\d+)$/;
    return $1;
}

1;
