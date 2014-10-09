use strict;
use warnings;
use Test::More tests => 28;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/prefixedlist');

ok($scanner->run, 'Prefixed list run');

my %expected = (
    Inline => {
        count => 3,
        lines => [ 4 .. 6 ],
    },
    'Inline::C' => {
        count => 1,
        lines => [ 4 ],
    },
    'Inline::Java' => {
        count => 1,
        lines => [ 6 ],
    },
    'Inline::X' => {
        count => 1,
        lines => [ 5 ],
    },
    Mo => {
        count => 2,
        lines => [ 1, 9 ],
    },
    'Mo::default' => {
        count => 1,
        lines => [ 1 ],
    },
    'Mo::xs' => {
        count => 1,
        lines => [ 1 ],
    },
    POE => {
        count => 2,
        lines => [ 2, 3 ],
    },
    'POE::Alpha' => {
        count => 1,
        lines => [ 2 ],
    },
    'POE::Bravo' => {
        count => 1,
        lines => [ 2 ],
    },
    'POE::Charlie' => {
        count => 1,
        lines => [ 2 ],
    },
    'POE::Delta' => {
        count => 1,
        lines => [ 2 ],
    },
    'POE::Echo' => {
        count => 2,
        lines => [ 2, 3 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expected], 'Prefixed list uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "Prefixed list uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "Prefixed list uses line number ($_)");
}
