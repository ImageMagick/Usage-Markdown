ln -s ../images/bag_frame?.gif .

# Generate a impure Black and White image...
convert ../images/wmark_image.png -background white -flatten \
        -sigmoidal-contrast 10x50% wmark_dragon.jpg
chmod 644 wmark_dragon.jpg
