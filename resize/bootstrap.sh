
ln -s ../images/dragon_sm.gif dragon.gif
ln -s ../images/terminal.gif .
ln -s ../images/storm.gif .
ln -s ../images/rose.gif .
ln -s ../images/rose.png .
ln -s ../img_photos/rings_* .
ln -s ../img_photos/earth_lights_4800.tif .

# ./animate_lqr
# This should be moved to scripts directory (perhaps)
#!/bin/sh
#
# Create a animation of of a rotating image.
# Some alpha composition is used to crop the result to the original size.
#
command="convert -delay 10 logo: -resize 50% -trim +repage -bordercolor blue"
command="$command \\( +clone -border 1x1 -fill lightsteelblue"
command="$command    -colorize 100% \\) -gravity center"

for i in `seq 100 -2 20 ;`; do
  command="$command \\( -clone 0 -liquid-rescale ${i}x100%\!"
  command="$command     -border 1x1 -clone 1 +swap -composite \\)"
done

# remove source images
command="$command -delete 0,1"

# duplicate frames to reverse
command="$command \\( -clone -2-1 \\)"

# write out animation
command="$command -layers Optimize -loop 0 animate_lqr.gif"

eval $command

chmod 644 animate_lqr.gif