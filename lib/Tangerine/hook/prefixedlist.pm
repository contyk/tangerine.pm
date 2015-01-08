package Tangerine::hook::prefixedlist;
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
        (any { $s->[1] eq $_ } qw(Inline Mo POE))) {
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
        @args = $args[0] ? ($args[0]) : ()
            if $s->[1] eq 'Inline';
        return Tangerine::HookData->new(
            modules => {
                map {
                    ( $s->[1].'::'.$_ => Tangerine::Occurence->new() )
                    } @args,
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

Tangerine::hook::prefixedlist - Process simple sub-module lists.

=head1 DESCRIPTION

This hook catches C<use> statements with modules loading more modules
listed as their arguments.  The difference from L<Tangerine::hook::list>
is these modules use the same namespace as the module loading them.

Currently this hook knows about L<Inline>, L<Mo> and L<POE>.

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015 Petr Šabata

See LICENSE for licensing details.

=cut
