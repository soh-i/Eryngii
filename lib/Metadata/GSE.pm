package Metadata::GSE;

use strict;
use warnings;
use Carp;
use Data::Dumper;

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
        push @Supdata, _clean_up_data($i->{content});
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
    if (wantarray) {
        return @GSMs;
    } else {
        return "GSMIDs:".join ",", @GSMs;
    }
}


1;
