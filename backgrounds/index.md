# ImageMagick v6 Examples --  
 ![](../../w_images/space.gif) Background Examples

[![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
This is a table of applying various transforms against some 'random' canvases, showing methods of producing interesting random backgrounds at whatever size you desire, whether it is a single large image, or a background tile for a web page.
The table starts with the method used to generate the initial 'random' image used to generate all the other images shown. Just insert the various image 'transform' into the command, to convert the raw image into something similar to that shown. From there you can adjust the various setting yourself to produce exactly the type of background image you want.
Be sure to read the notes at the end, before attempting to create your own examples. and please mail any interesting variations you may come across.
Input Images :- Generator, Transform and Post-processing
 
*Images results shown here were generated with a "`-noop`" null transform operator*
Plasma Fractal *(non-tiling canvas image)*
  
      convert -size 120x120  plasma:fractal fractal.png
      convert fractal.png   {..transform..} \
               -shave 20x20 +repage  -auto_level  {result}
     

[![\[IM Output\]](fractal_noop.png)](fractal_noop.png)
Random Noise *(tilable background image)*
  
      convert -size 80x80 xc: +noise Random noise.png
      convert noise.png -virtual-pixel tile  {..transform..} \
              -auto_level  {result}
     

[![\[IM Output\]](noise_noop.png)](noise_noop.png)
Random Hex Tile *(hex tile background image)*
  
      convert -size 50x80 xc: +noise Random -write mpr:rand \
               -extent 100x80   -page +50-40 mpr:rand \
               -page +50+40 mpr:rand -flatten  hextile.png
      convert hextile.png -virtual-pixel tile  {..transform..} \
              -auto_level    {result}
     

[![\[IM Output\]](hextile_noop.png)](hextile_noop.png)
 
Basic Transforms
blur\_raw *(no post -auto-level)*
  
      -blur 0x1

[![\[Fractal\]](fractal_blur_raw.png)](fractal_blur_raw.png)
[![\[Noise\]](noise_blur_raw.png)](noise_blur_raw.png)
[![\[Noise\]](hextile_blur_raw.png)](hextile_blur_raw.png)
blur\_1
  
      -blur 0x1

[![\[Fractal\]](fractal_blur_1.png)](fractal_blur_1.png)
[![\[Noise\]](noise_blur_1.png)](noise_blur_1.png)
[![\[Noise\]](hextile_blur_1.png)](hextile_blur_1.png)
blur\_3
  
      -blur 0x3

[![\[Fractal\]](fractal_blur_3.png)](fractal_blur_3.png)
[![\[Noise\]](noise_blur_3.png)](noise_blur_3.png)
[![\[Noise\]](hextile_blur_3.png)](hextile_blur_3.png)
blur\_5
  
      -blur 0x5

[![\[Fractal\]](fractal_blur_5.png)](fractal_blur_5.png)
[![\[Noise\]](noise_blur_5.png)](noise_blur_5.png)
[![\[Noise\]](hextile_blur_5.png)](hextile_blur_5.png)
blur\_10
  
      -blur 0x10

[![\[Fractal\]](fractal_blur_10.png)](fractal_blur_10.png)
[![\[Noise\]](noise_blur_10.png)](noise_blur_10.png)
[![\[Noise\]](hextile_blur_10.png)](hextile_blur_10.png)
intensity
  
      -blur 0x10  -colorspace Gray

[![\[Fractal\]](fractal_intensity.png)](fractal_intensity.png)
[![\[Noise\]](noise_intensity.png)](noise_intensity.png)
[![\[Noise\]](hextile_intensity.png)](hextile_intensity.png)
channel
  
      -blur 0x10  -fx G

[![\[Fractal\]](fractal_channel.png)](fractal_channel.png)
[![\[Noise\]](noise_channel.png)](noise_channel.png)
[![\[Noise\]](hextile_channel.png)](hextile_channel.png)
hues
  
      -blur 0x10 -auto-level -separate -background white \
         -compose ModulusAdd -flatten -channel R -combine +channel \
         -set colorspace HSB -colorspace RGB

[![\[Fractal\]](fractal_hues.png)](fractal_hues.png)
[![\[Noise\]](noise_hues.png)](noise_hues.png)
[![\[Noise\]](hextile_hues.png)](hextile_hues.png)
Shade Transforms
shade\_raw *(no post -auto-level)*
  
      -shade 120x45

[![\[Fractal\]](fractal_shade_raw.png)](fractal_shade_raw.png)
[![\[Noise\]](noise_shade_raw.png)](noise_shade_raw.png)
[![\[Noise\]](hextile_shade_raw.png)](hextile_shade_raw.png)
shade
  
      -shade 120x45

[![\[Fractal\]](fractal_shade.png)](fractal_shade.png)
[![\[Noise\]](noise_shade.png)](noise_shade.png)
[![\[Noise\]](hextile_shade.png)](hextile_shade.png)
shade\_dimmed *(no post -auto-level)*
  
      -shade 120x45 -auto-level -fill grey -colorize 40%

[![\[Fractal\]](fractal_shade_dimmed.png)](fractal_shade_dimmed.png)
[![\[Noise\]](noise_shade_dimmed.png)](noise_shade_dimmed.png)
[![\[Noise\]](hextile_shade_dimmed.png)](hextile_shade_dimmed.png)
shade\_1
  
      -blur 0x1 -shade 120x45

[![\[Fractal\]](fractal_shade_1.png)](fractal_shade_1.png)
[![\[Noise\]](noise_shade_1.png)](noise_shade_1.png)
[![\[Noise\]](hextile_shade_1.png)](hextile_shade_1.png)
shade\_2
  
      -blur 0x2 -shade 120x45

[![\[Fractal\]](fractal_shade_2.png)](fractal_shade_2.png)
[![\[Noise\]](noise_shade_2.png)](noise_shade_2.png)
[![\[Noise\]](hextile_shade_2.png)](hextile_shade_2.png)
shade\_5
  
      -blur 0x5 -shade 120x45

[![\[Fractal\]](fractal_shade_5.png)](fractal_shade_5.png)
[![\[Noise\]](noise_shade_5.png)](noise_shade_5.png)
[![\[Noise\]](hextile_shade_5.png)](hextile_shade_5.png)
shade\_10
  
      -blur 0x10 -fx G -shade 120x45

[![\[Fractal\]](fractal_shade_10.png)](fractal_shade_10.png)
[![\[Noise\]](noise_shade_10.png)](noise_shade_10.png)
[![\[Noise\]](hextile_shade_10.png)](hextile_shade_10.png)
Emboss Transforms
emboss\_1
  
      -blur 0x5  -emboss 1

[![\[Fractal\]](fractal_emboss_1.png)](fractal_emboss_1.png)
[![\[Noise\]](noise_emboss_1.png)](noise_emboss_1.png)
[![\[Noise\]](hextile_emboss_1.png)](hextile_emboss_1.png)
emboss\_1g
  
      -blur 0x5  -emboss 1  -fx G

[![\[Fractal\]](fractal_emboss_1g.png)](fractal_emboss_1g.png)
[![\[Noise\]](noise_emboss_1g.png)](noise_emboss_1g.png)
[![\[Noise\]](hextile_emboss_1g.png)](hextile_emboss_1g.png)
emboss\_0s
  
      -blur 0x3  -emboss .5 -shade 120x45

[![\[Fractal\]](fractal_emboss_0s.png)](fractal_emboss_0s.png)
[![\[Noise\]](noise_emboss_0s.png)](noise_emboss_0s.png)
[![\[Noise\]](hextile_emboss_0s.png)](hextile_emboss_0s.png)
emboss\_1s
  
      -blur 0x5  -emboss 1  -shade 120x45

[![\[Fractal\]](fractal_emboss_1s.png)](fractal_emboss_1s.png)
[![\[Noise\]](noise_emboss_1s.png)](noise_emboss_1s.png)
[![\[Noise\]](hextile_emboss_1s.png)](hextile_emboss_1s.png)
emboss\_1gs
  
      -blur 0x5  -emboss 1  -fx G  -shade 120x45

[![\[Fractal\]](fractal_emboss_1gs.png)](fractal_emboss_1gs.png)
[![\[Noise\]](noise_emboss_1gs.png)](noise_emboss_1gs.png)
[![\[Noise\]](hextile_emboss_1gs.png)](hextile_emboss_1gs.png)
emboss\_5gs
  
      -blur 0x10 -emboss 5  -fx G  -shade 120x45

[![\[Fractal\]](fractal_emboss_5gs.png)](fractal_emboss_5gs.png)
[![\[Noise\]](noise_emboss_5gs.png)](noise_emboss_5gs.png)
[![\[Noise\]](hextile_emboss_5gs.png)](hextile_emboss_5gs.png)
Edging Transforms
charcoal
  
      -blur 0x2  -charcoal 10 -negate

[![\[Fractal\]](fractal_charcoal.png)](fractal_charcoal.png)
[![\[Noise\]](noise_charcoal.png)](noise_charcoal.png)
[![\[Noise\]](hextile_charcoal.png)](hextile_charcoal.png)
charcoal\_10s
  
      -blur 0x2  -charcoal 10 -negate -shade 120x45

[![\[Fractal\]](fractal_charcoal_10s.png)](fractal_charcoal_10s.png)
[![\[Noise\]](noise_charcoal_10s.png)](noise_charcoal_10s.png)
[![\[Noise\]](hextile_charcoal_10s.png)](hextile_charcoal_10s.png)
charcoal\_1s
  
      -blur 0x2  -charcoal 1  -negate -shade 120x45

[![\[Fractal\]](fractal_charcoal_1s.png)](fractal_charcoal_1s.png)
[![\[Noise\]](noise_charcoal_1s.png)](noise_charcoal_1s.png)
[![\[Noise\]](hextile_charcoal_1s.png)](hextile_charcoal_1s.png)
edges
  
      -blur 0x2  -edge 10

[![\[Fractal\]](fractal_edges.png)](fractal_edges.png)
[![\[Noise\]](noise_edges.png)](noise_edges.png)
[![\[Noise\]](hextile_edges.png)](hextile_edges.png)
edge\_grey
  
      -blur 0x2  -edge 10 -fx G

[![\[Fractal\]](fractal_edge_grey.png)](fractal_edge_grey.png)
[![\[Noise\]](noise_edge_grey.png)](noise_edge_grey.png)
[![\[Noise\]](hextile_edge_grey.png)](hextile_edge_grey.png)
mesas
  
      -blur 0x2  -edge 10 -fx G -shade 120x45

[![\[Fractal\]](fractal_mesas.png)](fractal_mesas.png)
[![\[Noise\]](noise_mesas.png)](noise_mesas.png)
[![\[Noise\]](hextile_mesas.png)](hextile_mesas.png)
Line Generating Transforms
lines
  
      -blur 0x10 -emboss 4 -edge 1

[![\[Fractal\]](fractal_lines.png)](fractal_lines.png)
[![\[Noise\]](noise_lines.png)](noise_lines.png)
[![\[Noise\]](hextile_lines.png)](hextile_lines.png)
loops
  
      -blur 0x10 -edge 15  -edge 1  -blur 0x1

[![\[Fractal\]](fractal_loops.png)](fractal_loops.png)
[![\[Noise\]](noise_loops.png)](noise_loops.png)
[![\[Noise\]](hextile_loops.png)](hextile_loops.png)
engrave\_loops
  
      -blur 0x10 -edge 15  -edge 1  -blur 0x1 -fx R+B+G -shade 280x45

[![\[Fractal\]](fractal_engrave_loops.png)](fractal_engrave_loops.png)
[![\[Noise\]](noise_engrave_loops.png)](noise_engrave_loops.png)
[![\[Noise\]](hextile_engrave_loops.png)](hextile_engrave_loops.png)
engrave\_loop
  
      -blur 0x10 -edge 15  -edge 1  -blur 0x1 -fx G -shade 280x45

[![\[Fractal\]](fractal_engrave_loop.png)](fractal_engrave_loop.png)
[![\[Noise\]](noise_engrave_loop.png)](noise_engrave_loop.png)
[![\[Noise\]](hextile_engrave_loop.png)](hextile_engrave_loop.png)
color\_contours
  
      -blur 0x10 -normalize -fx 'sin(u*4*pi)*100' -edge 1 -blur 0x1

[![\[Fractal\]](fractal_color_contours.png)](fractal_color_contours.png)
[![\[Noise\]](noise_color_contours.png)](noise_color_contours.png)
[![\[Noise\]](hextile_color_contours.png)](hextile_color_contours.png)
contours
  
      -blur 0x10 -normalize -fx 'sin(g*4*pi)*100' \
         -edge 1 -blur 0x1 -shade 280x45

[![\[Fractal\]](fractal_contours.png)](fractal_contours.png)
[![\[Noise\]](noise_contours.png)](noise_contours.png)
[![\[Noise\]](hextile_contours.png)](hextile_contours.png)
Complex Textured Blob Transforms
*(using a strange '`-edge 1`' effect)*
blobs
  
      -blur 0x10 -edge 1

[![\[Fractal\]](fractal_blobs.png)](fractal_blobs.png)
[![\[Noise\]](noise_blobs.png)](noise_blobs.png)
[![\[Noise\]](hextile_blobs.png)](hextile_blobs.png)
blobs\_grey
  
      -blur 0x10 -edge 1 -fx '(R+G+B)/3'

[![\[Fractal\]](fractal_blobs_grey.png)](fractal_blobs_grey.png)
[![\[Noise\]](noise_blobs_grey.png)](noise_blobs_grey.png)
[![\[Noise\]](hextile_blobs_grey.png)](hextile_blobs_grey.png)
pits
  
      -blur 0x10 -edge 1 -fx G -shade 280x45

[![\[Fractal\]](fractal_pits.png)](fractal_pits.png)
[![\[Noise\]](noise_pits.png)](noise_pits.png)
[![\[Noise\]](hextile_pits.png)](hextile_pits.png)
ridges
  
      -blur 0x10 \( +clone -negate \) -edge 1 -fx u.G+v.G -shade 280x45

[![\[Fractal\]](fractal_ridges.png)](fractal_ridges.png)
[![\[Noise\]](noise_ridges.png)](noise_ridges.png)
[![\[Noise\]](hextile_ridges.png)](hextile_ridges.png)
mottled
  
      -blur 0x10 -write mpr:save -negate -edge 1 -negate -fx G \
         \( mpr:save -edge 1 -fx G \) -shade 280x45 -average

[![\[Fractal\]](fractal_mottled.png)](fractal_mottled.png)
[![\[Noise\]](noise_mottled.png)](noise_mottled.png)
[![\[Noise\]](hextile_mottled.png)](hextile_mottled.png)
Paint Transforms
paint\_raw10 *(no post -auto-level)*
  
      -paint 10

[![\[Fractal\]](fractal_paint_raw10.png)](fractal_paint_raw10.png)
[![\[Noise\]](noise_paint_raw10.png)](noise_paint_raw10.png)
[![\[Noise\]](hextile_paint_raw10.png)](hextile_paint_raw10.png)
paint\_areas
  
      -paint 10  -blur 0x5  -paint 10

[![\[Fractal\]](fractal_paint_areas.png)](fractal_paint_areas.png)
[![\[Noise\]](noise_paint_areas.png)](noise_paint_areas.png)
[![\[Noise\]](hextile_paint_areas.png)](hextile_paint_areas.png)
paint\_raw10s
  
      -paint 10  -shade 120x45

[![\[Fractal\]](fractal_paint_raw10s.png)](fractal_paint_raw10s.png)
[![\[Noise\]](noise_paint_raw10s.png)](noise_paint_raw10s.png)
[![\[Noise\]](hextile_paint_raw10s.png)](hextile_paint_raw10s.png)
paint\_8
  
      -blur 0x5  -paint 8

[![\[Fractal\]](fractal_paint_8.png)](fractal_paint_8.png)
[![\[Noise\]](noise_paint_8.png)](noise_paint_8.png)
[![\[Noise\]](hextile_paint_8.png)](hextile_paint_8.png)
paint\_8s
  
      -blur 0x5  -paint 8  -shade 120x45

[![\[Fractal\]](fractal_paint_8s.png)](fractal_paint_8s.png)
[![\[Noise\]](noise_paint_8s.png)](noise_paint_8s.png)
[![\[Noise\]](hextile_paint_8s.png)](hextile_paint_8s.png)
paint\_3
  
      -blur 0x10 -paint 3

[![\[Fractal\]](fractal_paint_3.png)](fractal_paint_3.png)
[![\[Noise\]](noise_paint_3.png)](noise_paint_3.png)
[![\[Noise\]](hextile_paint_3.png)](hextile_paint_3.png)
paint\_3s
  
      -blur 0x10 -paint 3  -shade 120x45

[![\[Fractal\]](fractal_paint_3s.png)](fractal_paint_3s.png)
[![\[Noise\]](noise_paint_3s.png)](noise_paint_3s.png)
[![\[Noise\]](hextile_paint_3s.png)](hextile_paint_3s.png)
paint\_3d
  
      -blur 0x10 -paint 3 \( +clone -shade 120x45 \) \
         +swap  -compose overlay -composite

[![\[Fractal\]](fractal_paint_3d.png)](fractal_paint_3d.png)
[![\[Noise\]](noise_paint_3d.png)](noise_paint_3d.png)
[![\[Noise\]](hextile_paint_3d.png)](hextile_paint_3d.png)
Gradient Transforms
levels *(no post -auto-level)*
  
      -blur 0x12 -fx intensity -normalize \
         -size 1x9 gradient:navy-lavender \
         -interpolate integer -fx 'v.p{0,G*(v.h-1)}'

[![\[Fractal\]](fractal_levels.png)](fractal_levels.png)
[![\[Noise\]](noise_levels.png)](noise_levels.png)
[![\[Noise\]](hextile_levels.png)](hextile_levels.png)
levels\_3d *(no post -auto-level)*
  
      -blur 0x12 -fx intensity -normalize \
         -size 1x9 gradient:navy-lavender \
         -interpolate integer -fx 'v.p{0,G*(v.h-1)}' \
         \( +clone -shade 120x45 -normalize \) \
         -compose overlay -composite

[![\[Fractal\]](fractal_levels_3d.png)](fractal_levels_3d.png)
[![\[Noise\]](noise_levels_3d.png)](noise_levels_3d.png)
[![\[Noise\]](hextile_levels_3d.png)](hextile_levels_3d.png)
zebra
  
      -blur 0x12 -normalize \
         -size 1x19   pattern:gray50   -fx 'v.p{0,G*(v.h-1)}'

[![\[Fractal\]](fractal_zebra.png)](fractal_zebra.png)
[![\[Noise\]](noise_zebra.png)](noise_zebra.png)
[![\[Noise\]](hextile_zebra.png)](hextile_zebra.png)
midlevel
  
      -blur 0x12 -normalize \
         \( -size 1x9 xc: -draw 'color 0,4 point' -negate \) \
         -fx 'v.p{0,G*(v.h-1)}'

[![\[Fractal\]](fractal_midlevel.png)](fractal_midlevel.png)
[![\[Noise\]](noise_midlevel.png)](noise_midlevel.png)
[![\[Noise\]](hextile_midlevel.png)](hextile_midlevel.png)
edged\_level *(no post -auto-level)*
  
      -blur 0x12 -normalize \
         \( -size 1x9 xc: -draw 'color 0,4 point' \) \
         -fx '(.6+.2*v.p{0,G*(v.h-1)})' \
         \( +clone -normalize -edge 1 \)  -fx 'u+v'

[![\[Fractal\]](fractal_edged_level.png)](fractal_edged_level.png)
[![\[Noise\]](noise_edged_level.png)](noise_edged_level.png)
[![\[Noise\]](hextile_edged_level.png)](hextile_edged_level.png)
layered\_levels *(no post -auto-level)*
  
      -blur 0x12 -normalize \
         \( -size 1x9 xc: -draw 'color 0,4 point' \) \
         -fx '(.5+.3*v.p{0,u*(v.h-1)})' \
         \( +clone -normalize -edge .3 -fx 'R+G+B' \) \
         -fx 'intensity+v'  -fill skyblue -tint 100

[![\[Fractal\]](fractal_layered_levels.png)](fractal_layered_levels.png)
[![\[Noise\]](noise_layered_levels.png)](noise_layered_levels.png)
[![\[Noise\]](hextile_layered_levels.png)](hextile_layered_levels.png)
Miscellaneous
filaments
  
      -blur 0x5 -normalize -fx g \
         -sigmoidal-contrast 15x50% -solarize 50%

[![\[Fractal\]](fractal_filaments.png)](fractal_filaments.png)
[![\[Noise\]](noise_filaments.png)](noise_filaments.png)
[![\[Noise\]](hextile_filaments.png)](hextile_filaments.png)
If you have or come up with a nice background generator or image transform, please let me know so it can be added here to share with others.

### Final Important Notes

The two [Random Noise Images](../canvas/#random), being so 'random' are tilable, and we use "`-virtual-pixels`" to ensure that they remain tilable during the transformation. However the [Plasma Image](../canvas/#plasma) is not tilable to start with, so a enlarged version with the edges "`-shave`" off afterward is used to remove the unwanted edge effect of many operations. These technique is discussed further in [Modifying Tile Images](../canvas/#tile_mod).
Note that the final "`-auto_level`" is applied to most images to enhance the contrast of the results, unless the transform is marked as not requiring it so as to preserve and coloring or shadings that resulted from the transformation.
Because many image transformations such as, "`-blur`", "`-emboss`", and "`-edge`" are grey-scale transformations, they work on the three color channels, completely independently of each other. As a result, in many of the images, the result looks like three separate images have been overlaid, then shaded.
The final example "`layered_levels`" was designed to works on each of the three levels simultaneously, while keeping them separate, until the final step where they are added together and color tinted.
This triple effect can be removed by either applying an initial gray-scaling operation, or extracting just one of the channels when finished. Typically I extract the '`green`' or '`G`' channel as it is normally the strongest channel in a grey scale image anyway, though any of the three channels can be used.

------------------------------------------------------------------------

Created: 15 December 2004  
 Updated: 20 December 2006  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/backgrounds/`
