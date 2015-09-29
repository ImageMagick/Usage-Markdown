#!/bin/bash
#
# multicrop [options] infile [outfile]
#
# Crops (and posibily unrotates) multiple images from a larger image typically
# from a PDF or scanned page.
#
# OPTIONS:
#
#   -b  color          background color to use
#   -c  coords         pixel coordinate to extract background color.
#                      May be a x,y value or a Gravity value (def: TopLeft)
#   -f  fuzz_percent   fuzz value for matching background color (def: 10% )
#   -g  grid           Grid spacing as a percent of image side (def: 10%)
#   -u  unrotate       unrotate method: 0=none (def) 1=deskew 2=freds_unrotate
#   -m  mask           Mask preserve and view (for debugging)
#   -s  suffix         Use this suffix for output files
#
###
#
# The script basically makes a mask of the original image, then does a grid
# search of the mask looking for and extracting rectangular segments found.
#
# The images must be well separate so that background color shows between
# them.  Images smaller than the 'grid spacing' used to search for sub-images
# are ignored (usally text).  Fine decoration such as connecting lines are
# also ignored using a morphology open to remove them from the mask.
#
# The correct choice of fuzz factor is very important. If too small, the
# images will not be separate, or will not 'unrotate' correctly if enabled.
# If too larger, parts of the outer area of the image containing similar
# colors will be lost and the image may be separated into multiple parts.
#
# There are two unrotate methods provided for extracted images (off by
# default). The first uses the IM deskew function, but is limited to 5 degrees
# of rotate or less. The second uses my unrotate script. It allows much larger
# rotations, but will be slower. If using the second method, Fred Wienhaus's
# unrotate script must be downloaded and installed.
#
# IMPORTANT: The images in the scanned file must be well separated in x and y
# so that their bounding boxes do not overlap. This is especially important
# if the images have a significant rotation.
#
# The output images will be named from the specified outfile with a two digit
# number added to the filename before the file suffix.
#
#
# Original program Fred Weinhaus 1/30/2010,  revised 7/7/2010
#
# Modified by Anthony Thyssen, with different defaults and improved handling
# to ignore 'small images', and produce less verbose error reports.
#
######
#
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
Usage() {
  echo >&2 "$PROGNAME:" "$@"
  sed >&2 -n '/^###/q; /^#/!q; s/^#//; s/^ //; 3s/^/Usage: /; 2,$ p' \
          "$PROGDIR/$PROGNAME"
  exit 10;
}
Help() {
  echo >&2 "$PROGNAME:" "$@"
  sed >&2 -n '/^######/q; /^#/!q; s/^#//; s/^ //; 3s/^/Usage: /; 2,$ p' \
          "$PROGDIR/$PROGNAME"
  exit 10;
}

# function to report error messages
Error() {
  echo >&2 "$PROGNAME: $1"
}


# set default values;
coords=""      # initial coord for finding background color
bgcolor=""     # initial background color
fuzz=10        # default fuzz-factor for background color
grid=10        # grid spacing in percent image
mask=""        # view, save, output
unrotate=''    # unrotate method
suffix=''      # replacement suffix

# test for correct number of arguments and get values
while [ $# -gt 0 ]; do
  # get parameters
  case "$1" in
  -c) shift; coords="$1" ;;                        # Coords for background
  -b) shift; bgcolor="$1" ;;                       # Background color
  -s) shift; suffix="$1" ;;                        # Output suffix

  -f) shift; fuzz=`expr "$1" : '\([0-9]*\)'`    # fuzz factor
      [ "$fuzz" = "" ] &&
          Error "Fuzz $fuzz must be an percentage integer"
      fuzztestA=`echo "$fuzz < 0" | bc`
      fuzztestB=`echo "$fuzz > 100" | bc`
      [ $fuzztestA -eq 1 -a $fuzztestB -eq 1 ] &&
          Error "FuzzVAL $fuzz must be an percentage integer"
      ;;
  -g) shift;  grid=`expr match "$1" '\([0-9]*\)'`  # grid size
      [ "$grid" = "" ] &&
            Error "Grid $grid must be percentage integer"
      gridtestA=`echo "$grid <= 0" | bc`
      gridtestB=`echo "$grid >= 100" | bc`
      [ $gridtestA -eq 1 -a $gridtestB -eq 1 ] &&
            Error "Grid $grid must be percentage integer"
      ;;
  -u) shift                                        # Unrotate type (if any)
      case "$1" in
        ''|0) unrotate='' ;;
        1)    unrotate="-deskew 40%" ;;
        2)    unrotate="unrotate" ;;
        *)    Error "Invalid unrotate (value=0 to 2)" ;;
      esac
      ;;
  -m) shift                                        # Mask handling
      mask=`echo "$1" | tr "[:upper:]" "[:lower:]"`
      ;;

  -h|-help|--help) Help ;;   # says it all
  -)  break ;;               # STDIN,  end of user options

  --) shift; break ;;        # end of user options
  -*) Usage "Unknown option \"$1\"" ;;
  *)  break ;;               # end of user options

  esac
  shift   # next option
