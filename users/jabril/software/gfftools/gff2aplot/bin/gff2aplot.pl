#!/usr/bin/perl -w
# This is perl, version 5.005_03 built for i386-linux
#line 4663 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
#line 4744 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %                          GFF2APLOT                               %
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
#    Converting alignments in GFF format to PostScript dotplots.
# 
#     Copyright (C) 1999 - Josep Francesc ABRIL FERRANDO  
#                                  Thomas WIEHE                   
#                                 Roderic GUIGO SERRA       
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
# 
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#line 4665 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
#line 4738 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# $Id: gff2aplot.pl,v 1.1 2001-09-06 18:33:35 jabril Exp $
#line 4667 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
#line 305 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# MODULES
#
#line 377 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
use strict;
#
#line 4178 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$SIG{HUP}  = \&trap_signals_prog;
$SIG{ABRT} = \&trap_signals;
$SIG{INT}  = \&trap_signals;
$SIG{QUIT} = \&trap_signals;
$SIG{TERM} = \&trap_signals;
$SIG{KILL} = \&trap_signals;
$SIG{CHLD} = 'IGNORE';
#line 380 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
#line 660 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
use Getopt::Long;
Getopt::Long::Configure qw/ bundling /;
#line 4217 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
use Data::Dumper;
local $Data::Dumper::Purity = 0;
local $Data::Dumper::Deepcopy = 1;
#line 4316 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
use Benchmark;
  
#line 4328 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my @Timer = (new Benchmark);
#line 309 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# CONSTANTS
#
#line 384 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($T,$F) = (1,0); # for 'T'rue and 'F'alse
#line 396 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($PROGRAM,$VERSION,$REVISION,$REVISION_DATE,$LAST_UPDATE) = 
   ( 'gff2aplot','v2.0',
     '$Revision: 1.1 $', #'
     '$Date: 2001-09-06 18:33:35 $', #'
     '$Id: gff2aplot.pl,v 1.1 2001-09-06 18:33:35 jabril Exp $', #'
    );
$REVISION =~ s/\$//og;
$REVISION_DATE =~ s/\$//og;
#line 934 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $noCV = '?';
my %varkeys = (
    L => 'LAYOUT',
    Q => 'SEQUENCE',
    S => 'SOURCE',
    T => 'STRAND',
    G => 'GROUP',
    F => 'FEATURE',
    );
#line 1991 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($GFF,$GFF_NOGP,$VECTOR,$ALIGN,
    $APLOT,$APLOT_NOGP,$noGFF) =
    qw/ X x V A O o ? /;
#line 4255 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $Error = "\<\<\<  ERROR  \>\>\> ";
my $Warn  = "\<\<\< WARNING \>\>\> ";
my $spl   = "\<\<\<\-\-\-\-\-\-\-\-\-\>\>\>\n";
my $spw   = "\<\<\<         \>\>\> ";
#line 4280 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $line = ("#" x 80)."\n";
my $sp = "###\n";
#line 313 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# VARIABLES
#
#line 390 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my (%DefaultVars,%CmdLineVars,%CustomVars,%Vars,%gff_data,%aplot_data);
#line 524 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $Custom_path = $ENV{GFF2APLOT_CUSTOMPATH};
my $Custom_file = $ENV{GFF2APLOT_CUSTOMFILE};
defined($Custom_path) || ($Custom_path = '.');
defined($Custom_file) || ($Custom_file = '.gff2aplotrc');
$Custom_path =~ s{/$}{}o; 
#line 671 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($Debug,$Verbose,$Quiet,$LogFile,$logs_filename) = (0,0,0,0,undef);
#line 746 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my (@data_files,$file);
#line 837 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my @custom_files = ();
#line 1203 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my %Fonts = (
    # serif
    times                   => 'Times-Roman',
    'times-roman'           => 'Times-Roman',
    'times-italic'          => 'Times-Italic',
    'times-bold'            => 'Times-Bold',
    'times-bolditalic'      => 'Times-BoldItalic',
    # sans serif
    helvetica               => 'Helvetica',
    'helvetica-oblique'     => 'Helvetica-Oblique',
    'helvetica-bold'        => 'Helvetica-Bold',
    'helvetica-boldoblique' => 'Helvetica-BoldOblique',
    # monospaced
    courier                 => 'Courier',
    'courier-oblique'       => 'Courier-Oblique',
    'courier-bold'          => 'Courier-Bold',
    'courier-boldoblique'   => 'Courier-BoldOblique',
    );
#line 1997 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($n,$c);
#line 2127 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($seqname_1,$seqname_2,
    $source_1,$source_2,$feature_1,$feature_2,
    $start_1,$start_2,$end_1,$end_2,$score_1,$score_2,
    $strand_1,$strand_2,$frame_1,$frame_2); # APLOT temporary vars
my ($tag,$group,$group_id,$label,
    $group_gff_counter,$group_aplot_counter); # GROUPING temporary vars
#line 2214 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my (%ALN_DATA);
#line 2234 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my ($seqname,$source,$feature,$start,
    $end,$score,$strand,$frame); # GFF temporary vars
#line 2402 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my (%GFF_DATA,$seq_COUNT);
my ($_counter,$_prop,$_element) = (0,1,2);
my ($_order,$_elemNum,$_ori,$_end) = (0,1,2,3);
#line 2560 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my %SOURCE = ( # this is a temporary hash name (to implement later)
               align_tag  => 'target',
               vector_tag => 'vector',
               label_tag  => 'id',
               );
