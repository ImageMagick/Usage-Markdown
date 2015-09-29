#!/usr/bin/perl
=head1 NAME

dpx_timecode.pl  -  Simple DPX time code manipulation using ImageMagick

=head1 SYNOPSIS

 dpx_timecode.pl prefix suffix start_frame end_frame dpx_timecode

=head1 DESCRIPTION

Adjust the timecodes of DPX images of the form  {prefix}{frame}{suffix}
with the given timecode (which is incremented as appropriate).

For example: To apply a 25 fps time code from 10:00:12:05 onwards to the 76
files from 'shotA.000120.dpx' to 'shotA.000196.dpx' we would write:

    dpx_timecode.pl shotA. .dpx 120 196 10:00:12:05:25

Time codes may be specified as separate arguments, colon separated or as a
single concatinated string of numbers.

=head1 AUTHOR

 Seth Dubieniec   23 April 2007

=cut
use Pod::Usage;
use FindBin;
my $PROGNAME = $FindBin::Script;

pod2usage( -msg => "$PROGNAME: Invalid Argument Count" )
   unless @ARGV == 5 || @ARGV == 9;

my ($prefix, $suffix, $start, $end, @tc) = @ARGV;

if ( @tc == 1 ) {   # If time code is one single number...
  @tc = $tc[0] =~ /^(\d\d)\D*(\d\d)\D*(\d\d)\D*(\d\d)\d*(\d\d)$/;
}
if ( @tc < 5 ) {   # If non-number separators in timecode
  @tc = split(/\D/, "@tc" );
}

pod2usage( -msg => "$PROGNAME: Invalid Timecode Argument" )
  if ( @tc != 5) || (join('', @tc) =~ /\D/);

my ( $tc_hour, $tc_minute, $tc_second, $tc_frame, $tc_fps ) = @tc;

# ----
for (my $file=$start; $file<=$end;  $frame++){

   $current_file=sprintf "%s%06d%s",$ARGV[0], $file, $ARGV[1];

   printf "Setting %s to %02d:%02d:%02d:%02d\n", $current_file,
            $tc_hour, $tc_minute, $tc_second, $tc_frame;
   $timecode=sprintf "%02d%02d%02d%02d",
            $tc_hour, $tc_minute, $tc_second, $tc_frame;
   my $code = system 'convert', '-regard-warnings',  $current_file,
                -define => "dpx:television.time.code=$timecode",
                $current_file;
   if ( $? != 0 ) {
     printf STDERR "$PROGNAME: IM 'convert' returned bad exit code %d\n",
             $? >> 8;
     exit 1;
   }

   #Increment Time Code
   $tc_frame++;
   if($tc_frame>=$tc_fps){
      $tc_frame=0;
      $tc_second++;
      if($tc_second>=60){
         $tc_second=0;
         $tc_minute++;
         if($tc_minute>=60){
            $tc_hour++;
         }
      }
   }
}

