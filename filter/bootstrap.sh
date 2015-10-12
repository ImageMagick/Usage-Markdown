PATH=$PATH:../scripts
ln -s ../images/storm.gif .
ln -s ../img_photos/rings_* .

# Extra Images...
# ./generate_graphs
#!/bin/sh
#
# Generate graphs of the various filters...
#
gnuplot_colors='xffffff x000000 x000000 xff0000 x00ff00 \
                xff00ff x6495ed xa0522d x00ffff xff7a50 xffb000'
gnuplot_gif_output="set size .3,.25; set terminal gif tiny $gnuplot_colors"
gnuplot_jpg_output="set terminal jpeg medium $gnuplot_colors"

normalize() {
  # Normalize the filter data -- in place
  perl -i -ple '
    undef $first if /#/;
    next if /^$/ || /#/;
    ($x,$y)=split;
    $first=$y  if ! defined $first && $y > 0;
    $y /= $first; $_="$x\t$y";
    '  "$1"
}

echo "Graph Sinc()/Jinc() Mathematical Functions"
gnuplot <<EOF
  set title "Sinc() Functions"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  Jinc(x) = 2*besj1(x*PI)/(x*PI)
  set grid
  set xtics 1
  set style data lines
  $gnuplot_jpg_output
  set output "graph_sinc.jpg"
  plot [0:10][-.3:1.1] Sinc(x)
  set output "graph_jinc.jpg"
  plot [0:10][-.3:1.1] Jinc(x)
  set output "graph_sinc_jinc.jpg"
  plot [0:10][-.3:1.1] Sinc(x), Jinc(x)

  unset title
  unset key
  set xtics 2
  $gnuplot_gif_output
  set output "graph_sinc.gif"
  plot [0:10][-.3:1.1] Sinc(x)
  set output "graph_jinc.gif"
  plot [0:10][-.3:1.1] Jinc(x)
  set output "graph_sinc_jinc.gif"
  plot [0:10][-.3:1.1] Sinc(x), Jinc(x)
  quit
EOF
#convert graph_sinc_jinc.gif -trim +repage -bordercolor white -border 5 \
#        -resize '150x100!'  -colors 256 graph_sinc_jinc.gif

# ------------
# Filter Data Collection

# Data for ALL filters at their default support
for filter in `convert -list filter`; do
  [ $filter = Point ]    && continue    # Don't both with these filter names
  [ $filter = SincFast ] && continue    # either non-filter or a duplicate
  [ $filter = Cubic ]    && continue    # naming of another filter.
  name=`echo $filter | tr A-Z a-z`

  echo "Data for filter \"$filter\""
  convert -define filter:verbose=1 -filter "$filter" \
          null: -resize 2 null: > filter_$name.dat
  echo '10.00   0.0000' >> filter_$name.dat

  normalize filter_$name.dat

done

# Data for specific filters at variable support
while read filter support; do
  echo "Data for filter \"$filter\" (support=$support)"
  name=`echo ${filter}_${support} | tr A-Z a-z`
  convert -define filter:verbose=1 \
          -define filter:support=$support \
          -filter "$filter" \
          null: -resize 2 null: > filter_$name.dat
  echo '10.00   0.0000' >> filter_$name.dat

  normalize filter_$name.dat

done << EOF
  Gaussian 1.25
  Lanczos 2
  Lanczos 3
  Lanczos 4
  Lanczos 5
  Lanczos 6
  Lanczos 7
  Lanczos 8
  Lagrange 0.5
  Lagrange 1.0
  Lagrange 1.5
  Lagrange 2.0
  Lagrange 2.5
  Lagrange 3.0
  Lagrange 3.5
  Lagrange 4.0
  Lagrange 4.5
EOF

# Data for specific blurred filters
while read filter blur; do
  echo "Data for filter \"$filter\" (blur=$blur)"
  name=`echo ${filter}_blur_${blur} | tr A-Z a-z`
  convert -define filter:verbose=1 \
          -define filter:blur=$blur \
          -filter "$filter" \
          null: -resize 2 null: > filter_$name.dat
  echo '10.00   0.0000' >> filter_$name.dat

  normalize filter_$name.dat

done << EOF
  Gaussian 0.75
EOF

# Extract data for windowing filters (normalized range)
for filter in Welch Cosine Lanczos Bartlett \
              Hamming Hann Kaiser Blackman Bohman Parzen; do
  name=`echo $filter | tr A-Z a-z`
  echo "Data for window \"$filter\""
  convert -define filter:verbose=1 \
          -define filter:filter=Box \
          -define filter:window=$filter \
          -define filter:support=1 \
          null: -resize 2 null: > window_$name.dat

  normalize  window_$name.dat

