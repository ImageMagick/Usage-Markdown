#!/bin/sh
#
#  bg_removal [options] image [background|color] fuzz_out fuzz_in image_out
#
# Attempt to remove the given background image, given color, or top-left
# corner pixel color, from the input image, anti-aliasing the pixels between
# the percentage values 'fuzz_out' and 'fuzz_in'.
#
# This basically implements a two masked background remove system as detailed
# in  http://www.imagemagick.org/Usage/channels/#mask_antialised
#
#
# The 'fuzz_out' percentage defines the pixels that will be definateally
# classed as background (outside the object in the 'image'.  The lower the
# value the better, but too low and the main image may become surrounded by
# too many semi-transparent pixels.
#
# The 'fuzz_in' percentage defines what pixels should be definatally inside
# the object in the image.  Pixels that differ by this much from the
# background will be classed as fully-opaque.  If too low you may get halo
# effects, while is too big the semi-transparent edging pixels make 'leak'
# into the main object.
#
# The program assumes the object in the image as some definate 'threshold'
# division between inside and outside.  It will by default color re-color
# semi-transparent areas black (shadow), but the -b option lets you change
# that.
#
# Options
#    -n     Normalize the differences between image and background
#
#    -a     Add the channel differences instead of simply grayscaling
#           this will require larger fuzz factor differences)
#
#    -r     use color replacement instead of flood-fill for mask generation
#           this lets you find 'holes' within the image object
#
#    -m     Flicker compare (space to swap) the masks found with the original
#           image.  Press 'q' to continue processing
#             green = object   blue = semi-trans edge  red = transparency
#
#    -b color  use this color for background semi-transparent (def: black)
#
# FUTURE:  determine the replacement background color from the edge colors of
# the fully-opaque masked object. This technique is known as 'hole-filling'.
#
###
#
#  Anthony Thyssen    3 July 2009    <A.Thyssen_AT_griffith.edu.au>
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

background=black

while [  $# -gt 0 ]; do
  case "$1" in
  --help|--doc*) Usage ;;

  -r) replace=true ;;
  -m) showmasks=true ;;
  -a) additive=true ;;
  -n) normalize=true ;;
  -b) background=$2; shift ;;

  -)  break ;;           # stdin end of user options
  --) shift; break ;;    # end of user options
  -*) Usage "Unknown option \"$1\"" ;;
  *)  break ;;           # end of user options
  esac
  shift   # next option
done
case $# in
 4|5) ;;
 *) Usage "incorrect number of arguments" ;;
esac

# get the main arguments...

image="$1";  shift

if [ $# -eq 4 ]; then
  case "$1" in
  -|*:*|*/*|*.*|*' '*)
     # This can't be a color, so use it as a normal image.
     bgnd="$1"
     ;;
  *) # Assume the argument is a color, generate a image.
     bgnd='( +clone -sparse-color voronoi 0,0,'$1' )'
     ;;
  esac
  shift
else
  bgnd='( +clone -sparse-color voronoi 0,0,%[pixel:p{0,0}] )'
fi

fzout="$1"; shift
fzin="$1"; shift
image_out="$1"; shift

# set up the inline optional extras

if [ "$replace" ]; then
  fill='-opaque black'
else
  fill='-bordercolor black -border 1x1 -floodfill +0+0 black -shave 1x1'
fi
if [ "$showmasks" ]; then
  showmasks='( -clone 3,2,4 -combine -clone 0 -write x: -delete 0--1 )'
fi
if [ "$additive" ]; then
  grayscale='-separate -compose plus -background black -flatten'
else
  #grayscale='-modulate 100,0'
  grayscale='-colorspace gray'
fi
if [ "$normailze" ]; then
  grayscale="$grayscale"' -normalize'
fi

# -----------

# Do the work...
#
# Images generated in the following are (number = parenthesis)
# 0 = Original image
# 1 = difference image (blue channel cleared)
# 2 = outside mask  - definatally transparent
# 3 = inside mask   - definatally opaque
# 4 = edge mask     - parts between inside and outside
# 5 = fully opaque pixels from original
# 6 = final image combining all the above
#
#
convert "$image" \
  \( -clone 0 $bgnd -compose Difference -composite \
     $grayscale \
     -channel B -evaluate 'set' 0 +channel \) \
  \( -clone 1 -fill blue -fuzz $fzout%  $fill \
     -channel B -separate +channel \) \
  \( -clone 1 -fill blue -fuzz $fzin%  $fill \
     -channel B -separate +channel -negate \) \
  \( -clone 2,3 -negate -compose multiply -composite \) \
  $showmasks \
  \( -clone 0,3 +matte -compose CopyOpacity -composite \) \
  \( -clone 1 -channel R -separate +channel \
     -clone 4 +matte -compose CopyOpacity -composite \
     \( +clone -blur 0x30 +matte \) +swap -compose Over -composite \
     +matte -normalize \
     -clone 4 -compose multiply -composite  \
     -background $background -alpha shape \
     -clone 5 -compose over -composite \) \
  -delete 0--2 "$image_out"

exit 0

# alturnative to -modulate (larger range of difference values)

# DEBUG line insert (outside parentesis), output last image generated
  -delete 0--2 show:; exit 0
# DEBUG line insert (inside parentesis), output images at this point.
  -write show: \) null:; exit 0

#
# FUTURE:
#  * switch from blue channel to alpha channel
#  * do not grayscale difference image.
#  * try morphology methods to 'fill-in' edge colors
#  * find method to subtract the background color or overlaid color.
#
