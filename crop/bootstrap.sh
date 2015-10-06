ln -s ../img_photos/hatching_tn.gif hatching.gif
ln -s ../images/star.gif .
ln -s ../images/font_[1-5].gif .

#!/bin/sh
#
# Generate a montage array of various cases of the wartermark
#

echo "Generating Border Compose Montage..."

#. ../generate_options
page_bg_color=transparent

color=limegreen
image=star.gif

list=
for compose in  Over Copy Src Dst Dst_In Dst_Out; do
  convert -label $compose  $image -bordercolor $color \
          -compose $compose -border 5  b_$compose.png
  list="$list b_$compose.png"
done

montage -tile x1 -geometry +15+2  -pointsize 10 \
        -background $page_bg_color -mattecolor $page_bg_color \
        $list  $jpg_opt border_compose.jpg

rm -rf b_*.png
chmod 644 border_compose.jpg


#!/bin/sh
#
# Generate a montage array of various cases of the wartermark
#
echo "Generating Frame Compose Montage..."

#. ../generate_options

color=limegreen
image=star.gif

list=
for compose in  Over Copy Src Dst Dst_In Dst_Out; do
  convert -label $compose  $image -bordercolor $color \
          -compose $compose -frame 6x6+2+2  f_$compose.png
  list="$list f_$compose.png"
done

montage -tile x1 -geometry +15+2  -pointsize 10 \
        -background $page_bg_color -mattecolor $page_bg_color \
        $list  $jpg_opt frame_compose.jpg

rm -rf f_*.png
chmod 644 frame_compose.jpg