#line 2600 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my @vect_ary;
#line 2674 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my %Order;
#line 2931 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $colors = 0;
my %COLORS = (    # [ ColorNUMBER, qw/ CYAN MAGENTA YELLOW BLACK / ]
  
#line 3089 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# black+grey+white
black              => [ ++$colors, qw/ 0.00 0.00 0.00 1.00 / ],
verydarkgrey       => [ ++$colors, qw/ 0.00 0.00 0.00 0.80 / ],
darkgrey           => [ ++$colors, qw/ 0.00 0.00 0.00 0.60 / ],
grey               => [ ++$colors, qw/ 0.00 0.00 0.00 0.40 / ],
lightgrey          => [ ++$colors, qw/ 0.00 0.00 0.00 0.20 / ],
verylightgrey      => [ ++$colors, qw/ 0.00 0.00 0.00 0.10 / ],
white              => [ ++$colors, qw/ 0.00 0.00 0.00 0.00 / ],
#line 3125 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# magenta				  
verydarkmagenta    => [ ++$colors, qw/ 0.00 1.00 0.00 0.30 / ],
darkmagenta        => [ ++$colors, qw/ 0.00 0.80 0.00 0.05 / ],
magenta            => [ ++$colors, qw/ 0.00 0.60 0.00 0.00 / ],
lightmagenta       => [ ++$colors, qw/ 0.00 0.40 0.00 0.00 / ],
verylightmagenta   => [ ++$colors, qw/ 0.00 0.20 0.00 0.00 / ],
#line 3155 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# violet				  
verydarkviolet     => [ ++$colors, qw/ 0.45 0.85 0.00 0.00 / ],
darkviolet         => [ ++$colors, qw/ 0.30 0.65 0.00 0.00 / ],
violet             => [ ++$colors, qw/ 0.22 0.55 0.00 0.00 / ],
lightviolet        => [ ++$colors, qw/ 0.15 0.40 0.00 0.00 / ],
verylightviolet    => [ ++$colors, qw/ 0.10 0.20 0.00 0.00 / ],
#line 3185 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# blue				  
verydarkblue       => [ ++$colors, qw/ 1.00 1.00 0.00 0.20 / ],
darkblue           => [ ++$colors, qw/ 0.90 0.90 0.00 0.00 / ],
blue               => [ ++$colors, qw/ 0.75 0.75 0.00 0.00 / ],
lightblue          => [ ++$colors, qw/ 0.50 0.50 0.00 0.00 / ],
verylightblue      => [ ++$colors, qw/ 0.30 0.30 0.00 0.00 / ],
#line 3215 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# skyblue				  
verydarkskyblue    => [ ++$colors, qw/ 0.90 0.50 0.00 0.15 / ],
darkskyblue        => [ ++$colors, qw/ 0.75 0.45 0.00 0.00 / ],
skyblue            => [ ++$colors, qw/ 0.60 0.38 0.00 0.00 / ],
lightskyblue       => [ ++$colors, qw/ 0.45 0.25 0.00 0.00 / ],
verylightskyblue   => [ ++$colors, qw/ 0.30 0.15 0.00 0.00 / ],
#line 3245 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# cyan				  
verydarkcyan       => [ ++$colors, qw/ 1.00 0.00 0.00 0.10 / ],
darkcyan           => [ ++$colors, qw/ 0.80 0.00 0.00 0.00 / ],
cyan               => [ ++$colors, qw/ 0.60 0.00 0.00 0.00 / ],
lightcyan          => [ ++$colors, qw/ 0.40 0.00 0.00 0.00 / ],
verylightcyan      => [ ++$colors, qw/ 0.20 0.00 0.00 0.00 / ],
#line 3275 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# seagreen			  
verydarkseagreen   => [ ++$colors, qw/ 0.75 0.00 0.45 0.00 / ],
darkseagreen       => [ ++$colors, qw/ 0.62 0.00 0.38 0.00 / ],
seagreen           => [ ++$colors, qw/ 0.50 0.00 0.30 0.00 / ],
lightseagreen      => [ ++$colors, qw/ 0.38 0.00 0.22 0.00 / ],
verylightseagreen  => [ ++$colors, qw/ 0.25 0.00 0.15 0.00 / ],
#line 3305 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# green				  
verydarkgreen      => [ ++$colors, qw/ 1.00 0.00 1.00 0.25 / ],
darkgreen          => [ ++$colors, qw/ 0.80 0.00 0.80 0.00 / ],
green              => [ ++$colors, qw/ 0.60 0.00 0.60 0.00 / ],
lightgreen         => [ ++$colors, qw/ 0.40 0.00 0.40 0.00 / ],
verylightgreen     => [ ++$colors, qw/ 0.20 0.00 0.20 0.00 / ],
#line 3335 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# limegreen			  
verydarklimegreen  => [ ++$colors, qw/ 0.50 0.00 1.00 0.10 / ],
darklimegreen      => [ ++$colors, qw/ 0.40 0.00 0.95 0.00 / ],
limegreen          => [ ++$colors, qw/ 0.30 0.00 0.80 0.00 / ],
lightlimegreen     => [ ++$colors, qw/ 0.20 0.00 0.65 0.00 / ],
verylightlimegreen => [ ++$colors, qw/ 0.10 0.00 0.50 0.00 / ],
#line 3365 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# yellow				  
verydarkyellow     => [ ++$colors, qw/ 0.00 0.00 1.00 0.25 / ],
darkyellow         => [ ++$colors, qw/ 0.00 0.00 1.00 0.10 / ],
yellow             => [ ++$colors, qw/ 0.00 0.00 1.00 0.00 / ],
lightyellow        => [ ++$colors, qw/ 0.00 0.00 0.50 0.00 / ],
verylightyellow    => [ ++$colors, qw/ 0.00 0.00 0.25 0.00 / ],
#line 3395 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# orange				  
verydarkorange     => [ ++$colors, qw/ 0.00 0.50 0.80 0.10 / ],
darkorange         => [ ++$colors, qw/ 0.00 0.40 0.80 0.00 / ],
orange             => [ ++$colors, qw/ 0.00 0.30 0.80 0.00 / ],
lightorange        => [ ++$colors, qw/ 0.00 0.20 0.75 0.00 / ],
verylightorange    => [ ++$colors, qw/ 0.00 0.15 0.70 0.00 / ],
#line 3425 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# red					  
verydarkred        => [ ++$colors, qw/ 0.00 1.00 1.00 0.15 / ],
darkred            => [ ++$colors, qw/ 0.00 0.80 0.80 0.00 / ],
red                => [ ++$colors, qw/ 0.00 0.60 0.60 0.00 / ],
lightred           => [ ++$colors, qw/ 0.00 0.40 0.40 0.00 / ],
verylightred       => [ ++$colors, qw/ 0.00 0.20 0.20 0.00 / ],
#line 3455 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# brown				  
verydarkbrown      => [ ++$colors, qw/ 0.35 0.85 1.00 0.40 / ],
darkbrown          => [ ++$colors, qw/ 0.30 0.70 1.00 0.35 / ],
brown              => [ ++$colors, qw/ 0.25 0.75 1.00 0.25 / ],
lightbrown         => [ ++$colors, qw/ 0.20 0.60 0.70 0.15 / ],
verylightbrown     => [ ++$colors, qw/ 0.15 0.45 0.55 0.00 / ],
#line 2934 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  ); # %COLORS
#line 2956 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $formats = 0;
my %FORMATS = (   # [ FormatNUMBER, X(short edge), Y(long edge) ]
  
#line 3500 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  a0        => [ ++$formats, 2384, 3370 ],
  a1        => [ ++$formats, 1684, 2384 ],
  a2        => [ ++$formats, 1190, 1684 ],
  a3        => [ ++$formats,  842, 1190 ],
  a4        => [ ++$formats,  595,  842 ],
  a5        => [ ++$formats,  420,  595 ],
  a6        => [ ++$formats,  297,  420 ],
  a7        => [ ++$formats,  210,  297 ],
  a8        => [ ++$formats,  148,  210 ],
  a9        => [ ++$formats,  105,  148 ],
  a10       => [ ++$formats,   73,  105 ],
#line 3529 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  b0        => [ ++$formats, 2920, 4127 ],
  b1        => [ ++$formats, 2064, 2920 ],
  b2        => [ ++$formats, 1460, 2064 ],
  b3        => [ ++$formats, 1032, 1460 ],
  b4        => [ ++$formats,  729, 1032 ],
  b5        => [ ++$formats,  516,  729 ],
  b6        => [ ++$formats,  363,  516 ],
  b7        => [ ++$formats,  258,  363 ],
  b8        => [ ++$formats,  181,  258 ],
  b9        => [ ++$formats,  127,  181 ],
  b10       => [ ++$formats,   91,  127 ],
#line 3559 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  executive => [ ++$formats,  540,  720 ],
  folio     => [ ++$formats,  612,  936 ],
  legal     => [ ++$formats,  612, 1008 ],
  letter    => [ ++$formats,  612,  792 ],
  quarto    => [ ++$formats,  610,  780 ],
  statement => [ ++$formats,  396,  612 ],
 '10x14'    => [ ++$formats,  720, 1008 ],
  ledger    => [ ++$formats, 1224,  792 ],
  tabloid   => [ ++$formats,  792, 1224 ],
#line 2959 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  );
#line 4236 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
# Program status strings.
my %Messages = (
    # ERROR MESSAGES
    
#line 750 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
FILE_NO_OPEN =>
  $spl.$Warn."Cannot Open Current file \"\%s\" . Not used !!!\n".$spl,
#line 4204 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
USER_HALT =>
  $spl.$Warn."$PROGRAM has been stopped by user !!!\n".
  $spl.$Warn."---------- Exiting NOW !!! ----------\n".$spl,
PROCESS_HALT =>
  $spl.$Warn."------- $PROGRAM is down !!! -------\n".
  $spl.$Warn."---------- Exiting NOW !!! ----------\n".$spl,
#line 4240 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 675 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
UNKNOWN_CL_OPTION =>
  $Warn."Error trapped while processing command-line:\n".(" "x16)."\%s\n",
CMD_LINE_ERROR =>
  $spl.$spw." Please, check your command-line options!!!\n".$Error."\n".
  $spw." ".("."x12)." Type \"gff2aplot -h\" for help.\n".$spl,
#line 4241 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 978 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SECTION_NOT_DEF =>
  $Warn."You probably forgot a section header, unable to parse this record.\n",
VAR_NOT_DEFINED =>
  $Warn."\%s variable not defined: \"\%s\" .\n",
#line 998 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
VARTYPE_NOT_DEFINED =>
  $Error."Variable type \"\%s\" not defined,\n".
  $spw."  could not check value for \"\%s\".\n",
#line 1048 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_BOOLEAN =>
  $Warn."\"\%s\" variable requires a boolean value:\n".
  $spw."     (ON/OFF, 1/0, TRUE/FALSE, YES/NO)\n",
#line 1099 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_DIGIT =>
  $Warn."\"\%s\" variable requires a digit (natural number).\n",
NOT_AN_INTEGER =>
  $Warn."\"\%s\" variable requires an integer.\n",
NOT_A_DECIMAL =>
  $Warn."\"\%s\" variable requires a decimal number.\n",
NOT_A_REAL =>
  $Warn."\"\%s\" variable requires a real number (with exponent).\n",
#line 1128 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_COLOR =>
  $Warn."\"\%s\" color not defined in \"\%s\" variable.\n",
#line 1145 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_PAGE =>
  $Warn."\"\%s\" page-size is not defined for \"\%s\" variable.\n",
#line 1163 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_DNABASE =>
  $Warn."\"\%s\" variable requires nucleotide units.\n".
  $spw." \"\%s\" is not valid (units must be in Gb, Mb, Kb, or bases).\n",
#line 1196 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_FONT =>
  $Warn."Sorry, \"\%s\" font is not defined for \"\%s\" variable.\n",
#line 1224 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_FONT =>
  $Warn."\"\%s\" font is not available for \"\%s\" variable.\n",
#line 1245 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_A_FONTSIZE =>
  $Warn."\"\%s\" is not a valid font-size for \"\%s\" variable.",
#line 4242 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 2001 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NOT_ENOUGH_FIELDS =>
  $Warn."Not enough fields in file \"\%s\", line \%s :\n\t\%s\n",
#line 2066 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
ORI_GREATER_END =>
  $Warn."Start greater than end \"\%s > \%s\" in file \"\%s\" line \"\%s\".\n", 
#line 2085 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
STRAND_MISMATCH =>
  $Warn." Strand mismatch definition \"\%s\" in file \"\%s\" line \"\%s\".\n",
#line 2104 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
FRAME_MISMATCH =>
  $Warn." Frame mismatch definition \"\%s\" in file \"\%s\" line \"\%s\".\n",
#line 4243 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    # WORKING MESSAGES
    
#line 755 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
CHECKING_FILENAMES =>
  $sp."### Validating INPUT FILENAMES\n".$sp,
READING_FILE =>
  "###---> \"\%s\" exists, including as Input File.\n",
READING_STDIN =>
  "###---> Including GFF records from standard input.\n",  
#line 841 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
CHECKING_CUSTOM_NAMES =>
  $sp."### Validating CUSTOM FILENAMES\n".$sp,
READING_FROM_PATH =>
  "###---> Custom File NOT FOUND in local path: \"\%s\"\n".
  "###     Trying to find in \"GFF2APLOT_CUSTOMPATH\": \"\%s\"\n",
READING_CUSTOM_FILE =>
  "###---> \"\%s\" exists, including as Custom File.\n",
NO_CUSTOM_FILES =>
  "###---> NO CUSTOM FILES found. Using program DEFAULTS.\n",
#line 4245 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 713 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SHOW_VERSION =>
  $sp."### \%s -- \%s\n".$sp,
#line 4246 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 946 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
READ_CUSTOM_FILE => 
  $sp."### Reading Customization Parameters from \"\%s\"\n".$sp,
NO_CUSTOM_FOUND =>
  $sp."### NO CUSTOM FILES found: Using program DEFAULTS.\n".$sp,
#line 4247 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 2006 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
READ_GFF_FILE => 
  $sp."### Reading GFF records from \"\%s\"\n".$sp,
#line 4248 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 2678 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SORT_GFF => "\%sSorting \%s\n",
#line 2715 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SORT_SEQ => "\%sSequence: \%s\n",
SORT_SRC => "\%sSource: \%s\n",
#line 2739 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SORT_STR => "\%sStrand: \%s\n",
#line 2767 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SORT_GRP => "\%sGroup: \%s\n",
SORT_FTR => "\%s       Sorted \%s elements.\n",
#line 2793 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
SORT_GPN => "\%s\`Sorted \%s groups.\n",
#line 4249 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
   ); # %Messages
#line 4345 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $total_time = 0;
my $DATE = localtime;
my $USER = defined($ENV{USER}) ? $ENV{USER} : 'Child Process';

#line 318 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# MAIN PROGRAM LOOP
#

#line 342 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  # &set_default_vars;

  %CmdLineVars = ();            # Reseting Command-Line OPTIONS
  &parse_command_line;

  
#line 360 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%CustomVars = ();             # Reseting Customization OPTIONS
&parse_custom_files;

%Vars = ();
&map_vars_layout;

%gff_data = %aplot_data = (); # Reseting DATA
&parse_GFF_files;

&map_vars_data;

&sort_elements;
#line 348 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
  &make_plot;

  $total_time = &timing($T);
  &header("$PROGRAM HAS FINISHED","Timing: $total_time secs");
  
  &close_logfile();
  exit(0);
#line 322 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# MAIN FUNCTIONS
#
#line 496 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub set_default_vars() {
    %DefaultVars = (
        LAYOUT   => {           ## '# L #'
            
#line 1688 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#						  
page_size                  => { TYPE => 'PAGE'   , VALUE => 'a4'   },
background_color           => { TYPE => 'COLOR'  , VALUE => 'white' },
foreground_color           => { TYPE => 'COLOR'  , VALUE => 'black' },
# GLOBAL Labels			  
show_title                 => { TYPE => 'BOOLEAN', VALUE => $T     },
title                      => { TYPE => 'STRING' , VALUE => undef  },
show_subtitle              => { TYPE => 'BOOLEAN', VALUE => $T     },
subtitle                   => { TYPE => 'STRING' , VALUE => undef  },
show_x_sequence_label      => { TYPE => 'BOOLEAN', VALUE => $T     },
x_sequence_label           => { TYPE => 'STRING' , VALUE => undef  },
show_y_sequence_label      => { TYPE => 'BOOLEAN', VALUE => $T     },
x_sequence_label           => { TYPE => 'STRING' , VALUE => undef  },
# TICKMARK features		  										 
show_tickmark_label        => { TYPE => 'BOOLEAN', VALUE => $T     },
show_aplot_x_ticks         => { TYPE => 'BOOLEAN', VALUE => $T     },
show_percent_x_ticks       => { TYPE => 'BOOLEAN', VALUE => $T     },
show_extrabox_x_ticks      => { TYPE => 'BOOLEAN', VALUE => $T     },
show_aplot_y_ticks         => { TYPE => 'BOOLEAN', VALUE => $T     },
show_percent_y_ticks       => { TYPE => 'BOOLEAN', VALUE => $T     },
show_extrabox_y_ticks      => { TYPE => 'BOOLEAN', VALUE => $T     },
show_onlylower_x_ticks     => { TYPE => 'BOOLEAN', VALUE => $F     },
aplot_major_tickmark       => { TYPE => 'INTEGER', VALUE => 2      },
aplot_minor_tickmark       => { TYPE => 'INTEGER', VALUE => 5      },
percent_major_tickmark     => { TYPE => 'INTEGER', VALUE => 5      },
percent_minor_tickmark     => { TYPE => 'INTEGER', VALUE => 5      },
extra_major_tickmark       => { TYPE => 'INTEGER', VALUE => 2      },
extra_minor_tickmark       => { TYPE => 'INTEGER', VALUE => 5      },
major_tickmark_nucleotide  => { TYPE => 'DNABASE', VALUE => undef  },
minor_tickmark_nucleotide  => { TYPE => 'DNABASE', VALUE => undef  },
percent_box_score_range    => { TYPE => 'RANGE'  , VALUE => '50..100' },
show_grid                  => { TYPE => 'BOOLEAN', VALUE => $F     },
# APLOT box features	  
aplot_axes_same_scale      => { TYPE => 'BOOLEAN', VALUE => $F     },
aplot_box_bgcolor          => { TYPE => 'COLOR'  , VALUE => 'bg'   },
#						  
sequence1_start            => { TYPE => 'DNABASE', VALUE => undef  },
sequence1_end              => { TYPE => 'DNABASE', VALUE => undef  },
sequence2_start            => { TYPE => 'DNABASE', VALUE => undef  },
sequence2_end              => { TYPE => 'DNABASE', VALUE => undef  },
#						  
sequence1_zoom_start       => { TYPE => 'DNABASE', VALUE => undef  },
sequence1_zoom_end         => { TYPE => 'DNABASE', VALUE => undef  },
sequence2_zoom_start       => { TYPE => 'DNABASE', VALUE => undef  },
sequence2_zoom_end         => { TYPE => 'DNABASE', VALUE => undef  },
zoom                       => { TYPE => 'BOOLEAN', VALUE => $F     },
zoom_area                  => { TYPE => 'BOOLEAN', VALUE => $F     },
zoom_marks                 => { TYPE => 'BOOLEAN', VALUE => $F     },
zoom_area_mark_color       => { TYPE => 'COLOR'  , VALUE => 'lightred' },
# PERCENT box features	  
show_percent_box           => { TYPE => 'BOOLEAN', VALUE => $F     },
percent_box_bgcolor        => { TYPE => 'COLOR'  , VALUE => 'bg'   },
show_percent_box_label     => { TYPE => 'BOOLEAN', VALUE => $T     },
percent_box_label          => { TYPE => 'STRING' , VALUE => undef  },
percent_box_sublabel       => { TYPE => 'STRING' , VALUE => undef  },
# EXTRA box features	  
show_extra_box             => { TYPE => 'BOOLEAN', VALUE => $F     },
extra_box_bgcolor          => { TYPE => 'COLOR'  , VALUE => 'bg'   },
show_extra_box_label       => { TYPE => 'BOOLEAN', VALUE => $T     },
extra_box_label            => { TYPE => 'STRING' , VALUE => undef  },
extra_box_sublabel         => { TYPE => 'STRING' , VALUE => undef  },
#						  
feature_x_label_angle      => { TYPE => 'INTEGER', VALUE => 0      },
feature_y_label_angle      => { TYPE => 'INTEGER', VALUE => 0      },
feature_label_length       => { TYPE => 'INTEGER', VALUE => 0      },
feature_labels_font        => { TYPE => 'FONT'   , VALUE => 'helvetica' },
feature_labels_fontsize    => { TYPE => 'FONT_SZ', VALUE => '5pt'  },
group_x_label_angle        => { TYPE => 'INTEGER', VALUE => 0      },
group_y_label_angle        => { TYPE => 'INTEGER', VALUE => 0      },
group_label_length         => { TYPE => 'INTEGER', VALUE => 0      },
group_labels_font          => { TYPE => 'FONT'   , VALUE => 'helvetica' },
group_labels_fontsize      => { TYPE => 'FONT_SZ', VALUE => '5pt'  },
#line 2527 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
align_tag                  => { TYPE => 'STRING' , VALUE => 'target' },
#line 2538 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
vector_tag                 => { TYPE => 'STRING' , VALUE => 'vector' },
#line 2549 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
label_tag                  => { TYPE => 'STRING' , VALUE => 'id'   },
#line 500 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },					  
        SEQUENCE => {           ## '# Q #'
            
#line 1763 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NIL => { TYPE => 'BOOLEAN', VALUE => $F },
#line 503 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },					  
        SOURCE   => {           ## '# S #'
            
#line 1767 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NIL => { TYPE => 'BOOLEAN', VALUE => $F },
#line 506 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },					  
        STRAND   => {           ## '# T #'
            
#line 1771 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
NIL => { TYPE => 'BOOLEAN', VALUE => $F },
#line 509 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },					  
        GROUP    => {           ## '# G #'
            
#line 1775 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
show_group_label           => { TYPE => 'BOOLEAN', VALUE => $T     }, 
show_group_rule            => { TYPE => 'BOOLEAN', VALUE => $T     },
show_group_arrow           => { TYPE => 'BOOLEAN', VALUE => $T     },
feature_arrows_color       => { TYPE => 'COLOR'  , VALUE => 'fg'   },
Show_JOINS                 => { TYPE => 'BOOLEAN', VALUE => $T     },
Join_Lines_COLOR           => { TYPE => 'COLOR'  , VALUE => 'fg'   },
#line 512 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },					  
        FEATURE  => {           ## '# F #'
            
#line 1784 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
Show_HalfHeightBOX         => { TYPE => 'BOOLEAN', VALUE => $T     },
HalfSizeBox_BGCOLOR        => { TYPE => 'COLOR'  , VALUE => 'DEFAULT' },
Show_FullHeightBOX         => { TYPE => 'BOOLEAN', VALUE => $T     },
FullSizeBox_BGCOLOR        => { TYPE => 'COLOR'  , VALUE => 'DEFAULT' },
Show_BOX_LABEL             => { TYPE => 'BOOLEAN', VALUE => $T     },
Show_UserDef_BOX_LABEL     => { TYPE => 'BOOLEAN', VALUE => $T     },
Show_RIBBON                => { TYPE => 'BOOLEAN', VALUE => $T     },
Ribbon_BGCOLOR             => { TYPE => 'COLOR'  , VALUE => 'DEFAULT' },
Show_GFF                   => { TYPE => 'BOOLEAN', VALUE => $F     },
Show_GFF_ReverseOrder      => { TYPE => 'BOOLEAN', VALUE => $F     },
Show_FUNCTION              => { TYPE => 'BOOLEAN', VALUE => $F     },
APlotLine_GroupScore       => { TYPE => 'BOOLEAN', VALUE => $F     },
APlotLine_ScaleWidth       => { TYPE => 'BOOLEAN', VALUE => $F     },
APlotLine_ScaleGrey        => { TYPE => 'BOOLEAN', VALUE => $F     },
Show_SELECTION_BOX         => { TYPE => 'BOOLEAN', VALUE => $T     },
SelectionBox_BGCOLOR       => { TYPE => 'COLOR'  , VALUE => 'grey' },
Function_COLOR             => { TYPE => 'COLOR'  , VALUE => 'red'  },
#line 515 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        },
    ); # %DefaultVars
    print LOGFILE '>>> \%DefaultVars : '.(Dumper(\%DefaultVars)) if ($LogFile && $Debug);
} # set_default_vars
#line 561 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub parse_command_line() {
    
#line 636 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $cmdln_stdin = undef;
for (my $a = 0; $a <= $#ARGV; $a++) { 
    next unless $ARGV[$a] =~ /^-$/o;
    $cmdln_stdin = $a - $#ARGV;
    splice(@ARGV,$a,1);
};    

#line 564 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    $SIG{__WARN__} = sub { &warn('UNKNOWN_CL_OPTION',$T,$_[0]) };
    GetOptions(
               
#line 1261 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"v|verbose"   => \$Verbose, # Print_Report
#line 1279 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"V|logs-filename=s"  => \$logs_filename, # Print_Report -> LogFile
#line 1296 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"q|quiet"   => \$Quiet, # Quiet_Mode
#line 789 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"O|custom-filename=s@"  => \@custom_files,
#line 1321 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"S|sequence1-start=i"  => \$CmdLineVars{"sequence1_start"}, # SEQUENCE1_ORIGIN # Zoom_SEQUENCE1_ORIGIN
#line 1333 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"E|sequence1_end=i"  => \$CmdLineVars{"sequence1_end"}, # SEQUENCE1_END    # Zoom_SEQUENCE1_END
#line 1345 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"s|sequence2_start=i"  => \$CmdLineVars{"sequence2_start"}, # SEQUENCE2_ORIGIN # Zoom_SEQUENCE2_ORIGIN
#line 1357 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"e|sequence2_end=i"  => \$CmdLineVars{"sequence2_end"}, # SEQUENCE2_END    # Zoom_SEQUENCE2_END
#line 1369 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Z|zoom"   => \$CmdLineVars{"zoom"}, # ZOOM_Zoom; Zoom_Marks
#line 1383 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"z|zoom-area"   => \$CmdLineVars{"zoom_area"}, # ZOOM_Area
#line 1397 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"G|display-grid"   => \$CmdLineVars{"display_grid"}, # Display_GRID
# "g"    => \$CmdLineVars{""}, # Display_GRID
#line 1410 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"P|display-percent-box"   => \$CmdLineVars{"display_percent_box"}, # Display_PERCENT-BOX
# "p"    => \$CmdLineVars{""}, # Display_PERCENT-BOX
#line 1423 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Q|display-extra-box"   => \$CmdLineVars{"display_extra_box"}, # Display_EXTRA-BOX
# "q"    => \$CmdLineVars{""}, # Display_EXTRA-BOX
#line 1436 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"T|title=s"  => \$CmdLineVars{"title"}, # TITLE
#line 1448 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"t|subtitle=s"  => \$CmdLineVars{"subtitle"}, # SUBTITLE
#line 1460 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"X|x-label=s"  => \$CmdLineVars{"x-axis_label"}, # X-Axis_LABEL
#line 1472 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Y|y-label=s"  => \$CmdLineVars{"y-axis_label"}, # Y-Axis_LABEL
#line 1485 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"L|percent-box-label=s"  => \$CmdLineVars{"percent_box_label"}, # Percent-Box_LABEL
#line 1497 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"l|extra-box-label=s"  => \$CmdLineVars{"extra_box_label"}, # Extra-Box_LABEL
#line 1509 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"R|xy-axes-scale"   => \$CmdLineVars{"xy_axes_scale"}, # XY_AXES_Same-SIZE
# "r"    => \$CmdLineVars{""}, # XY_AXES_Same-SIZE
#line 1522 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"W|aln-scale-width"    => \$CmdLineVars{"alignment_scale_width"}, # APlotLine_ScaleWidth; APlotLine_GroupScore
#line 1534 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"w|aln-scale-color"    => \$CmdLineVars{"alignment_scale_color"}, # APlotLine_ScaleGrey; APlotLine_GroupScore
#line 1546 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"B|background-color=s"  => \$CmdLineVars{"background_color"}, # BACKGROUND_COLOR
#line 1558 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"F|foreground-color=s"  => \$CmdLineVars{"foreground_color"}, # FOREGROUND_COLOR
#line 1570 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"D|aplot-box-color=s"  => \$CmdLineVars{"aplot_box_color"}, # APlotBox_BqGCOLOR
#line 1582 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"C|percent-box-color=s"  => \$CmdLineVars{"percent_box_color"}, # PercentBox_BGCOLOR
#line 1594 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"c|extra-box-color=s"  => \$CmdLineVars{"extra_box_color"}, # ExtraBox_BGCOLOR
#line 1606 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"A|alignment-name=s"  => \$CmdLineVars{"alignment_name"}, # Align_NAME
#line 1619 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"N|x-sequence-name=s"  => \$CmdLineVars{"x-sequence_name"}, # X-Sequence_NAME
#line 1631 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"n|y-sequence-name=s"  => \$CmdLineVars{"y-sequence_name"}, # Y-Sequence_NAME
#line 1643 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"K|show-ribbons=s"   => \$CmdLineVars{"show_ribbons"}, # Show_Ribbons (NLRB)
#line 1656 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"I|page-size=s"  => \$CmdLineVars{"page_size"}, # PAGE_SIZE
#line 1668 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"a|show-credits"   => \$CmdLineVars{"show_credits"}, # Show_Credits
#line 4227 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"debug"  => \$Debug, # Dumps Vars -> LogFile
#line 567 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
               
#line 687 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"version"   => \&prt_version, 
"h|help|?"  => \&prt_help,
#line 568 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
               ) || (&warn('CMD_LINE_ERROR',$T), exit(1));
    $SIG{__WARN__} = 'DEFAULT';

    
#line 647 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
CHKLOG:
  (defined($logs_filename)) && do {
      open(LOGFILE,"> ".$logs_filename) ||
          (&warn('FILE_NO_OPEN',$T,$logs_filename),last CHKLOG);
      $LogFile = 1;
  };

#line 573 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    &header('',"RUNNING $PROGRAM",'',"User: $USER","Date: $DATE");

    &header("SETTING DEFAULTS");
    %DefaultVars = ();
    &set_default_vars;

    &header("CHECKING COMMAND-LINE OPTIONS");
    @data_files = ();
    &set_input_file($cmdln_stdin);
    @ARGV = (); # ensuring that command-line ARGVs array is empty

    &set_custom_files();

    

    &footer("COMMAND-LINE CHECKED");
} # parse_command_line
#line 704 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub prt_version() {
    my $comment = $Messages{'SHOW_VERSION'};
    $comment = sprintf($comment,$PROGRAM,$VERSION);
    &prt_to_stderr($comment);
    exit(1);
}
#line 720 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub set_input_file() {
    my $stdin_flg = $F;
    
#line 766 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $chk_stdin = shift @_;
my $t = scalar(@ARGV);
defined($chk_stdin) && do {
    abs($chk_stdin) > $t && ($chk_stdin = -$t);
	$chk_stdin > 0  && ($chk_stdin = 0 );
    $t += $chk_stdin;
    splice(@ARGV,$t,0,'-');
};
#line 723 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    &report("CHECKING_FILENAMES");
  FILECHK: foreach my $test_file (@ARGV) {
        $test_file ne '-' && do {
            -e $test_file || do {
                &warn('FILE_NO_OPEN',$T,$test_file);
                next FILECHK;
            };
            &report('READING_FILE',$test_file);
            push @data_files, $test_file;
            next FILECHK;
        };
        $stdin_flg = $T;
        push @data_files, '-';
	}; # foreach
    scalar(@data_files) == 0 && do {
        push @data_files, '-';
        $stdin_flg = $T;
    };
    $stdin_flg && &report('READING_STDIN');
}
#line 809 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub set_custom_files() {
	unshift @custom_files, $Custom_file;
    my @files = ();
    &report("CHECKING_CUSTOM_NAMES");
  MLOOP: foreach my $test_file (@custom_files) {
      FILECHK: {
        -e $test_file && last FILECHK;
        ($test_file =~ m{/}og || $Custom_path eq '.') || do {
            my $tmpfl = $test_file;
			$test_file = "$Custom_path/$test_file";
            &report('READING_FROM_PATH',$tmpfl,$test_file);
            -e $test_file && last FILECHK;
        };
        scalar(@custom_files) == 1 && do {
            &report('NO_CUSTOM_FILES',$T);
            last MLOOP;
		};
        &warn('FILE_NO_OPEN',$T,$test_file);
        next MLOOP;
	  }; # FILECHK
        &report('READING_CUSTOM_FILE',$test_file);
        push @files, $test_file;
	}; # MLOOP: foreach
	@custom_files = @files;
} # set_custom_files
#line 857 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub parse_custom_files() {
    &header("READING CUSTOM FILES");
  MAIN: {
      scalar(@custom_files) == 0 && do {
          &report('NO_CUSTOM_FOUND',$file);
		  last MAIN;
	  };
    LOAD: foreach $file (@custom_files) {
        open(THIS,"< $file") ||
            ( &warn('FILE_NO_OPEN',$T,$file), next LOAD);
        &report('READ_CUSTOM_FILE',$file);
        ($n,$c) = (0,undef);
        while (<THIS>) {
            my (@line,$main,$_c,$_v,$v_flag);
		    /^\#/o && do {
                /^\# ([LQSTGF]) \#/o && do { 
                     $_c = $1; $c = '*';
                     $v_flag = ($_c ne 'L') ? $T : $F;
                     $_v = $varkeys{$_c};
                     next;
                };
				$c = '.'; next;
            };
            ($c = '.', next) if /^\s*$/o;
            chomp;
            ($main,undef) = split /\b\s+\#/o;
          TWOTHREE: {
              $v_flag && do {
				  $main =~ /^(.*?):{2}(.*?)={1}(.*?)$/o &&
                      (@line = ($1,$2,$3));
				  last TWOTHREE;
			  };
              $main =~ /^(.*?)={1}(.*?)$/o &&
                  (@line = ($_v,$1,$2));
		  }; # TWOTHREE
            $c = &varscheck($v_flag,$_v,\@line) ? $_c : $noCV;
        } continue {
            &counter(++$n,$c) if ($Verbose && !$Quiet);
        }; # WHILE
        &counter_end($n,$c) if ($Verbose && !$Quiet);
        close(THIS);
    }; # LOAD
  }; # MAIN
    print LOGFILE '>>> \%CustomVars : '.(Dumper(\%CustomVars))
        if ($LogFile && $Debug);
    &footer("CUSTOM FILES LOADED");
} # parse_custom_files
#line 957 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub varscheck() {
    my ($flag,$class,$rec) = @_;
    defined($class) || 
        (&warn('SECTION_NOT_DEF',$F),return $F);
	my $_var = \%{$DefaultVars{$class}};
    defined($_var->{$$rec[1]}) || 
        (&warn('VAR_NOT_DEFINED',$F,$class,$$rec[1]),return $F);
    &checkvarvalues($_var->{$$rec[1]}{'TYPE'},\$$rec[2],$$rec[1]) || return $F;
