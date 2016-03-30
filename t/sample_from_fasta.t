#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
BEGIN { is(-e '../sample_from_fasta.pl', 1, 'file exists') };

# my$exp=`cat expected_samples.fa`;
# is(`cat input.fa | ../sample_from_fasta.pl` ,$exp, 'sample 3 sequences');
