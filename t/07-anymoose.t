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

is_deeply([sort keys %{$scanner->compile}], [sort keys %expected], 'Any::Moose compile');
for (sort keys %expected) {
    is(scalar @{$scanner->compile->{$_}}, $expected{$_}->{count},
        "Any::Moose compile count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->compile->{$_}} ],
        $expected{$_}->{lines}, "Any::Moose compile line number ($_)");
}
is($scanner->compile->{'Any::Moose'}->[3]->version, '0.18', 'Any::Moose version');
