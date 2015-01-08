use strict;
use warnings;
use Test::More tests => 10;
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
        count => 1,
        lines => [ 3 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'XXX uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "XXX uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "XXX uses line numbers ($_)");
}
