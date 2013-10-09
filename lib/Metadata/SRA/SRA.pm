package Metadata::SRA::SRA;

use HTTP::Request::Common;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Net::FTP;

use Metadata::Utils;

sub new {
    my $class = shift;
    my $id = shift;
    $self->{srxid} = $id;
    bless $self, $class;
}

1;
