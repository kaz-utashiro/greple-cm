package App::Greple::cm;

use v5.14;
use warnings;

our $VERSION = "0.01";

=encoding utf-8

=head1 NAME

App::Greple::cm - Greple module to load colormap file

=head1 SYNOPSIS

    greple -Mcm [ options ... ]

=head1 DESCRIPTION

This is a greple module to handle colormap.

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2020 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use Exporter qw(import);
our @EXPORT;

use Data::Dumper;
use App::Greple::Common;
use Getopt::EX::Colormap qw(colorize);

my %param = (
    name => 0,
    name_format => "[%s]",
    name_position => "right",
    string_format => "%s",
    color => "",
    samecolor => 0,
    reverse => 0,
);

my($mod, $argv);
my @cm;

sub initialize {
    ($mod, $argv) = @_;
}

sub load {
    my %arg = @_;
    my $filename = delete $arg{&FILELABEL};
    my $file = $arg{file};
    open my $fh, "<", $file or die;
    @cm = do {
	map  { chomp; [ split ' ', $_, 2 ] }
	grep { not /^\s*(?:$|#)/ }
	<$fh>;
    };
    ();
}

sub option {
    map { ( "--cm" => "&__cm(c=$_->[0])" ) } @cm;
}

push @EXPORT, qw(&__cm);
sub __cm {
    my %arg = (%param, @_);
    my $s = sprintf $param{string_format}, colorize($arg{c}, $_);
    if ($arg{name}) {
	my $name = $arg{c};
	my $color = $param{samecolor} ? $arg{c} : $param{color};
	if ($color) {
	    $color .= "S" if $param{reverse};
	    $name = colorize($color, $name);
	}
	$name = sprintf $param{name_format}, $name;
	if ($param{name_position} eq 'right') {
	    $s .= $name;
	} else {
	    $s = $name . $s;
	}
    }
    $s;
}

sub setparam {
    my %arg = @_;
    for my $key (keys %arg) {
	if (not exists $param{$key}) {
	    warn "$key: Unknown parameter\n";
	    next;
	}
	$param{$key} = $arg{$key};
    }
    return ();
}

1;

__DATA__

mode function

option --cm-param &setparam($<shift>)
option --cm-file  &load(file=$<shift>)
option --cm-option &option
