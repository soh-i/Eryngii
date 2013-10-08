package Metadata::GSE;

use strict;
use warnings;
use Carp;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

sub new {
    my $class = shift;
    my $id    = shift;
    
    my $self = {
                GSEID => $id,
                URL => 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi',
               };

    my %param = ('acc'  => $self->{GSEID},
                 'targ' => 'series',
                 'form' => 'xml',
                 'view' => 'full',
                );
    
    my $req = POST($self->{URL}, \%param);
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);
    my $data = $res->content();
    
    my $xml = XML::Simple->new(forcearray=>0);
    my $row = $xml->XMLin($data);
    $self->{XML} = $row;
    
    bless $self, $class;
}

sub title {
    my $self = shift;
    my $title = "Title:" . "\"" . $self->{XML}->{Series}->{Title} . "\"";
    return $title;
}

sub gse_id{ 
    my $self = shift;
    my $GSE_ID = "GSE:". $self->{XML}->{Series}->{Accession}->{content};
    return $GSE_ID;
}

sub pmid {
    my $self = shift;
    my $PMID = "PMID:" . $self->{XML}->{Series}->{"Pubmed-ID"};
    return $PMID;
}

sub supp_data {
    my $self = shift;
    my @Supdata = qw//;
    for my $i (@{$self->{XML}->{Series}->{"Supplementary-Data"} }) {
        push @Supdata, __clean_up_data($i->{content});
    }
    my $joined_Suppdata = "SuppData:".join ",", @Supdata;
    return $joined_Suppdata;
}

sub gsm_ids {
    my $self = shift;
    my @GSMs = qw//;
    for my $GSM (@{$self->{XML}->{Series}->{"Sample-Ref"}}) {
        push @GSMs, $GSM->{ref};
    }
    my $joined_GSM_ID = "GSMIDs:".join ",", @GSMs;
    return $joined_GSM_ID;
}

sub __clean_up_data {
    my ($data) = @_;
    if ($data) {
        (my $c = $data) =~ s/(\n)|(\s+$)|(^\s+)//g;
        return $c;
    }
};


1;

#my $to_LTSV = sprintf "%s\t%s\t%s\t%s\%s\n", $title, $GSE_ID, $PMID, $joined_GSM_ID, $joined_Suppdata;
#return $to_LTSV;


