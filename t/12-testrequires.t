use strict;
use warnings;
use Test::More tests => 28;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/testrequires');

ok($scanner->run, 'Test::Requires run');

my %expecteduses = (
    Alfa => {
        count => 1,
        lines => [ 1 ],
    },
    Beta => {
        count => 1,
        lines => [ 1 ],
    },
    Charlie => {
        count => 1,
        lines => [ 1 ],
    },
    Delta => {
        count => 1,
        lines => [ 2 ],
    },
    Echo => {
        count => 1,
        lines => [ 2 ],
    },
    Foxtrot => {
        count => 1,
        lines => [ 2 ],
    },
    Golf => {
        count => 1,
        lines => [ 3 ],
    },
    Hotel => {
        count => 1,
        lines => [ 3 ],
    },
    'Test::Requires' => {
        count => 3,
        lines => [ 1 .. 3 ],
    },
);

my %expectedreqs = (
    India => {
        count => 1,
        lines => [ 7 ],
    },
    Juliett => {
        count => 1,
        lines => [ 8 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduses], 'Test::Requires uses');
for (sort keys %expecteduses) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduses{$_}->{count},
        "Test::Requires uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduses{$_}->{lines}, "Requires uses line numbers ($_)");
}

is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedreqs], 'Test::Requires requires');
for (sort keys %expectedreqs) {
    is(scalar @{$scanner->requires->{$_}}, $expectedreqs{$_}->{count},
        "Test::Requires requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedreqs{$_}->{lines}, "Requires requires line numbers ($_)");
}

is($scanner->uses->{Golf}->[0]->version, '1.00', 'Test::Requires Golf version');
is($scanner->uses->{Hotel}->[0]->version, '2.00', 'Test::Requires Hotel version');
is($scanner->requires->{Juliett}->[0]->version, '3.00', 'Test::Requires Juliett version');
