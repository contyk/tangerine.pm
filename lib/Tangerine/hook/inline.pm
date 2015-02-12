package Tangerine::hook::inline;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any);
use Mo;
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

extends 'Tangerine::Hook';

sub run {
    my ($self, $s) = @_;
    if ((any { $s->[0] eq $_ } qw(use no)) && scalar(@$s) > 2 &&
        $s->[1] eq 'Inline') {
        my ($version) = $s->[2] =~ /^(\d.*)$/o;
        $version //= '';
        my $voffset = $version ? 3 : 2;
        my @args;
        if (scalar(@$s) > $voffset) {
            return if $s->[$voffset] eq ';';
            @args = @$s;
            @args = @args[($voffset) .. $#args];
            @args = stripquotelike(@args);
        }
        my @modules;
        if ($args[0] =~ /config/io) {
            return
        } elsif ($args[0] =~ /with/io) {
            shift @args;
            push @modules, @args;
        } else {
            push @modules, 'Inline::'.$args[0];
        }
        return Tangerine::HookData->new(
            modules => {
                map {
                    ( $_ => Tangerine::Occurence->new() )
                    } @modules,
                },
            );
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::inline - Process Inline module use statements.

=head1 DESCRIPTION

This hook parses L<Inline> arguments and attempts to report required
C<Inline> language modules or non-C<Inline> modules used for
configuration, usually loaded via the C<with> syntax.

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015 Petr Šabata

See LICENSE for licensing details.

=cut
