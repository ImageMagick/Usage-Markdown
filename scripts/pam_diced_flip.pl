#!/usr/bin/perl
#
# pam_diced_flip [option] image
#
# Dice an very large image into smaller images, then rotate each image,
# reorder files, and append the images back together into a large image
# using a very small amount of memory.
#
# Images must be a PbmPlus/NetPBM image file format, and only PbmPlus/NetPBM
# commands are used to do the work.
#
# NetPbm actually states that the dice (and later undice) programs are really
# for OTHER programs (e.g. GIMP).  This just makes it less ram intensive.
#
# NetPbm noramlly handles 'streamed' images fine, the exception is rotates and
# flips as these require access to the whole image. You might find it
# "interesting" to compare the performance of "my" flip versus netpbm flip on
# an image larger than your RAM :-)
#
# This script is an example of handling massive images.  It shows how large
# images can be processed in smaller tiles or chunks.
#
# --
#
# Original script "flip_dice.pl" is by "bugbear" on the IM forums
# Paul Womack   pwomack_AT_papermule_DOT_co_DOT_uk
#
# Extra comments added by Anthony Thyssen for clarity - 10 May 2013
#
use strict;
use Data::Dumper;
use Getopt::Std;
my %opt;

my $USAGE = qq@-s <side(512)> -r90|-r180|-r270 [infile]@
;

my ($side, $rot, $f_in);

my $STEM="rot_tmp";
my $FLIPSTEM="_${STEM}";
my $SUFFIX;
my $digits;

sub tidy {
    system("rm -f $STEM*");
    system("rm -f $FLIPSTEM*");
}

$SIG{INT} = \&tidy;

sub docmd {
    my ($cmd) = @_;
    # print STDERR "$cmd\n";
    my $info;
    $info = `$cmd`;
    if($? != 0) {
        die;
    }
}

sub flip_all {
  my ($tx, $ty) = @_;
  for(my $y = 0; $y < $ty; $y++) {
    for(my $x = 0; $x < $tx; $x++) {
      my $i = sprintf("%s_%0${digits}d_%0${digits}d.${SUFFIX}",
                                 $STEM, $y, $x);
      my $o = sprintf("%s_%0${digits}d_%0${digits}d.${SUFFIX}",
                                 $FLIPSTEM, $y, $x);
      docmd("pamflip $rot $i > $o");
      unlink($i);
    }
  }
}

sub getmatrix {
  my ($tx, $ty) = @_;
  if($rot eq "-r90") {
    return [0,-1,1,0,0,$tx - 1];
  }
  if($rot eq "-r270") {
    return [0,1,-1,0,$ty - 1,0];
  }
  # must be 180
  return [-1,0,0,-1,$tx - 1, $ty - 1];
}

sub matmul {
  my ($m, $x, $y) = @_;
  return ($m->[0] * $x + $m->[2] * $y + $m->[4],
    $m->[1] * $x + $m->[3] * $y + $m->[5])
}

sub rename_all {
  my ($tx, $ty) = @_;
  my $matrix = getmatrix($tx, $ty);
  for(my $y = 0; $y < $ty; $y++) {
    for(my $x = 0; $x < $tx; $x++) {
      my $i = sprintf("%s_%0${digits}d_%0${digits}d.${SUFFIX}",
                                        $FLIPSTEM, $y, $x);
      my ($x1, $y1) = matmul($matrix, $x, $y);
      my $o = sprintf("%s_%0${digits}d_%0${digits}d.${SUFFIX}",
                                        $STEM, $y1, $x1);
      # print("$x,$y -> $x1,$y1\n");
      # print STDERR "mv $i $o\n";
      rename($i, $o);
    }
  }
}

sub xfer {
    my ($dest, $src) = @_;
    my $buffer;
    while(read($src, $buffer, 1024 * 64)) {
  print $dest $buffer;
    }
}

sub undice {
  my ($tx, $ty) = @_;
  my @rows;
  for(my $y = 0; $y < $ty; $y++) {
    my @cols;
    for(my $x = 0; $x < $tx; $x++) {
      my $f = sprintf("%s_%0${digits}d_%0${digits}d.${SUFFIX}",
                                   $STEM, $y, $x);
      push(@cols, $f);
    }
    my $r = sprintf("%s_%0${digits}d.${SUFFIX}", $STEM, $y);
    docmd("pnmcat -leftright " . join(" ", @cols) . "> $r");
    unlink(@cols);
    push(@rows, $r);
  }
  open(SQUIRT, "pnmcat -topbottom " . join(" ", @rows) . "|")
     or die "failed to open pnmcat";
  xfer(\*STDOUT, \*SQUIRT);
  close(SQUIRT);
  unlink(@rows);
}

# ---------------------------------------------------------------------------

$Getopt::Std::STANDARD_HELP_VERSION=1;
getopts("s:r:", \%opt);

if(!exists($opt{s})) {
  $opt{s} = 512;
}
$side = $opt{s};

if(scalar(@ARGV) > 1) {
  print STDERR "$USAGE\n";
  exit 1;
}
if(scalar(@ARGV) == 1) {
  $f_in = $ARGV[0];
}

if(!exists($opt{r})) {
  print STDERR "$USAGE\n";
  exit 1;
}

$rot = "-r" . $opt{r};
if($rot !~ /-r90|-r180|-r270/) {
  print STDERR "bad rot $rot";
  print STDERR "$USAGE\n";
  exit 1;
}

# dice up the image
my $pamdice = "pamdice -width=$side -height=$side -outstem=$STEM";
if(defined($f_in)) {
    docmd("$pamdice $f_in");
} else {
    open DICE, "|$pamdice" || die "cannot start pamdice";
    xfer(\*DICE, \*STDIN);
    close(DICE);
}

# get the bounds of the array of images
my ($tx,$ty) = (0,0);
opendir DIR, ".";
while(my $dirent = readdir(DIR)) {
  if($dirent =~ /^${STEM}_(\d+)_(\d+)\.(\w{3})$/o) {
    if(!defined($SUFFIX)) {
      $SUFFIX = lc($3);
    }
    if($1 > $ty) {
      $ty = $1;
    }
    if($2 > $tx) {
      $tx = $2;
    }
  }
}
closedir(DIR);
# print STDERR "$tx $ty $SUFFIX\n";

# number of digits in numbers (for renaming)
$digits=length($tx);
if(length($ty) > $digits) {
  $digits=length($ty);
}
$tx++; $ty++; # change indexes to counts

# rotate all the images appropriatally
flip_all($tx, $ty);

# Rename the images into a new array
rename_all($tx, $ty);

if($rot eq "-r180") {
  undice($tx, $ty);
} else {
  undice($ty, $tx);
}
$STEM = undef;