#
# Regexp checking for $$rec[0] left 
#
    $flag && do {
        push @{$CustomVars{$class}{$$rec[1]}}, [ $$rec[0], $$rec[2] ];
        return $T;
	};
    $CustomVars{$class}{$$rec[1]} = $$rec[2];
    return $T;
} # varscheck
#line 988 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub checkvarvalues() {
	my ($_test,$_val,$_var) = @_;
    my $_t = lc($$_val);
    
#line 1039 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'BOOLEAN' && do {
    $_t =~ /^(1|on|t(rue)|y(es))$/o && ($$_val = $T, return $T);
    $_t =~ /^(0|off|f(alse)|n(o))$/o && ($$_val = $F, return $T);
    &warn('NOT_A_BOOLEAN',$F,$_var);
    return $F;
};
#line 1058 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'STRING' && do {
    $$_val =~ s{[\\]}{\\134}og;
    $$_val =~ s{[\(]}{\\050}og;
    $$_val =~ s{[\)]}{\\051}og;
    return $T;
};
#line 1075 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'DIGIT' && do {
    $$_val =~ /^\d+$/o && (return $T);
    &warn('NOT_A_DIGIT',$F,$_var);
    return $F;
};
$_test eq 'INTEGER' && do {
    $$_val =~ /^[+-]?\d+$/o && (return $T);
    &warn('NOT_AN_INTEGER',$F,$_var);
    return $F;
};
$_test eq 'DECIMAL' && do {
    $$_val =~ /^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/o && (return $T);
    &warn('NOT_A_DECIMAL',$F,$_var);
    return $F;
};
$_test eq 'REALNUM' && do {
    $$_val =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/o &&
        (return $T);
    &warn('NOT_A_REAL',$F,$_var);
    return $F;
};
#line 1114 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'COLOR' && do { # lc
	$_t =~ /^(b(ack)?|f(ore)?)g(round)?(color)?/o &&
		($$_val = $_t, return $T);
	defined($COLORS{$_t}) && ($$_val = $_t, return $T);
    &warn('NOT_A_COLOR',$F,$_t,$_var);
    return $F;
};
#line 1137 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'PAGE' && do { # lc
	defined($FORMATS{$_t}) && ($$_val = $_t, return $T);
    &warn('NOT_A_PAGE',$F,$_t,$_var);
    return $F;
};
#line 1154 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'DNABASE' && do { # lc
    $_t =~ /^[+-]?(?:\d+(?:\.\d*)?|\.\d+)([gmk]?b(ases)?)?$/o && 
        ($$_val = $_t, return $T);
    &warn('NOT_A_DNABASE',$F,$_var,$_t);
    return $F;
};
#line 1176 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'RANGE' && do {

    return $T;
};
#line 1187 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'FONT' && do { # lc
    defined($Fonts{$_t}) && 
        ($$_val = $Fonts{$_t}, return $T);
    &warn('NOT_A_FONT',$F,$_t,$_var);
    return $F;
};
#line 1231 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_test eq 'FONT_SZ' && do {
    $_t =~ /^(?:\d+(?:\.\d*)?|\.\d+)
            (pt|cm|mm|in(ches)?|points|(centi|mili)meters)?$/ox && 
        ($$_val = $_t, return $T);
    &warn('NOT_A_FONTSIZE',$F,$_t,$_var);
    return $F;
};
#line 992 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    &warn('VARTYPE_NOT_DEFINED',$T,$_test,$_var);
    return $F;
} # checkvarvalues
#line 1931 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub parse_GFF_files() {
    &header("PARSING INPUT GFF RECORDS");
  LOAD: foreach $file (@data_files) {
      open(THIS,"< $file") ||
          (&warn('FILE_NO_OPEN',$T,$file), next LOAD);
      $file eq '-' && ($file = 'STANDARD INPUT');
      &report('READ_GFF_FILE',$file);
      ($n,$c) = (0,undef);
      while (<THIS>) {
          my (@line,$main);
          ($c = '.', next) if /^\#/o;
          ($c = '.', next) if /^\s*$/o;
          chomp;
          # $c = $noGFF;
          ($main,undef) = split /\s+\#/o;
          @line = split /\s+/o, $main, 9;        
          scalar(@line) < 8 &&
              (&warn('NOT_ENOUGH_FIELDS',$F,$file,$n,join(" ",@line)), next);
          $c = &GFF_format(&fieldscheck(\@line));
      } continue {
          &counter(++$n,$c) if ($Verbose && !$Quiet);
      }; # WHILE
      &counter_end($n,$c) if ($Verbose && !$Quiet);
      close(THIS);
  }; # LOAD
    print LOGFILE '>>> \%GFF_DATA : '.(Dumper(\%GFF_DATA))
        if ($LogFile && $Debug);
    &footer("DATA LOADED");
} # sub parse_GFF
#line 2013 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub GFF_format() {
    my $gff = $_[0];
    # return "x" if $GFF == $version1;
    return $GFF        if $gff eq $GFF;        # $version2
    return $GFF_NOGP   if $gff eq $GFF_NOGP;   # $version2 (ungrouped)
    return $VECTOR     if $gff eq $VECTOR;     # VECTOR: GFFv2 particular case 
    return $ALIGN      if $gff eq $ALIGN;      # ALIGN: GFFv2 particular case
    return $APLOT      if $gff eq $APLOT;      # Old aplot format (with colons)
    return $APLOT_NOGP if $gff eq $APLOT_NOGP; # Old aplot format (ungrouped)
    return $noGFF;
} # GFF_format
#line 2029 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub fieldscheck() {
    my ($list) = @_;
    my ($seqname,$start,$end) = @$list[0,3,4]; # ($list->[0],$list->[3],$list->[4]);
    (&fcolon($seqname) && &fcolon($start) && &fcolon($end)) && do {
        return &load_aplot(\@$list);
    };
    return &load_gff(\@$list);
} # fieldscheck
#line 2042 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub fcolon() { return ($_[0] =~ /.+:.+/o ? $T : $F) }
#line 2053 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub check_coords() { # ((ori,end)_1,...,(ori,end)_n)
    my @ary = @_;
    for (my $j=0; $j<=$#ary; $j+=2) {
        $ary[$j] > $ary[$j+1] && do {
            &warn('ORI_GREATER_END',$F,$ary[$j],$ary[$j+1],$file,$n+1);
            return $F;
        };
    }; # foreach
    return $T;
} # check_coords
#line 2073 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub check_strand() { # (str_1,...,srt_n)
    foreach my $str (@_) {
        $str !~ /[+-.]/o && do {
            &warn('STRAND_MISMATCH',$F,$str,$file,$n+1);
            return $F;
        };
    }; # foreach
    return $T;
} # check_strand
#line 2092 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub check_frame() { # (frm_1,...,frm_n)
    foreach my $frm (@_) {
        $frm !~ /[.012]/o && do {
            &warn('FRAME_MISMATCH',$F,$frm,$file,$n+1);
            return $F;
        };
    }; # foreach
    return $T;
} # check_frame
#line 2113 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_aplot() { # if errors found > return $noGFF
    my ($list) = @_;
    my $w_gff;
    ($seqname_1,$seqname_2,$source_1,$source_2,$feature_1,$feature_2,
     $start_1,$start_2,$end_1,$end_2,$score_1,$score_2,
     $strand_1,$strand_2,$frame_1,$frame_2) = 
     &remove_colon(@$list[0,1,2,3,4,5,6,7]);
    $w_gff = &load_grouping($F,$list->[8]);
    &check_aplot_fields || ($w_gff=$noGFF);
    return $w_gff;
} # load_aplot
#line 2175 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub remove_colon() {
    my @ary_out = ();
    my ($a,$b) = (undef,undef);
	foreach my $fld (@_) {
		($a,$b) = split /:/o, $fld, 2;
        $a = '.' unless defined($a);
        $b = $a  unless defined($b);
		push @ary_out, $a, $b;
	};
	return @ary_out;
} # remove_colon
#line 2193 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub check_aplot_fields() {
    &check_coords($start_1,$end_1,$start_2,$end_2) || (return $F);
    &check_strand($strand_1,$strand_2) || (return $F);
    &check_frame($frame_1,$frame_2) || (return $F);
    &add_aplot_record;
    return $T; 
} # check_aplot_fields
#line 2206 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub add_aplot_record() {
    return;
} # add_aplot_record
#line 2222 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_gff() { # if errors found > return $noGFF
    my ($list) = @_ ;
    my $w_gff;
    ($seqname,$source,$feature,$start,$end,
     $score,$strand,$frame) = @$list[0,1,2,3,4,5,6,7];
    $w_gff = &load_grouping($T,$list->[8]);
    &check_gff_fields($w_gff) || ($w_gff=$noGFF);
    return $w_gff;
} # load_gff
#line 2241 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub check_gff_fields() {
    &check_coords($start,$end) || (return $F);
    &check_strand($strand) || (return $F);
    &check_frame($frame) || (return $F);
    &add_gff_record($_[0]);
    return $T; 
} # check_gff_fields
#line 2339 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub add_gff_record() {
    my $_gff = $_[0];
    