done

if [ "X$bgcolor" != "X" -a "X$coods" != "X" ]; then
  Usage "Background Color and Coodinates are mutually exclusive"
fi

[ $# -lt 1 -o $# -gt 2 ] && Usage "Invalid number of arguments"

# get infile and outfile
infile="$1"
outfile="${2:-$1}"


# set directory for temporary files
tmp="${TMPDIR:-/tmp}"    # suggestions are dir="." or dir="/tmp"

[ -z "$tmp" ] && Error "Invalid TMPDIR setting"

# set up temp file
tmp=$tmp/$PROGNAME-$$

trap "rm -rf $tmp; exit 0" 0
trap "rm -rf $tmp; exit 1" 1 2 3 15
mkdir $tmp ||
  Error "Unable to create tmp dir \"$tmp\""

# read the input image into the temp files and test validity.
convert -quiet -regard-warnings "$infile" +repage "$tmp/IN.mpc" ||
  Error "File $infile not readable as an image"


# get output filename and suffix
outname=`expr "$outfile" : "\(.*\)\.[^./]*$" \| "$outfile" `
[ -z "$suffix" ] &&
  suffix=`expr "$outfile" : '.*\.\([^./]*\)$'`
#echo "DEBUG: outname=$outname"
#echo "DEBUG: suffix=$suffix"

# get image width and height
width=`identify -ping -format "%w" $tmp/IN.mpc`
height=`identify -ping -format "%h" $tmp/IN.mpc`

# get color at user specified location
if [ "X$bgcolor" != "X" ]; then
  coords="0,0"
else
  widthm1=`convert xc: -format "%[fx:$width-1]" info:`
  heightm1=`convert xc: -format "%[fx:$height-1]" info:`
  midwidth=`convert xc: -format "%[fx:round(($width-1))/2]" info:`
  midheight=`convert xc: -format "%[fx:round(($height-1))/2]" info:`
  coords=`echo "$coords" | tr "[:upper:]" "[:lower:]"`
  case "$coords" in
    ''|nw|northwest) coords="0,0" ;;
    n|north)         coords="$midwidth,0" ;;
    ne|northeast)    coords="$widthm1,0" ;;
    e|east)          coords="$widthm1,$midheight" ;;
    se|southeast)    coords="$widthm1,$heightm1" ;;
    s|south)         coords="$midwidth,$heightm1" ;;
    sw|southwest)    coords="0,$heightm1" ;;
    w|west)          coords="0,$midheight" ;;
    [0-9]*,[0-9]*)   coords=$coords ;;
    *)  Error "--- INVALID COORDS ---" ;;
  esac
  bgcolor=`convert $tmp/IN.mpc -format "%[pixel:u.p{$coords}]" info:`
fi
#echo "DEBUG: bgcolor=$bgcolor"

# get grid spacing
wg=`convert xc: -format "%[fx:round($grid*$width/100)]" info:`
hg=`convert xc: -format "%[fx:round($grid*$height/100)]" info:`
num=`convert xc: -format "%[fx:round(100/$grid) - 2]" info:`
#echo "DEBUG: width=$width; height=$height; wg=$wg; hg=$hg; num=$num"


