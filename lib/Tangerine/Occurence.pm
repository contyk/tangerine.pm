package Tangerine::Occurence;
use strict;
use warnings;
use Mo qw(default);

has version => '';
has line => 0;
has extra => {};

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::Occurence - A simple object describing a provide, require or
use-like statement occurence in the analysed document.

=head1 DESCRIPTION

Instances of this object are returned by C<provides>, C<requires> and
C<uses> L<Tangerine> methods.

=head1 METHODS

=over

=item C<line>

Returns the line number of this particular occurence.

=item C<version>

Returns the required version of a used module, if applicable.

=item C<extra>

Returns a hash reference with additional extra flags.  This is currently unused.

=back

=head1 SEE ALSO

L<Tangerine>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
