use strict;
use warnings;
use Test::More tests => 19;

for my $module (qw/
    Tangerine
    Tangerine::Hook
    Tangerine::HookData
    Tangerine::Occurence
    Tangerine::Utils
    Tangerine::hook::anymoose
    Tangerine::hook::if
    Tangerine::hook::inline
    Tangerine::hook::list
    Tangerine::hook::moduleruntime
    Tangerine::hook::mooselike
    Tangerine::hook::package
    Tangerine::hook::prefixedlist
    Tangerine::hook::require
    Tangerine::hook::testloading
    Tangerine::hook::testrequires
    Tangerine::hook::tests
    Tangerine::hook::use
    Tangerine::hook::xxx
    /) {
    use_ok $module;
}
