#!/bin/sh
#
#  gif_anim_montage [options] animation.gif  [output_image]
#
# Convert a GIF animation into a strip showing each sub-frame of the
# animation with a black border, positioned in the larger canvas context
# of the animation.  Also include a label defining the size and position,
# and disposal setting of each frame in the animation.
#
# OPTIONS:
#    -u          Underlay a dimmed coaleased image (context for frame)
#    -c          Add checkerboard background for transparent areas
#    -g          Use granite for background
#    -w          Use a white background
#    -b          Use a black background
#    -t image    Use this image (or color image) for background
#    -r          Use a red border color rather than black
#    #x#         tile the images   (default one single row)
#    -n          Don't label the animation frames (not important)
#
####
#
# WARNING: Input arguments are NOT tested for correctness.
# This script represents a security risk if used ONLINE.
# I accept no responsiblity for misuse. Use at own risk.
#
# Anthony Thyssen   Feburary 2006
#
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
Usage() {                              # output the script comments as docs
  echo >&2 "$PROGNAME:" "$@"
  sed >&2 -n '/^###/q; /^#/!q; s/^#//; s/^ //; 3s/^/Usage: /; 2,$ p' \
          "$PROGDIR/$PROGNAME"
  exit 10;
}

border=black
thickness=1x1
pointsize=10
tile='-tile x1'
montage_opts=""
method=1
background=none

# Figure out the montage label to use
# Does IM understand %T as the frame time delay?
label='%s: %D\n%wx%h%O'
case `identify -format %T rose:` in
0) label="%D, %Tcs\n%wx%h%O"
esac


while [  $# -gt 0 ]; do
  case "$1" in
  --help|--doc*) Usage ;;
  -u) method=2 ;;   # add disposal image context
  -n) label='' ;;  # don't label the montage
  -c) tile_image="pattern:checkerboard" ;;
  -g) tile_image="granite:" ;;
  -w) background="white" ;;
  -b) background="black" ;;
  -r) border=red  ;;
  [0-9]*x*[0-9]|[0-9]*x|x*[0-9])
      X=`expr "$1" : '\([0-9]*\)x'`
      Y=`expr "$1" : '[0-9]*x\([0-9]*\)$'`
      tile="-tile ${X}x${Y}"
      ;;
  -) break ;;    # stdin filename
  --) shift; break ;;    # end of user options
  -*) Usage "Unknown option \"$1\"" ;;
  *)  break ;;           # end of user options
  esac
  shift   # next option
done

input="$1"
[ $# -eq 0 ] && Usage "Missing Animation to Montage"
[ $# -eq 1 ] && output='show:'
[ $# -eq 2 ] && output="$2"
[ $# -gt 2 ] && Usage "Too Many Arguments"

if [ "$tile_image" ]; then
  montage_opts="$montage_opts -texture $tile_image"
fi
if [ "$background" ]; then
  montage_opts="$montage_opts -background $background"
fi

case "$method" in
 1) # Montage only method
    convert "$input"  -set label "$label" \
            -compose Copy -bordercolor $border -border $thickness \
            -set dispose Background -coalesce  miff:- |\
      montage - -frame 4 -geometry '+1+1' $tile \
              -bordercolor none -pointsize $pointsize \
              $montage_opts "$output"
    ;;
 2) # Montage with a disposed image underlay
    # Still need some way to make the underlay partically transparent
    convert "$input"  -set label "$label" -write mpr:a \
            -coalesce -bordercolor none -border $thickness \
            -channel A -evaluate divide 2 +channel  null: \
            \( mpr:a -bordercolor none -mattecolor $border -frame $thickness \
            \) -layers Composite \
            miff:- | \
      montage - -frame 4 -geometry '+1+1' $tile \
              -bordercolor none -pointsize $pointsize \
              $montage_opts  "$output"
    ;;
 3) # convert only method  -- no montage labels :-(
    convert -dispose Background  "$input" \
            -compose Copy -bordercolor $border -border $thickness \
            -compose Over -coalesce  -bordercolor none   -frame 4x4+1+1 \
            -bordercolor none -border 2x2 +append -set delay 0 \
            $montage_opts  "$output"

esac
