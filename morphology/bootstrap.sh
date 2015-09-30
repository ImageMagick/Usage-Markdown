PATH=$PATH:../scripts

ln -s ../images/rose.gif .
ln -s ../images/shape_figure.gif figure.gif
ln -s ../images/shape_man.gif man.gif
ln -s ../images/shape_lines.gif lines.gif
ln -s ../images/shape_circles.gif circles.gif
ln -s ../images/shape_disks.gif disks.gif
ln -s ../images/test_morphology.gif test.gif
ln -s ../img_photos/rose_orig.png .

kernel2image -20.2 -m "Diamond"            kernel_diamond.gif
kernel2image -20.2 -m "Square"             kernel_square.gif
kernel2image -15.2 -m "Octagon"            kernel_octagon.gif
kernel2image -9.1  -m "Disk"               kernel_disk.gif
kernel2image -15.2 -m "Plus"               kernel_plus.gif
kernel2image -15.2 -m "Rectangle:7x4+3+2"  kernel_rectangle.gif
kernel2image -20.2 -m -k 0 "Corners"       kernel_corner.gif
kernel2image -8.1 -mn -n "Gaussian:5x2"    kernel_gaussian.gif


kernel2image "Disk" kernel_disk_raw.gif

kernel2image -35.2 -m "Unity"    kernel_unity.gif
kernel2image -20.2 -m "Octagon:1"  kernel_octagon_1.gif
kernel2image -15.2 -m "Octagon:2"  kernel_octagon_2.gif
kernel2image -12.2 -m "Octagon:3"  kernel_octagon_3.gif
kernel2image -10.1 -m "Octagon:4"  kernel_octagon_4.gif
kernel2image -9.1  -m "Octagon:5"  kernel_octagon_5.gif

kernel2image -30.2 -m "Disk:0.5"  kernel_disk_01.gif
kernel2image -20.2 -m "Disk:1.0"  kernel_disk_02.gif
kernel2image -20.2 -m "Disk:1.5"  kernel_disk_03.gif
kernel2image -15.2 -m "Disk:2.0"  kernel_disk_04.gif
kernel2image -15.2 -m "Disk:2.5"  kernel_disk_05.gif
kernel2image -15.2 -m "Disk:2.9"  kernel_disk_06.gif
kernel2image -12.1 -m "Disk:3.5"  kernel_disk_07.gif
kernel2image -12.1 -m "Disk:3.9"  kernel_disk_08.gif
kernel2image -10.1 -m "Disk:4.3"  kernel_disk_09.gif
kernel2image -10.1 -m "Disk:4.5"  kernel_disk_10.gif
kernel2image -9.1  -m "Disk:5.3"  kernel_disk_11.gif

kernel2image -20.2 -m "Plus:1"  kernel_plus_1.gif
kernel2image -15.2 -m "Plus:2"  kernel_plus_2.gif
kernel2image -10.1 -m "Plus:3"  kernel_plus_3.gif
kernel2image -9.1  -m "Plus:4"  kernel_plus_4.gif

kernel2image -13.2 -m "Cross"   kernel_cross.gif

kernel2image -20.2 -m "Cross:1"  kernel_cross_1.gif
kernel2image -13.2 -m "Cross:2"  kernel_cross_2.gif
kernel2image -10.1 -m "Cross:3"  kernel_cross_3.gif
kernel2image -9.1  -m "Cross:4"  kernel_cross_4.gif

kernel2image -10.1 -m "Ring"   kernel_ring.gif

kernel2image -20.1 -m "Ring:1"         kernel_ring_01.gif
kernel2image -20.1 -m "Ring:1.5"       kernel_ring_02.gif
kernel2image -20.1 -m "Ring:1,1.5"     kernel_ring_03.gif
kernel2image -15.1 -m "Ring:2"         kernel_ring_04.gif
kernel2image -15.1 -m "Ring:1,2"       kernel_ring_05.gif
kernel2image -15.1 -m "Ring:1.5,2"     kernel_ring_06.gif
kernel2image -15.1 -m "Ring:1,2.5"     kernel_ring_07.gif
kernel2image -15.1 -m "Ring:1.5,2.5"   kernel_ring_08.gif
kernel2image -15.1 -m "Ring:1.5,2.9"   kernel_ring_09.gif
kernel2image -15.1 -m "Ring:2,2.5"     kernel_ring_10.gif
kernel2image -12.1 -m "Ring:2,3.5"     kernel_ring_11.gif
kernel2image -12.1 -m "Ring:2.5,3.5"   kernel_ring_12.gif
kernel2image -12.1 -m "Ring:2.9,3.5"   kernel_ring_13.gif
kernel2image -12.1 -m "Ring:3,3.5"     kernel_ring_14.gif
kernel2image -12.1 -m "Ring:3,3.9"     kernel_ring_15.gif
kernel2image -10.1 -m "Ring:2.5,4.3"   kernel_ring_16.gif
kernel2image -10.1 -m "Ring:3.5,4.3"   kernel_ring_17.gif
kernel2image -10.1 -m "Ring:3.9,4.5"   kernel_ring_18.gif
kernel2image -10.1 -m "Ring:4,4.5"     kernel_ring_19.gif
kernel2image -10.1 -m "Ring:4.3,4.5"   kernel_ring_20.gif
kernel2image -9.1  -m "Ring:4.3,5.3"   kernel_ring_21.gif

