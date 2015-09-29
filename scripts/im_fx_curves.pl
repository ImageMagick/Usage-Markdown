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
# This uses a perl "Math::Polynomial" module to do the least squares curve
# fit. However it may also be converted to use "Algorithm::CurveFit" instead.
#
####
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
use Math::Polynomial 1.002;

# set  percentage divisor by default.
my $percent = 1.0;
if ( $ARGV[0] eq '-p' || $ARGV[0] eq '-percent' ) {
  $percent = 100.0;
  shift;
}

# Argument adjustments...
@ARGV = map( /([^\s,]+)/g, @ARGV); # Remove any commas/spaces in arguments
@ARGV = map( $_/$percent, @ARGV);  # adjust using a percentage modifier.

# The Math::Polynomial module changed with version 1.0  Arrgghhh...
# Re-order arguments to fit the modules new rewquirments, by pulling
# out every second entry.
my @x = @ARGV[map $_*2,   0 .. $#ARGV/2];
my @y = @ARGV[map $_*2+1, 0 .. $#ARGV/2];

# Fit fit a polynomial function to the arguments
my $poly = Math::Polynomial->interpolate( \@x, \@y );

# how to print results
#
if ( 1 ) {
  #
  # Output using modules polynomial formater
  #
  # Set how the polynomial should be formated to fit IM's -fx function
  Math::Polynomial->string_config({
      fold_sign     => 1,
      convert_coeff => sub { sprintf "%.3f", @_ },
      leading_minus => q{-},
      times         => q{*},
      variable      => q{u},
      power         => q{^},
      prefix        => q{},
      suffix        => q{},
  });
  print "$poly\n";
}
else {
  #
  # Format the polynomial expression (DIY)
  #
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
}
