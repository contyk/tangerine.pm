use strict;
use warnings;
use Test::More tests => 20;
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
    aliased => {
        count => 1,
        lines => [ 3 ],
    },
    base => {
        count => 3,
        lines => [ 1, 4, 5 ],
    },
    parent => {
        count => 1,
        lines => [ 2 ],
    },
);

is_deeply([sort keys $scanner->uses], [sort keys %expected], 'List uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "List uses count ($_)");
    is_deeply([ sort map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "List uses line number ($_)");
}
