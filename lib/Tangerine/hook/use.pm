package Tangerine::hook::use;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any);
use Tangerine::HookData;
use Tangerine::Occurence;

sub run {
    my $s = shift;
    if (scalar(@$s) >= 2 && (any { $s->[0] eq $_ } qw(use no))) {
        my $module = $s->[1];
        my ($version) = $s->[2] && $s->[2] =~ /^(\d.*)$/o;
        $version //= '';
        return Tangerine::HookData->new(
            modules => {
                $module => Tangerine::Occurence->new(
                    version => $version,
                    ),
                },
            ) unless $module =~ /^v?5\..*$/;
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::use - Process C<use> statements.

=head1 DESCRIPTION

This is a basic C<use> type hook, simply looking for C<use> statements,
not doing anything fancy.

=head1 SEE ALSO

L<Tangerine>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata.

See LICENSE for licensing details.

=cut
