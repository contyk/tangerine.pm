package Tangerine::hook::list;
use 5.010;
use strict;
use warnings;
use List::MoreUtils qw(any);
use Tangerine::HookData;
use Tangerine::Occurence;
use Tangerine::Utils qw(stripquotelike);

sub run {
    my $s = shift;
    if ((any { $s->[0] eq $_ } qw(use no)) && scalar(@$s) > 2 &&
        (any { $s->[1] eq $_ } qw(aliased base ok parent))) {
        my ($version) = $s->[2] =~ /^(\d.*)$/o;
        $version //= '';
        my $voffset = $version ? 3 : 2;
        my @args;
        if (scalar(@$s) > $voffset) {
            return if $s->[$voffset] eq ';';
            @args = @$s;
            @args = @args[($voffset) .. $#args];
            @args = grep { !/^-norequire$/ } @args
                if $s->[1] eq 'parent';
            @args = stripquotelike(@args);
        }
        @args = $args[0] if $s->[1] eq 'ok';
        return Tangerine::HookData->new(
            modules => {
                map {
                    ( $_ => Tangerine::Occurence->new() )
                    } @args,
                },
            );
    }
    return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine::hook::list - Process simple module lists.

=head1 DESCRIPTION

This hook catches C<use> statements with modules loading more modules
listed as their arguments.

Currently this hook knows about L<aliased>, L<base>, L<Test::use::ok>
and L<parent>.

=head1 SEE ALSO

L<Tangerine>, L<aliased>, L<base>, L<Test::use::ok>, L<parent>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
