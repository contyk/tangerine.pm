package Tangerine::hook::mooselike;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any);
use Tangerine::Hook;
use Tangerine::HookData;

sub run {
    my $s = shift;
    if ((any { $s->[0] eq $_ } qw(use no)) &&
        scalar(@$s) > 2 && (any { $s->[1] eq $_ } qw(Moose Mouse Moo Mo))) {
        require Tangerine::hook::extends;
        my @hooks = (
            Tangerine::Hook->new(
                type => 'req',
                run => \&Tangerine::hook::extends::run,
            )
        );
        # Write the with hook first
        if (0 && $s->[1] ne 'Mo') {
            require Tangerine::hook::with;
            push @hooks, Tangerine::Hook->new(
                type => 'req',
                run => \&Tangerine::hook::with::run,
            );
        }
        return Tangerine::HookData->new( hooks => [ @hooks ] );
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::mooselike - Detect Moose-like modules being loaded and
register additional hooks.

=head1 DESCRIPTION

This hook catches various Moose-like modules and registers their specific
hooks, e.g. L<Tangerine::hook::extends> or L<Tangerine::hook::with>.

Currently this hook knows about L<Moose>, L<Mouse>, L<Moo> and L<Mo>.

=head SEE ALSO

L<Tangerine>, L<Moose>, L<Mouse>, L<Moo>, L<Mo>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
