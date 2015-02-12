package Tangerine::hook::moduleruntime;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any none);
use Mo;
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

extends 'Tangerine::Hook';

sub run {
    my ($self, $s) = @_;
    my @routines = qw(require_module use_module use_package_optimistically);
    if ((any { $s->[0] eq $_ } qw(use no)) && scalar(@$s) > 1 &&
        $s->[1] eq 'Module::Runtime') {
        return Tangerine::HookData->new( hooks => [
                Tangerine::hook::moduleruntime->new(type => 'req') ] );
    }
    # NOTE: For the sake of simplicity, we only check for one subroutine
    #       call per statement.
    if ($self->type eq 'req' && any { my $f = $_; any { $_ eq $f } @$s }
        @routines) {
        while (none { $s->[0] eq $_ } @routines) {
            shift @$s;
        }
        for (my $clip = 0; $clip <= $#$s && $clip < 3; $clip++) {
            if (any { $s->[$clip] eq $_ } qw(-> ;)) {
                @$s = @$s[0..$clip-1];
                last
            }
        }
        my @args = stripquotelike(@$s[1..$#$s]);
        return Tangerine::HookData->new(
            modules => {
                    $args[0] => Tangerine::Occurence->new(
                        version => $args[1]
                    ),
                },
            );
    }
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::moduleruntime - Process runtime module loading functions.

=head1 DESCRIPTION

This hook parses L<Module::Runtime> module loading functions -
C<require_module>, C<use_module> and C<use_package_optimistically>.

=head1 SEE ALSO

L<Module::Runtime>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
