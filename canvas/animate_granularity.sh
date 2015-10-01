#!/bin/sh
#
# Create a animation of varying granularity
#

# Generate initial random image (also  granularity=0 image)
command='convert -size 150x150 xc: +noise random'

# Ensure final image is 'tilable' makes results better too..
command="$command -virtual-pixel tile"

# to speed things up - lets limit operaqtions to just the 'G' channel.
command="$command -channel G"

# generate a sequence of images with varying granularity
b=0.5
for i in `seq 16`;  do
  command="$command \\( -clone 0 -blur 0x$b \\)"
  b=`convert null: -format "%[fx: $b * 1.3 ]" info:`
done

# normalize and separate a grayscale image
command="$command -normalize  -separate  +channel"

# separate black and white granules in equal divisions of black,gray,white
#command="$command  +dither -posterize 3"
command="$command  -ordered-dither threshold,3"

# Set intermedite frame animation delay and infinite loop cycle
command="$command -set delay 12"

# give a longer pause for the first image
command="$command \\( -clone 0 -set delay 50 \\) -swap 0 +delete"

# give a longer pause for the last image
command="$command \\( +clone -set delay 50 \\) +swap +delete"

# make it a patrol cycle (see Animation Modifications)
command="$command \\( -clone -2-1 \\)"


# final image save
command="$command -loop 0 animate_granularity.gif"

eval $command

chmod 644 animate_granularity.gif
