package Tangerine::hook::anymoose;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any);
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

sub run {
    my $s = shift;
    if ((any { $s->[0] eq $_ } qw(use no)) &&
        scalar(@$s) > 2 && $s->[1] eq 'Any::Moose') {
            my ($version) = $s->[2] =~ /^(\d.*)$/o;
            $version //= '';
            my $param = stripquotelike($s->[$version ? 3 : 2])
                if $s->[$version ? 3 : 2] ne ';';
            my $module = 'Mouse';
            $module.= '::Role' if $param && ($param eq 'Role');
            return Tangerine::HookData->new(
                modules => { $module => Tangerine::Occurence->new },
                );
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::anymoose - Process C<use Any::Moose> statements.

=head1 DESCRIPTION

This hook catches C<use Any::Moose> statements, and simply translates
them into C<use Mouse> or C<use Mouse::Role>.  Please, note L<Any::Moose>
is deprecated.  This module is for legacy code only.

=head1 SEE ALSO

L<Tangerine>, L<Any::Moose>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
