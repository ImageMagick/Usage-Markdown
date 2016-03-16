
ops_duff='Src         Dst        Clear       Xor
          Over        In         Out         Atop
          DstOver     DstIn      DstOut      DstAtop
         '
ops_math='Plus         ModulusAdd  Minus        ModulusSubtract
          Screen       Multiply    Difference   Exclusion
          Lighten      Darken      -none-       Divide
          LinearDodge  LinearBurn  ColorBurn    ColorDodge
          Overlay      SoftLight   PegtopLight  -none-
          HardLight    PinLight    LinearLight  VividLight
         '  # Bumpmap
ops_xtra='CopyOpacity CopyRed    CopyGreen   CopyBlue
          Hue         Saturate   Luminize    Colorize
         '
        #
        # Copy        CopyCyan   CopyMagenta CopyYellow
        #
        # Operators with arguments
        #    Modulate   Dissolve    Blend
        #    Threshold   Distort  Displace

methods="$ops_duff $ops_math $ops_lght $ops_xtra"

# Empty Image
convert -size 1x1 xc:$page_bg_color ${png_format}compose_none.png

# Error Image
error=../../images/image_error.gif

# Given the vaiables  P,  Q  and M  do montage
do_montage() {

  rm -f compose_op_*.png

  convert -label 'Overlay (Src)' $P \
          -bordercolor blue  -compose Copy  -border 1 \
          ${png_format}compose_op_P.png
  convert -label 'Backgnd (Dst)' $Q \
          -bordercolor blue  -compose Copy  -border 1 \
          ${png_format}compose_op_Q.png

  list=""
  if [ "$M" ]; then
    list="$list compose_op_P.png"
    list="$list label:method"
    list="$list compose_op_Q.png"
    list="$list compose_op_M.png"
    convert -label 'mask' $M \
           -bordercolor blue  -compose Copy  -border 1 \
           ${png_format}compose_op_M.png
  else
    list="$list compose_op_P.png"
    list="$list label:method"
    list="$list compose_op_Q.png"
    list="$list compose_none.png"
  fi

  for op in  $methods
  do
    if [ X$op = X-none- ]; then
      list="$list compose_none.png"
    else
      #composite -gravity center -compose $op  $P  $Q  $M miff:- |\
      #  convert -label $op - \
      #          -bordercolor blue  -compose Copy  -border 1 \
      #          ${png_format}compose_op_$op.png
      convert -label $op  $Q  $P \
              -gravity center  -compose $op  -composite \
              -bordercolor blue  -compose Copy  -border 1 \
              ${png_format}compose_op_$op.png
      if [ ! -f compose_op_$op.png ]; then
        convert -label $op   $error \
                ${png_format}compose_op_$op.png
      fi
      list="$list compose_op_$op.png"
    fi
  done

  eval "montage -tile 4x -geometry +4+4  \
                $list   $jpg_opt  jpg:-"

  rm -f compose_op_*.png
}

# ----------------------------------------------------------------------------
# ---- Duff-Porter Composites -----
# ------------------------------
#
methods="$ops_duff"

convert -size 50x50 xc:none -fill gold \
        -draw 'polyline 0,0 0,49 49,0'   ${png_format}compose_P.png
convert -size 64x64 xc:none -fill blue \
        -draw 'polyline 0,0 63,63 63,0'  ${png_format}compose_Q.png

M=''

echo "montage triangles..."
P=compose_P.png
Q=compose_Q.png
do_montage > montage_triangles.jpg


# Colored Circles on Transparency
convert -size 64x64 xc:none -fill gold \
        -draw 'circle 22,32 5,32'  ${png_format}compose_circle_P.png
convert -size 64x64 xc:none -fill blue \
        -draw 'circle 41,32 58,32' ${png_format}compose_circle_Q.png

methods="$ops_duff"

echo "montage circles ..."
P=compose_circle_P.png
Q=compose_circle_Q.png
do_montage > montage_circles.jpg

rm -f compose_[PQ]*.png

# ----------------------------------------------------------------------------
# ---- Circle Composites -----
# ----------------------------
#

methods="$ops_duff"

#Black on White circles
convert -size 64x64 xc:white -fill black \
        -draw 'circle 22,32 5,32'  +matte ${png_format}compose_circle_BWl.png
convert -size 64x64 xc:white -fill black \
        -draw 'circle 41,32 58,32' +matte ${png_format}compose_circle_BWr.png

# White on Black circles
convert -size 64x64 xc:black -fill white \
        -draw 'circle 22,32 5,32'  +matte ${png_format}compose_circle_WBl.png
convert -size 64x64 xc:black -fill white \
        -draw 'circle 41,32 58,32' +matte ${png_format}compose_circle_WBr.png

methods="$ops_math"

echo "montage circles 1..."
P=compose_circle_BWl.png
Q=compose_circle_BWr.png
do_montage > montage_circles_1.jpg

echo "montage circles 2..."
P=compose_circle_WBl.png
Q=compose_circle_WBr.png
do_montage > montage_circles_2.jpg

rm -f compose_circles_*.png

# ----------------------------------------------------------------------------
# ---- Gradient Composites -----
# ----------------------------
#
methods="$ops_math $ops_xtra"

convert -size 64x64 gradient: ${png_format}gradient_grey_v.png
convert -size 64x64 gradient: -rotate 90  ${png_format}gradient_grey_h.png

convert -size 64x64 gradient:yellow-blue gradient_YB_v.png

convert -size 64x64 gradient:black-blue ${png_format}gradient_blue_v.png
convert -size 64x64 gradient:black-yellow  ${png_format}gradient_yellow_v.png
convert -size 64x64 gradient:black-red -rotate -90 \
                                         ${png_format}gradient_red_h.png

echo "montage gradient 1..."
P=gradient_grey_v.png
Q=gradient_grey_h.png
do_montage > montage_gradient_1.jpg

echo "montage gradient 2..."
P=gradient_YB_v.png
Q=gradient_grey_h.png
do_montage > montage_gradient_2.jpg

echo "montage gradient 3..."
P=gradient_grey_h.png
Q=gradient_YB_v.png
do_montage > montage_gradient_3.jpg

echo "montage gradient 4..."
P=gradient_blue_v.png
Q=gradient_red_h.png
do_montage > montage_gradient_4.jpg

echo "montage gradient 5..."
P=gradient_yellow_v.png
Q=gradient_red_h.png
do_montage > montage_gradient_5.jpg

rm -f gradient_*.png

# ----------------------------------------------------------------------------
# Final Cleanup
#
rm -f compose_*.png gradient_*.png

#for img in *.png; do
#  jpg=`basename $img .png`.jpg
#  convert $img -fill $page_bg_color -draw 'color 0,0 reset' \
#          $img -compose Over $jpg_opt $jpg
#done

rm -f *.png 2>/dev/null
