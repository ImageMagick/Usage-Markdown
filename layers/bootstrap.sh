PATH=$PATH:../scripts
ln -s ../images/font_[0-9].gif .
ln -s ../images/{balloon,medical,present,shading}.gif .
ln -s ../images/{castle,eye,eyeguy,ghost,hand_point}.gif .
ln -s ../images/{news,noseguy,paint_brush,pencil,recycle}.gif .
ln -s ../images/{skull,snowman,storm,terminal,tree}.gif .
ln -s ../images/tile_fabric.gif .
ln -s ../images/push_pin.png .
ln -s ../images/map_venice* .
ln -s ../images/dragon_long.gif .
ln -s ../img_photos/holocaust_tn.gif .
ln -s ../img_photos/spiral_stairs_tn.gif .
ln -s ../img_photos/chinese_chess_tn.gif .

# From generate_font_chars --append
font=../images/font.gif
convert $font -crop 32x32+0+0    +repage  font_A.gif
convert $font -crop 32x32+160+32 +repage  font_P.gif
convert $font -crop 32x32+128+0  +repage  font_E.gif
convert $font -crop 32x32+96+32  +repage  font_N.gif
convert $font -crop 32x32+96+0   +repage  font_D.gif