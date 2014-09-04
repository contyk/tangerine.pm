use strict;
use warnings;
use Test::More tests => 12;
use Test::Script;

for my $file (qw(
    bin/tangerine
    lib/Tangerine.pm
    lib/Tangerine/HookData.pm
    lib/Tangerine/Hook.pm
    lib/Tangerine/Occurence.pm
    lib/Tangerine/Utils.pm
    lib/Tangerine/hook/if.pm
    lib/Tangerine/hook/list.pm
    lib/Tangerine/hook/package.pm
    lib/Tangerine/hook/prefixedlist.pm
    lib/Tangerine/hook/require.pm
    lib/Tangerine/hook/use.pm
    )) {
        script_compiles($file, '$file compiles');
    }
