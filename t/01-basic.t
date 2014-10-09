use strict;
use warnings;
use Test::More tests => 18;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/basic');

ok($scanner->run, 'Basic run');

is_deeply([sort keys %{$scanner->provides}], [qw/Alfa/], 'Basic provides');
is(scalar @{$scanner->provides->{Alfa}}, 1, 'Basic provides count');
is($scanner->provides->{Alfa}->[0]->line, 1, 'Basic provides line number');

is_deeply([sort keys %{$scanner->requires}], [qw/Echo Foxtrot Golf/], 'Basic requires');
is(scalar @{$scanner->requires->{Echo}}, 1, 'Basic requires count (Echo)');
is(scalar @{$scanner->requires->{Foxtrot}}, 1, 'Basic requires count (Foxtrot)');
is(scalar @{$scanner->requires->{Golf}}, 1, 'Basic requires count (Golf)');
is($scanner->requires->{Echo}->[0]->line, 6, 'Basic requires line number (Echo)');
is($scanner->requires->{Foxtrot}->[0]->line, 7, 'Basic requires line number (Foxtrot)');
is($scanner->requires->{Golf}->[0]->line, 8, 'Basic requires line number (Golf)');

my %expected = (
    Bravo => {
        count => 2,
        lines => [ 2, 3 ],
    },
    Charlie => {
        count => 1,
        lines => [ 4 ],
    },
    Delta => {
        count => 1,
        lines => [ 5 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expected], 'Basic uses');
for (sort keys %expected) {
    is(scalar @{$scanner->uses->{$_}}, $expected{$_}->{count},
        "Basic uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expected{$_}->{lines}, "Basic uses line number ($_)");
}