kernel2image -35.2 -m "Rectangle:2x2"      kernel_rect_1.gif
kernel2image -25.2 -m "Rectangle:3x3"      kernel_rect_2.gif
kernel2image -20.2 -m "Rectangle:4x2"      kernel_rect_3.gif
kernel2image -20.2 -m "Rectangle:4"        kernel_rect_4.gif
kernel2image -15.1 -m "Rectangle:7x3"      kernel_rect_5.gif
kernel2image -15.1 -m "Rectangle:7x1"      kernel_rect_6.gif
kernel2image -15.1 -m "Rectangle:7x1+1+0"  kernel_rect_7.gif
kernel2image -15.1 -m "Rectangle:7x1+6+0"  kernel_rect_8.gif

kernel2image -12.1 -n -ml '' "Blur:0x1"    blur_kernel.gif
kernel2image -12.1 -n -ml '' "Blur:0x1+90" blur_kernel2.gif

kernel2image -10.1 -m "Diamond:3"   kernel_diamond_3.gif

for method in  '' _erode _dilate _open _close; do
  convert test$method.gif -scale 156x102 test${method}_mag.gif
done

kernel2image -30.2 -m "2x1:1,0"    kernel_right.gif

kernel2image -30.2 -m "3x1:1,-,0"    kernel_right2.gif
kernel2image -30.2 -m "3:0,0,- 0,1,1 -,1,-"    kernel_nw_corner.gif
kernel2image -20.2 -ml '' -mt x1 "3>:0,0,- 0,1,1 -,1,-" \
       kernel_hmt_corners.gif

kernel2image -30.2 -m "3x1+2+0:1,0,0"    kernel_right_out.gif

kernel2image -20.2 -m "5x1+0+0:1,1,1,1,0"    kernel_right_in.gif

kernel2image -10.1 -m "Peaks"         kernel_peaks.gif

kernel2image -20.1 -m "Peaks:1"         kernel_peaks_01.gif
kernel2image -20.1 -m "Peaks:1.9"       kernel_peaks_02.gif
kernel2image -15.1 -m "Peaks:2"         kernel_peaks_03.gif
kernel2image -15.1 -m "Peaks:2.5"       kernel_peaks_04.gif
kernel2image -15.1 -m "Peaks:2.9"       kernel_peaks_05.gif
kernel2image  -8.1 -m "Peaks:4.3,5.3"   kernel_peaks_06.gif

kernel2image -20.1 -ml '' -mt x1 "Edges"  miff:- | \
  convert -background LightSteelBlue  - label:Edges \
          -gravity center -append    kernel_edges.gif

kernel2image -20.1 -ml '' -mt x1 "Corners"  miff:- | \
  convert -background LightSteelBlue  - label:Corners \
          -gravity center -append    kernel_corners.gif

kernel2image -20.2 -ml '' -mt x1 "Diagonals"  miff:- | \
  convert -background LightSteelBlue  - label:Diagonals \
          -gravity center -append    kernel_diagonals.gif

kernel2image -25.2 -m "Diagonals:1"  kernel_diagonals1.gif
kernel2image -25.2 -m "Diagonals:2"  kernel_diagonals2.gif

kernel2image -20.2 -ml '' -mt x1 "LineEnds"  miff:- | \
  convert -background LightSteelBlue  - label:LineJunctions \
          -gravity center -append    kernel_lineends.gif

