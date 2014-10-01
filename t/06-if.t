use strict;
use warnings;
use Test::More tests => 17;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/if');

ok($scanner->run, 'If run');

my %expected = (
    if => {
        count => 5,
        lines => [ 1 .. 5 ],
    },
    Alfa => {
        count => 1,
        lines => [ 1 ],
    },
    Beta => {
        count => 1,
        lines => [ 2 ],
    },
    Delta => {
        count => 1,
        lines => [ 4 ],
    },
    Mo => {
        count => 1,
        lines => [ 5 ],
    },
    'Mo::default' => {
        count => 1,
        lines => [ 5 ],
    },
    'Mo::xs' => {
        count => 1,
        lines => [ 5 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expected], 'If uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "If uses count ($_)");
    is_deeply([ sort map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "If uses line number ($_)");
}
is($scanner->uses->{if}->[3]->version, '0.05', 'If version');
