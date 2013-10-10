package Excel::Parser;

use strict;
use warnings;
use Carp;
use Spreadsheet::ParseExcel;
use Spreadsheet::XLSX;
use IO::File;
use File::Basename qw/fileparse/;

use lib qw{./lib/};
use base q/Exporter/;
our @EXPORT = qw/to_ltsv to_csv/;

sub new {
    my ($class, %args) = @_;
    
    if (!$args{file} or !$args{sheet} or !$args{format}) {
        croak("Initialize error: file/sheet/format args are nessesary");
    }
    elsif (! -f $args{file}) {
        croak("IO error: $args{file} is not found");
    }
    elsif ($args{format} !~ m/(xls)|(xlsx)/) {
        croak("Format error: only xls/xlsx format accepted");
    }
    my $self = {
                file  => $args{file},
                sheet => $args{sheet},
                format => $args{format},
               };
    bless $self, $class;
}

sub file {
    my $self = shift;
    return $self->{file};
};

sub sheet {
    my $self = shift;
    return $self->{sheet};
}

sub format {
    my $self = shift;
    return $self->{format};
}

sub _name_without_ext {
    my $file = shift;
    (my $file_name) = fileparse($file, qr/\..*$/);
    return $file_name;
}

sub to_csv {
    my $self = shift;
    
    if ($self->{format} eq 'xls') {
        unlink _name_without_ext($self->{file}) . '.csv' if -f _name_without_ext($self->{file}) . '.csv';
        _xls($self);
    }
    elsif ($self->{format} eq 'xlsx') {
        unlink _name_without_ext($self->{file}) . '.csv' if -f _name_without_ext($self->{file}) . '.csv';
        _xlsx($self);
    }
}

sub to_ltsv {
    my $self = shift;
    return $self;
}

sub _xls {
    my $self = shift;
    
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($self->{file});
    
    if (!defined $workbook) {
        croak("Error: $parser->error()");
    }
    
    my $io = IO::File->new(_name_without_ext($self->{file}) . '.csv', 'a');
    foreach my $worksheet ($workbook->worksheet($self->{sheet})) {
        my ($row_min, $row_max) = $worksheet->row_range();
        my ($col_min, $col_max) = $worksheet->col_range();
        
        foreach my $row ($row_min .. $row_max){
            foreach my $col ($col_min .. $col_max){
                my $cell = $worksheet->get_cell($row, $col);
                if ($cell) {
                    $io->print($cell->value() . ',');
                } else {
                    $io->print(',');
                }
            }
            $io->print("\n");
        }
    }
    $io->close();
}

sub _xlsx {
    my $self = shift;
    
    my $excel = Spreadsheet::XLSX->new($self->{file});
    
    my $io = IO::File->new(_name_without_ext($self->{file}) . '.csv', 'a');
    foreach my $sheet (@{ $excel->{Worksheet} }) {
        if ($sheet->{Name} eq $self->{sheet}) {
            $sheet->{MaxRow} ||= $sheet->{MinRow};

            foreach my $row ($sheet->{MinRow} .. $sheet->{MaxRow}) {
                $sheet->{MaxCol} ||= $sheet->{MinCol};
                foreach my $col ($sheet->{MinCol} ..  $sheet->{MaxCol}) {
                    my $cell = $sheet->{Cells}->[$row]->[$col];
                    if ($cell) {
                        $io->print($cell->{Val}.',');
                    }
                }
                $io->print("\n");
            }
        }
    }
}

1;
