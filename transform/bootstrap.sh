PATH=$PATH:../scripts

convert ../images/jigsaw_tmpl.png +matte -resize 64x64 mask.gif
ln -s ../images/piglet.gif .
ln -s ../images/rose* .
ln -s ../img_photos/spiral_stairs_sm.jpg .
ln -s ../images/shape_rectangle.gif .
echo "This is a secret pass-phrase, for image encryption" > pass_phrase.txt