done

# Extract data for windowing filters (default support range)
for filter in Welch Cosine Lanczos Bartlett \
              Hamming Hann Kaiser Blackman Bohman Parzen; do
  name=`echo $filter | tr A-Z a-z`
  echo "Data for window \"$filter\" (scaled to support)"
  support=`sed -n 's/.*practical-support = //p' filter_$name.dat`
  convert -define filter:verbose=1 \
          -define filter:filter=Box \
          -define filter:window=$filter \
          -define filter:support=$support \
          null: -resize 2 null: > window_${name}_support.dat
  echo '10.00   0.0000' >> window_${name}_support.dat

  normalize  window_${name}_support.dat

done

# Extract data for Specific cylindrical filters
for filter in Jinc Lanczos LanczosSharp LanczosRadius \
              Lanczos2 Lanczos2Sharp Robidoux RobidouxSharp; do
  name=`echo $filter | tr A-Z a-z`
  echo "Data for cylindrical \"$filter\""
  convert -define filter:verbose=1 -filter "$filter" \
          null: -distort SRT 0 null: > filter_${name}_cyl.dat
  echo '10.00   0.0000' >> filter_${name}_cyl.dat

  normalize filter_${name}_cyl.dat

done


# ------------
# Graphs for specific filter (one per graph)
#
while read filter; do
  echo "Graph of filter \"$filter\""
  name=`echo $filter | tr A-Z a-z`
  support=`sed -n 's/.*practical-support = //p' filter_$name.dat`

  gnuplot << EOF
    set title "Filter $filter (support=$support)"
    set grid
    set xtics $support<=2?.25:.5
    set style data lines
    $gnuplot_jpg_output
    set output "graph_filter_$name.jpg"
    set xrange [0:$support<2?2:$support]
    set yrange [-.15:1.05]
    plot "filter_$name.dat" title "$filter"

    unset title
    unset key
    set xtics $support<=2?.5:1
    $gnuplot_gif_output
    set output "graph_filter_$name.gif"
    replot
    quit
EOF
done << EOF
  Box
  Triangle
  Gaussian
  Catrom
EOF

echo "Graph of filter \"Gaussian (1.25)\""
support=1.25

gnuplot << EOF
  set title "Filter Gaussian (support=1.25)"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_gaussian_support.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_gaussian_1.25.dat" title "gaussian (1.25)"

  unset title
  unset key
  set xtics .5
  $gnuplot_gif_output
  set output "graph_gaussian_support.gif"
  replot
  quit
EOF

# ------------
echo "Graph Interpolation Filters"
gnuplot << EOF
  set title "Interpolation Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_interpolation.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_box.dat"      title "Box" \
     , "filter_triangle.dat" title "Triangle" \
     , "filter_hermite.dat"  title "Hermite" \

  unset title
  unset key
  set xtics .5
    $gnuplot_gif_output
  set output "graph_interpolation.gif"
  replot
  quit
EOF

# ------------
echo "Graph Gaussian-like Filters"
gnuplot << EOF
  set title "Gaussian-like Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_gaussian.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_gaussian.dat"  title "Gaussian" \
      ,"filter_quadratic.dat" title "Quadratic" \
      ,"filter_spline.dat"    title "Spline" \
      ,"filter_mitchell.dat"  title "Mitchell" \

  unset title
  unset key
  set xtics .5
  $gnuplot_gif_output
  set output "graph_gaussian.gif"
  replot
  quit
EOF

# ------------
echo "Graph Gaussian Interpolation Filter"
gnuplot << EOF
  set title "Gaussian Interpolation Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_blurred.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_gaussian_blur_0.75.dat"  title "Gaussian (blur=0.75)" \
      ,"filter_hermite.dat"             title "Hermite" \

  unset title
  unset key
  set xtics .5
  $gnuplot_gif_output
  set output "graph_blurred.gif"
  replot
  quit
EOF

# ------------
echo "Graph of the Sinc Windowing process"
gnuplot << EOF
  set title "Sinc Windowing Process"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics .5
  set style data lines
  $gnuplot_jpg_output
  set output "graph_sinc_windowing.jpg"
  set xrange [0:4]
  set yrange [-.25:1.05]
  plot Sinc(x) title "True Sinc" \
      ,"window_hann.dat" using (\$1*4):2 title "Hann Window" \
      ,"filter_hann.dat" title "Sinc() * Hann" \

  unset title
  unset key
  set xtics 1
  $gnuplot_gif_output
  set output "graph_sinc_windowing.gif"
  replot
  quit