#line 2393 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_gff eq $ALIGN && do {
    &add_aplot_record;
    return;
};
#line 2342 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    my ($VarName,$Counter,$Type);
    ($VarName,$Counter,$Type) = (
        \%GFF_DATA,
        \$seq_COUNT,
        'SEQUENCE' );
    &load_gff_var($seqname,$VarName,$Counter,$Type);
    ($VarName,$Counter,$Type) = (
        \%{$VarName->{$seqname}[$_element]},
        \$$VarName{$seqname}[$_counter][$_elemNum],
        'SOURCE' );
    &load_gff_var($source,$VarName,$Counter,$Type);
    ($VarName,$Counter,$Type) = ( 
        \%{$VarName->{$source}[$_element]},
        \$$VarName{$source}[$_counter][$_elemNum],
        'STRAND' );
    &load_gff_var($strand,$VarName,$Counter,$Type);
    ($VarName,$Counter,$Type) = (
        \%{$VarName->{$strand}[$_element]},
        \$$VarName{$strand}[$_counter][$_elemNum],
        'GROUP' );
    &load_gff_var($group,$VarName,$Counter,$Type);
    
#line 2371 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
push @{$VarName->{$group}[$_element]},
    [
      'G',      # Type == plain GFF
	  {},       # Properties hash, now empty
      $feature, # GFF feature (3rd field)
      $label,   # Record ID if exist, order# otherwise
      $start,
      $end,
      $score,
      $frame,
    ];
