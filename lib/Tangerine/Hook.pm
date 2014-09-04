package Tangerine::Hook;
use strict;
use warnings;
use Mo qw(default xs);

has type => '';
has run => undef;

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::Hook - A simple hook object.

=head1 SYNOPSIS

    my $hook = Tangerine::Hook->new(
        type => 'prov',
        run => \&Tangerine::hook::package::run
    );
    $hook->run([ qw/use strict ;/]);

=head1 DESCRIPTION

Hooks hold a code reference to the actual hook routine.  They also have
a type property which may be one of C<prov>, C<req> or C<use> to denote
whether this hook is returns provided modules or modules required at
run-time or compile-time respectively.

Code references expect a statement to process.  This is simply a list
reference of L<PPI::Statement>'s significant children.

=head1 METHODS

=over

=item C<type>

Returns or sets the hook type.  May be one of C<prov>, C<req> or C<use>.

=item C<run>

Returns or set the hook code reference.

=back

=head1 SEE ALSO

C<Tangerine>, C<PPI::Statement>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
