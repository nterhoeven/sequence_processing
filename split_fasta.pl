#!/usr/bin/env perl

=head1 NAME

    split fasta

=head1 DESCRIPTION

    This script takes a fasta file and creates individual files for all sequences.

    This script will also clean the fasta file: Linebreaks in the sequence as well as empty
    lines and leading whitespaces in headers (> id) are removed by default. Additionally,
    non ACGT charachters can be converted to N and lowercase sequence characters can be 
    converted to uppercase.
    

=head1 SYNOPSIS
    
    ./split_fasta.pl [--convert-to-N --uppercase --debug --out <base>] --in <input.fa>

=head1 OPTIONS

=over

=back

=head2 required

=over

=item --in

    Fasta file to be sampled from


=back

=head2 optional

=over

=item --out

    Base of the output files. Default: input.fa.name
    where name is the sequence ID

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
                out|o=s
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


#set output file
unless(exists $opt{out})
{
    $opt{"out"}=$opt{"in"};
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
    my$head=shift(@obj);
    $head=~s/^>//g;
    $head=~s/^\s+//g;

    (my$id)=$head=~/(\S+)/;

    my$seq=join("",@obj);
    $seq=~s/>//g;
    $seq=uc($seq) if $opt{'uppercase'};
    $seq=~s/[^ACGTacgt]/N/g if $opt{'convert-to-N'};
    
    my$outfile=$opt{out}.".".$id;
    if(exists $fasta{$id})
    {
	$L->warn("found duplicate for $id - Adding a unique tag to the output file name.\nYou might want to deduplicate your fasta file first.");
	$outfile=$outfile."_".$fasta{$id};
    }

    $fasta{$id}++;
    
    
    
# print sequence to file
    open(OUT, '>', $outfile) or $L->logdie($!);
    print OUT ">",$head,"\n",$seq,"\n";
    close OUT or die $L->logdie($!);



}

close IN or $L->logdie($!);

$L->info("done");
