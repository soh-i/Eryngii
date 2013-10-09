package Metadata::Generator;

use strict;
use warnings;
use Carp;

use lib qw{./lib/};
use Metadata::GEO::GSE;
use Metadata::GEO::GSM;
use Metadata::Utils;

sub new {
    my $class = shift;
    my $id    = shift;
    
    if (not _is_GSE($id)) {
        croak("Error: $id is invalid GSE ID");
    }
    
    my $self = {
                GSEID => $id,
                URL => 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi',
               };

    my $params = {'acc'  => $self->{GSEID},
                  'targ' => 'series',
                  'form' => 'xml',
                  'view' => 'full',
                 };
    
    $self->{XML} = _fetch_xml(id=>$self->{GSE_ID}, url=>$self->{URL}, post_params=>$params);
    bless $self, $class;
}

sub print_all {
    my $self = shift;

    
}    


1;




