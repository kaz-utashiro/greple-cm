package App::Greple::cm;

use v5.14;
use warnings;

our $VERSION = "0.01";

=encoding utf-8

=head1 NAME

App::Greple::cm - Greple module to load colormap file

=head1 SYNOPSIS

    greple -Mcm --load-colormap ...

=head1 DESCRIPTION

App::Greple::cm is ...

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

my($mod, $argv) = @_;

sub initialize {
    ($mod, $argv) = @_;
}

sub load {
    my %arg = @_;
    my $filename = delete $arg{&FILELABEL};
    my $file = $arg{file};
    open my $fh, "<", $file or die;
    my @cm = map { chomp; [ split ' ', $_, 2 ] } <$fh>;
    if ($arg{colorname}) {
	map {
	    my $color = $_->[0];
	    ( "--cm" => "&__cm__comment(color=$color)" );
	}
	@cm;
    } else {
	( "--cm" => join ',', map $_->[0], @cm );
    }
}

push @EXPORT, qw(&__cm__comment);
sub __cm__comment {
    comment(@_);
}

sub comment {
    my %arg = @_;
    my $s = colorize($arg{color}, $_);
    my $comment = sprintf "[%s]", $arg{color};
    $s . $comment;
}

1;

__DATA__

mode function

option --load-colormap &load(file=$<shift>)
option --load-colormap-colorname &load(file=$<shift>,colorname)

option --load-cm --load-colormap
