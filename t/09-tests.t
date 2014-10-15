use strict;
use warnings;
use Test::More tests => 35;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/tests');

ok($scanner->run, 'Tests run');

my %expecteduses = (
    'Test::More' => {
        count => 1,
        lines => [ 1 ],
    },
    Alfa => {
        count => 1,
        lines => [ 2 ],
    },
    Beta => {
        count => 1,
        lines => [ 3 ],
    },
    Charlie => {
        count => 1,
        lines => [ 4 ],
    },
    Delta => {
        count => 1,
        lines => [ 5 ],
    },
    Lima => {
        count => 1,
        lines => [ 13 ],
    },
    'Mike::November' => {
        count => 1,
        lines => [ 14 ],
    },
    Mo => {
        count => 3,
        lines => [ 9 .. 11 ],
    },
    'Mo::default' => {
        count => 2,
        lines => [ 9, 10 ],
    },
    'Mo::is' => {
        count => 2,
        lines => [ 9, 10 ],
    },
    'Mo::isa' => {
        count => 1,
        lines => [ 11 ],
    },
    'Mo::xs' => {
        count => 2,
        lines => [ 9, 10 ],
    },
    parent => {
        count => 1,
        lines => [ 13 ],
    },
);

my %expectedrequires = (
    Echo => {
        count => 1,
        lines => [ 6 ],
    },
    Foxtrot => {
        count => 1,
        lines => [ 7 ],
    },
    India => {
        count => 1,
        lines => [ 8 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'Tests uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "Tests uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "Tests uses line numbers ($_)");
}
is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedrequires], 'Tests requires');
for (sort keys %expectedrequires) {
    is(scalar @{$scanner->requires->{$_}}, $expectedrequires{$_}->{count},
        "Tests requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedrequires{$_}->{lines}, "Tests requires line numbers ($_)");
}
