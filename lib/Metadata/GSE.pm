package Metadata::GSE;

use strict;
use warnings;
use Carp;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

sub new {
    my ($class, $url) = @_;
    my $self = {
             url => $url,
            };
    bless $self, $class;
}

sub get_url {
    my $self = shift;
    return $self->{url};
}

sub fetch_xml_from_GSE {
    my $ID = shift;
    croak("Error: GSE ID is lacked") unless $ID;
    
    my $url = 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi';
    my %param = ('acc'  => $ID,
                 'targ' => 'series',
                 'form' => 'xml',
                 'view' => 'full',
                );
    
    my $req = POST($url, \%param);
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);
    my $data = $res->content();
    
    my $xml = XML::Simple->new(forcearray=>0);
    my $row = $xml->XMLin($data);
    
    
    my $title = "Title:" . "\"" . $row->{Series}->{Title} . "\"";
    my $GSE_ID = "GSE:". $row->{Series}->{Accession}->{content};
    my $PMID = "PMID:" . $row->{Series}->{"Pubmed-ID"};
    
    my @Supdata = qw//;
    for my $i (@{$row->{Series}->{"Supplementary-Data"} }) {
        push @Supdata, _clean_up_data($i->{content});
    }
    my $joined_Suppdata = "SuppData:".join ",", @Supdata;
    
    my @GSMs = qw//;
    for my $GSM (@{$row->{Series}->{"Sample-Ref"}}) {
        push @GSMs, $GSM->{ref};
    }
    my $joined_GSM_ID = "GSMIDs:".join ",", @GSMs;
    
    my $to_LTSV = sprintf "%s\t%s\t%s\t%s\%s\n", $title, $GSE_ID, $PMID, $joined_GSM_ID, $joined_Suppdata;
    return $to_LTSV;
}


1;