# OLD METHOD: Fill from the given coolrdinate point
# convert $tmp/IN.mpc -fuzz ${fuzz}% -fill none \
#   -draw "matte $coords floodfill" \
#   -fill red +opaque none \
#   $tmp/MASK.mpc

# add a border to set the background color (and/or flood fill from all edges)
# 'replace' is used instead of floodfill, with a morphology Open to avoid
# problems with 'thin decorative lines' that may box or link images.  It also
# tends to remove most 'text' and other 'too small' hits.

convert $tmp/IN.mpc -fuzz ${fuzz}% -fill none \
        -bordercolor $bgcolor -border 1x1 \
        -draw "matte $coords replace" \
        +fuzz -shave 1x1 -fill red +opaque none \
        -channel all -morphology Open:3 Square \
        $tmp/MASK.mpc

case "$mask" in
  '') ;; # do nothing
  v|view)
     display $tmp/MASK.mpc
     exit 0 ;;
  s|save)
     convert $tmp/MASK.mpc ${outname}_mask.gif
     ;;
  o|ouput)
     convert $tmp/MASK.mpc ${outname}_mask.gif
     exit 0 ;;
  *) Error "Mask $mask must be either \"view\", \"save\", or \"output\""
     ;;
esac

echo ""
# loop over grid and floodfill and trim to get individual mask for each image
k=0
y=0
for ((j=0;j<=$num;j++))
  do
   x=0
   y=$(($y + $hg))
  for ((i=0;i<=$num;i++))
    do
    x=$(($x + $wg))
    # test if found color is 'red' -- match
    testcolor=`convert $tmp/MASK.mpc -format "%[pixel:u.p{$x,$y}]" info:`
    echo "$x $y $testcolor"
    if [ "$testcolor" = 'red' ]; then
      echo "Processing Image $k"
      # Take red and none mask.
      # Floodfill the local red region with white.
      convert $tmp/MASK.mpc -channel rgba -alpha on -fill "white" \
              -draw "color $x,$y floodfill" $tmp/part.mpc
      # Fill anything not white with transparency and
      # turn transparency off so black.
      # Then clone and trim to bounds of white.
      # Then fill any black with white.
      # Then flatten back onto white and black image so that any white
      # areas eaten away are filled with white.
      # Note flatten uses the virtual canvas left by -trim so that it
      # goes back into the right location.
      convert \( $tmp/part.mpc -channel rgba -alpha on \
        -fill none +opaque white -alpha off \) \
        \( +clone -trim -fill white -opaque black -write $tmp/ptrim.mpc \) \
        -flatten $tmp/pmask.mpc
      # Print size and page geometry
      identify -ping -format "  Size: %wx%h\n  Page Geometry: %g" \
               $tmp/ptrim.mpc
      w=`identify -ping -format %w $tmp/ptrim.mpc`
      h=`identify -ping -format %h $tmp/ptrim.mpc`
      if [ $w -lt $wg -o $h -lt $hg ]; then
        echo "  Image too small -- Skipping"
      else
        # Composite the black and white mask onto the original scan.
        # Then trim and deskew/unrotate to make the output.
        n=`printf %02d $k`
        echo "  Output to file \"${outname}-${n}.${suffix}\""
        if [ "$unrotate" = 'unrotate' ]; then
          convert $tmp/IN.mpc $tmp/pmask.mpc -compose multiply -composite \
            -fuzz ${fuzz}% -trim miff:- | \
          unrotate -f ${fuzz}% - ${outname}-${n}.${suffix}
        else
          convert $tmp/IN.mpc $tmp/pmask.mpc -compose multiply -composite \
            -fuzz ${fuzz}% -trim -background "$bgcolor" $unrotate \
            -compose over -bordercolor "$bgcolor" -border 2 -trim +repage \
            ${outname}-${n}.${suffix}
        fi
        k=$(($k + 1))
      fi
      # Fill the segment that was discovereda in red/none mask with none
      # so that the same sub-image is not found again.
      # Do this as a flood fill so any internal 'sub-rectangles' are not
      # effected.
      convert $tmp/MASK.mpc -channel rgba -alpha on \
              -fill none -draw "matte $x,$y floodfill" $tmp/MASK.mpc
    fi
  done
done

echo ""
exit 0



