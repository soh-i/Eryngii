#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

#my @IDs = qw/G4117 GSM693746 GSM693747/;
#for (@IDs) {
#    print __fetch_xml_from_GEO($_);
#}

fetch_xml_from_GSE('GSE37232');

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
    
    my $title = $row->{Series}->{Title};
    my $GSE_ID = $row->{Series}->{Accession};
    my $PMID = $row->{Series}->{"Pubmed-ID"};
    
    for my $i (@{$row->{Series}->{"Supplementary-Data"} }) {
        print $i->{content};
    }

    for my $GSM (@{$row->{Series}->{"Sample-Ref"}}) {
        #print $GSM->{ref}, "\n";
    }
}

sub fetch_xml_from_GSM {
    my $ID = shift;
    if (!$ID) {
        croak("Error: GEO is not found");
    }
    
    my $url = 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi';
    my %param = ('acc'  => $ID,
                 'form' => 'xml',
                 'view' => 'full'
                );

    my $req = POST($url, \%param);
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);
    my $data = $res->content();
    
    my $xml = XML::Simple->new();
    my $row = $xml->XMLin($data);
    
    my $GSM = $row->{Sample}->{iid};
    my $sp = $row->{Sample}->{Channel}->{Organism}->{content};
    my $strain = _clean_up_data($row->{Sample}->{Channel}->{Characteristics}->[0]->{content});
    my $tissue = _clean_up_data($row->{Sample}->{Channel}->{Characteristics}->[1]->{content});
    my $age    = _clean_up_data($row->{Sample}->{Channel}->{Characteristics}->[2]->{content});
    my $gender = _clean_up_data($row->{Sample}->{Channel}->{Characteristics}->[3]->{content});

    my $lib_strategy = $row->{Sample}->{'Library-Strategy'};
    my $platform = $row->{Sample}->{'Instrument-Model'}->{Predefined};
    my $SRA = _get_SRX_ID($row->{Sample}->{Relation}->[0]->{target});

    my $result = sprintf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $GSM, $sp, $strain, $tissue, $age, $gender, $lib_strategy, $platform, $SRA;
    return $result;
};

sub _clean_up_data {
    my ($data) = @_;
    if ($data) {
        (my $c = $data) =~ s/\n//g;
        return $c;
    }
};

sub _get_SRX_ID {
    my ($url) = @_;
    $url =~ m/\?term\=(SRX\d+)$/;
    return $1;
};
