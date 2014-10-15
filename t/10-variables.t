use strict;
use warnings;
use Test::More tests => 7;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/variables');

ok($scanner->run, 'Variables run');

my %expecteduses = (
    Echo => {
        count => 1,
        lines => [ 5 ],
    },
);

my %expectedrequires = (
    Foxtrot => {
        count => 1,
        lines => [ 6 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'Variables uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "Variables uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "Variables uses line numbers ($_)");
}
is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedrequires], 'Variables requires');
for (sort keys %expectedrequires) {
    is(scalar @{$scanner->requires->{$_}}, $expectedrequires{$_}->{count},
        "Variables requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedrequires{$_}->{lines}, "Variables requires line numbers ($_)");
}
