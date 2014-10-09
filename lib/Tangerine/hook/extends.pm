package Tangerine::hook::extends;
use strict;
use warnings;
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

sub run {
    my $s = shift;
    if (scalar(@$s) > 1 && $s->[0] eq 'extends') {
        return if $s->[1] eq ';';
        my $module = stripquotelike($s->[1]);
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

Tangerine::hook::extends - Process C<extends> statements.

=head1 DESCRIPTION

Detect C<extends> statements from L<Moose>, L<Mouse>, L<Moo> or L<Mo>
modules.  This is C<require>-style dependency.

=head1 SEE ALSO

L<Tangerine>, L<Moose>, L<Mouse>, L<Moo>, L<Mo>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
