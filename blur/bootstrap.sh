ln -s ../images/tree.gif .
ln -s ../images/bg.gif .
ln -s ../images/rose.png .
ln -s ../images/shape_figure.gif shape.gif

list=
for r in 1 2 5 0; do
  for s in 1 2 3 4 6 8; do
    convert -font Candice -pointsize 48 -label "-blur ${r}x${s}" \
            blur_source.png  -blur ${r}x${s}  blur_${r}x${s}.png
     list="$list blur_${r}x${s}.png"
  done
done

montage -tile 6x  -geometry +4+2  -pointsize 10 \
        -background transparent -mattecolor transparent \
        $list blur_montage.png

rm -f blur_[0-9]*.png
chmod 644 blur_montage.png
