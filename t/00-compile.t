use strict;
use warnings;
use Test::More tests => 18;
use Test::Script;

for my $file (qw(
    bin/tangerine
    lib/Tangerine.pm
    lib/Tangerine/HookData.pm
    lib/Tangerine/Hook.pm
    lib/Tangerine/Occurence.pm
    lib/Tangerine/Utils.pm
    lib/Tangerine/hook/anymoose.pm
    lib/Tangerine/hook/extends.pm
    lib/Tangerine/hook/if.pm
    lib/Tangerine/hook/list.pm
    lib/Tangerine/hook/mooselike.pm
    lib/Tangerine/hook/package.pm
    lib/Tangerine/hook/prefixedlist.pm
    lib/Tangerine/hook/require.pm
    lib/Tangerine/hook/tests.pm
    lib/Tangerine/hook/testloading.pm
    lib/Tangerine/hook/use.pm
    lib/Tangerine/hook/with.pm
    )) {
        script_compiles($file, '$file compiles');
    }
