package Metadata::GEO::GSM;

use strict;
use warnings;
use Carp;
use LWP::Simple;
use HTTP::Request::Common;
use XML::Simple;
use Net::FTP;
use HTML::TreeBuilder;

use lib qw{./lib/};
use Metadata::Utils;

sub new {
    my $class = shift;
    my $id    = shift;
    
    my $self = {
                GSMID => $id,
                URL => 'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi',
               };
    
    my $params = {'acc'  => $self->{GSMID},
                'form' => 'xml',
                'view' => 'full'
               };
    
    $self->{XML} = _fetch_xml(id=>$self->{GSMID}, url=>$self->{URL}, post_params=>$params);
    bless $self, $class;
}

sub DESTROY {
    my $self = shift;
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

sub time_points {
    my $self = shift;
    _clean_up_data($self->{XML}->{Sample}->{Channel}->{Characteristics}->[4]->{content});
}

sub lib_strategy {
    my $self = shift;
    $self->{XML}->{Sample}->{"Library-Strategy"};
    
}

sub platform {
   my $self = shift;
   $self->{XML}->{Sample}->{'Instrument-Model'}->{Predefined};
}

sub srx_id {
    my $self = shift;
    _get_SRX_ID($self->{XML}->{Sample}->{Relation}->[0]->{target});
}

sub fastq_links {
    my $self = shift;
    my $id   = shift;
    
    # Access to DDBJ SRA search and parse to get fq links
    my $base_url = 'http://trace.ddbj.nig.ac.jp/DRASearch/experiment';
    my %param = (acc => $id);
    my $req = POST($base_url, \%param);
    my $ua = LWP::UserAgent->new();
    my $res = $ua->request($req);
    
    my $fq_link = qw//;
    if ($res->is_success()) {
        my $tree = HTML::TreeBuilder->new();
        $tree->parse($res->content());
        for my $tag ($tree->look_down('class', 'navigation')->find('a')) {
            if ($tag->as_text() =~ m/^FASTQ\s$/ ) {
                $fq_link = ($tag->attr("href"));
            }
        }
    } elsif ($res->is_error()) {
        croak("HTTP error: ", $res->status_line());
    }
    
    # Establish FTP connection and list of fq files
    my $host = 'ftp.ddbj.nig.ac.jp';
    (my $mod_link = $fq_link) =~ s/^ftp\:\/{2}ftp\.ddbj\.nig\.ac\.jp\///;
    my $ftp = Net::FTP->new($host, Timeout=>30) or die();
    $ftp->login('anonymous', '');
    
    return map{$host . '/' . $_ . ','}$ftp->ls($mod_link);
}

sub _get_SRX_ID {
    my ($url) = @_;
    $url =~ m/\?term\=(SRX\d+)$/;
    return $1;
}

sub AUTOLOAD {
    our $AUTOLOAD;
    my (@args) = @_;
    croak "Called $AUTOLOAD is not found";
};


1;
