 ln -s ../images/test.png .
 ln -s ../images/rose.png .
 ln -s ../images/bg.gif .
 ln -s ../images/tree.gif .
 ln -s ../images/tile_* .
 ln -s ../images/shape_figure.gif shape.gif

./animate_granularity.sh

convert -size 100x100 xc: -sparse-color  Voronoi \
            '30,10 red   10,80 blue   90,90 lime' \
        -fill white -stroke black \
        -draw 'circle 30,10 30,12  circle 10,80 10,82  circle 90,90 90,92' \
        sparse_voronoi_3.gif
convert -size 100x100 xc: -sparse-color  Voronoi \
            '30,10 red   10,80 blue   90,90 lime' \
        -blur 0x15   -fill white -stroke black \
        -draw 'circle 30,10 30,12  circle 10,80 10,82  circle 90,90 90,92' \
        sparse_voronoi_blur_3.png
convert -size 100x100 xc: -sparse-color  Shepards \
            '30,10 red   10,80 blue   90,90 lime' \
        -fill white -stroke black \
        -draw 'circle 30,10 30,12  circle 10,80 10,82  circle 90,90 90,92' \
        sparse_shepards_3.png
convert -size 100x100 xc: -sparse-color  Inverse \
            '30,10 red   10,80 blue   90,90 lime' \
        -fill white -stroke black \
        -draw 'circle 30,10 30,12  circle 10,80 10,82  circle 90,90 90,92' \
        sparse_inverse_3.png
