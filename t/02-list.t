use strict;
use warnings;
use Test::More tests => 28;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/list');

ok($scanner->run, 'List run');

my %expected = (
    Alfa => {
        count => 1,
        lines => [ 1 ],
    },
    Beta => {
        count => 1,
        lines => [ 2 ],
    },
    Charlie => {
        count => 1,
        lines => [ 2 ],
    },
    'Delta::Echo::Foxtrot' => {
        count => 1,
        lines => [ 3 ],
    },
    Golf => {
        count => 1,
        lines => [ 4 ],
    },
    Hotel => {
        count => 1,
        lines => [ 5 ],
    },
    India => {
        count => 1,
        lines => [ 6 ],
    },
    Julliet => {
        count => 1,
        lines => [ 7 ],
    },
    Lima => {
        count => 1,
        lines => [ 9 ],
    },
    aliased => {
        count => 2,
        lines => [ 3, 9 ],
    },
    base => {
        count => 4,
        lines => [ 1, 4, 5, 8 ],
    },
    ok => {
        count => 2,
        lines => [ 6, 7 ],
    },
    parent => {
        count => 1,
        lines => [ 2 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expected], 'List uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "List uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "List uses line number ($_)");
}
