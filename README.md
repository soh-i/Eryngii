Eryngii
=========

Eryngii: Metadata aggregator for GEO/SRA

## Dependencies
* Spreadsheet::ParseExcel == 0.59
* Spreadsheet::XLSX == 0.13
* Net::FTP.pm: == 2.78
* LWP::Simple == 2.20
* LWP::UserAgent == 6.05
* HTML::TreeBuilder == 5.03
* HTTP::Request::Common == 6.04

## Usage
### Convert excel file to LTSV.
* For Rodriguez, 2013.

```perl
use lib qw{./lib};
use Excel::Parser;
use Generator::FruitFly::Rodriguez;
my $ep = Excel::Parser->new(
                            file => "mmc1.xls",
                            sheet => "Table_S1",
                            format => 'xls'
                           );
$ep->to_csv();
my $gen = Generator::FruitFly::Rodriguez->parse($ep->file());
for my $id ($gen->iter()) {
    print $gen->to_ltsv($id);
}
```