EOF

# ------------
echo "Graph Windowing Functions (range 0 to 1)"
gnuplot << EOF
  set title "Normalized Windowing Functions"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_windowing.jpg"
  set xrange [0:1]
  set yrange [-.25:1.05]
  plot -.25 notitle \
      ,"window_welch.dat"     title "Welch" \
      ,"window_cosine.dat"    title "Cosine" \
      ,"window_lanczos.dat"   title "Lanczos" \
      ,"window_bartlett.dat"  title "Bartlett" \
      ,"window_hamming.dat"   title "Hamming" \
      ,"window_hann.dat"      title "Hann" \
      ,"window_kaiser.dat"    title "Kaiser" \
      ,"window_blackman.dat"  title "Blackman" \
      ,"window_bohman.dat"    title "Bohman" \
      ,"window_parzen.dat"    title "Parzen" \

  unset title
  unset key
  set xtics .25
  $gnuplot_gif_output
  set output "graph_windowing.gif"
  replot
  quit
EOF

# ------------
echo "Graph Windowing Functions (default support range)"
gnuplot << EOF
  set title "Normalized Windowing Functions (default support range)"
  set grid
  set xtics .5
  set style data lines
  $gnuplot_jpg_output
  set output "graph_windowing_support.jpg"
  set xrange [0:4]
  set yrange [-.25:1.05]
  plot -.25 notitle \
      ,"window_welch_support.dat"     title "Welch" \
      ,"window_cosine_support.dat"    title "Cosine" \
      ,"window_lanczos_support.dat"   title "Lanczos" \
      ,"window_bartlett_support.dat"  title "Bartlett" \
      ,"window_hamming_support.dat"   title "Hamming" \
      ,"window_hann_support.dat"      title "Hann" \
      ,"window_kaiser_support.dat"    title "Kaiser" \
      ,"window_blackman_support.dat"  title "Blackman" \
      ,"window_bohman_support.dat"    title "Bohman" \
      ,"window_parzen_support.dat"    title "Parzen" \

  unset title
  unset key
  set xtics 1
  $gnuplot_gif_output
  set output "graph_windowing_support.gif"
  replot
  quit
EOF

# ------------
echo "Graph Windowed-Sinc Filters"
gnuplot << EOF
  set title "Windowed-Sinc Filters"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics .5
  set style data lines
  $gnuplot_jpg_output
  set output "graph_windowed_sinc.jpg"
  set xrange [0:4]
  set yrange [-.25:1.05]
  plot Sinc(x) title "True Sinc" \
      ,"filter_welch.dat"     title "Welch" \
      ,"filter_cosine.dat"    title "Cosine" \
      ,"filter_lanczos.dat"   title "Lanczos" \
      ,"filter_bartlett.dat"  title "Bartlett" \
      ,"filter_hamming.dat"   title "Hamming" \
      ,"filter_hann.dat"      title "Hann" \
      ,"filter_kaiser.dat"    title "Kaiser" \
      ,"filter_blackman.dat"  title "Blackman" \
      ,"filter_bohman.dat"    title "Bohman" \
      ,"filter_parzen.dat"    title "Parzen" \

  unset title
  unset key
  set xtics 1
  $gnuplot_gif_output
  set output "graph_windowed_sinc.gif"
  replot
  quit
EOF

# ------------
echo "Graph Lanczos Filters"
gnuplot << EOF
  set title "Lanczos Filters"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics 1
  set style data lines
  $gnuplot_jpg_output
  set output "graph_lanczos_filters.jpg"
  set xrange [0:3]
  set yrange [-.25:1.05]
  plot "filter_lanczos.dat"  title "Lanczos" \
      ,"filter_lanczos2.dat" title "Lanczos2" \
      ,"filter_catrom.dat"   title "Catrom" \

  unset title
  unset key
  set xtics 2
  $gnuplot_gif_output
  set output "graph_lanczos_filters.gif"
  replot
  quit
EOF

# ------------
echo "Graph Lanczos Lobes Support"
gnuplot << EOF
  set title "Lanczos Lobes Adjustment"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics 1
  set style data lines
  $gnuplot_jpg_output
  set output "graph_lanczos_lobes.jpg"
  set xrange [0:8]
  set yrange [-.25:1.05]
  plot Sinc(x) title "True Sinc" \
      ,"filter_lanczos_2.dat" title "Lanczos(2)" \
      ,"filter_lanczos_3.dat" title "Lanczos(3)" \
      ,"filter_lanczos_4.dat" title "Lanczos(4)" \
      ,"filter_lanczos_5.dat" title "Lanczos(5)" \
      ,"filter_lanczos_6.dat" title "Lanczos(6)" \
      ,"filter_lanczos_7.dat" title "Lanczos(7)" \
      ,"filter_lanczos_8.dat" title "Lanczos(8)" \

  unset title
  unset key
  set xtics 2
  $gnuplot_gif_output
  set output "graph_lanczos_lobes.gif"
  replot
  quit