kernel2image -20.2 -m "LineEnds:1"  kernel_lineends1.gif
kernel2image -20.2 -m "LineEnds:2"  kernel_lineends2.gif
kernel2image -20.2 -m "LineEnds:3"  kernel_lineends3.gif
kernel2image -20.2 -m "LineEnds:4"  kernel_lineends4.gif

# CODE EXECUTE SCRIPT IMAGE=kernel_linejunctions.gif
( kernel2image -15.1 -ml '' -mt x1 "LineJunctions:1@"  miff:-
     kernel2image -15.1 -ml '' -mt x1 "LineJunctions:2>"  miff:-
   ) |
   convert -background LightSteelBlue  - label:LineJunctions \
           -gravity center -append    kernel_linejunctions.gif

kernel2image -25.2 -m "LineJunctions:1"  kernel_linejunctions1.gif
kernel2image -25.2 -m "LineJunctions:2"  kernel_linejunctions2.gif
kernel2image -25.2 -m "LineJunctions:3"  kernel_linejunctions3.gif
kernel2image -25.2 -m "LineJunctions:4"  kernel_linejunctions4.gif
kernel2image -25.2 -m "LineJunctions:5"  kernel_linejunctions5.gif

kernel2image -20.2 -ml '' -mt x1 "Ridges"  miff:- | \
  convert -background LightSteelBlue  - label:Ridges \
          -gravity center -append    kernel_ridges.gif

kernel2image -15.1 -ml '' -mt x3 "Ridges:2"  miff:- | \
   montage -label Ridges:2 -  -background LightSteelBlue \
           -geometry +0+0  kernel_ridges2.gif

kernel2image -15.1 -ml '' -mt x2 "ConvexHull"  miff:- | \
   montage -label ConvexHull -  -background LightSteelBlue \
           -geometry +0+0  kernel_convexhull.gif

kernel2image -15.1 -ml '' -mt x1 "Skeleton:1"  miff:- | \
   montage -label "Skeleton:1 (Traditional)" - \
       -background LightSteelBlue -geometry +0+0  kernel_skeleton1.gif

kernel2image -15.1 -ml '' -mt x1 "Skeleton:2"  miff:- | \
   montage -label "Skeleton:2 (HIPR2)" - \
       -background LightSteelBlue -geometry +0+0  kernel_skeleton2.gif

kernel2image -15.1 -ml '' -mt x1 "Edges;Corners"  miff:- | \
   montage -label 'Edges ; Corners' - \
           -background LightSteelBlue -geometry +0+0  kernel_edge-corner.gif

kernel2image -15.1 -ml '' -mt x1 "Skeleton:3"  miff:- | \
   montage -label "Skeleton:3 (Bloomberg)" - \
       -background LightSteelBlue -geometry +0+0  kernel_skeleton3.gif

# SCRIPT

flags="-tile x1 -background LightSteelBlue -geometry +0+0"
for i in `seq 41 44`; do
    kernel2image -15.1 -m -ml $i  "ThinSE:$i" miff:-
done | montage - $flags miff:- |
  montage -label "Strong 4-connected" - \
    -font ArialB $flags kernel_thinse_4strong.gif

for i in `seq 45 49`; do
    kernel2image -15.1 -m -ml $i "ThinSE:$i" miff:-
done | montage - $flags miff:- |
  montage -label "Weak 4-connected" - \
    -font ArialB $flags kernel_thinse_4weak.gif

for i in `seq 81 84`; do
    kernel2image -15.1 -m -ml $i "ThinSE:$i" miff:-
done | montage - $flags miff:- |
  montage -label "Strong 8-connected" - \
    -font ArialB $flags kernel_thinse_8strong.gif

for i in `seq 85 89`; do
    kernel2image -15.1 -m -ml $i "ThinSE:$i" miff:-
done | montage - $flags miff:- |
  montage -label "Weak 8-connected" - \
    -font ArialB $flags kernel_thinse_8weak.gif

for i in 423 823; do
    kernel2image -15.1 -m -ml $i "ThinSE:$i" miff:-
done | montage - $flags -geometry +15+0 miff:- |
  montage -label "Weak, Combined 2 and 3" - \
    -font ArialB $flags -geometry +25+0 kernel_thinse_23comb.gif

for i in 481 482; do
    kernel2image -15.1 -m -ml $i "ThinSE:$i" miff:-
done | montage - $flags -geometry +15+0 miff:- |
  montage -label "General 4 & 8 Conection Preserving" - \
    -font ArialB $flags -geometry +25+0 kernel_thinse_48gen.gif

