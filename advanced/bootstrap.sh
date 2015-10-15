PATH=$PATH:../scripts

ln -s ../img_photos/holocaust_md.jpg .
ln -s ../img_photos/holocaust_tn.gif .
ln -s ../images/jigsaw_*.png .
ln -s ../images/pokemon.gif .
ln -s ../images/tile_wood.gif .
ln -s ../img_www/asterix.gif .

create_bullet() {
    #!/bin/sh
    #
    # Given a shaped image, create a color image with a highlight shading.
    #
    INPUT=$1
    COLOR=$2
    OUTPUT=$3

    convert $INPUT -alpha on \
            \( +clone -channel A -separate +channel \
               -bordercolor black -border 5  -blur 0x2 -shade 120x30 \
               -normalize -blur 0x1  -fill $COLOR -tint 100 \) \
            -gravity center -compose Atop -composite \
            $OUTPUT
}
