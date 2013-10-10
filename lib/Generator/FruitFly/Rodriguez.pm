package Generator::FruitFly::Rodriguez;

use strict;
use warnings;
use Carp;
use IO::File;

### header info ###
#CG ID
#genesymbol
#Region
#chr
#coord
#ywTotalGenomecoverage
#ywNascentEditR1
#ywNascentEditR2
#POOLEDywNascentedit
#ywmRNA_poolededitinglevel
#CsmRNA_poolededitinglevel
#YWR1R2_editFM7aR1R2_edit
#AOR1R2_edit
#0.05pctile_editinglevel
#Occurs in all small prep controls (yw and FM7a both replicates)

# !!!CAUTION!!! change type of coord column to standard 
# because parse error occured at contained "," in coord.

sub parse {
    my $class = shift;
    my $file  = shift;
    
    my $self = ();
    my $fh = IO::File->new($file) or croak "Internal Error: Can not open file:$!";
    while (my $data_entory = $fh->getline) {
        next if __LINE__ == 1;
        my ($gene, $region, $chr, $pos, $cov, $pooled_edit)  = (split /\,/, $data_entory)[0,2,3,4,5,7];
        my $id = '_id'.int(rand(1000000));
        push @{ $self->{$id}->{gene} },  $gene;
        push @{ $self->{$id}->{region} },$region;
        push @{ $self->{$id}->{chr} }, $chr;
        push @{ $self->{$id}->{pos} }, $pos;
        push @{ $self->{$id}->{coverage} }, $cov;
        push @{ $self->{$id}->{nascent_edit_ratio} }, $pooled_edit;
    }
    $fh->close();
    bless $self, __PACKAGE__;
}

sub iter {
    my $self = shift;
    return keys %$self;
}

sub gene {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{gene}};
}

sub region {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{region}};
}

sub chromosome {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{chr}};
}

sub position {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{pos}};
}

sub coverage {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{coverage}};
}

sub nascent_edit_ratio {
    my $self = shift;
    my $id = shift;
    return @{$self->{$id}->{nascent_edit_ratio}};
}

sub AUTOLOAD {
    our $AUTOLOAD;
    croak "Called $AUTOLOAD is not found";
};


1;
