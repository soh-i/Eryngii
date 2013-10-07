#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

my $ID = 'GSM914117';
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

#my $desc = _clean_up_data($row->{Sample}->{Description});

my $lib_strategy = $row->{Sample}->{'Library-Strategy'};
my $platform = $row->{Sample}->{'Instrument-Model'}->{Predefined};
my $SRA = _get_SRX_ID($row->{Sample}->{Relation}->[0]->{target});

print $GSM, $sp, $strain, $tissue, $age, $gender, $lib_strategy, $platform, $SRA;



sub _clean_up_data {
    my ($data) = @_;
    
    if ($data) {
        (my $c = $data) =~ s/\n//g;
        return chomp $c;
    }
};

sub _get_SRX_ID {
    my ($url) = @_;
    $url =~ m/\?term\=(SRX\d+)$/;
    return $1;
}

