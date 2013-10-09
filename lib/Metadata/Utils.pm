package Metadata::Utils;

use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

use base q/Exporter/;
our @EXPORT = qw/_clean_up_data
                 _is_GSE
                 _is_GSM
                 _fetch_xml
                /;

sub _fetch_xml {
    my %args = (
                url => '',
                id => '',
                post_params => '',
                @_,
               );
    
    my $req = POST($args{url}, $args{post_params});
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);
    
    my $xml_content = ();
    if ($res->is_success) {
        $xml_content= $res->content();
    } elsif ($res->is_error()) {
        croak("HTTP Request error: ", $res->status_line());
    }
    
    my $xml = XML::Simple->new(forcearray=>0);
    my $struct;
    eval {
        $struct = $xml->XMLin($xml_content);
    };
    if ($@) {
        croak("XML::Simple error: invalid XML content maybe given");
    }
    return $struct;
}

sub _is_GSE {
    my $id = shift;
    if ($id =~ m/^GSE\d{5}$/) {
        return 1;
    }
}

sub _is_GSM {
    my $id = shift;
    if ($id =~ m/^GSM\d{4}$/) {
        return 1;
    }
}

sub _clean_up_data {
    my ($data) = @_;
    if ($data) {
        (my $c = $data) =~ s/(\n)|(\s+$)|(^\s+)//g;
        return $c;
    }
};



1;

