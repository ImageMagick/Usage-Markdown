PATH=$PATH:../scripts

ln -s ../images/test.png .
ln -s ../images/rose.png .
ln -s ../images/tile_disks.jpg .
ln -s ../images/cow.gif .
ln -s ../img_photos/wedding_party_sm.jpg .
ln -s ../img_photos/zelda_dark_sm.png zelda.png
ln -s ../img_photos/port_sm.png port.png
ln -s ../img_photos/chinese_chess_sm.jpg chinese_chess.jpg

im_graph '-noop' gp_noop.gif
im_graph '-negate' gp_negate.gif
im_graph '-level 25%' gp_level.gif
im_graph '-level 0%,75%'   gp_level_lt.gif
im_graph '-level 25%,100%' gp_level_dk.gif
im_graph '-level -25%' gp_level-.gif
im_graph '-level 100%,0' gp_level_neg.gif
im_graph '-level 50%,50%' gp_level_thres.gif
im_graph '+level 25%' gp_level+.gif
im_graph '+level 20% -level 20%' gp_level_undo.gif
im_graph '+level 30%,30%' gp_level_const.gif
im_graph '-level 0%,100%,2.0' gp_level_glt.gif
im_graph '-level 0%,100%,0.5' gp_level_gdk.gif
im_graph '+level 25%,100%,.6'  gp_level_blue.gif
# SETCHELL - cannot make next line work
# im_graph '-fx "(1/(1+exp(10*(.5-u)))-0.0067)*1.0136"' gp_sigmoidal.gif
# Assert what?
[ "`identify -format '%[fx:saturation]' normalize.jpg`" != 0 ] && echo >&2 \
  "ASSERTION FAILURE: Normalize channels were not tied together."


# Post processing for 
# ~~~
# convert -size 1x100 gradient: \
#          -depth 8 -format "%c" histogram:info:
# ~~~
#sed '/^$/d; s/      //' grad_hist.txt |
#   sort -t, -k2n  -o grad_hist.txt
#head -n 3 grad_hist.txt; echo '   ...'; tail -n 3 grad_hist.txt

im_histogram -l -t 'Linear White Tint' 'x * .7' fx_linear_white_plot
im_histogram -l -t 'Linear Black Tint' \
             '1-(1-.3)*(1-x)'     fx_linear_black_plot
im_histogram -l -t 'Linear Color Tint' \
              '.7*x+.2*(1-x)'    fx_linear_color_plot
im_histogram -l -t 'Non-Linear Color Tint' \
              '.2+(.8-.2)*x**4'     fx_non-linear_plot
im_histogram -l -t 'Non-Linear Color Tint' \
              '.25+(1-.25)*x**2'     fx_quadratic_plot
im_histogram -l -t 'Non-Linear Tint for Blue Channel' \
              '.25*exp(-x*4.9)+x'     fx_expotential_plot
im_histogram -d fx_control.txt  -t "Histogram Curve Fit" \
          -- "`sed 's/u/x/g; s/\^/**/g'  fx_funct.txt`"   fx_funct_plot
echo 0,0.2  0.3,0.7  0.6,0.5  0.8,0.8  1,0.6   |\
       perl -pe 's/ +/\n/g; s/,/ /g;'       > fx_curve_pts.txt
im_histogram -d fx_curve_pts.txt  -t "Histogram Curve Fit" \
       -- "`sed 's/u/x/g; s/\^/**/g'  fx_curve.txt`"   fx_curve_plot
im_histogram -t "Tint Vector Function" \
       '1-(4.0*((x-0.5)*(x-0.5)))' tint_plot

im_profile -s fuzzy_thres.png fuzzy_thres_pf.gif
im_profile -s fuzzy_spike.png fuzzy_spike_pf.gif
im_profile -s filament.png filament_pf.gif
convert gradient_levels.png -scale 16x100\! gradient_levels_mag.png
enlarge_image -7 hald_3.png hald_3_lg.png

# Assert
[ `compare -metric PAE rose: rose_hald_noop.png null: 2>&1 |
             sed 's/ .*//'` != '0' ] && echo >&2 \
  "ASSERTION FAILURE: Noop Hald CLUT made a chnage to the image\!"

rm -f fit.log
