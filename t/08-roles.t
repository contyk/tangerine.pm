use strict;
use warnings;
use Test::More tests => 15;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/roles');

ok($scanner->run, 'Roles run');

my %expecteduses = (
    Mo => {
        count => 3,
        lines => [ 2 .. 4 ],
    },
    Moose => {
        count => 1,
        lines => [ 7 ],
    },
);

my %expectedrequires = (
    LoadThisInstead => {
        count => 1,
        lines => [ 8 ],
    },
    UsedRole1 => {
        count => 1,
        lines => [ 9 ],
    },
    UsedRole2 => {
        count => 1,
        lines => [ 10 ],
    },
    UsedRole3 => {
        count => 1,
        lines => [ 10 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'Roles uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "Roles uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "Roles uses line numbers ($_)");
}
is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedrequires], 'Roles requires');
for (sort keys %expectedrequires) {
    is(scalar @{$scanner->requires->{$_}}, $expectedrequires{$_}->{count},
        "Roles requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedrequires{$_}->{lines}, "Roles requires line numbers ($_)");
}