EOF

# ------------
echo "Graph Lagrange Interpolate Filters"
gnuplot << EOF
  set title "Lagrange Order (support)"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_lagrange_interpolate.jpg"
  set xrange [0:2]
  set yrange [-.25:1.05]
  plot "filter_lagrange_0.5.dat" title "Lagrange-0 (0.5)" \
      ,"filter_lagrange_1.0.dat" title "Lagrange-1 (1.0)" \
      ,"filter_lagrange_2.0.dat" title "Lagrange-3 (2.0)" \

  unset title
  unset key
  set xtics .5
  $gnuplot_gif_output
  set output "graph_lagrange_interpolate.gif"
  replot
  quit
EOF

echo "Graph Lagrange Self Windowed (Odd Orders)"
gnuplot << EOF
  set title "Lagrange 'Odd' Orders (support)"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics .5
  set style data lines
  $gnuplot_jpg_output
  set output "graph_lagrange_windowed.jpg"
  set xrange [0:4]
  set yrange [-.25:1.05]
  plot "filter_lagrange_2.0.dat" title "Lagrange-3 (2.0)" \
      ,"filter_lagrange_3.0.dat" title "Lagrange-5 (3.0)" \
      ,"filter_lagrange_4.0.dat" title "Lagrange-7 (4.0)" \

  unset title
  unset key
  set xtics 1
  $gnuplot_gif_output
  set output "graph_lagrange_windowed.gif"
  replot
  quit
EOF

echo "Graph Lagrange Self Windowed (Even Orders)"
gnuplot << EOF
  set title "Lagrange 'Even' Orders (support)"
  PI=atan2(1,1)*4
  Sinc(x) = sin(x*PI)/(x*PI)
  set grid
  set xtics .5
  set style data lines
  $gnuplot_jpg_output
  set output "graph_lagrange_even.jpg"
  set xrange [0:4]
  set yrange [-.25:1.05]
  plot "filter_lagrange_1.5.dat" title "Lagrange-2 (1.5)" \
      ,"filter_lagrange_2.5.dat" title "Lagrange-4 (2.5)" \
      ,"filter_lagrange_3.5.dat" title "Lagrange-6 (3.5)" \
      ,"filter_lagrange_4.5.dat" title "Lagrange-8 (4.5)" \

  unset title
  unset key
  set xtics 1
  $gnuplot_gif_output
  set output "graph_lagrange_even.gif"
  replot
  quit
EOF

# ------------
echo "Graph of Cubic Filters"
# This does not include the Robidoux filter

gnuplot << EOF
  set title "Normalized Cubic Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_cubics.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_spline.dat"   title "Spline" \
      ,"filter_mitchell.dat" title "Mitchell" \
      ,"filter_catrom.dat"   title "Catrom" \
      ,"filter_hermite.dat"  title "Hermite" \

  unset title
  unset key
  set xtics .5
  $gnuplot_gif_output
  set output "graph_cubics.gif"
  replot
  quit
EOF

# ------------
echo "Graph of Windowed Jinc Filters"

gnuplot << EOF
  set title "Windowed Jinc Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_jinc.jpg"
  set xrange [0:3]
  set yrange [-.15:1.05]
  set arrow from  1.6,0.15 to  1.235,0.007
  set label "Jinc zero crossing at 1.21967" at 1.61,0.15 left
  plot "filter_jinc_cyl.dat"      title "Jinc" \
      ,"filter_lanczos_cyl.dat"   title "Lanczos" \
      ,"filter_lanczos2_cyl.dat" title "Lanczos2" \

  unset title
  unset key
  unset arrow
  unset label
  set xtics .5
  $gnuplot_gif_output
  set output "graph_jinc.gif"
  replot
  quit
EOF

# ------------
echo "Graph of 2-Lobe Lanczos Cylinderical Filters"

gnuplot << EOF
  set title "2-Lobe Lanczos Cylinderical Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_cyl_lanczos_2.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  #set arrow from  1.45,0.14 to  1.235,0.007
  #set label "Jinc zero at 1.21967" at 1.46,0.14 left
  #set arrow from  1.04,-0.1 to  1.168,-0.015
  #set label "Sharpened zero at 1.168484" at 1.04,-0.1 right
  plot "filter_lanczos2_cyl.dat"      title "Lanczos2" \
      ,"filter_lanczos2sharp_cyl.dat" title "Lanczos2Sharp" \

  unset title
  unset key
  unset arrow
  unset label
  set xtics .5
  $gnuplot_gif_output
  set output "graph_cyl_lanczos_2.gif"
  replot
  quit
