use strict;
use warnings;
use Test::More tests => 3;
use Tangerine;

my $scanner = Tangerine->new(file => 't/data/perlversion');

ok($scanner->run, 'Perlversion run');

is_deeply([keys $scanner->requires], [], 'Perlversion requires');
is_deeply([keys $scanner->uses], [], 'Perlversion uses');
