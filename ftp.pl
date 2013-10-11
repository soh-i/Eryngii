#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use HTTP::Request::Common;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Net::FTP;

# sample code
if (scalar @ARGV == 0) {
    die __help();
}

for (@ARGV) {
    _get_fastq_dl_links($_);
    sleep (1);
}

sub _get_fastq_dl_links {
    my $srx_id = shift or croak();
    
    my $base_url = 'http://trace.ddbj.nig.ac.jp/DRASearch/experiment';
    my %param = (acc => $srx_id);
    my $req = POST($base_url, \%param);
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);

    if ($res->is_success()) {
        my $tree = HTML::TreeBuilder->new();
        $tree->parse($res->content());
        for my $tag ($tree->look_down('class', 'navigation')->find('a')) {
            if ($tag->as_text() =~ m/^FASTQ\s$/ ) {
                __get_dl_links($tag->attr("href"));
            } 
        }
    } elsif ($res->is_error()) {
        croak "HTTP error: ", $res->status_line();
    }
}

sub __get_dl_links {
    my $link = shift or croak();
    
    (my $mod_link = $link) =~ s/^ftp\:\/{2}ftp\.ddbj\.nig\.ac\.jp\///;
    
    my $host = 'ftp.ddbj.nig.ac.jp';
    my $ftp = Net::FTP->new($host, Timeout=>30) or die();
    $ftp->login('anonymous', '');
    for ($ftp->ls($mod_link)) {
        print $host . '/' . $_ . "\n";
    }
}

sub __help {
    return "Usage: perl $0 SRX110671";
}
