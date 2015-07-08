#!/usr/bin/env perl

=head1 NAME

    remove duplicates

=head1 DESCRIPTION

    This script takes a fasta file from STDIN, removes duplicated sequences
    and writes the output to STDOUT.

    Sequences will be deleted, if they have an identical header and an identical sequence.
    This script can also clean the fasta file: Linebreaks in the sequence as well as empty
    lines and leading whitespaces in headers (> id) are removed by default. Additionally,
    non ACGT charachters are converted to N. This feature can be skipped using the --no-convert
    option. The script also converts lowercase sequence characters to uppercase. This can be 
    skipped with the --no-up option.
    

=head1 SYNOPSIS
    
    cat <input.fa> | remove_duplicates [--no-convert --no-up --debug] > output.fa

=head1 OPTIONS

=over

=item --no-convert

    skip converting non ACGT charachters to N

=item --no-up

    skip converting lowercase acgt to uppercase ACGT

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

use Carp;
use Getopt::Long qw(:config no_ignore_case bundling);
use Pod::Usage;
use Log::Log4perl qw(:no_extra_logdie_message);
use Log::Log4perl::Level;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

use FindBin qw($RealBin);
use lib "$RealBin/../lib/";

use File::Basename;
use File::Copy;


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
                no-up
                no-convert
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



#-----------------------------------------------------------------------------#
# MAIN

$L->info('reading input from STDIN');
$/="\n>";

my%fasta;

while(<STDIN>)
{
    my@obj=split(/\n/,$_);
    
    #get header and remove > and leading whitespace
    my$id=shift(@obj);
    $id=~s/^>//g;
    $id=~s/^\s+//g;

    my$seq=join("",@obj);
    $seq=~s/>//g;
    $seq=uc($seq) unless $opt{'no-up'};
    $seq=~s/[^ACGTacgt]/N/g unless $opt{'no-convert'};
    
    if(exists $fasta{$id})
    {
	if($fasta{$id} eq $seq)
	{
	    $L->info("found duplicate for $id");
	}
	else
	{
	    $L->warn("found two sequences with the same ID ($id), but different sequences
using '$id.2' as header");
	    print ">",$id.".2","\n",$seq,"\n";
	}
    }
    else
    {
	print ">",$id,"\n",$seq,"\n";
	$fasta{$id}=$seq;
    }
}

$L->info("done");



































#-----------------------------------------------------------------------------#

=head1 AUTHOR

Niklas Terhoeven S<niklas.terhoeven@uni-wuerzburg.de>

=cut















