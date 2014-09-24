use strict;
use warnings;
use Test::More tests => 17;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/anymoose');

ok($scanner->run, 'If run');

my %expected = (
    'Any::Moose' => {
        count => 2,
        lines => [ 1, 2 ],
    },
    Mouse => {
        count => 2,
        lines => [ 1, 2 ],
    },
);

is_deeply([sort keys $scanner->uses], [sort keys %expected], 'Any::Moose uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "Any::Moose uses count ($_)");
    is_deeply([ sort map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "Any::Moose uses line number ($_)");
}
is($scanner->uses->{Any::Moose}->[1]->version, '0.18', 'Any::Moose version');
