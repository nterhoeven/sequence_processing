#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
BEGIN { is(-e '../remove_duplicates', 1, 'file exists') };

my$exp=`cat expected-out-default.fa`;
is(`cat input.fa | ../remove_duplicates` ,$exp, 'run default');

$exp=`cat expected-out-no-conv.fa`;
is(`cat input.fa | ../remove_duplicates --no-convert` ,$exp, 'run --no-conv');

$exp=`cat expected-out-no-up.fa`;
is(`cat input.fa | ../remove_duplicates --no-up` ,$exp, 'run --no-up');

$exp=`cat expected-out-no-conv-up.fa`;
is(`cat input.fa | ../remove_duplicates --no-convert --no-up` ,$exp, 'run --no-conv --no-up');


done_testing();
