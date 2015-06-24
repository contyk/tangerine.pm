package Tangerine::Utils;

use strict;
use warnings;
use Exporter 'import';
use List::MoreUtils qw(apply);
our @EXPORT_OK = qw(accessor addoccurence stripquotelike);

sub accessor {
    # TODO: This needs checks
    $_[1]->{$_[0]} = $_[2] ? $_[2] : $_[1]->{$_[0]}
}

sub stripquotelike {
    my @filtered = map {
            if (/^('|").*$/o) {
                substr $_, 1, -1
            } elsif (/^(\(|\[|\{).*$/so) {
                stripquotelike(split /,|=>/so, substr $_, 1, -1)
            } elsif (/^qq?\s*[^\w](.*)[^\w]$/so) {
                $1
            } elsif (/^qw\s*[^\w](.*)[^\w]$/so) {
                grep { $_ } split /\s+/so, $1
            } else {
                $_
            }
        } grep {
            1 if !/^(,|=>|;|)$/so
        } apply {
            s/^\s+|\s+$//sgo;
            $_
        } @_;
    return wantarray ? @filtered : $filtered[0];
}

sub addoccurence {
    my ($a, $b) = @_;
    for my $k (keys %$b) {
        if (exists $$a{$k}) {
            $a->{$k} = [ @{$a->{$k}}, $b->{$k} ];
        } else {
            $a->{$k} = [ $b->{$k} ];
        }
    }
    return $a;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::Utils - A set of routines used by various L<Tangerine> modules

=head1 DESCRIPTION

This module exports the various routines used by L<Tangerine> internals.

=head1 ROUTINES

=over

=item C<accessor>

A helper routine to generate common attribute accessors.

=item C<stripquotelike>

Attempt to sanitise and strip quote-like operators from a list.

=item C<addoccurence>

A helper routine for module hash references merging.

=back

=head1 SEE ALSO

L<Tangerine>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015 Petr Šabata

See LICENSE for licensing details.

=cut
