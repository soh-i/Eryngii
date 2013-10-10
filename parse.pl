#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use lib qw{./lib};
use Excel::Parser;
use Generator::FruitFly::Rodriguez;

my $ep = Excel::Parser->new(
                            file => "mmc1.xls",
                            sheet => "Table_S1",
                            format => 'xls'
                           );
$ep->to_csv();

my $gen = Generator::FruitFly::Rodriguez->parse($ep->file().'.csv');
for my $id ($gen->iter()) {
    print $gen->gene($id), "\t";
    print $gen->position($id), "\t";
    print $gen->chromosome($id), "\t";
    print $gen->region($id), "\t";
    print $gen->coverage($id), "\n";
}