my $t = ++$VarName->{$group}[$_counter][$_elemNum];
&set_var_defaults('FEATURE',
                  \%{$VarName->{$group}[$_element][($t-1)][$_prop]});
$_gff eq $VECTOR && do {
	@{$VarName->{$group}[$_element][8]} = [ @vect_ary ];
};
#line 2364 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    return;
} # add_gff_record
#line 2409 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_gff_var() {
    my ($_value,$_var,$_cnt,$_type) = @_;
	defined($$_var{$_value}) || do {
		$$_var{$_value}[$_counter] = [ ++$$_cnt, 0, 0, 0 ];
		&set_var_defaults($_type,\%{$$_var{$_value}[$_prop]});
	};
	return;
} # load_gff_var
#line 2422 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub set_var_defaults() {
    my ($sect,$varhash) = @_;
    foreach my $nm (keys %{$DefaultVars{$sect}}) {
        $$varhash{$nm} = \$DefaultVars{$sect}{$nm}{'VALUE'};
	};
	return;
} # load_gff_var
#line 2438 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_grouping() {
    my ($_type,$attributes) = @_;
    my ($grp_string,$grp_counter,$grp_GP,$grp_NOGP,$grp_tag);
  GFF_CHOICE: {
    $_type && do { 
        $grp_string = "$seqname\_$source\_$strand";
        $grp_counter = ++$group_gff_counter;
        $grp_GP = $GFF;
        $grp_NOGP = $GFF_NOGP;
        $grp_tag = '';
        last GFF_CHOICE;
    };
    $grp_string = "$seqname_1\_$seqname_2\_$source_1\_$strand_1$strand_2";
    $grp_counter = ++$group_aplot_counter;
    $grp_GP = $APLOT;
    $grp_NOGP = $APLOT_NOGP;
    $grp_tag = $SOURCE{'align_tag'}; # %SOURCE is a temporary hash name
  };
    $label = $group_id = $grp_counter;
    defined($attributes) || do {
        $group = "$grp_string\_$group_id";
	    return $grp_NOGP;
    };
    my @grouping_list = ();
    @grouping_list = split /\b\s*;\s*\b/o, $attributes;
	
#line 2472 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $grp_flag = 0;
my @new_group = ();
my $groupregexp = '^(.*?)(?:"(.+?)"(?:\s+\b(.*))?)?$'; #'
my $group_string = shift @grouping_list;
($group_string =~ /$groupregexp/o) && 
    (@new_group = ($1,$2,$3));
$new_group[0] =~ s/\b\s*$//o;
$new_group[0] || do {  # type 2 attributes
    $grp_flag = 1;
    $new_group[0] = $grp_tag;
};
$new_group[1] || do {  # type 1 attributes
    $grp_flag = 1;
    $new_group[1] = $new_group[0];
    $new_group[0] = $grp_tag;
};
($tag,$group) = (lc($new_group[0]),$new_group[1]);
# Here looking for colon field separator in aplot GFF-like grouping
($grp_flag && $group =~ /^(.*?):(.*?)$/o) && (($group,$label) = ($1,$2));
#line 2464 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
	
#line 2496 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$_type && do { # GFF grouping
    $tag =~ /$SOURCE{'align_tag'}/ && do {
        &load_GFF_align;
        return $ALIGN;
    }; 
    $tag =~ /$SOURCE{'vector_tag'}/ && do {
        &load_GFF_vector;
        return $VECTOR;
	};
};
#line 2511 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
scalar(@grouping_list) > 0 && do{ 
    foreach my $element (@grouping_list) {
        ($element =~ /$groupregexp/o) && (@new_group = ($1,$2,$3));
        lc($new_group[0]) =~ $SOURCE{'label_tag'} && do {
            $label = $new_group[1];
            $label eq "" && do {
                (undef,$label,undef) = split /\s+/og, $new_group[0];
            };
        };
    };
};
#line 2465 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    return $grp_GP;
}
#line 2582 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_GFF_align() {

} # load_GFF_align
#line 2594 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub load_GFF_vector() {
	@vect_ary = ();
} # load_GFF_vector
#line 2643 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub sort_elements() {
    &header("SORTING ELEMENTS BY ACCEPTOR (START)");
    %Order = ();
    # sorting %GFF_DATA contents 
    scalar(%GFF_DATA) && do {
        &report('SORT_GFF','*- ','ANNOTATION DATA');
        my ($v_max,$v_min);
        my $sq_ord = \@{ $Order{GFF} } ;
        @{ $sq_ord } = ();
        my $s_ref = \%GFF_DATA;
        foreach my $s_seq (keys %{ $s_ref }) {
            
#line 2684 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
&report('SORT_SEQ','|  *- ',$s_seq);
my @sc_coords = ();
push @{ $sq_ord },
        [ $s_seq,
          $s_ref->{$s_seq}[$_counter][$_order],
          () ];
my $sc_ord = \@{ $sq_ord->[ $#{$sq_ord} ][2] };
my $ss_ref = \%{ $s_ref->{$s_seq}[$_element] };
foreach my $s_src (keys %{ $ss_ref }) {
    
#line 2700 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
&report('SORT_SRC',(('|  ' x 2).'*- '),$s_src);
my @sr_coords = ();
push @{ $sc_ord },
        [ $s_src,
          $ss_ref->{$s_src}[$_counter][$_order],
          () ];
my $sr_ord = \@{ $sc_ord->[ $#{$sc_ord} ][2] };
my $sc_ref = \%{ $ss_ref->{$s_src}[$_element] };
foreach my $s_str (keys %{ $sc_ref }) {
    
#line 2722 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
&report('SORT_STR',(('|  ' x 3).'*- '),$s_str);
my @ft_coords = ();
push @{ $sr_ord },
        [ $s_str,
          # $sc_ref->{$s_str}[$_counter][$_order],
          () ]; # if uncomment '$sc_ref' set next to [2] instead of [1].
my $st_ord = \@{ $sr_ord->[ $#{$sr_ord} ][1] };
my $sr_ref = \%{ $sc_ref->{$s_str}[$_element] };
#line 2841 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $sortfunct = ($s_str eq '-') ? \&sort_reverse : \&sort_forward;
#line 2731 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
my $s_elem;
foreach my $s_grp (keys %{ $sr_ref }) {
    
#line 2745 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
&report('SORT_GRP',(('|  ' x 4).'*- '),$s_grp);
my $sg_ref = \@{ $sr_ref->{$s_grp}[$_element] };
$s_elem = $sr_ref->{$s_grp}[$_counter][$_elemNum];
$s_elem > 1 && do {
    @{ $sg_ref } = map { $_->[2] }
                   sort { &$sortfunct }
                   map { [ $_->[4],
                           $_->[5],
                           $_ ] } @{ $sg_ref }; # maps 'start 'end 'arrayelement
}; # $s_elem > 1
@ft_coords = ( map { $_->[4], $_->[5] } @{ $sg_ref } );
$v_min = &min(@ft_coords);
$v_max = &max(@ft_coords);
$sr_ref->{$s_grp}[$_counter][$_ori] = $v_min;
$sr_ref->{$s_grp}[$_counter][$_end] = $v_max;
push @{ $st_ord }, [ $s_grp, $v_min, $v_max ];
&report('SORT_FTR',('|  ' x 5),$s_elem);
#line 2734 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
}; # foreach $s_grp
#line 2776 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
@ft_coords = ( map { $_->[1], $_->[2] } @{ $st_ord } );
$v_min = &min(@ft_coords);
$v_max = &max(@ft_coords);
$sc_ref->{$s_str}[$_counter][$_ori] = $v_min;
$sc_ref->{$s_str}[$_counter][$_end] = $v_max;
push @sr_coords, $v_min, $v_max;
#
@{ $st_ord } = map { $_->[2] }
               sort { &$sortfunct }
               map { [ $_->[1], $_->[2], $_->[0] ] } @{ $st_ord };
$s_elem = $sc_ref->{$s_str}[$_counter][$_elemNum];
&report('SORT_GPN',('|  ' x 4),$s_elem);
#line 2710 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
}; # foreach $s_str
#line 2799 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$v_min = &min(@sr_coords);
$v_max = &max(@sr_coords);
$ss_ref->{$s_src}[$_counter][$_ori] = $v_min;
$ss_ref->{$s_src}[$_counter][$_end] = $v_max;
push @sc_coords, $v_min, $v_max;
#line 2694 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
}; # foreach $s_src
&sort_by_inputorder($sc_ord);
#line 2807 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$s_ref ->{$s_seq}[$_counter][$_ori] = &min(@sc_coords);
$s_ref ->{$s_seq}[$_counter][$_end] = &max(@sc_coords);
#line 2655 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
        }; # foreach $s_seq
        &sort_by_inputorder($sq_ord);
        print LOGFILE '>>> \%Order{GFF} : '.(Dumper(\%{ $Order{GFF} }))
            if ($LogFile && $Debug);
    }; # scalar(%GFF_DATA) > 0
    # sorting %ALN_DATA contents 
    scalar(%ALN_DATA) && do {
        my $s_ref = \%ALN_DATA;
        &report('SORT_GFF','*- ','ALIGNMENT DATA');
    }; # scalar(%ALN_DATA) > 0
  # print LOGFILE '>>> \%GFF_DATA : '.(Dumper(\%GFF_DATA))
  #     if ($LogFile && $Debug);
    &footer("ELEMENTS SORTED");
} # sort_elements
#line 2812 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub sort_by_inputorder() {
    my $ref = $_[0];
    @{ $ref } = map { [ $_->[0], $_->[2] ] }
                sort { $a->[1] <=> $b->[1] }
                map { [ $_->[0], $_->[1], $_->[2] ] } @{ $ref };
} # sort_by_inputorder
#line 2825 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub sort_forward {
    $a->[0] <=> $b->[0]  # sorting by start
             or
    $b->[1] <=> $a->[1]; # reverse sorting by end if same start
} # sort_forward
#
sub sort_reverse {
    $b->[1] <=> $a->[1] # reverse sorting by end
             or
    $a->[0] <=> $b->[0];  # sorting by start if same end
} # sort_forward
#line 2613 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub map_vars_layout() {
    &header("SETTING CUSTOM VALUES TO LAYOUT ELEMENTS");

    &footer("VALUES SET for LAYOUT ELEMENTS");
} # map_vars_layout
#line 2626 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub map_vars_data() {
    &header("SETTING CUSTOM VALUES TO GFF ELEMENTS");

    &footer("VALUES SET for GFF ELEMENTS");
} # map_vars_data
#line 2852 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub make_plot() {
    &header("WRITING POSTSCRIPT TO STDOUT");

    &ps_header;
    &ps_colors;
    &ps_page_formats;
    &ps_variables;
    &ps_main;

    &ps_plot; 

    &ps_trailer;

    &footer("WRITING POSTSCRIPT FINISHED");
} # make_plot
#line 428 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub prt_help() {
    open(HELP, "| more") ;
    print HELP <<"+++EndOfHelp+++";
