package Tangerine::Hook;
use strict;
use warnings;
use Tangerine::Utils qw/accessor/;

sub new {
    my $class = shift;
    my %args = @_;
    bless {
        _type => $args{type},
    }, $class
}

sub type { accessor _type => @_ }

sub run {
    warn "Hook run() method not implemented."
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::Hook - A simple hook class.

=head1 SYNOPSIS

    package MyHook;
    use Mo;
    use Tangerine::HookData;
    use Tangerine::Occurence;
    extends 'Tangerine::Hook';

    sub run {
        my ($self, $s) = @_;
        if ($s->[0] eq 'use' && $self->type eq 'use' &&
            $s->[1] && $s->[1] eq 'MyModule') {
            return Tangerine::HookData->new(
                modules => { MyModule => Tangerine::Occurence->new },
            )
        }
        return
    }

=head1 DESCRIPTION

Hooks are the workhorses of Tangerine, examining the actual code and
returning L<Tangerine::HookData> where applicable.

Every hook has a type, which can be one of 'prov', 'req' or 'use',
set by the caller and determining what she is interested in.

Every hook should implement the C<run> method which is passed an array
reference containing the significant children (see L<PPI::Statement>)
of the currently parsed Perl statement.

The caller expects a L<Tangerine::HookData> instance defining what
C<modules> of the requested C<type> we found, what C<hooks> the caller
should register or what C<children> shall be examined next.  Either or
all these may be returned at once.

=head1 METHODS

=over

=item C<type>

Returns or sets the hook type.  May be one of C<prov>, C<req> or C<use>.

=item C<run>

This is called by L<Tangerine> with an array reference containing the
significant children of the currently parsed Perl statement.  Returns a
L<Tangerine::HookData> instance.

Every hook needs to implement this method.

=back

=head1 SEE ALSO

C<Tangerine>, C<PPI::Statement>, C<Tangerine::HookData>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015 Petr Šabata

See LICENSE for licensing details.

=cut
