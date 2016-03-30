#!/usr/bin/env perl

=head1 NAME

    sample from fasta

=head1 DESCRIPTION

    This script takes a fasta file and a number of sequences (n) to sample. It writes n 
    randomly selected sequences to the output file.

    This script can also clean the fasta file: Linebreaks in the sequence as well as empty
    lines and leading whitespaces in headers (> id) are removed by default. Additionally,
    non ACGT charachters can be converted to N and lowercase sequence characters can be 
    converted to uppercase.
    

=head1 SYNOPSIS
    
    ./sample_from_fasta.pl [--convert-to-N --uppercase --debug --outfile <outfile.fa>] --in <input.fa> --number-of-seqs|-n <Number of Sequences to sample>

=head1 OPTIONS

=over

=back

=head2 required

=over

=item --in

    Fasta file to be sampled from

=item --number-of-seqs | -n

    Number of sequences, that should be written to <outfile.fa>

=back

=head2 optional

=over

=item --outfile

    Name of the output file. Default: input.fa.sampled-n 
    (Where n is the number specified)

=item --convert-to-N

    convert non ACGT charachters to N

=item --uppercase

    convert lowercase acgt to uppercase ACGT

=item --debug

    Verbose debug messages.

=item -V|--version

    Display version.

=item -h|--help

    Display this help.

=item --man

    Display man page

=back

=head1 CHANGELOG

see git log.

=head1 TODO

=head1 CODE

=cut

#-----------------------------------------------------------------------------#
# Modules

# core
use strict;
use warnings;
no warnings 'qw';

use Getopt::Long qw(:config no_ignore_case bundling);
use Pod::Usage;
use Log::Log4perl qw(:no_extra_logdie_message);
use Log::Log4perl::Level;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

#-----------------------------------------------------------------------------#
# Globals

our $VERSION = 0.01;

# get a logger
my $L = Log::Log4perl::get_logger();
Log::Log4perl->init( \q(
	log4perl.rootLogger                     = INFO, Screen
	log4perl.appender.Screen                = Log::Log4perl::Appender::Screen
	log4perl.appender.Screen.stderr         = 1
	log4perl.appender.Screen.layout         = PatternLayout
	log4perl.appender.Screen.layout.ConversionPattern = [%d{yy-MM-dd HH:mm:ss}] [%C] %m%n
));


#-----------------------------------------------------------------------------#
# GetOptions
my%opt;
GetOptions( # use %opt (Cfg) as defaults
	\%opt, qw(
                uppercase
                convert-to-N
                in|i=s
                outfile|o=s
                number-of-seqs|n=s
		version|V!
		debug|D!
		help|h!
                man!
	)
) or $L->logcroak('Failed to "GetOptions"');

# help
$opt{help} && pod2usage(-verbose=>1);
$opt{man} && pod2usage(-verbose=>2);

# version
if($opt{version}){
	print "$VERSION\n"; 
	exit 0;
}

$L->level($DEBUG) if $opt{debug};
$L->debug('Verbose level set to DEBUG');

$L->debug(Dumper(\%opt));

# required stuff  
for(qw(in number-of-seqs)){
       pod2usage("required: --$_") unless defined ($opt{$_})
};

#set output file
unless(exists $opt{outfile})
{
    $opt{"outfile"}=$opt{"in"}.".sampled-".$opt{"number-of-seqs"};
}


#-----------------------------------------------------------------------------#
# MAIN

$L->info('reading input from ',$opt{in});

open(IN,'<',$opt{in}) or $L->logdie($!);
$/="\n>";
my%fasta;

while(<IN>)
{
    my@obj=split(/\n/,$_);
    
    #get header and remove > and leading whitespace
    my$id=shift(@obj);
    $id=~s/^>//g;
    $id=~s/^\s+//g;

    my$seq=join("",@obj);
    $seq=~s/>//g;
    $seq=uc($seq) if $opt{'uppercase'};
    $seq=~s/[^ACGTacgt]/N/g if $opt{'convert-to-N'};
    
    $L->warn("found duplicate for $id.\nYou might want to deduplicate your fasta file first.") if exists $fasta{$id};

    $fasta{$id}=$seq;
}

close IN or $L->logdie($!);

$L->info("finished reading");
$L->info("starting sampling ",$opt{"number-of-seqs"}," sequences");
$L->info("writing output to ",$opt{outfile});


open(OUT,'>',$opt{outfile}) or $L->logdie($!);
my$count=0;
my@IDs=keys(%fasta);
my$numSeqs=@IDs+0;


while($count < $opt{"number-of-seqs"})
{
    my$index=int(rand($numSeqs)); #get random index
    $L->debug("index: ",$index);
    my$id=$IDs[$index];
    print OUT ">",$id,"\n",$fasta{$id},"\n";  #print sequence

    #remove index from pool 
    splice(@IDs, $index, 1);
    $numSeqs--;
    $count++;
}

close OUT or $L->logdie($!);

$L->info("done");



































#-----------------------------------------------------------------------------#

=head1 AUTHOR

Niklas Terhoeven S<niklas.terhoeven@uni-wuerzburg.de>

=cut















