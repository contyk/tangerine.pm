package Tangerine::hook::testrequires;

use 5.010;
use strict;
use warnings;
use parent 'Tangerine::Hook';
use List::Util 1.33 qw(any);
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike $vre);

sub run {
    my ($self, $s) = @_;
    my %found;
    if ($self->type eq 'compile' &&
        (any { $s->[0] eq $_ } qw(use no)) && scalar(@$s) > 2 &&
        $s->[1] eq 'Test::Requires') {
        my ($version) = $s->[2] =~ $vre;
        $version //= '';
        return if !$version && stripquotelike($s->[2]) =~ /^v?5(?:\..*)?$/;
        my $voffset = $version ? 3 : 2;
        my @args;
        if (scalar(@$s) > $voffset) {
            return if $s->[$voffset] eq ';';
            @args = @$s;
            @args = @args[($voffset) .. $#args];
            @args = stripquotelike(@args);
        }
        if (substr($s->[$voffset], 0, 1) eq '{') {
            %found = @args;
        } else {
            %found = map { $_ => '' } @args;
        }
    } elsif ($self->type eq 'runtime' &&
        $s->[0] eq 'test_requires' && scalar(@$s) > 1) {
        return if $s->[1] eq ';';
        my @args = stripquotelike((@$s)[1..$#$s]);
        $found{$args[0]} = $args[1] && $args[1] ne ';' ? $args[1] : '';
    } else {
        return
    }
    return Tangerine::HookData->new(
        modules => {
            map {
                ( $_ => Tangerine::Occurence->new(version => $found{$_}) )
                } keys %found,
            },
        )
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::testrequires - Process Test::Requires calls

=head1 DESCRIPTION

This module inspects L<Test::Requires> use and test_requires() calls
and inspects their arguments, checking which modules the subroutines
will load.

=head1 SEE ALSO

L<Tangerine>, L<Test::Requires>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
