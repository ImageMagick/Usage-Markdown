#!/usr/bin/perl
#
#  im_fx_curves.pl [-percent]  x,y...
#
# Given a set of control points figure out a mathematical histogram curve that
# fits those points exactly.
#
# The points are given as pairs of comma separated numbers on the command
# line, or as a gnuplot data file, one control point per line with spaces
# between the numbers.  All the numbers must be between 0 and 1, as floting
# point numbers or percentages (if -p option is given).
#
# This is a perl version using the Math::Polynomial library.
#
# Options:
#    -p | --percent     Control points are percentage values
#
# For example...
#    im_fx_curves.pl -p  0,20   100,90   20,80   70,50
# results in...
#    7.56u^3-11.9u^2+5.09u+0.2
#
####
#
# WARNING WARNING WARNING:  The Math::Polynomial perl module change in an
# incompatible way for version 1.000.  As such this script no longer works
# with the new versions of that module. See updated script.
#
# NOTE: Input arguments are NOT tested for correctness.
# This script represents a security risk if used ONLINE.
# I accept no responsiblity for misuse. Use at own risk.
#
# Original Code by Gabe Schaffer <magick@gabe.com>
#
#    #!/usr/bin/perl
#    use Math::Polynomial;
#    $poly = Math::Polynomial::interpolate(@ARGV);
#    printf "%.2f", $poly->coeff(0);
#    printf("%s%.2fu%s", $poly->coeff($_) >= 0 ? "+" : "",
#    $poly->coeff($_), $_ > 1 ? "^" . $_ : "") for (1 .. $poly->degree());
#
# Modified and expanded apon by Anthony Thyssen   November 2005
#
use strict;
use Math::Polynomial;

# set  percentage divisor by default.
my $percent = 1.0;
if ( $ARGV[0] eq '-p' || $ARGV[0] eq '-percent' ) {
  $percent = 100.0;
  shift;
}

# Argument adjustments...
@ARGV = map( /([^\s,]+)/g, @ARGV);   # Remove any commas in arguments
@ARGV = map( $_/$percent, @ARGV);    # adjust any percentage modifier.

# Fit fit a polynomial function to the arguments
my $poly = Math::Polynomial::interpolate( @ARGV );

# Format the polynomial expression
my $seen = 0;
for ( my $p=$poly->degree(); $p >= 0; $p-- ) {
   # format the parameter (see if we can junk it after rounding)
   my $v =  sprintf "%.3f", $poly->coeff($p);
   #my $v =  sprintf "%.3g", $poly->coeff($p);  # -- problems with 'e'

   # junk terms with a zero (or very small) parameter
   next if $v eq '0' || $v =~ /^0\.00/ || $v =~ /e-/;

   # sign of the parameter, and intra-term spacing
   print "+" if $seen && substr($v,0,1) ne '-';

   # print parameter if not 1 or a constant
   if ( $v ne '1' && $v ne '-1' || $p == 0 ) {
     print $v;
     print "*" if $p;
   }

   # and the term of the parameter
   print "u"     if $p == 1;
   print "u^$p"  if $p >= 2;

   $seen = 1;  # we have seen the first parameter
}
print "\n";
