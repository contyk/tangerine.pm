package Tangerine::hook::require;
use strict;
use warnings;
use Tangerine::HookData;
use Tangerine::Occurence;

sub run {
    my $s = shift;
    if (scalar(@$s) > 1 && $s->[0] eq 'require') {
        return if $s->[1] eq ';';
        my $module = $s->[1];
        return Tangerine::HookData->new(
            modules => { $module => Tangerine::Occurence->new },
            ) unless $module =~ /^v?5\..*$/;
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::require - Process C<require> statements.

=head1 DESCRIPTION

This is a basic C<req> type hook, simply looking for C<require> statements.

=head1 SEE ALSO

L<Tangerine>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
