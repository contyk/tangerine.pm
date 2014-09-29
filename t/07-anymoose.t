use strict;
use warnings;
use Test::More tests => 9;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/anymoose');

ok($scanner->run, 'Any::Moose run');

my %expected = (
    'Any::Moose' => {
        count => 6,
        lines => [ 1 .. 6 ],
    },
    Mouse => {
        count => 4,
        lines => [ 1, 3, 4, 6 ],
    },
    'Mouse::Role' => {
        count => 2,
        lines => [ 2, 5 ],
    },
);

is_deeply([sort keys $scanner->uses], [sort keys %expected], 'Any::Moose uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "Any::Moose uses count ($_)");
    is_deeply([ sort map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "Any::Moose uses line number ($_)");
}
is($scanner->uses->{'Any::Moose'}->[3]->version, '0.18', 'Any::Moose version');
