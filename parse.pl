#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use lib qw{./lib};
use Excel::Parser;

my $ep = Excel::Parser->new(
                            file=>"1471-2164-14-206-s5.xls",
                            sheet=>"1471-2164-14-206-s5.csv",
                            format=>'xls'
                           );
$ep->to_csv();

