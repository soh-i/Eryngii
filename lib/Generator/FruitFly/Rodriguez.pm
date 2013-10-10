package Generator::FruitFly::Rodriguez;

use strict;
use warnings;
use Carp;
use IO::File;
use Excel::Parser;

sub generate_db {
    
}

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

sub parse {
    my $self = shift;
    
    my $fh = IO::File->new($args{file}) or croak "Can not open file:$!";
    my $collected = [];
    while (my $data_entory = $bfh->getline()) {
        next if __LINE__ == 1;
        my ($gene, $region, $chr, $pos, $cov, $pooled_edit)  = (split /\,/, $data_entory)[0,2,3,4,5,7];
        $self->{gene} = $gene;
        $self->{region} = $region;
        $self->{chr} = $chr;
        $self->{pos} = $pos;
        $self->{coverage} = $cov;
        $self->{nascent_edit_ratio} = $pooled_edit;
    }
    return $self;
}

sub gene {
    my $self = shift;
    return $self->{gene};
}

sub region {
    my $self = shift;
    return $self->{region};
}

sub chromosome {
    my $self = shift;
    return $self->{chr};
}

sub positon {
    my $self = shift;
    return $self->{pos};
}

sub coverage {
    my $self = shift;
    return $self->{coverage};
}

sub nascent_edit_ratio {
    my $self = shift;
    return $self->{nascent_edit_ratio};
}

sub AUTOLOAD {
    our $AUTOLOAD;
    croak "Called $AUTOLOAD is not found";
};


1;