EOF
# ------------
echo "Graph of 3-Lobe Lanczos Cylindrical Filters"

gnuplot << EOF
  set title "3-Lobe Lanczos Cylindrical Filters"
  set grid
  set xtics 0.25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_cyl_lanczos_3.jpg"
  set xrange [0:3]
  set yrange [-.15:1.05]
  plot "filter_lanczos_cyl.dat"       title "Lanczos" \
      ,"filter_lanczossharp_cyl.dat"  title "LanczosSharp" \
      ,"filter_lanczosradius_cyl.dat" title "LanczosRadius" \

  unset title
  unset key
  unset arrow
  unset label
  set xtics 0.5
  $gnuplot_gif_output
  set output "graph_cyl_lanczos_3.gif"
  replot
  quit
EOF

# ------------
echo "Graph of Robidoux Cubic Filters"

gnuplot << EOF
  set title "Robidoux Filters"
  set grid
  set xtics .25
  set style data lines
  $gnuplot_jpg_output
  set output "graph_robidoux.jpg"
  set xrange [0:2]
  set yrange [-.15:1.05]
  plot "filter_lanczos2sharp_cyl.dat"  title "Lanczos2sharp" \
      ,"filter_robidoux.dat"           title "Robidoux" \
      ,"filter_robidouxsharp.dat"      title "RobidouxSharp" \

  unset title
  unset key
  unset arrow
  unset label
  set xtics .5
  $gnuplot_gif_output
  set output "graph_robidoux.gif"
  replot
  quit
EOF

# ------------
echo "Thumbnail Cleanup"
mogrify -trim +repage -bordercolor white -border 15 \
        -gravity center -crop 180x120+0+0\! -colors 256  graph_*.gif
echo "Graph Cleanup"
rm filter_*.dat window_*.dat
chmod 644 graph_*

# ./generate_enlarge
#!/bin/sh
#
# Generate a motage array using various resize filters
# to enlarge a small image
#
echo "Generating Resize Filters Montage (enlarge)..."

. ../generate_options

for filter in Box Hermite Triangle \
              Gaussian Quadratic Spline \
              Lanczos Hamming Blackman \
              Lagrange Catrom Mitchell \
;do
  if [ "$filter" = 'null:' ]; then
    convert null: miff:-
  else
    convert -label $filter -size 10x6 xc:grey20 \
            +antialias -draw 'fill white line 4,0 5,5' \
            -filter $filter  -resize 100x  miff:-
  fi
done |
  montage -  -tile 6x  -geometry +4+2  -pointsize 10 \
          -background $page_bg_color -mattecolor $page_bg_color \
          montage_enlarge.png

chmod 644 montage_enlarge.png

# ./generate_shrink
#!/bin/sh
#
# Generate a motage array using various resize filters
# to shrink a crop of the rings image
#
echo "Generating Resize Filters Montage (shrink)..."

. ../generate_options

for filter in Box Hermite Triangle \
              Gaussian Quadratic Spline \
              Lanczos Hamming Blackman \
              Lagrange Catrom Mitchell \
;do
  if [ "$filter" = 'null:' ]; then
    convert null: miff:-
  else
    convert -label $filter rings_crop.png \
            -filter $filter -resize 100x  miff:-
  fi
done |
  montage -  -tile 6x  -geometry +4+2  -pointsize 10 \
          -background $page_bg_color -mattecolor $page_bg_color \
          montage_shrink.png

chmod 644 montage_shrink.png

# ./generate_smaller
#!/bin/sh
#
# Generate a motage array using various resize filters
# to shrink a smaller rings image down
#
echo "Generating Resize Filters Montage (smaller)..."

. ../generate_options

for filter in Box Hermite Triangle \
              Gaussian Quadratic Spline \
              Lanczos Hamming Blackman \
              Lagrange Catrom Mitchell \
;do
  if [ "$filter" = 'null:' ]; then
    convert null: miff:-
  else
    convert -label $filter rings_sm_orig.gif \
            -filter $filter -resize 100x  miff:-
  fi
done |
  montage -  -tile 6x  -geometry +4+2  -pointsize 10 \
          -background $page_bg_color -mattecolor $page_bg_color \
          montage_smaller.png

chmod 644 montage_smaller.png

