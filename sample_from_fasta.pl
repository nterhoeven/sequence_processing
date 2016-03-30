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



exit;
#-----------------------------------------------------------------------------#
# MAIN

# $L->info('reading input from STDIN');
# $/="\n>";

# my%fasta;

# while(<STDIN>)
# {
#     my@obj=split(/\n/,$_);
    
#     #get header and remove > and leading whitespace
#     my$id=shift(@obj);
#     $id=~s/^>//g;
#     $id=~s/^\s+//g;

#     my$seq=join("",@obj);
#     $seq=~s/>//g;
#     $seq=uc($seq) unless $opt{'no-up'};
#     $seq=~s/[^ACGTacgt]/N/g unless $opt{'no-convert'};
    
#     if(exists $fasta{$id})
#     {
# 	if($fasta{$id} eq $seq)
# 	{
# 	    $L->info("found duplicate for $id");
# 	}
# 	else
# 	{
# 	    $L->warn("found two sequences with the same ID ($id), but different sequences
# using '$id.2' as header");
# 	    print ">",$id.".2","\n",$seq,"\n";
# 	}
#     }
#     else
#     {
# 	print ">",$id,"\n",$seq,"\n";
# 	$fasta{$id}=$seq;
#     }
# }

# $L->info("done");



































#-----------------------------------------------------------------------------#

=head1 AUTHOR

Niklas Terhoeven S<niklas.terhoeven@uni-wuerzburg.de>

=cut















