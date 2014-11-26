use strict;
use warnings;
use Test::More tests => 23;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/roles');

ok($scanner->run, 'Roles run');

my %expecteduses = (
    Moose => {
        count => 1,
        lines => [ 1 ],
    },
);

my %expectedrequires = (
    Alfa => {
        count => 1,
        lines => [ 2 ],
    },
    Beta => {
        count => 1,
        lines => [ 2 ],
    },
    Charlie => {
        count => 1,
        lines => [ 4 ],
    },
    Delta => {
        count => 1,
        lines => [ 4 ],
    },
    Echo => {
        count => 1,
        lines => [ 5 ],
    },
    Foxtrot => {
        count => 1,
        lines => [ 5 ],
    },
    Golf => {
        count => 1,
        lines => [ 6 ],
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

is($scanner->requires->{Alfa}->[0]->version, 0.01, 'Roles - Alfa version');
is($scanner->requires->{Beta}->[0]->version, 0.02, 'Roles - Beta version');
is($scanner->requires->{Foxtrot}->[0]->version, 0.03, 'Roles - Foxtrot version');
is($scanner->requires->{Golf}->[0]->version, 0.04, 'Roles - Golf version');
