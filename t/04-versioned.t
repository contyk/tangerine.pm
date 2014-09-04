use strict;
use warnings;
use Test::More tests => 5;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/versioned');

ok($scanner->run, 'Versioned run');

is_deeply([sort keys $scanner->uses], [qw/Foo/], 'Versioned uses');
is(scalar @{$scanner->uses->{Foo}}, 4, 'Prefixed list uses count');
is_deeply([ sort map { $_->line } @{$scanner->uses->{Foo}} ],
    [ 1 .. 4 ], 'Versioned line numbers');
is_deeply([ sort map { $_->version } @{$scanner->uses->{Foo}} ],
    [ qw/1.00 1.01 1.02 1.99/ ], 'Versioned versions');
