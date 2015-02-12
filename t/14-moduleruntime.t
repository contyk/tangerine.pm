use strict;
use warnings;
use Test::More tests => 13;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/moduleruntime');

ok($scanner->run, 'Module::Runtime run');

my %expecteduse = (
    'Module::Runtime' => {
        count => 1,
        lines => [ 1 ],
    },
);
my %expectedreq = (
    Alfa => {
        count => 1,
        lines => [ 2 ],
    },
    Bravo => {
        count => 1,
        lines => [ 3 ],
    },
    Charlie => {
        count => 1,
        lines => [ 4 ],
    },
);

is_deeply([sort keys %{$scanner->uses}], [sort keys %expecteduse], 'Module::Runtime uses');
for (sort keys %expecteduse) {
    is(scalar @{$scanner->uses->{$_}}, $expecteduse{$_}->{count},
        "Module::Runtime uses count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->uses->{$_}} ],
        $expecteduse{$_}->{lines}, "Module::Runtime uses line number ($_)");
}
is_deeply([sort keys %{$scanner->requires}], [sort keys %expectedreq], 'Module::Runtime requires');
for (sort keys %expectedreq) {
    is(scalar @{$scanner->requires->{$_}}, $expectedreq{$_}->{count},
        "Module::Runtime requires count ($_)");
    is_deeply([ sort { $a <=> $b } map { $_->line } @{$scanner->requires->{$_}} ],
        $expectedreq{$_}->{lines}, "Module::Runtime requires line number ($_)");
}
is($scanner->requires->{Bravo}->[0]->version, '1.23', 'Module::Runtime Bravo version');
is($scanner->requires->{Charlie}->[0]->version, '4.567', 'Module::Runtime Charlie version');
