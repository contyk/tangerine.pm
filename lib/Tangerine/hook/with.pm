package Tangerine::hook::with;
use strict;
use warnings;
use Mo;
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

extends 'Tangerine::Hook';

sub run {
    my ($self, $s) = @_;
    if (scalar(@$s) > 1 && $s->[0] eq 'with') {
        return if $s->[1] eq ';';
        my @modules = stripquotelike((@$s)[1..$#$s]);
        return Tangerine::HookData->new(
            modules => { map { ($_ => Tangerine::Occurence->new) } @modules },
            );
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::with - Process C<with> statements.

=head1 DESCRIPTION

Detect C<with> statements from L<Moose>, L<Mouse>, L<Moo> or L<Mo>
modules.  This is C<require>-style dependency.

=head1 SEE ALSO

L<Tangerine>, L<Moose>, L<Mouse>, L<Moo>, L<Mo>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
