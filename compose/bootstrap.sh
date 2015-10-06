ln -s ../images/dragon_sm.gif  .
ln -s ../images/cyclops_sm.gif  cyclops.gif
ln -s ../images/{bg,star,sphinx,hand_point}.gif .
ln -s ../images/tile_{aqua,water}.jpg .
ln -s ../images/text_scan.png .
ln -s ../images/overlay_*.gif .
ln -s ../images/koala.gif .
ln -s ../images/rose.png .
ln -s ../img_photos/flower_sm.jpg .

echo "Generating Blend Montage..."

list=

for b in 0 20 30 40 50 60 80 100 \
          0x100 20x100 30x100 40x100 50x100 60x100 80x100 100x100 \
          100x100 100x80 100x70 100x60 100x50 100x40 100x20 100x0; do
  composite -label "blend ${b}" -blend ${b}  -gravity South \
            compose_R.png compose_plus_GB.png -matte montage_blend_${b}.png
  list="$list montage_blend_${b}.png"
done

montage -tile 8x -geometry +4+2  -pointsize 10 \
        $list blend_montage.jpg

rm -f montage_blend_[0-9]*.png
chmod 644 blend_montage.jpg

echo "Generating Gradient OP"
methods='
        Plus         ModulusAdd   Minus         ModulusSubtract
        Screen       Multiply     Difference    Exclusion
        Lighten      Darken       -none-        Divide
        LinearDodge  LinearBurn   ColorBurn     ColorDodge
        Overlay      SoftLight    PegtopLight   -none-
        HardLight    Pinlight     LinearLight   VividLight
        Bumpmap
        '

utf_arrow=`env LC_CTYPE=en_AU.utf8 printf '\u2500\u2192'`

for method in $methods; do
  [ "X$method" = 'X-none-' ] && continue
  convert gradient_dst.png gradient_src.png \
          -compose $method  -composite -compose Over \
          -bordercolor blue -border 1 \
          -pointsize 12 -font Arial \
          -size 66x \( label:"Dest $utf_arrow" \) -append \
          \( label:"Src $utf_arrow" -rotate -90 \) +swap +append \
          gradient_op_`echo $method | tr 'A-Z' 'a-z'`.png
done


echo "Generating Dissolve Montage..."


#. ../generate_options
#jpg_opt='-quality 100%'

list=

for b in 0 20 30 40 50 60 80 100 \
          100 120 130 140 150 160 180 200 \
          0x100 20x80 30x70 40x60 50x50 60x40 80x20 100x0; do
  composite -label "dissolve ${b}" -dissolve ${b}  -gravity South \
            star.gif dragon_sm.gif -matte   montage_dissolve_${b}.png
  list="$list montage_dissolve_${b}.png"
done

montage -tile 8x -geometry +4+2  -pointsize 10 \
        $list  $jpg_opt dissolve_montage.jpg

rm -f montage_dissolve_[0-9]*.png
chmod 644 dissolve_montage.jpg

echo "Generating Watermark Montage..."

#trap "rm -rf wmark_*.png; exit 0" 0 1 2 3 15

# . ../generate_options
#jpg_opt='-quality 100%'

list=

#for s in '' x10 x30 x50 x70 x90 x100; do
  for b in 10 15 20 25 30 35 40 100; do
    composite -label "wmark ${b}${s}" -watermark ${b}${s}  -gravity South \
              sphinx.gif cyclops.gif  -matte  wmark_${b}${s}.png
    list="$list wmark_${b}${s}.png"
  done
#done

montage -tile x1 -geometry +4+2  -pointsize 10 \
        $list  $jpg_opt wmark_montage.jpg
chmod 644 wmark_montage.jpg
rm -rf wmark_*.png
