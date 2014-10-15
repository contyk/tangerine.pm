use strict;
use warnings;
use Test::More tests => 15;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/xxx');

ok($scanner->run, 'XXX run');

my %expecteduses = (
    'Data::Dump::Color' => {
        count => 1,
        lines => [ 4 ],
    },
    'Data::Dumper' => {
        count => 1,
        lines => [ 2 ],
    },
    XXX => {
        count => 4,
        lines => [ 1 .. 4 ],
    },
    YAML => {
        count => 2,
        lines => [ 1, 3 ],
    },
);

my %expectedrequires = (
    XXX => {
        count => 1,
        lines => [ 5 ],
    },
    YAML => {
        count => 1,
        lines => [ 5 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'XXX uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "XXX uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "XXX uses line numbers ($_)");
}
is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedrequires], 'XXX requires');
for (sort keys %expectedrequires) {
    is(scalar @{$scanner->requires->{$_}}, $expectedrequires{$_}->{count},
        "XXX requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedrequires{$_}->{lines}, "XXX requires line numbers ($_)");
}
