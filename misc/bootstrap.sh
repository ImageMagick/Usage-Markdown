# the 'random' virtual pixel setting is really random!
rm -f _*_random*.gif   # always remove these backups

ln -s ../images/{eye,news,storm,tree,star}.gif .
ln -s ../images/{balloon,medical,present,shading}.gif .
ln -s ../images/koala.gif .
ln -s ../images/list_test.gif .

#!/bin/sh
#
# Generate a motage array of the letter A with various
# Annoation Slew rotations..
#
echo "Generating Annotate Montage..."

. ../generate_options
#jpg_opt='-quality 100%'

list=

for sy in 0 45 90 135 180 225 270 315; do
  for sx in  0 45 90 135 180 225 270 315; do
    convert -font ArialB -pointsize 24 -gravity center \
            -label "${sx} x ${sy}" -size 55x55 xc:white \
            -annotate ${sx}x${sy}+0+0 'Text'  annotate_${sx}x${sy}.png
    list="$list annotate_${sx}x${sy}.png"
  done
done

montage -tile 8x  -geometry +4+2  -pointsize 10 \
        -background $page_bg_color -mattecolor $page_bg_color \
        $list  $jpg_opt annotate_montage.jpg

rm -f annotate_*.png
chmod 644 annotate_montage.jpg
