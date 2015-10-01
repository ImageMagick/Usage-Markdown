
ln -s ../images/rose.gif .
ln -s ../images/cow.gif .
ln -s ../images/colorwheel.png .
ln -s ../images/{balloon,present}.gif .
ln -s ../images/shape_disks.gif  disks.gif

convert rose: -colorspace CMY -separate separate_CMY_%d.gif

which tac >/dev/null
if [ $? -eq 0 ]
then
    ../scripts/hsl_named_colors named_colors.png
fi