PROGRAM:
                        $PROGRAM - $VERSION

    Converting GFF files for pairwise alignments to PostScript.

USAGE:        $PROGRAM [options] <GFF_files|STDIN>

DESCRIPTION:

    This program draws color-filled alignment plots from GFF
    files for that alignment and two sequences annotations.

REQUIRES:

    
#line 470 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
$PROGRAM needs the following Perl modules installed in 
your system, we used those available from the standard 
Perl distribution. Those that are not in the standard 
distribution are marked with an '(*)', in such cases 
make sure that you already have downloaded them from 
CPAN (http://www.perl.com/CPAN) and installed.

#line 665 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Getopt::Long" - processing command-line options.
#line 4223 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Data::Dumper" - pretty printing data structures for debugging (*).
#line 4321 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
"Benchmark" - checking and comparing running times of code.

#line 447 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
ENVIRONMENT VARIABLES:

    
#line 534 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    There are two environmental variables that can be set by 
users to their preferences:
 + You can specify the path where $PROGRAM can find the default
  files with the shell variable \"GFF2APLOT_CUSTOMPATH\". Default
  value is the path where you are running $PROGRAM.
 + You can also define the default custom filename you will like
  with the variable \"GFF2APLOT_CUSTOMFILE\", program default
  filename for custom file is \".gff2aplotrc\".
 + Now $PROGRAM does not need to write any temporary file, 
  so that previous versions default temporary directory path
  variable (\"GFF2APLOT_TMP\") is no longer used.
 + Setting those vars in Bourne-shell and C-shell:
   o Using a Bourne-Shell (e.g. bash):
        export GFF2APLOT_CUSTOMPATH=\"path\"
        export GFF2APLOT_CUSTOMFILE=\"file_name\"
   o Using a C-Shell:
        setenv GFF2APLOT_CUSTOMPATH \"path\"
        setenv GFF2APLOT_CUSTOMFILE \"file_name\"

#line 451 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
COMMAND-LINE OPTIONS:

    
#line 480 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
A double dash on itself "--" signals end of the options
and start of file names (if present). You can use a single
dash "-" as STDIN placeholder. Available options and a
short description are listed here:

#line 691 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-h, --help    Shows this help.
--version     Shows current version and exits.
#line 1264 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-v, --verbose    Verbose mode, a full report is sent to standard error 
                 (default is set to showing only WARNINGS).
#line 1282 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-V, --logs-filename <logs_filename>    Report is written to a log file.
#line 1300 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-q, --quiet    Quiet mode, do not show any message/warning
               to standard error (only ERRORS are reported).
#line 792 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-O, --custom-filename <custom_filename> Load a configuration file 
         (if default \".gff2aplotrc\" exists is loaded before it).
#line 1324 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-S, --sequence1-start <pos>   Sets X-sequence first nucleotide.
#line 1336 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-E, --sequence1-end <pos>     Sets X-sequence last nucleotide.
#line 1348 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-s, --sequence2-start <pos>   Sets Y-sequence first nucleotide.
#line 1360 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-e, --sequence2-end <pos>     Sets Y-sequence last nucleotide.
#line 1372 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-Z, --zoom [ [-S <pos>] [-E <pos>] [-s <pos>] [-e <pos>] ]
               This option zooms an area you have selected
               with -S,-E,-s,-e (all 4 are optional).
#line 1386 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-z, --zoom-area [ [-S <pos>] [-E <pos>] [-s <pos>] [-e <pos>] ]
               This option marks a zoom area on your plot,
               but does not make a zoom.
#line 1401 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-G, --display-grid   Switches 'on' grid (default is 'off').
#line 1414 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-P, --display-percent-box   Switches 'on' Percent box (default is 'off').
#line 1427 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-Q, --display-extra-box   Switches 'on' Extra box (default is 'off').
#line 1439 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-T, --title <Title>   Definning Plot Title.
#line 1451 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-t, --subtitle <Subtitle>   Definning Plot SubTitle.
#line 1463 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-X, --x-label <X-Label>   Definning X-Axis Label.
#line 1475 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-Y, --y-label <Y-Label>   Defining Y-Axis Label.
#line 1488 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-L, --percent-box-label <PBox-Label>   Definning Percent-Box Label.
#line 1500 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-l, --extra-box-label <XBox-Label>   Definning Extra-Box Label.
#line 1513 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-R, --xy-axes-scale   X and Y axes having same scale (default is 'off').
#line 1525 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-W, --aln-scale-width   Scaling score on width for Aplot line.
#line 1537 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-w, --aln-scale-color   Scaling score on color for Aplot line.
#line 1549 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-B, --background-color <color>   Background color.
#line 1561 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-F, --foreground-color <color>   Foreground color.
#line 1573 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-D, --aplot-box-color <color>   Aplot main box background color.
#line 1585 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-C, --percent-box-color <color>   Percent box background color.
#line 1597 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-c, --extra-box-color <color>   Extra box background color.
#line 1609 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-A, --alignment-name <SeqXName:SeqYName>   Defining which alignment is going to be plotted 
                  if you have more than one alignment in your gff files.
#line 1622 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-N, --x-sequence-name <SeqXName>   Defining which sequence is going to be plotted at X-axes.
#line 1634 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-n, --y-sequence-name <SeqYName>   Defining which sequence is going to be plotted at Y-axes.
#line 1646 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-K, --show-ribbons <ribbon_type> Force Ribbons for all features on axes:
                 (N)one, (L)ines, (R)ibbons, (B)oth.
#line 1659 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-I, --page-size <page_size> Set page size for plot (default is a4).
#line 1671 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
-a, --show-credits  Switch off $PROGRAM CopyRight line on plot.
#line 4230 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
--debug    Reporting variable contents when testing the program.

#line 455 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 3483 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
Those are the colors defined in $PROGRAM:
+ Basic Colors: black white.
+ Variable Colors: 
      grey magenta violet blue skyblue cyan seagreen
         green limegreen yellow orange red brown
  You can get five color shades from Variable Colors with
  \"verydark\", \"dark\", \"light\" and \"verylight\" prefixes,
  as example: 
    verydarkblue, darkblue, blue, lightblue and verylightblue.

#line 457 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
    
#line 3585 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
The following page sizes are available: from A0 to A10, 
from B0 to B10, 10x14, executive, folio, ledger, legal, 
letter, quarto, statement and tabloid.

#line 459 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
BUGS:    Report any problem to 'jabril\@imim.es'.

AUTHOR:  $PROGRAM is under GNU-GPL (C) 2000 - Josep F. Abril

+++EndOfHelp+++
    close(HELP);
    exit(1);
} # prt_help
#line 326 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# GENERAL FUNCTIONS
#
#line 656 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub close_logfile() { close(LOGFILE) if $LogFile };
#line 4188 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub trap_signals() {
    &prt_to_logfile($Messages{'USER_HALT'});
    &close_logfile();
    die($Messages{'USER_HALT'});
}
#line 4196 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub trap_signals_prog() {
    &prt_to_logfile($Messages{'PROCESS_HALT'});
    &close_logfile();
    die($Messages{'PROCESS_HALT'});
}
#line 4262 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub warn() {
    my $type = shift @_;
    my $screen_flg = shift @_;
    my $comment = sprintf($Messages{$type}, @_);
    # ALWAYS to STDERR if $screen_flg==$T unless $Quiet==$T
    $screen_flg && ($Quiet || print STDERR $comment); 
    &prt_to_logfile($comment);
} # warn
#line 4273 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub prt_to_logfile() { $LogFile && (print LOGFILE $_[0]) }
sub prt_to_stderr()  { $Verbose && ($Quiet || print STDERR $_[0]) }
#line 4285 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub report() {
    my $type = shift @_;
    my $comment = sprintf($Messages{$type},@_);
    &prt_to_stderr($comment);
    &prt_to_logfile($comment);
} # report
#line 4294 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub header() {
    my $comment = $line;
    foreach my $ln (@_) { 
        $comment .= "### ".&fill_mid("$ln",72," ")." ###\n";
        };
    $comment .= $line;
    &prt_to_stderr($comment);
    &prt_to_logfile($comment);
} # header
sub footer() {
    $total_time = &timing($F);
    &header(@_,$total_time);
    &prt_to_stderr("###\n");
    &prt_to_logfile("###\n");
}
#line 4332 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub timing() {
    push @Timer, (new Benchmark);
    # partial time 
    $_[0] || 
        (return timestr(timediff($Timer[$#Timer],$Timer[($#Timer - 1)])));
    # total time
    return timestr(timediff($Timer[$#Timer],$Timer[0]));
}
#line 4679 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
sub max() {
    my $z = shift @_;
    foreach my $l (@_) { $z = $l if $l > $z };
    return $z;
} # max
sub min() {
    my $z = shift @_;
    foreach my $l (@_) { $z = $l if $l < $z };
    return $z;
} # min
#
sub fill_right() { $_[0].($_[2] x ($_[1] - length($_[0]))) }
sub fill_left()  { ($_[2] x ($_[1] - length($_[0]))).$_[0] }
sub fill_mid()   { 
    my $l = length($_[0]);
    my $k = int(($_[1] - $l)/2);
    ($_[2] x $k).$_[0].($_[2] x ($_[1] - ($l+$k)));
} # fill_mid
#
sub counter { # $_[0]~current_pos++ $_[1]~char
    print STDERR "$_[1]";
    (($_[0] % 50) == 0) && (print STDERR "[".&fill_left($_[0],6,"0")."]\n");
} # counter
#
sub counter_end { # $_[0]~current_pos   $_[1]~char
    (($_[0] % 50) != 0) && (print STDERR "[".&fill_left($_[0],6,"0")."]\n");
} # counter_end
#line 330 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
#
# POSTSCRIPT CODE
#
#line 3015 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_plot(){
} # ps_plot
#line 2884 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_header() {
    print STDOUT << "+++HEADER+++";
%!PS-Adobe-3.0
%%Title: title
%%Creator: $PROGRAM
%%Version: $VERSION
%%CreationDate: $DATE
%%For: $USER
%%Pages: 1
%%Orientation: Portrait
%%BoundingBox: 0 0 595 842
%%EndComments
%
#line 4772 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                          GFF2APLOT                               %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    Converting alignments in GFF format to PostScript dotplots.
% 
%     Copyright (C) 1999 - Josep Francesc ABRIL FERRANDO  
%                                  Thomas WIEHE                   
%                                 Roderic GUIGO SERRA       
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#line 2898 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%
% $LAST_UPDATE
%
% Report BUGS to: jabril@\imim.es 
%
%%BeginProlog
%
#line 3595 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: Short_names 1.0 0
%
/tflg false def % test flag
/bdf { bind def } bind def
/xdf { exch def } bdf
/cm { 28.35 mul } bdf
/ivcm { 28.35 div } bdf
/in { 72    mul } bdf
/F { scale } bdf
/T { translate } bdf
/S { gsave } bdf
/R { grestore } bdf
/m { moveto } bdf
/rm { rmoveto } bdf
/l { lineto } bdf
/rl { rlineto } bdf
/K { stroke } bdf
/scmyk { setcmykcolor } bdf
/slw { setlinewidth } bdf
/bbox { 4 copy 3 1 roll exch 6 2 roll 8 -2 roll m l l l closepath } bdf
/dotted { [ 1 ] 0 setdash } def
%
%%EndProcSet:   Short_names 1.0 0
%
#line 3624 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: Constants 1.0 0
%
% Printing Offset
/VUpOS 0.25 cm def  % offset defines non printable
/VDnOS 0.25 cm def  % paper area for pages (printer outlimits).
/HLtOS 0.25 cm def
/HRtOS 0.25 cm def
/htag   0 def
/Xmarg  5.0 cm def       % Starting Point (upper left corner)
/Ymarg  842 2 cm sub def
/Y Ymarg def
/PlotWidth  14 cm def    % Blocks Size
/Spacer   1.00 cm def    % BBox relative to dotplot
/BBoxX  PlotWidth def    % SBox relative to percent box
/BBoxY   14.00 cm def    % XBox relative to extra box
/SBoxX  PlotWidth def
/SBoxY    2.25 cm def
/XBoxX  PlotWidth def
/XBoxY    3.00 cm def
/WBox     0.50 cm def    % TagBox Size
/HWBox WBox 2 div    def
/Warw  WBox 0.75 mul def
/HWarw Warw 2 div    def
%
%%EndProcSet:   Constants 1.0 0
%
#line 2907 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
+++HEADER+++
} # ps_header
#line 2914 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_colors() {
  my %tmp = ();
  print STDOUT "%% Fixed Color Variables (CMYK)\n";
  print STDOUT "/colordict ".($colors + 28)." dict def colordict begin %% ".
               $colors." colors + 28 definitions\n";
  foreach my $key (keys %COLORS) { $tmp{$COLORS{$key}->[0]} = $key };
  for (my $j = 1; $j <= $colors; $j++) { 
      my $name = $tmp{$j};
      my $ref = \$COLORS{$name};
      my $cmyk = "$$ref->[1] $$ref->[2] $$ref->[3] $$ref->[4]";
      print STDOUT "/".(&fill_right($name,20," "))."{ $cmyk } def\n";
      };
  print STDOUT "end %% colordict\n";
} # ps_colors
#line 2940 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_page_formats() {
  my %tmp = ();
  print STDOUT "%% Paper Sizes (in points)\n";
  print STDOUT "/pagedict ".($formats + 2)." dict def pagedict begin %% ".
               $formats." formats + 2 definitions\n";
  foreach my $key (keys %FORMATS) { $tmp{$FORMATS{$key}->[0]} = $key };
  for (my $j = 1; $j <= $formats; $j++) { 
      my $name = $tmp{$j};
      my $ref = \$FORMATS{$name};
      my $pgsz = &fill_left($$ref->[1],4," ").&fill_left($$ref->[2],5," ");
      print STDOUT "/pg".(&fill_right($name,10," "))."{ $pgsz } def\n";
      };
  print STDOUT "end %% pagedict\n";}
#line 2968 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_variables() {
    print STDOUT << '+++PSVARS+++';
%%BeginProcSet: Setting_Vars 1.0 0
%
%%EndProcSet:   Setting_Vars 1.0 0
%
+++PSVARS+++
} # ps_variables
#line 2985 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_main() {
    print STDOUT << '+++MAINProcs+++';
#line 3655 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: Page_Layout 1.0 0
%
/TitleFont    { 24 /Times-Bold  } def
/SubTtFont    { 16 /Times-Roman } def
/ElmFont      { 12 FTLbsc mul /Times-Roman } def
/TagFont      { 14 GPLbsc mul /Times-Roman } def
/TagLabelFont { 16 /Times-Bold  } def
/TickFont     { 10 /Helvetica } def
%
/xBDspl  1.8 putExon add putExLbl add putGnLbl add def % 1.25
/xGLDspl 1.0 putExon add putExLbl add def              % 0.85
/xGDspl  0.75 putExon add putExLbl add def
/FBDspl 0.60 def % For example, for mRNA.
%
/vertical   { /htag 0 def } bdf
/horizontal { /htag 1 def } bdf
%
/FSF 4 def % Point size for Credits for A4
/CSF { pagedict begin pga4 pop end Dpage pop exch div mul } bdf
%
% checking if margins are within the defined offset
flglscape {
 UpM HLtOS lt { /UpM HLtOS def } if % Checking margins for flglscape mode
 DnM HRtOS lt { /DnM HRtOS def } if
 LtM VDnOS lt { /LtM VDnOS def } if
 RtM VUpOS lt { /RtM VUpOS def } if
 } {
  UpM VUpOS lt { /UpM VUpOS def } if % Checking margins for portrait mode
  DnM VDnOS lt { /DnM VDnOS def } if
  LtM HLtOS lt { /LtM HLtOS def } if
  RtM HRtOS lt { /RtM HRtOS def } if
  } ifelse
% defining pagelimits and X - Y scales (Xlim Ylim)
/pglim { Dpage pop LtM RtM add sub Dpage exch pop UpM DnM add sub } def
% Defining starting point on page.
/XORI LtM def
/YORI UpM def
%
%%EndProcSet:   Page_Layout 1.0 0
%
#line 3700 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: text_functions 1.0 0
%
/sfont { findfont exch scalefont setfont } bdf
/tshow { S scmyk sfont m rotate show R } bdf
/ctshow {
  10 -1 roll dup 11 1 roll 7 -2 roll 2 copy 9 2 roll 
  S sfont stringwidth pop R 2 div 
  htag 1 eq {
    9 -1 roll exch sub 8 1 roll
    } {
      8 -1 roll exch sub 7 1 roll
    } ifelse
  tshow
  } bdf
/ltshow {
  10 -1 roll dup 11 1 roll 7 -2 roll 2 copy 9 2 roll 
  S sfont stringwidth pop R 
  htag 1 eq {
    9 -1 roll exch sub 8 1 roll
    } {
      8 -1 roll exch sub 7 1 roll
    } ifelse
  tshow
  } bdf
%
% X Y angle string valign halign fnt color ttxt
 % valign : tv (top)  cv (middle) bv (bottom)
 % halign : lh (left) ch (center) rh (right)
/chrh { 
  S newpath 0 0 m false 
  charpath flattenpath pathbbox exch pop
  3 -1 roll pop R
  } bdf
/strh {
  2 dict begin /lly 0.0 def /ury 0.0 def 
  { ( ) dup 0 4 -1 roll put chrh 
    dup ury gt { /ury xdf } { pop } ifelse
    dup lly lt { /lly xdf } { pop } ifelse
    } forall
  ury end
  } bdf
/ttxt {
  S scmyk sfont 8 dict begin 
  /h xdf /v xdf /lbl xdf /angle xdf /y xdf /x xdf 
  /hs lbl stringwidth pop neg def /vs lbl strh neg def
  x y T angle rotate
  h (rh) eq { hs
    } {
      h (ch) eq { hs 2 div } { 0 } ifelse
    } ifelse
  v (tv) eq { vs
    } {
      v (cv) eq { vs 2 div } { 0 } ifelse
    } ifelse
  m lbl show end R
  } bdf
%
/Title { S 0 Xmarg Y TitleFont FGcolor tshow R /Y Y 0.75 cm sub def } bdf 
/SubTitle { S 0 Xmarg Y SubTtFont FGcolor tshow R /Y Y 2.5 cm sub def } bdf 
%
%%EndProcSet:   text_functions 1.0 0
%
#line 3767 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: aplotdict 1.0 0
%
/aplot 120 dict def aplot begin
/min { 2 copy gt { exch } if pop } bdf 
/max { 2 copy lt { exch } if pop } bdf
/Xscm { Xscale mul } bdf /Xscme { Xscm exch } bdf
/Yscm { Yscale mul } bdf /Yscme { Yscm exch } bdf
/fmt { Yscme Xscme m } bdf /flt { Yscme Xscme l } bdf
/line { scmyk slw m l K } bdf
/uline {
  scmyk slw m S htag 1 eq { 0 -0.1 cm } { 0.1 cm 0 } ifelse
  rl K R l S htag 1 eq { 0 -0.1 cm } { 0.1 cm 0 } ifelse
  rl K R K
  } bdf
/ZoomTicks {
  /zmdict 3 dict def zmdict begin
  /r { TxWB BDspl mul Xscm } def /s { TyWB BDspl mul Yscm } def
  /corner { S 10 -2 roll m 
    2 { rl S BGcolor scmyk .4 slw K R rl
      S FGcolor scmyk 2 slw [1 3] 0 setdash K R
      } repeat R 
    } def
  4 copy 3 1 roll exch
  0 s 0 s neg r neg 0 r 0 corner
  0 s neg 0 s r 0 r neg 0 corner
  0 s neg 0 s r neg 0 r 0 corner
  0 s 0 s neg r 0 r neg 0 corner end
  } def
/Line {
  S 9 5 roll 
    2 { Yscm 4 1 roll Xscm 4 1 roll } repeat
    9 4 roll line
  R } bdf
/Xline { 
  S 3 1 roll Xscme Xscme 3 -1 roll Yscm xwdt sub dup
    3 1 roll xwdt 9 -4 roll line
  R } bdf
/Bline {
  S htag 1 eq { Xscme Xscme y0 Yscme y1 Yscm bbox }
     { Yscme Yscme X0 Xscm 3 1 roll X1 Xscme bbox } ifelse
  S scmyk fill 
  R scmyk slw K
  R } bdf
/Bsquare {
  S Yscme Yscme 4 2 roll Xscme Xscme 4 1 roll exch bbox 
  S scmyk fill 
  R scmyk slw K
  R } bdf
/Msquare {
  S Yscme Yscme 4 2 roll Xscme Xscme 4 1 roll exch bbox
    scmyk slw K
  R } bdf
/Mcircle {
  S Yscme Xscme 3 -1 roll Xscm 0 360 arc closepath scmyk slw K
  R } bdf
/Join {
  S 2 copy 2 copy pop sub 2 div add exch
    htag 1 eq {
      y1 TyWB add dup dup TyWB 0.75 mul add 4 1 roll 5 1 roll
      } {
        X0 TxWB sub dup dup TxWB 0.75 mul sub 5 1 roll 6 1 roll exch
      } ifelse
    3 { Yscme Xscme 6 2 roll } repeat
    m l l 0.25 slw scmyk K
  R } bdf
/Arrow {
  /acol [ 9 -4 roll ] def /acolor { acol aload pop } def
  S 1 eq { exch /sn { 1 mul } def } { /sn { 1 neg mul } def } ifelse
    htag 1 eq { Xscm dup y1 Yscm HWBox add m
      HWarw sn HWarw rl 0 Warw neg rl HWarw neg sn HWarw rl closepath
      S acolor scmyk fill R
      y1 Yscm HWBox add m Xscm y1 Yscm HWBox add l acolor scmyk 1 slw K
      } { Yscm dup X0 Xscm HWBox sub exch m
        HWarw neg HWarw sn rl Warw 0 rl HWarw neg HWarw neg sn rl closepath
        S acolor scmyk fill R
        X0 Xscm HWBox sub exch m Yscm X0 Xscm HWBox sub exch l
        acolor scmyk 1 slw K
      } ifelse
  R } bdf
/FBox {
  htag 1 eq {
    Xscme Xscme y1 Yscme y1 TyWB FBDspl mul add Yscm bbox
    } {
      Yscme Yscme X0 Xscm 3 1 roll X0 TxWB FBDspl mul sub Xscme bbox
    } ifelse
  S scmyk fill R FGcolor scmyk 1 slw K
  } bdf
/FTalgn {
  htag 1 eq {
    FTXangle 0 eq { (bv) (ch) } { (cv) (lh) } ifelse
    } {
      FTYangle 0 eq { (cv) (rh) } { (bv) (rh) } ifelse
    } ifelse
  } bdf
/GPalgn {
  htag 1 eq {
    GPXangle 0 eq { (bv) (ch) } { (cv) (lh) } ifelse
    } {
      GPYangle 0 eq { (cv) (rh) } { (bv) (rh) } ifelse
    } ifelse
  } bdf
/Box {
  2 copy 2 copy pop sub 2 div add 7 1 roll
  S htag 1 eq {
    Xscme Xscme y1 Yscme y1 TyWB add Yscm bbox
    } {
      Yscme Yscme X0 Xscm 3 1 roll X0 TxWB sub Xscme bbox
    } ifelse
  S scmyk fill R
  FGcolor scmyk 1 slw K
  htag 1 eq {
    Xscm y1 TyWB 1.75 mul add Yscm FTXangle
    } {
      Yscm X0 TxWB 1.75 mul sub Xscme FTYangle
    } ifelse
  6 -1 roll FTalgn 8 -2 roll FGcolor ttxt
  R } bdf
%
/GDmore {
  MxFtLBL S ElmFont sfont (M) stringwidth pop R mul
  htag 1 eq { FTXangle sin } { FTYangle cos } ifelse
  abs mul ivcm add
  } bdf
/BDmore {
  MxGpLBL S TagFont sfont (M) stringwidth pop R mul
  htag 1 eq { GPXangle sin } { GPYangle cos } ifelse
  abs mul ivcm add
  } bdf
%
/GnBanner{
  S 1 eq {
      2 copy
      htag 1 eq {
        Xscme Xscme y1 TyWB GDspl mul add dup Yscme Yscm 3 1 roll
        } {
          Yscme Yscme X0 TxWB GDspl mul sub dup Xscme Xscme 4 1 roll exch
        } ifelse
      0.5 FGcolor uline
      } if
    2 copy pop sub 2 div add
    htag 1 eq {
      Xscm y1 TyWB GLDspl mul add Yscm GPXangle
      } {
        Yscm X0 TxWB GLDspl mul sub Xscme GPYangle
      } ifelse
    6 -1 roll GPalgn 8 -2 roll FGcolor ttxt
  R } bdf
/SbBanner {
  S htag 1 eq {
      0 X0 X1 X0 sub 2 div add Xscm y1 TyWB GDspl mul add Yscm
      } {
        90 X0 TxWB GDspl mul sub Xscm y0 y1 y0 sub 2 div add Yscm
      } ifelse
    5 -2 roll FGcolor ctshow
  R } bdf
/Banner {
  S htag 1 eq {
      0 X0 X1 X0 sub 2 div add Xscm y1 TyWB BDspl mul add Yscm
      } {
        90 X0 TxWB BDspl mul sub Xscm y0 y1 y0 sub 2 div add Yscm
      } ifelse
    5 -2 roll FGcolor ctshow
  R } bdf
%
% mxt mnt xp yp ori end htick
/tckdict 15 dict def
 tckdict begin
 /mkmxt {
  dup 0 lt { neg } if
  dup 10 lt {
    10 mul log round 10 exch exp cvi
    } {
      log round 10 exch exp cvi
    } ifelse
  } def
 /nwmod {
  dup 1 le {
    100 mul cvi exch 100 mul cvi exch mod 100 div
    } {
      exch dup
      1 le {
        100 mul cvi exch 100 mul cvi mod 100 div
        } {
          cvi exch cvi mod
        } ifelse
    } ifelse
  } def
 /isltone { dup 1 lt { 100 mul cvi 100 div } if } def
end
/htick { 
  S tckdict begin horizontal 
    /yp exch Yscm def /xp exch Xscm def /xend xdf /xori xdf
    /nmnt exch cvi def /nmxt exch cvi def
    /mxt exch dup 0 lt { pop xend xori sub mkmxt } if def
    /mnt exch dup 0 lt { pop mxt nmnt div } if def
    /lori xori dup mnt nwmod sub mnt add def
    /lend xend dup mnt nwmod sub mnt sub def
    xp yp T
    lori mnt lend {
      isltone dup dup xori gt exch xend lt and {
        dup Xscm 0 m dup dup Xscme
        mxt nwmod 0 eq { 7.5 } { 4 } ifelse neg l
        1 slw FGcolor scmyk K
        GridON 1 eq {
          S 0 y0 Yscm neg T dup Xscm dup y0 Yscm m y1 Yscm l
          0.1 slw verylightgrey scmyk K R
          } if
        dup mxt nwmod 0 eq {
          dup xend mnt sub exch ge {
            dup dup 1 ge { cvi } if
            10 string cvs 0 3 -1 roll Xscm -18 TickFont FGcolor ctshow
            } if
          } {
            pop
          } ifelse
        } if
      } for
    xori Xscm dup 0 m 7.5 neg l 2 slw FGcolor scmyk K
    xori 10 string cvs 0 xori Xscm ZoomON 1 eq { 4 sub } if
    -18 TickFont FGcolor ZoomON 0 eq { ctshow } { ltshow } ifelse
    xend Xscm dup 0 m 7.5 neg l 2 slw FGcolor scmyk K
    xend 10 string cvs 0 xend Xscm ZoomON 1 eq { 4 add } if
    -18 TickFont FGcolor ZoomON 0 eq { ctshow } { tshow } ifelse
  end R } def
/vtick {
  S tckdict begin vertical
    /yp exch Yscm def /xp exch Xscm def /xend xdf /xori xdf
    /nmnt exch cvi def /nmxt exch cvi def
    /mxt exch dup 0 lt { pop xend xori sub mkmxt } if def
    /mnt exch dup 0 lt { pop mxt nmnt div } if def
    /lori xori dup mnt nwmod sub mnt add def
    /lend xend dup mnt nwmod sub mnt sub def
    xp yp T
    lori mnt lend {
      isltone dup dup xori gt exch xend lt and {
        dup Yscm 0 exch m dup dup Yscme
        mxt nwmod 0 eq { 7.5 } { 4 } ifelse exch l
        1 slw FGcolor scmyk K
        GridON 1 eq {
          S X0 Xscm 0 T dup Yscm dup X0 neg Xscme m
          X1 neg Xscme l 0.1 slw verylightgrey scmyk K R
          } if
        dup 0 eq {
          S dup dup X0 Xscme Yscm m X1 neg Xscme Yscm l
          0.1 slw FGcolor scmyk K R
          } if
        dup mxt nwmod 0 eq {
          dup xend mnt sub exch ge {
            dup dup 1 ge { cvi } if
            10 string cvs 0 10 4 -1 roll Yscm 2.5 sub TickFont FGcolor tshow
            } if
          } {
            pop
          } ifelse
        } if
      } for
    7.5 xori Yscm dup 0 exch m l 2 slw FGcolor scmyk K
    xori 10 string cvs 0 10 xori Yscm
    ZoomON 0 eq { 2.5 sub } { 2.5 add } ifelse
    TickFont FGcolor tshow 7.5 xend Yscm dup 0 exch m l
    2 slw FGcolor scmyk K xend 10 string cvs 0 10 xend Yscm
    ZoomON 0 eq { 2.5 sub } { 2.5 add } ifelse
    TickFont FGcolor tshow end
  R } def
/nucltick { tickmn tickmx maxtck mintck X0 X1 0 y0 htick } def
/pctmarks {
  S y0 10 y1 {
      Yscm dup X0 Xscm X1 Xscm 3 1 roll 4 1 roll 0.5 FGcolor line
      } for
  R } bdf
%
/beginfunct {
  R S 3 dict begin
    /maxx exch ceiling def /minx exch floor def
    /Yscale XBoxY maxx minx sub div def
    minx 0 lt { 0 minx neg Yscm T } if
    S XBYtickflg 1 eq {
        -1 -1 xtrmxt xtrmnt minx maxx X1 0 vtick
        S X0 Xscm 0 m X1 Xscm 0 l dotted FGcolor scmyk K R
        } if
    R
  } def /endfunct { end R } def
end % aplot dict
%
%%EndProcSet:   aplotdict 1.0 0
%
#line 4058 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%%BeginProcSet: main_function_calls 1.0 0
%
/s_credits {
  S 1 dict begin
    /fs_cd FSF def
    pagedict begin
    pga4 pop end 1 cm sub DnM T 0 0 0
(This plot has been obtained using GFF2APLOT. The most recent version of GFF2APLOT is freely available at \042http:\/\/www1.imim.es/software/gfftools/APLOT.html\042. Copyright      1999 by Josep F. ABRIL, Thomas WIEHE & Roderic GUIGO)
    (cv) (rh) fs_cd /Times-Roman FGcolor ttxt
    S fs_cd /Times-Roman sfont
    (   1999 by Josep F. ABRIL, Thomas WIEHE & Roderic GUIGO)
    stringwidth pop neg R 0 0 (\343) (cv) (ch) fs_cd /Symbol FGcolor ttxt
    end
  R } bdf
%
/estlbl {
  S 3 dict begin
    /lbl xdf /ypos xdf /xpos xdf
    horizontal
      0 Xlwdt 4 div neg T
      lbl 0 xpos Xscm ypos Yscm 5 /Helvetica black ctshow
    vertical
    end
  R } bdf
%
/GsclonX {
  /Y exch Y Spacer sub exch sub def
  Xmarg Y T
  axesp 0 eq {
    /Xscale { BBoxX X1 X0 sub Y1 Y0 sub max div } def
    } {
      /Xscale { BBoxX X1 X0 sub div } def
    } ifelse
  } bdf
%
% DOTPLOT BOX
/begindata {
 aplot begin
  S /y1 Y1 def /y0 Y0 def
    BBoxY GsclonX
    axesp 0 eq {
      /Yscale Xscale def
      } {
        /Yscale { BBoxY y1 y0 sub div } def
      } ifelse
    /TxWB { WBox Xscale div } def /TyWB { WBox Yscale div } def
    /GDspl { xGDspl GDmore } def /GLDspl { xGLDspl GDmore } def
    /BDspl { xBDspl GDmore BDmore } def
    X0 Xscm neg y0 Yscm neg T
    S X0 Xscm y0 Yscm X1 Xscm y1 Yscm bbox BBoxcol scmyk fill R
    S X0 Xscm y0 Yscm X1 Xscm y1 Yscm
      ZoomON 1 eq { 4 copy ZoomTicks } if bbox
      2 slw FGcolor scmyk K
    R
    S BBXtickflg 1 eq {
        nucltick /Spacer 1 cm def
        } {
          /Spacer 0.5 cm def
        } ifelse
      BBYtickflg 1 eq {
        tickmn tickmx maxtck mintck y0 y1 X1 0 vtick
        } if
    R newpath
 } def
/enddata { R /GDspl xGDspl def /GLDspl xGLDspl def /BDspl xBDspl def end } def
%
% PERCENT BOX
/beginmatches {
 aplot begin 
   /ZoomON 0 def S /y1 xdf /y0 xdf SBoxY GsclonX
   /Yscale SBoxY y1 y0 sub div def
   X0 Xscm neg y0 Yscm neg T S X0 Xscm y0 Yscm X1 Xscm y1 Yscm bbox
   S
     S SBoxcol scmyk fill R
     S SBoxLab TagLabelFont Banner SBoxSLab TagFont SbBanner
       SBXtickflg 1 eq {
         nucltick /Spacer 1 cm def
         } {
           /Spacer 0.5 cm def
         } ifelse
     R
     S SBYtickflg 1 eq { -1 -1 pctmxt pctmnt y0 y1 X1 0 vtick } if
     R
     S X0 Xscm y0 Yscm X1 Xscm y1 Yscm bbox 2 slw FGcolor scmyk K
     R
   R clip newpath
 } def /endmatches { R R end } def
%
% EXTRA BOX
/beginextra {
 aplot begin
   S /nlines xdf /y0 0 def XBoxY GsclonX
     /Yscale XBoxY nlines 1 add div def
     /Xlwdt Yscale 0.75 mul def /xwdt Yscale 2 div def
     /y1 XBoxY Yscale div def
     X0 Xscm neg 0 T
     S X0 Xscm y0 Yscm X1 Xscm y1 Yscm bbox
       S XBoxcol scmyk fill R
       S XBoxLab TagLabelFont Banner XBoxSLab TagFont SbBanner
         XBXtickflg 1 eq { nucltick } if
       R newpath
  } def
/endextra {
  /Yscale XBoxY nlines 1 add div def
  X0 Xscm y0 Yscm X1 Xscm y1 Yscm bbox
  2 slw FGcolor scmyk K R
  R end
  } def
%
%%EndProcSet:   main_function_calls 1.0 0
%
#line 2991 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
%
%%EndProlog
%
%%BeginSetup
%
% initgraphics
% true setpacking
true setstrokeadjust
0.125 setlinewidth
0 setlinejoin
0 setlinecap
%
%%EndSetup
%
+++MAINProcs+++
} # ps_main
#line 3024 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_open_page() {
    print STDOUT << '+++OPEN+++';
%%Page: 1 1
%%BeginPageSetup
%
% Saving current page settings
/pgsave save def
% Setting BGcolor for sheet
Dpage 0 0 bbox S BGcolor scmyk fill R clip newpath
% Setting page-size scale
1 CSF dup F
%%EndPageSetup
%
+++OPEN+++
} # ps_open_page
#line 3042 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_close_page() {
    print STDOUT << '+++CLOSE+++';
%
flgcrd { s_credits } if
grestoreall
pgsave restore
showpage
%
%%PageEND: 1 1
%
+++CLOSE+++
} # ps_close_page
#line 3059 "/home/ug/jabril/development/softjabril/gfftools/gff2aplot/gff2aplot.nw"
sub ps_trailer() {
    print STDOUT << "+++EOF+++";
%%Trailer
%
%%Pages: 1
%%Orientation: Portrait
%%BoundingBox: 0 0 595 842
%%EOF
+++EOF+++
} # ps_trailer