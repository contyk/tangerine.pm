package Tangerine;
# ABSTRACT: Analyse perl files and report module-related information
use 5.010;
use strict;
use warnings;
use utf8;
use PPI;
use List::MoreUtils qw(none);
use Mo qw(default);
use Scalar::Util qw(blessed);
use Tangerine::Hook;
use Tangerine::Occurence;
use Tangerine::Utils qw(addoccurence);

has file => '';
has mode => 'all';
has provides => {};
has requires => {};
has uses => {};

my %hooks;
$hooks{prov} = [ qw(package) ];
$hooks{req} = [ qw(require xxx) ];
$hooks{use} = [ qw(use list prefixedlist anymoose if mooselike tests xxx) ];

sub run {
    my $self = shift;
    return 0 unless -r $self->file;
    $self->mode('all')
        unless $self->mode =~ /^(a(ll)?|p(rov)?|d(ep)?|r(eq)?|u(se)?)$/;
    my $document = PPI::Document->new($self->file, readonly => 1);
    return 0 unless $document;
    my $statements = $document->find('Statement') or return 1;
    my @hooks;
    for my $type (qw(prov req use)) {
        for my $hname (@{$hooks{$type}}) {
            my $hook = "Tangerine::hook::$hname";
            eval "require $hook";
            push @hooks, $hook->new(type => $type);
        }
    }
    @hooks = grep {
            if ($self->mode =~ /^a(ll)?$/o ||
                $_->type eq 'prov' && $self->mode =~ /^p/o ||
                $_->type eq 'req' && $self->mode =~ /^[dr]/o ||
                $_->type eq 'use' && $self->mode =~ /^[du]/o) {
                $_
            }
        } @hooks;
    my $children;
    STATEMENT: for my $statement (@$statements) {
        $children //= [ $statement->schildren ];
        if ($children->[1] &&
            ($children->[1] eq ',' || $children->[1] eq '=>')) {
            $children = undef;
            next STATEMENT
        }
        for my $hook (@hooks) {
            if (my $data = $hook->run($children)) {
                my $modules = $data->{modules};
                for my $k (keys %$modules) {
                    if ($k =~ /[\$%@\*]/o || $k =~ /^('|"|qq?\s*[^\w])/o) {
                        delete $modules->{$k};
                        next
                    }
                    $modules->{$k}->line($statement->line_number);
                }
                if ($hook->type eq 'prov') {
                    $self->provides(addoccurence($self->provides, $modules));
                } elsif ($hook->type eq 'req') {
                    $self->requires(addoccurence($self->requires, $modules));
                } elsif ($hook->type eq 'use') {
                    $self->uses(addoccurence($self->uses, $modules));
                }
                if ($data->{hooks}) {
                    for my $newhook (@{$data->{hooks}}) {
                        next if ($newhook->type eq 'prov') && ($self->mode =~ /^[dru]/o);
                        next if ($newhook->type eq 'req') && ($self->mode =~ /^[pu]/o);
                        next if ($newhook->type eq 'use') && ($self->mode =~ /^[pr]/o);
                        push @hooks, $newhook
                            if none {
                                blessed($newhook) eq blessed($_) &&
                                $newhook->type eq $_->type
                            } @hooks;
                    }
                }
                if ($data->{children}) {
                    $children = $data->{children};
                    redo STATEMENT;
                }
            }
        }
        $children = undef;
    }
    1;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tangerine - Analyse perl files and report module-related information

=head1 SYNOPSIS

    use Tangerine;
    use version 0.77;

    my $scanner = Tangerine->new(file => $file, mode => 'all');
    $scanner->run;

    print "$file contains the following modules: ".
        join q/, /, sort keys %{$scanner->provides}."\n";

    print "$file requires Exporter on the following lines: ".
        join q/, /, sort map $_->line, @{$scanner->requires->{Exporter}}."\n";

    my $v = 0;
    for ( @{$scanner->uses->{'Test::More'}}) {
        $v = $_->version if $_->version && qv($v) < qv($_->version)
    }
    print "The minimum version of Test::More required by $file is $v\n";

=head1 DESCRIPTION

Tangerine statically analyses perl files and reports various information
about provided, used (compile-time dependencies) and required (runtime
dependencies) modules.

Currently, PPI is used for the initial parsing and statement extraction.

=head1 CONSTRUCTOR

=over

=item C<new>

Creates the Tangerine object.  Takes the following two named arguments:

    'file', the file to analyse
    'mode', what should we look for; may be one of 'all', 'prov', 'dep',
        'req' or 'use'.  'dep' implies both 'req' and 'use'.  Single
        letter abbreviations are also accepted.

Both arguments are optional, however, 'file' needs to be set before
running the scanner, e.g.

    my $scanner = Tangerine->new;
    $scanner->file($file);
    $scanner->run;

=back

=head1 METHODS

=over

=item C<run>

Runs the analysis.

=item C<provides>

Returns a hash reference.  Keys are the modules provided, values
references to lists of Tangerine::Occurence objects.

=item C<requires>

Returns a hash reference.  Keys are the modules required at run-time,
values references to lists of Tangerine::Occurence objects.

=item C<uses>

Returns a hash reference.  Keys are the modules required at compile-time,
values references to lists of Tangerine::Occurence objects.

=back

=head1 SEE ALSO

L<Tangerine::Occurence>

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Petr Šabata

See LICENSE for licensing details.

=cut
