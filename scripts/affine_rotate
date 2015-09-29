#!/usr/bin/perl
#
# affine_rotate  angle  [center_x,y]  [new_center_x,y]
#
# Generate a affine matrix, that rotates an image by a specific angle.
#
# If a 'center of rotation' is given, add an appropriate translation so that
# that point has not moved after image is rotated.  If a 'new center'
# coordinate is given, also add a translaton to re-position the 'center'
# to this new location.
#
# No scaling, shearing or other distortion of the image is proformed, other
# than basic rotations and translations.
#
# This script was designed to allow the generation of a animated
# image of a moving object.
#
###
#
# WARNING: Input arguments are NOT tested for correctness.  This script
# represents a security risk if used ONLINE.  I accept no responsiblity for
# misuse. Use at own risk.
#
# by Anthony Thyssen  (December 2005)
#
use strict;
use FindBin;
my $prog = $FindBin::Script;

# Output the program comments as the programs manual
sub Usage {
  print STDERR "$prog: ", @_, "\n";
  @ARGV = ( "$FindBin::Bin/$prog" );
  while( <> ) {
    next if 1 .. 2;
    last if /^###/;
    s/^#$//; s/^# //;
    print STDERR "Usage: " if 3 .. 3;
    print STDERR;
  }
  exit 10;
}

# --------------
@ARGV = map( /([^\s,]+)/g, @ARGV);   # Remove any commas in arguments

if ( @ARGV != 1 && @ARGV != 3 && @ARGV != 5 ) {
  Usage( "Incorrect number of arguments." );
}

# Assign the coordinates of the two triangles (remove commas)
my ($angle, $cx, $cy, $nx, $ny) = @ARGV;

($cx,$cy)=(0,0)       if ! defined $cx;
($nx,$ny)=($cx,$cy)   if ! defined $nx;

# As no scaling or shearing is involved rotation are independant of movment.
my $radians = $angle * atan2(1,1)/45;
my $c = cos( $radians );
my $s = sin( $radians );

my $sx= $c; my $rx=$s;
my $ry=-$s; my $sy=$c;   # standard affine rotation matrix
my $tx= 0;  my $ty=0;

if ( defined $cx ) {
  # find the translation needed to place center of rotation at orign
  $tx -= ($cx*$c) -($cy*$s);   $ty -= ($cx*$s) +($cy*$c);
}
if ( defined $nx ) {
  # Add to that translation the location of the new center
  $tx += $nx;  $ty += $ny;
}

# Output the affine matrix needed
printf "%f,%f,%f,%f,%f,%f\n", $sx, $rx, $ry, $sy, $tx, $ty;

