# ImageMagick v6 Examples --  
 ![](../img_www/space.gif) Miscellaneous

**Index**
[![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
[![](../img_www/granitesm_right.gif) Interpolation](#interpolate) (Inter-pixel Color Lookups)
-   [Simple Interpolation Methods](#interpolate_simple)
-   [Bilinear](#bilinear),  [Mesh](#mesh),  [Catrom](#catrom),  [Spline](#spline)
-   [Interpolate on a Background](#interpolate_bgnd)
-   [Interpolate of a Rotated Line](#interpolate_line)
-   [Interpolate of a Rotate Edge](#interpolate_edge)

[![](../img_www/granitesm_right.gif) Virtual Pixels](#virtual-pixel) (Missed-Image Color Lookups)
-   [Edge](#edge),  [Tile](#tile),  [Mirror](#mirror),  [Transparent](#transparent),  [Black](#black),  [Gray](#gray),  [White](#white),  [Background](#background),   
     [HoriziontalTile](#horizontal_tile),  [HoriziontalTileEdge](#horizontal_edge),  [VerticalTile](#vertical_tile),  [VerticalTileEdge](#vertical_edge),   
     [CheckerTile](#checker_tile),  [Random](#random),  [Dither](#dither)
-   [Virtual Pixel and Infinities](#virtual_infinities)
-   [Virtual Pixel Colors](#virtual_colors)
-   [Virtual Pixel Examples](#virtual_examples)
-   [Implosion Effects on Virtual Pixels](#virtual_implode)

[![](../img_www/granitesm_right.gif) Random Spots of Solid Color](#spots)
[![](../img_www/granitesm_right.gif) Annotate Argument Usage](#annotate) ![](../img_www/space.gif)
[![](../img_www/granitesm_right.gif) Splice: Creating a New Image Operator](#splice)
[![](../img_www/granitesm_right.gif) Border, Frame, and the use of BorderColor](#border)
[![](../img_www/granitesm_right.gif) List Operator Testing](#list_test)
This page consists of examples which test various aspects of ImageMagick. But which do not properly fit into the discussions on the other example pages (at least not formally).
Also included on this page are some tables demonstrating the results of versions argument with specific IM operators. However other people have also done this, which unless I have something to add, I will not deal with further.

------------------------------------------------------------------------

## Pixel Interpolation or Inter-pixel Color Lookup

The "`-interpolate`" setting is used when looking up a color in a source image, but that 'lookup point' falls between the pixels of the source image.
This is done in various image operations, such as the "`-fx`" ([DIY Special Effects Operator](../transform/#fx)), and "`-distort`" ([Generalized Image Distortion Operator](../distorts/#distort)), as well as other related operators like the [Circular Distortions](../warping/#circular).
Basically 'interpolation' tells IM how to interpret a [Direct Color Lookup](../distorts/#lookup) from an image, when the point does not exactly match a actual pixel in an image, but falls in the space between pixels.
For example if you look up the color at pixel location `3,4` you should get the exact pixel color. But what should IM return if you looked up the color of an image at the point `3.23,4.75`? Should you get the pixel color at `3,4` or `3,5`? or perhaps some a mix of the surrounding pixels colors, and if so how should the colors be merged together?
***Pixel Interpolation* defines what ImageMagick should do when looking up a single color at a floating point position (in pixel coordinates).**
Interpolation is in some ways similar to pixel resampling, such as provided by [Resampling Filters](../filter/#filter). The essentual difference is that resampling has a 'scale', 'area' or variable 'window' from which a color that represents all the pixels in the area is returned. Interpolation does not have a 'scale' involved, only a single 'point' of lookup, and only a fixed sized 'area' around that point from which to determine the color to use at that point.
Of course most area resampling algorithms tend to devolve to a interpolative method when the area of resampling reaches a minimim working 'window', and this naturally happens when images are being enlarged, or upsampled. This is why [Interpolated Filters](../filter/#interpolated) and [Gaussian Blurring Filters](filter/#gaussian) tend to work better for enlarging images.
Interpolation is basically a lower form of sampling, and is basically used when you want a simple and fast answer to the 'what color' question.
### Simple Interpolation Methods

These are straight forward, simple methods, that try to do as lettl as posible to return a color to use from a 'point interpolation'
The simplest is '**`Nearest`**' and '**`Integer`**', will just pick a single pixel color from the source image, as it without any mixing or other blending effects. This preserves original color values of the image but at a cost of aliasing effects, and typically a less than smooth look to images.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*As of IM v6.7.6-2 you can use '`Nearest`' as a short hand for the '`Nearest-Neighbour`' interpolation setting.*
The two are very similar, only differing in which pixel the lookup coordinate extracts from the source image. Specifically '`Integer`' will simply round down the lookup point to select the pixel, which results in a general translation half a pixel right and downward. It is typically only used in simplified 'scaling' of the source image. On the other hand '`Nearest`' will select the closest pixel to the floating point lookup coordinate, and as such produces a more correct result.
'**`Blend`**' Will blend together (average) the nearest 1, 2 or 4 pixels, depending on their distance from the sampling point. The result is that the original pixel color is still present, but halved in size, while a checkerboard of blended colors fills space between. (see example below)
'**`Average`**', will never actually produce an exact color match, but will always mix the 4 surrounding pixels to produce a local average. This can be useful for color lookup situations. '`Average4`' can also be used an an alias for this interpolation method.
'**`Average9`**' is similar but will average the nearest 9 pixels around the sampling point, producing a blurry result.
'**`Average16`**' will average the nearest 16 pixels around the sampling point, producing an extrememly blurry result.
Here is a summery of the various simple interpolation methods, when enlarging a small group of colored pixels, or a single white pixel. The original image looks like the "Nearest" result, but much smaller.
  
      for method in  integer nearest blend average average9 average16 ; do
        convert \( xc:red xc:blue +append \) \
                \( xc:yellow xc:cyan +append \) -append \
                -bordercolor black -border 1 \
                -filter point -interpolate $method \
                +distort SRT 20,0 ip_color_${method}.jpg
        convert xc: -bordercolor black -border 2 \
                -filter point -interpolate $method \
                +distort SRT 16,0 ip_pixel_${method}.jpg
      done

[![\[IM Output\]](ip_color_integer.jpg)](ip_color_integer.jpg)
[![\[IM Output\]](ip_color_nearest.jpg)](ip_color_nearest.jpg)
[![\[IM Output\]](ip_color_blend.jpg)](ip_color_blend.jpg)
[![\[IM Output\]](ip_color_average.jpg)](ip_color_average.jpg)
[![\[IM Output\]](ip_color_average9.jpg)](ip_color_average9.jpg)
[![\[IM Output\]](ip_color_average16.jpg)](ip_color_average16.jpg)
[![\[IM Output\]](ip_pixel_integer.jpg)](ip_pixel_integer.jpg)
[![\[IM Output\]](ip_pixel_nearest.jpg)](ip_pixel_nearest.jpg)
[![\[IM Output\]](ip_pixel_blend.jpg)](ip_pixel_blend.jpg)
[![\[IM Output\]](ip_pixel_average.jpg)](ip_pixel_average.jpg)
[![\[IM Output\]](ip_pixel_average9.jpg)](ip_pixel_average9.jpg)
[![\[IM Output\]](ip_pixel_average16.jpg)](ip_pixel_average16.jpg)
Integer
Nearest
Blend
Average
Average9
Average16

  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.7.7-6 '`Average`' was actually equivalent to which is now '`Average16`'. The other two averging interpolators as well as '`Blend`', and '`Background`' was added at this time.*
One other simple interpolation method is also provided, '**`Background`**' which simply returns the current background color for any 'sampling' of the source image. In many ways this is rather usless, as typically you will just end up with a blank solid colored image.
Its primary use is as a check of more complex resampling functions, such as a [Resampling Failure](../distorts/#distort_failure), where the EWA resampling filter (typically used from the [General Distortion Operator](../distorts/#distort)) will fall back to a interpolated lookup when resampling fails to find any pixels in its 'support' or resampling area.
By setting interpolation to '`Background`', and setting a background color to something that stands out (like '`red`') you can then look for pixels in the resulting image to see where resampling 'failed' or 'missed all source image pixels' for some reason or another. Typically due to too small a support setting, or from playing with expert filter options.
*FUTURE: Posible future interpolation option of "random" selection over the interpolated area. Could be useful for fancy interpolated effects!*
### Bilinear

'**`Bilinear`**' (or linear interpolation) is the **default interpolation method**, and probably one of the simplest ways of getting a real interpolated result, from combining colors of the pixels around the lookup or sampling point.
Here is a diagram explaining how a bilinear interpolation works.
![\[diagram\]](../img_diagrams/bilinear_interpolation.jpg)

That is to say, it simply connects striaght lines in the orthogonal directions to locate the color of the given sampling point. The result is also equivelent to a [Triangle Resampling Filter](../filter/#triangle), when used with resize.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap  -fx 'v.p{i/(w-1),j/(h-1)}' \
              interpolate_bilinear.jpg

  
[![\[IM Output\]](interpolate_bilinear.jpg)](interpolate_bilinear.jpg)
  
      convert \( xc:white xc:black +append \) \
              \( xc:black xc:white +append \) -append \
              -size 100x100 xc: +swap -fx 'v.p{i/(w-1),j/(h-1)}' \
              interpolate_saddle.jpg

  
[![\[IM Output\]](interpolate_saddle.jpg)](interpolate_saddle.jpg)
This last image shows how a linear gradient is formed along the edges between the four known points, and then a second linear gradient is formed between those edges. That is the colors between the surrounding pixels is generated using a horizontal and vertical linear gradients.
This inturn produces a curved 2 dimensional gradient that is typically known as a 'saddle', in that it is rasied on two oppisite corners and lowered on the other two corners.
You can even use this method to more directly generate a 45 degree angled linear gradient, but requires you to specify the middle color for the diagonally opposite corners.
  
      convert \( xc:blue xc:navy +append \) \
              \( xc:navy xc:black +append \) -append \
              -size 100x100 xc: +swap -fx 'v.p{i/(w-1),j/(h-1)}' \
              interpolate_45linear.jpg

  
[![\[IM Output\]](interpolate_45linear.jpg)](interpolate_45linear.jpg)
The most important aspect of this default interpolation method, is that the very center pixel of the image will always be an average of all four corner colors, with perfect linear gradients at the edges, and exact color matching at the corners.
### Mesh

The "`-interpolate`" setting of '`Mesh`' is a variation of the '`Bilinear`' interpolation. Where as '`Bilinear`' will produce a 3 dimensional curved surface, '`Mesh`' was designed to split the inter-pixel area into two flat triangular surfaces.
The division of the area into two triangles is based on the diagonal with the two 'closest' corner colors.
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
*For details of the '`Mesh`' algorithm, see the paper [Image Interpolation by Pixel-Level Data-Dependent Triangulation](http://www.cs.bath.ac.uk/~pjw/Q3D/forum-ddt.pdf).*
For example lets use the same set of corner colors we used above.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap   -interpolate Mesh \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_tri-mesh.jpg

  
[![\[IM Output\]](interpolate_tri-mesh.jpg)](interpolate_tri-mesh.jpg)
As you can see the '`Mesh`' algorithm produced almost exactly the same set of color interpolations as '`Bilinear`'.
However if we reverse the yellow and cyan colors..
  
      convert \( xc:red xc:blue +append \) \
              \( xc:cyan xc:yellow +append \) -append \
              -size 100x100 xc: +swap   -interpolate Mesh \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_tri-mesh2.jpg

  
[![\[IM Output\]](interpolate_tri-mesh2.jpg)](interpolate_tri-mesh2.jpg)
This time the '`Mesh`' algorithm decided that the '`blue`' and '`cyan`' colors were the two closest corners, and created a linear gradient diagonally between these two corners. The rest of the colors then form a simple flat triangular gradient from this line to the other two corners.
This may seem like a unusual interpolation, but the method ensures that sharp borders, remain quite sharp, when color images are only slightly resized, rotated or sheared. In fact a [Adaptive Resize](../resize/#adaptive-resize) operation ("`-adaptive-resize`") uses this fact for small image resizes to reduce excessive blurring of the result.
For example if we have a single 'white' corner, '`mesh`' assumes that an edge has been found and adjusts the interpolated colors to highlight this edge.
  
      convert \( xc:black xc:black +append \) \
              \( xc:white xc:black +append \) -append \
              -size 100x100 xc: +swap    -interpolate Mesh \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_tri-mesh3.jpg

  
[![\[IM Output\]](interpolate_tri-mesh3.jpg)](interpolate_tri-mesh3.jpg)
Of course if the colors produce reasonably consistent gradient the 'mesh' interpolation also produces a reasonably consistent gradient.
  
      convert \( xc:blue xc:navy +append \) \
              \( xc:black xc:black +append \) -append \
              -size 100x100 xc: +swap    -interpolate Mesh \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_tri-mesh4.jpg

  
[![\[IM Output\]](interpolate_tri-mesh4.jpg)](interpolate_tri-mesh4.jpg)
As you can see the result quite a reasonable gradient, though if you look hard you can see the diagonal join of the two separate triangles. The change isn't as smooth as bi-linear (which isn't exactly smooth either) but these do not try to preserve the sharp edges in resized or distorted images either.
### Catrom (Catmull-Rom)

The "`-interpolate`" setting of '`Catrom`' (generally imprecisely known as '`BiCubic`' interpolation), is more complex, in the determination of the colors of a point lookup. Basically it does not just look at the colors in the corners of the inter-pixel area, but goes further to look at the colors beyond those nearest-neighbour pixels. A total of 16 pixels in a 4x4 area around the sampling point.
Basically it fits a curve to the whole area involved, so as to determine the best overall color to use.
Here is a diagram which probably explains the process better...
![\[diagram\]](../img_diagrams/bicubic_interpolation.jpg)

And here is the interpolated colors for our standard four colors.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap   -interpolate Catrom \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_catrom.jpg

  
[![\[IM Output\]](interpolate_catrom.jpg)](interpolate_catrom.jpg)
The above image may look very similar to a '`Bilinear`' interpolation, however the result has a smoother blending curve rather than straight lines to produce the interpolated color.
What this image does not show however is the effect of the other pixels surrounding our four near neighbours. For that we need to look at a slightly larger area. For this specific (very small) example the surrounding pixels are controled by the [Virtual Pixel](#virtual) setting.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Catrom -virtual-pixel edge \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_catrom_edge.jpg
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Catrom -virtual-pixel White \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_catrom_white.jpg
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Catrom -virtual-pixel Black \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_catrom_black.jpg

[![\[IM Output\]](interpolate_catrom_edge.jpg)](interpolate_catrom_edge.jpg) [![\[IM Output\]](interpolate_catrom_white.jpg)](interpolate_catrom_white.jpg) [![\[IM Output\]](interpolate_catrom_black.jpg)](interpolate_catrom_black.jpg)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*In a real image the effects of the [Virtual Pixels](#virtual) usually only effects results near the very edges of the image. As this image is only 2 pixels wide, the above example is strongly effected. This is not the case in larger more typical images.*
As you can see the curve is strongly influenced by the surrounding colors, resulting in either a very tight sharp color change, or a more blended color change as defined by the surrounding colors.
However you can also see that strong changes in the surrounding pixel colors, can produce a small areas of that colors inverse or negative. This is a [Ringing Artefact](../filter/#ringing) and is typically only seen on extremely sharp edges of complementary colors in a real image.
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
This ringing effect on very very strong color edges can become clipped resulting in a line of horrible pixels. This problem can be prevented by doing resizes and interpolation in a different colorspace than '`RGB`', such as '`Lab`' or '`Luv`' colorspaces.
  
For more information and examples of this problem see [Resizing in LAB colorspace](../resize/#resize_lab).
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
Note that '`BiCubic`' (interpolated [Cubic Filter](../filter/#cubics)), refers to a very large family of filters, and as such is very inexact in its meaning. It is however still available, but its use is depreciated, in favor of more exact names.
  
After IM v6.7.7-7 '`BiCubic`' is simply an alias to '`Catrom`', which is typically regarded as a good 'cubic interpolator' (b=0, c=1/2). You should use the name '`Catrom`' rather than '`BiCubic`' so as to be clear what you are using for interpolation.
  
Before IM v6.7.7-7 '`BiCubic`' actually used an extreme 'Cardinal Cubic' filter (b=0, c=1) which has a overly strong negative ringing effect. This have been completely replaced by '`Catrom`', and is no longer available as a interpolative function.
  
Before IM v6.3.5-3 '`BiCubic`' was implemented as a very blurry '`Spline`' cubic interpolator. That filter was renamed with this version of ImageMagick. (see next)
### Spline

The '`Spline`' interpolation method, like '`Catrom`' above, also uses the nearest 16 pixels. However this is a very blurry, Gaussian-like, interpolation.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap   -interpolate spline \
              -fx 'v.p{i/(w-1),j/(h-1)}'    interpolate_spline.jpg

  
[![\[IM Output\]](interpolate_spline.jpg)](interpolate_spline.jpg)
As you can see the colors in the very corners of the above '`Spline`' interpolation are muted, as the interpolated surface does not actually go through the original color of those pixels. Essentially it is overly 'blurred', and is more correctly known as a 'B-Spline' surface.
The surface is still a type of [Cubic Filter](../filter/#cubics) (b=1, c=0) as it generated using a technique of a piece-wise cubic curves. However this curve only approaches the original pixel colors, especially in areas of strong color changes.
That is a interpolated lookup of an exact integer pixel position, will not return that actual pixels color, but a blurring of the color with the surrounding pixels. This is often thought of as bad, but can be used as a general smoothing function.
Like '`Catrom`' it is also effected by the surrounding pixels.
  
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Spline -virtual-pixel edge \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_spline_edge.jpg
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Spline -virtual-pixel White \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_spline_white.jpg
      convert \( xc:red xc:blue +append \) \
              \( xc:yellow xc:cyan +append \) -append \
              -size 100x100 xc: +swap -interpolate Spline -virtual-pixel Black \
              -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}'   interpolate_spline_black.jpg

[![\[IM Output\]](interpolate_spline_edge.jpg)](interpolate_spline_edge.jpg) [![\[IM Output\]](interpolate_spline_white.jpg)](interpolate_spline_white.jpg) [![\[IM Output\]](interpolate_spline_black.jpg)](interpolate_spline_black.jpg)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*In a real image the effects of the [Virtual Pixels](#virtual) is only at the edges of the image. With real pixels surrounding the inter-pixel area from which the lookup is being made.*
Here you can see the effects of the color muting that results from the badly fitting 'spline' curves to the pixel colors. The results is generally fuzzier edges to colored areas, and thin lines. However they also will never exhibit any negative 'ringing' effect that you may get with a '`Catrom`' interpolation.
### Interpolation Background

As the effects of interpolation are often over larger areas, here is an enlargement of the four main interpolation methods with white or black surrounding pixels.
  
      for method in   bilinear mesh catrom spline  ; do
        for vpixel in   white black  ; do
          convert \( xc:red xc:blue +append \) \
                  \( xc:yellow xc:cyan +append \) -append \
             -size 100x100 xc: +swap -interpolate $method -virtual-pixel $vpixel \
             -fx 'v.p{3*i/(w-1)-1, 3*j/(h-1)-1}' ip_area_${method}_$vpixel.jpg
        done
      done

[![\[IM Output\]](ip_area_bilinear_white.jpg)](ip_area_bilinear_white.jpg)
[![\[IM Output\]](ip_area_mesh_white.jpg)](ip_area_mesh_white.jpg)
[![\[IM Output\]](ip_area_catrom_white.jpg)](ip_area_catrom_white.jpg)
[![\[IM Output\]](ip_area_spline_white.jpg)](ip_area_spline_white.jpg)
[![\[IM Output\]](ip_area_bilinear_black.jpg)](ip_area_bilinear_black.jpg)
[![\[IM Output\]](ip_area_mesh_black.jpg)](ip_area_mesh_black.jpg)
[![\[IM Output\]](ip_area_catrom_black.jpg)](ip_area_catrom_black.jpg)
[![\[IM Output\]](ip_area_spline_black.jpg)](ip_area_spline_black.jpg)
Bilinear
Mesh
Catrom
Spline

As you can see the surrounding background color has no real effect for '`bilinear`' interpolated colors. It looks like it is just overlaid onto whatever background color is present.
You can however see how '`mesh`' generates stronger sharper edges, but can decide to flip the diagonal depending on the surrounding color, when it is involved at the image edges. Look at the join between red and blue, between the white and black backgrounds to see this 'flip'.
The interpolated curve for '`catrom`' and '`spline`' is effected by the surrounding pixels. Particularly in the test cases involving absolute colors.
And finally '`spline`' interpolation is really just gussian-like blurring of the image (using a sigma of 0.65). Enough blurring to eliminate any 'ringing' or aliasing effect, though typically it is too blurry for most uses. See [Gaussian Filters](../filter/#gaussian).
### Interpolation of a Rotated Line

Here I demonstrate the various interpolation methods by creating an image of a vertical line, and using a affine distortion to rotate the line by 17 degrees, then enlarging the view so you can see the anti-aliasing pixels generated.
  
      convert -size 10x20 xc: -draw 'line 4,0 4,20' \
              -scale 50x100 ip_line_none.gif
      for method in integer nearest bilinear mesh catrom spline;  do
        convert -size 10x20 xc: -draw 'line 5,0 5,20' \
                -interpolate $method -filter point -distort SRT 17 \
                -scale 50x100 ip_line_${method}.gif
      done

As you can see the direct color lookup methods '`Interger`' and '`NearestNeighbor`' produces a highly aliased result, but only use the original colors found in the image. The main difference between the two is that '`Interger`' tends to push the resulting image down and left by half a pixel.
The '`Bilinear`', '`Mesh`' and '`Catrom`' generally produce very good and simular results (more on that later), with the latter producing a very sharp rotated line. Any of these is generally regarded as a good solution.
The '`Spline`' interpolation methods, produces a distinct blurring of thin lines, so as to remove aliasing effects. However '`Spline`' tends to over blur the results, and really more suited to smoothing gradients, rather than rotated lines.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The special setting "`-filter point`" is in the above example is used to ensure that [Distort Operator](../distort/#distort) only uses single 'point' interpolation in determining the final pixel color. Without it an [Area Resampling](../distorts/#area_resample) be used instead of [Interpolated Lookup](../distorts/#lookup), though that also produces very good results.*
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
Note that I did not use the "`-rotate`" operator for these examples, as that operator uses a Pixel Shearing method to [Rotate](../warping/#rotate) Images. As a result pixel interpolation is not used.
  
See [Rotating a Thin Line](../warping/#rotate_line) for an example of using the `-rotate`" operator in this way, and the resulting pixel level effects.
  
Update: As of IMv6.7.3-4 the rotate operator is now internally using [Distort Operator](../distort/#distort), so the above many no longer be true.
### Interpolation of a Rotated Edge

The results have a slight difference when the edge of an area is being distorted, compared to that of a single line of pixels.
  
      convert -size 10x20 xc: -draw 'rectangle 0,0 4,19' \
              -scale 50x100 ip_edge_none.gif
      for method in  integer nearest bilinear mesh catrom spline; do
        convert -size 10x20 xc: -draw 'rectangle 0,0 4,19' \
                -interpolate $method -filter point  -distort SRT -17 \
                -scale 50x100 ip_edge_${method}.gif
      done

The above generally speaks for itself. '`Bilinear`' and '`Mesh`' produce reasonably sharp edges for general rotates, while '`Catrom`' will produce a sharper edge in the distorted image. '`Spline`' however will produce fuzzier edges.
The difference between '`Bilinear`' and '`Mesh`' is extremely minor in the above cases. The two methods only really generate visible differences in cases of extreme enlargement during the distortion operation. Otherwise you will only see slight barely noticeable changes in pixel intensity.
  

------------------------------------------------------------------------

## Virtual Pixels Missed Image Color Lookup

Many operators often need to look-up colors which fall outside the boundaries of the image proper. This includes the operators for [Blurring Images](../blur/#blur), [General Image Distortion](../distorts/#distort), [Morphological and Convolution Operators](../morphology/), the [General Distortion Operator](../distorts/#distort), and even the very old [Implosion Operator](../warping/#implode).
So what color should be returned if you ask for a pixel at `-22,-3`? Such a pixel does not actually exist, but the color value returned can have far reaching effects on the overall effect on your image processing, especially the resulting colors of pixels close to the actual edge of the image.
The "`-virtual-pixel`" setting defines what IM should return when accessing a pixel outside the normal bounds of the image.
[![\[IM Output\]](tree.gif)](tree.gif) For example, here we use the [FX DIY Operator](../transform/#fx) "`-fx`" to 'lookup' and display all the pixels in and surrounding the small image so we can see what the **default** "`-virtual-pixel`" setting returned.
  
      convert -size 70x70 xc:  tree.gif \
                      -fx 'v.p[-19,-19]'  virtual_default.gif

  
[![\[IM Output\]](virtual_default.gif)](virtual_default.gif)
'**`Edge`**' "`-virtual-pixel`" setting return the color of the the closest real pixel to the 'virtual' location requested. That is theneaered 'edge' color.
This time I'll use a faster [Image Distortion with viewport](../distorts/#distort_viewport) to show the surrounding virtual pixels, instead of the much slower [FX Operator](../transform/#fx). The distort method "SRT 0" does not actually distort the image result, it just looks at what pixels the image operator actual sees, especially the 'virtual' ones surrounding the source image.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Edge -filter point   -distort SRT 0 \
              +repage  virtual_edge.gif

  
[![\[IM Output\]](virtual_edge.gif)](virtual_edge.gif)
An '`Edge`' virtual pixel setting is the default setting, so the above should be the same as the previous example.
This setting generally has the most minimal impact (in terms of edge effects) when processing images. Which is also why it was chosen as the default setting. This is especially important when using [Blur](../blur/#blur), or other [Morphological and Convolution](../morphology/) operators that use a 'neighbourhood' or pixels for processing.
It is important to note how the color of the corner pixel, will end up completely filling the diagonally adjacent areas surrounding the actual image. This can result in the single corner pixel having a large effect on various image transformations. This 'corner' effect is especially noticeable when blurring images.
'**`Tile`**' VP setting is very useful for generating and ensuring the image processing edge effects are wrapped around the boundaries of the image.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Tile  -filter point  -distort SRT 0 \
              +repage virtual_tile.gif

  
[![\[IM Output\]](virtual_tile.gif)](virtual_tile.gif)
This lets you ensure that images being worked on remain 'tileable', or become more 'tileable' as the image is modified. For further examples see [Modifying Tile Images](../canvas/#tile_mod).
'**`Mirror`**' is very similar to '`tile`' and may be better for some effects that the default '`edge`'.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Mirror -filter point   -distort SRT 0 \
              +repage virtual_mirror.gif

  
[![\[IM Output\]](virtual_mirror.gif)](virtual_mirror.gif)
This is particularly useful to reduce the edge and corner effect of images that are being blurred. However it can also generate other effects.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
Up until IM v6.5.0-1 only the images directly attached to the original image was mirrored. Other virtual copies, further away from the original remained un-mirrored (normal tile pattern). This was fixed so the whole virtual canvas space is now correctly mirror tiled, not just the neighbouring virtual copies.
  
It only becomes important when using mirror tile with [General Distortion Operator](../distorts/#distort) to mirror tile a very large area, such as when [Viewing Distant Horizons](../distorts/#horizon)
'**`Transparent`**' just returns the transparent color for pixels outside the real image bounds.
  
      convert tree.gif -alpha set  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Transparent  -filter point  -distort SRT 0 \
              +repage virtual_trans.gif

  
[![\[IM Output\]](virtual_trans.gif)](virtual_trans.gif)
The [Alpha 'set' Operator](../basics/#alpha) in the above is required to ensure the image has a matte or alpha channel for the transparent color to fill in correctly. Without this setting the above could return a 'black' color instead of transparent, as the color '`none`' or 'fully-transparent black' is the default transparent color.
For example here I mistakenly turn off transparency...
  
      convert tree.gif  -alpha off  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Transparent -filter point  -distort SRT 0 \
              +repage virtual_trans2.gif

  
[![\[IM Output\]](virtual_trans2.gif)](virtual_trans2.gif)
The '`Transparent`' setting is particularly useful for image distortions, where the distorted image will later be 'layered' to build up larger images. For example, [3d Affine Cubes](../distorts/#cube3d), and [3d Perspective Boxes](../distorts/#cube3d).
The '**`white`**', '**`gray`**', and '**`black`**', settings are similar to the previous '`Transparent`' setting above. They just return that specific color for any pixel that falls out of bounds.
  
      convert tree.gif  -alpha off  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel White -filter point  -distort SRT 0 \
              +repage virtual_white.gif

  
[![\[IM Output\]](virtual_white.gif)](virtual_white.gif)
  
      convert tree.gif  -alpha off  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Gray -filter point  -distort SRT 0 \
              +repage virtual_gray.gif

  
[![\[IM Output\]](virtual_gray.gif)](virtual_gray.gif)
  
      convert tree.gif  -alpha off  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Black -filter point  -distort SRT 0 \
              +repage virtual_black.gif

  
[![\[IM Output\]](virtual_black.gif)](virtual_black.gif)
If you want any other simple color , then you must define that color in the "`-background`" setting, and use a '**`Background`**' "`-virtual-pixel`" setting.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Background -background coral \
              -filter point -distort SRT 0     +repage virtual_bgnd.gif

  
[![\[IM Output\]](virtual_bgnd.gif)](virtual_bgnd.gif)
  
 '**`HorizontalTile`**' VP setting was added to IM v6.4.2-6 as a special form of tiling that is useful for full 360 degree "`Arc`" and "`Polar`" distortions. The image is only tiled horizontally, while the virtual pixels above and below the tiles are set from the current "`-background`" color.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel HorizontalTile  -background coral \
              -filter point -distort SRT 0     +repage virtual_horizontal.gif

  
[![\[IM Output\]](virtual_horizontal.gif)](virtual_horizontal.gif)
This lets you ensure that images being transformed remain 'tileable' horizontally. For further examples see [Modifying Tile Images](../canvas/#tile_mod).
The '**`HorizontalTileEdge`**' (added in IM v6.5.0-1) also tiles the image horizontally across the virtual space, but replicates the side edge pixels across the other parts of the virtual canvas space.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel HorizontalTileEdge  -background coral \
              -filter point -distort SRT 0     +repage virtual_horizontal_edge.gif

  
[![\[IM Output\]](virtual_horizontal_edge.gif)](virtual_horizontal_edge.gif)
These two VP methods were added for better handling of full circle '`Arc`' and '`Polar`' distortions where the en-circled image 'wraps around' and joins together end to end.
  
 Simularly the '**`VerticalTile`**' VP setting (also added IM v6.4.2-6, for completeness) as a tiles the image vertially only, with the current "`-background`" color used to fill in the sides of the image.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel VerticalTile  -background coral \
              -filter point -distort SRT 0     +repage virtual_vertical.gif

  
[![\[IM Output\]](virtual_vertical.gif)](virtual_vertical.gif)
The '**`VerticalTileEdge`**' was added in IM v6.5.0-1, and replicates the side edge pixels across the rest of the virtual canvas space.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel VerticalTileEdge  -background coral \
              -filter point -distort SRT 0     +repage virtual_vertical_edge.gif

  
[![\[IM Output\]](virtual_vertical_edge.gif)](virtual_vertical_edge.gif)
In IM v6.5.0-1 '**`CheckerTile`**' was added to tile an image as if filling in a checkerboard pattern. The other squares are simply filled with the background color (which may be transparent).
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel CheckerTile  -background coral \
              -filter point -distort SRT 0     +repage virtual_checker.gif

  
[![\[IM Output\]](virtual_checker.gif)](virtual_checker.gif)
By making background transparent and overlaying that image over a another fully-tiled image same size you can layer the two tilings to produce an interleaved checkerboard pattern of the two images.
  
      convert -size 96x96 tile:balloon.gif \
              \( tree.gif -alpha set  -set option:distort:viewport 96x96 \
                 -virtual-pixel CheckerTile  -background none \
                 -filter point -distort SRT 0 \) \
              -flatten  virtual_checker_2.gif

  
[![\[IM Output\]](virtual_checker_2.gif)](virtual_checker_2.gif)
  
 There also a couple of more unusual "`-virtual-pixel`" settings.
'**`random`**', just picks a random pixel from the image to use.
  
      convert tree.gif  -set option:distort:viewport 70x70-19-19 \
              -virtual-pixel Random -filter point   -distort SRT 0 \
              +repage virtual_random.gif

  
[![\[IM Output\]](virtual_random.gif)](virtual_random.gif)
This is often used with "`-blur`" to generate rough mottled average image color in the resulting edge effects it produces.
Note that the pixel value is not consistant, and will produce a different effect for each lookup, and even each run of the operation (unless the random number generator is given a "`-seed`" to initialize the randmon number generator.
This is especially bad when used with [Convolution](../convolve) or [Morphology](../morphology) image processing, as the each lookup along the edge of the image will contribute a different value even though the same pixel lookup was used.
I have however found the random pattern to be very good when generating a [Perspective Horizion](../distorts/#horizon) as the pattern shows a more blurred result as you get closer to the horizon. The bluring gives the random pattern depth that would otherwise not be visible if using a simple solid color.
  
 '**`dither`**' however returns a ordered dithered pattern of colors basied on pixels within 32x32 pixels of the requested position.
  
That means that once you have progressed beyond 32 pixels from the image, the result will be again just the corner pixel color of the image. It is a bit like a merger of '`edge`' and '`random`'.
  
To show this we need to show the image on a larger virtual canvas.
  
      convert tree.gif  -set option:distort:viewport 120x120-44-44 \
              -virtual-pixel Dither -filter point  -distort SRT 0 \
              +repage virtual_dither.gif

  
[![\[IM Output\]](virtual_dither.gif)](virtual_dither.gif)
In the above you can see that the yellow from the sun in one corner of this 32x32 pixel image manages to be selected all the way up the far lower-right corner, but no further. That is the limit of the 32 pixel 'neighbourhood' for the ordered dither color selection. If this image was larger, the yellow sun color would not reach the other corners.
This pattern is not 'random' and will always generate the same result for the same image. You could think of it as a more ordered form of '`random`' VP close into the image, but becomes more like '`edge`' like in effect once you process further than 32 pixels from the image proper.
  
#### Virtual Pixel and Infinities

You can see the effects of "`-virtual-pixel`" much more clearly in the results the [General Distortion Operator](../distorts/#distort), and especially with a [Perspective](../distorts/#perspective) distortion, allowing you to create a distorted view out toward an infinite distance.
For example here I show the results of a "`-virtual-pixel dither`" settings, on a perspective view of the tree. This shows how this setting can effect the pixels returned all the way out to infinity.
  
      convert tree.gif -mattecolor DodgerBlue   -virtual-pixel dither \
              -set option:distort:viewport  150x100-50-50 \
              -distort perspective '0,0 9,0  31,0 38,0  0,31 0,18  31,31, 40,18' \
              perspective_dither.gif

[![\[IM Output\]](perspective_dither.gif)](perspective_dither.gif)

Try the above with other "`-virtual-pixel`" settings to get a better idea of how they work. Some other examples can also be seen in [Viewing Distant Horizons](../distorts/#horizon).
Note that the 'sky' in the above view is actually generated from the "`-mattecolor`" setting, which is used by distort to prepresent areas that are 'Invalid', in this case the 'sky' of a perspective distortion. It did not come from the "`-virtual-pixel`" setting.
#### Virtual Pixel Colors

None of the "`-virtual-pixel`" methods actually return a different or composite color to what is already present within the image, unless that color was specifically requested via one of the solid color methods: '`background`', '`transparent`', '`background`', '`black`', '`white`', '`gray`'; That is no new colors are ever generated, though one specific color could be added (two for the [General Distortion Operator](../distorts/#distort)).
Of course if the requested pixels are being [Pixel Interpolated](#interpolate), or [Area Resampled](../distorts/#area_resample), such as in the perspective distorted view above, then those methods may merge the colors returned according ot the "`-virtual-pixel`" setting chosen.
#### Virtual Pixel Effects on Operators

Here I explore the effects of the effects of "`-virtual-pixel`" setting with various operators.
"`-blur`"...
  
      convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
              -virtual-pixel edge   -blur 0x8     vp_blur.png

  
[![\[IM Output\]](vp_blur.png)](vp_blur.png)
  
        convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
                -virtual-pixel mirror  -blur 0x8  vp_blur_2.png

  
[![\[IM Output\]](vp_blur_2.png)](vp_blur_2.png)
Note in the following how the image can be cross contaminated using "`-blur`" with the "`-virtual-pixel`" setting of '`tile`'. Of course if the image was tilable to start with this may be desired.
  
      convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
              -virtual-pixel tile  -blur 0x8  vp_blur_3.png

  
[![\[IM Output\]](vp_blur_3.png)](vp_blur_3.png)
Setting a specific color for the "`-virtual-pixel`" in the image has some very interesting effects and posibilities.
  
      convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
              -virtual-pixel background  -background blue \
              -blur 0x8     vp_blur_4.png

  
[![\[IM Output\]](vp_blur_4.png)](vp_blur_4.png)
  
      convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
              -virtual-pixel transparent  -channel RGBA  -blur 0x8 \
              -background red  -flatten       vp_blur_5.png

  
[![\[IM Output\]](vp_blur_5.png)](vp_blur_5.png)
Note how the '`red`' background I placed behind the image is visible around the edges where the resulting blurred image has made use of the virtual pixels that surround the real pixels of the image.
"`-gaussian`" has the same basic results as "`-blur`", which is understandable as they are mathematically identical.
  
      convert -size 70x70 xc:lightblue  -fill black -draw 'circle 35,65 25,55' \
              -virtual-pixel background   -background blue \
              -gaussian 0x8     vp_gaussian.png

  
[![\[IM Output\]](vp_gaussian.png)](vp_gaussian.png)
However "`-radial-blur`" (really a rotational blur), produces more interesting border effects...
  
      convert -size 70x70 xc:lightblue \
         -virtual-pixel background  -background blue \
         -radial-blur 0x30    vp_radial.png

  
[![\[IM Output\]](vp_radial.png)](vp_radial.png)
This last with the default 'transparent edge' will probably generate a smooth edge, when used with larger radial blur angles. It may produce a cleaner 'vignette' or soft edging overlay image, than other techniques. See [Soft and Blurred Edges](../thumbnails/#soft_edges) for examples of using this effect.
Note that "`-motion-blur`" can be very badly effected by edge effects.
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*It is made worse by the fact that "`-motion-blur`" does not current understand the use of "`-channel`" for limited its effects to specific channels.*
  
      convert -size 70x70 xc:none  -virtual-pixel edge \
         -fill yellow  -stroke red  -strokewidth 3 -draw 'circle 45,55 35,45' \
         -channel RGBA -motion-blur 0x12+65  vp_motion.png

  
[![\[IM Output\]](vp_motion.png)](vp_motion.png)
  
      convert -size 70x70 xc:none  -virtual-pixel transparent  \
         -fill yellow  -stroke red  -strokewidth 3  -draw 'circle 45,55 35,45' \
         -channel RGBA -motion-blur 0x12+65  vp_motion_2.png

  
[![\[IM Output\]](vp_motion_2.png)](vp_motion_2.png)
  
      convert -size 70x70 xc:none  -virtual-pixel background -background blue \
         -fill yellow  -stroke red  -strokewidth 3  -draw 'circle 45,55 35,45' \
         -channel RGBA -motion-blur 0x12+65  vp_motion_3.png

  
[![\[IM Output\]](vp_motion_3.png)](vp_motion_3.png)
### Implosion Effects of Virtual Pixels

Here are some more interesting examples of various large value (&gt;1.0) implosions using various "[`-virtual-pixel`](../option_link.cgi?virtual-pixel)" settings.
  
      for v in edge tile mirror dither random gray; do
        for i in 2 5 10 50 500; do \
          convert koala.gif -virtual-pixel $v \
                  -implode $i  implode_${v}_${i}.gif
        done
      done

Implode
Edge
Tile
Mirror
Dither
Random
Gray
2
[![\[IM Output\]](implode_edge_2.gif)](implode_edge_2.gif)
[![\[IM Output\]](implode_tile_2.gif)](implode_tile_2.gif)
[![\[IM Output\]](implode_mirror_2.gif)](implode_mirror_2.gif)
[![\[IM Output\]](implode_dither_2.gif)](implode_dither_2.gif)
[![\[IM Output\]](implode_random_2.gif)](implode_random_2.gif)
[![\[IM Output\]](implode_gray_2.gif)](implode_gray_2.gif)
5
[![\[IM Output\]](implode_edge_5.gif)](implode_edge_5.gif)
[![\[IM Output\]](implode_tile_5.gif)](implode_tile_5.gif)
[![\[IM Output\]](implode_mirror_5.gif)](implode_mirror_5.gif)
[![\[IM Output\]](implode_dither_5.gif)](implode_dither_5.gif)
[![\[IM Output\]](implode_random_5.gif)](implode_random_5.gif)
[![\[IM Output\]](implode_gray_5.gif)](implode_gray_5.gif)
10
[![\[IM Output\]](implode_edge_10.gif)](implode_edge_10.gif)
[![\[IM Output\]](implode_tile_10.gif)](implode_tile_10.gif)
[![\[IM Output\]](implode_mirror_10.gif)](implode_mirror_10.gif)
[![\[IM Output\]](implode_dither_10.gif)](implode_dither_10.gif)
[![\[IM Output\]](implode_random_10.gif)](implode_random_10.gif)
[![\[IM Output\]](implode_gray_10.gif)](implode_gray_10.gif)
50
[![\[IM Output\]](implode_edge_50.gif)](implode_edge_50.gif)
[![\[IM Output\]](implode_tile_50.gif)](implode_tile_50.gif)
[![\[IM Output\]](implode_mirror_50.gif)](implode_mirror_50.gif)
[![\[IM Output\]](implode_dither_50.gif)](implode_dither_50.gif)
[![\[IM Output\]](implode_random_50.gif)](implode_random_50.gif)
[![\[IM Output\]](implode_gray_50.gif)](implode_gray_50.gif)
500
[![\[IM Output\]](implode_edge_500.gif)](implode_edge_500.gif)
[![\[IM Output\]](implode_tile_500.gif)](implode_tile_500.gif)
[![\[IM Output\]](implode_mirror_500.gif)](implode_mirror_500.gif)
[![\[IM Output\]](implode_dither_500.gif)](implode_dither_500.gif)
[![\[IM Output\]](implode_random_500.gif)](implode_random_500.gif)
[![\[IM Output\]](implode_gray_500.gif)](implode_gray_500.gif)

The 'dotty' nature of the above results is a direct result of the direct 'interpolated sampling' used by the "[`-implode`](../option_link.cgi?implode)" operator. See [Direct Interpolated Lookup](../distorts/#lookup). This may change in a future version of IM, using [Area Resampling](../distorts/#area_resample). For now you will need to use a [Super Sampling](../distorts/#super_sample) technique to improve results.
The '`edge`' setting is the more usual and default setting that is use, to avoid most of the weird effects. The others (exept for '`background`' essentually produce a replicated pattern from the existing pixels in the image, and effects are highly variable.
Also note how the argument requires a expotential increase in size for simular increases in effects.
Also for arguments larger than about 200 a black circle may appear in the center of the resulting image. This is caused by the computers mathematical limit being reached. Using such large values is an effect we do not recommend you use.

------------------------------------------------------------------------

## Random Spots of Solid Color

By blurring a "`plasma:fractal`" canvas, then reducing the colors to very low values you can produce simple images containing random areas of different colors. However the results are highly variable depending on the final number of colors requested and the [Virtual Pixel](#virtual) setting (see above).
I had two choices for the initial random image in this experiment. A [Fractal Plasma Image](../canvas/#plasma_fractal), and a [Random Noise Image](../canvas/#random).
The [Random Image](../canvas/#random) will by its nature produce a image which can (with a 'tile "`-virtual-pixel`" setting) create a better tilable image. Where as the [Plasma Image](../canvas/#plasma_fractal) tends to create rectangular like edges to its spots of color.
On the other hand the [Plasma Image](../canvas/#plasma_fractal) produces fairly nice pastel colored spots, or blobs. While the [Random Image](../canvas/#random) tends to produce horrible shades of mid-tone gray. because of this I chose to use the [Plasma Image](../canvas/#plasma_fractal) for these experiments.
  
      convert -size 80x80 plasma:fractal -normalize   spot_start.gif
      #convert -size 80x80 xc: +noise Random  \
      #        -virtual-pixel tile  -blur 0x5  -normalize  spot_start.gif

      for n in 2 3 4 5; do
        for v in  edge mirror tile white black; do
          convert spot_start.gif -virtual-pixel $v -blur 0x10 \
                  +dither -colors $n  spot${n}_${v}.gif
        done
      done

  
2
  
[![\[IM Output\]](spot2_edge.gif)](spot2_edge.gif)
  
[![\[IM Output\]](spot2_mirror.gif)](spot2_mirror.gif)
  
[![\[IM Output\]](spot2_tile.gif)](spot2_tile.gif)
  
[![\[IM Output\]](spot2_white.gif)](spot2_white.gif)
  
[![\[IM Output\]](spot2_black.gif)](spot2_black.gif)
  
3
  
[![\[IM Output\]](spot3_edge.gif)](spot3_edge.gif)
  
[![\[IM Output\]](spot3_mirror.gif)](spot3_mirror.gif)
  
[![\[IM Output\]](spot3_tile.gif)](spot3_tile.gif)
  
[![\[IM Output\]](spot3_white.gif)](spot3_white.gif)
  
[![\[IM Output\]](spot3_black.gif)](spot3_black.gif)
  
4
  
[![\[IM Output\]](spot4_edge.gif)](spot4_edge.gif)
  
[![\[IM Output\]](spot4_mirror.gif)](spot4_mirror.gif)
  
[![\[IM Output\]](spot4_tile.gif)](spot4_tile.gif)
  
[![\[IM Output\]](spot4_white.gif)](spot4_white.gif)
  
[![\[IM Output\]](spot4_black.gif)](spot4_black.gif)
  
5
  
[![\[IM Output\]](spot5_edge.gif)](spot5_edge.gif)
  
[![\[IM Output\]](spot5_mirror.gif)](spot5_mirror.gif)
  
[![\[IM Output\]](spot5_tile.gif)](spot5_tile.gif)
  
[![\[IM Output\]](spot5_white.gif)](spot5_white.gif)
  
[![\[IM Output\]](spot5_black.gif)](spot5_black.gif)

The first three images has very specific effects on how the color 'spots' interact with the edges of the image. '`Edge`' and '`Mirror`' tends to cause the colors to join the edges at 90 degree angles.
A '`Random`' or '`Dither`' setting has simular but stronger attachments of the color blobs to the edges of the image, though both also introduces some sharp edge effects close to the image edges. A second blur-quantize cycle may be needed to clean up and smooth the edges of the spots.
The '`Tile`' setting tends to allow the spots to wrap around the image. However as the source [Plasma](../canvas/#plasma_fractal) image is not itself tilable, the result is a general color change near the rectangular edge. If the tilable [Random](../canvas/#random) image was used as the source, then the spots of colors would completely disregard the borders of the image.
By using a '`White`' or '`Black`' background virtual-pixel setting, the spots of color tend to be centered in the image proper. How well this 'centering' occurs depends on just how different original random image was relative to the 'background color' used.
The size of the "`-blur`" basically effects the size and smoothness of the blobs. A small blur producing lots of small spots, a large blur, such as we used in the above, producing a single more circular spot of color.
  
 You can also produce a completely different set of colors and interactions by using a different color quantization color space. For example here I repeat the last example (reducing to 5 colors) from above but use some more unusal "`-quantize`" color spaces for color selection. (See [Color Quantization and ColorSpace](../quantize/#quantize))
  
RGB
  
[![\[IM Output\]](spot_RGB_edge.gif)](spot_RGB_edge.gif)
  
[![\[IM Output\]](spot_RGB_mirror.gif)](spot_RGB_mirror.gif)
  
[![\[IM Output\]](spot_RGB_tile.gif)](spot_RGB_tile.gif)
  
[![\[IM Output\]](spot_RGB_white.gif)](spot_RGB_white.gif)
  
[![\[IM Output\]](spot_RGB_black.gif)](spot_RGB_black.gif)
  
YIQ
  
[![\[IM Output\]](spot_YIQ_edge.gif)](spot_YIQ_edge.gif)
  
[![\[IM Output\]](spot_YIQ_mirror.gif)](spot_YIQ_mirror.gif)
  
[![\[IM Output\]](spot_YIQ_tile.gif)](spot_YIQ_tile.gif)
  
[![\[IM Output\]](spot_YIQ_white.gif)](spot_YIQ_white.gif)
  
[![\[IM Output\]](spot_YIQ_black.gif)](spot_YIQ_black.gif)
  
HSL
  
[![\[IM Output\]](spot_HSL_edge.gif)](spot_HSL_edge.gif)
  
[![\[IM Output\]](spot_HSL_mirror.gif)](spot_HSL_mirror.gif)
  
[![\[IM Output\]](spot_HSL_tile.gif)](spot_HSL_tile.gif)
  
[![\[IM Output\]](spot_HSL_white.gif)](spot_HSL_white.gif)
  
[![\[IM Output\]](spot_HSL_black.gif)](spot_HSL_black.gif)
  
XYZ
  
[![\[IM Output\]](spot_XYZ_edge.gif)](spot_XYZ_edge.gif)
  
[![\[IM Output\]](spot_XYZ_mirror.gif)](spot_XYZ_mirror.gif)
  
[![\[IM Output\]](spot_XYZ_tile.gif)](spot_XYZ_tile.gif)
  
[![\[IM Output\]](spot_XYZ_white.gif)](spot_XYZ_white.gif)
  
[![\[IM Output\]](spot_XYZ_black.gif)](spot_XYZ_black.gif)
  
OHTA
  
[![\[IM Output\]](spot_OHTA_edge.gif)](spot_OHTA_edge.gif)
  
[![\[IM Output\]](spot_OHTA_mirror.gif)](spot_OHTA_mirror.gif)
  
[![\[IM Output\]](spot_OHTA_tile.gif)](spot_OHTA_tile.gif)
  
[![\[IM Output\]](spot_OHTA_white.gif)](spot_OHTA_white.gif)
  
[![\[IM Output\]](spot_OHTA_black.gif)](spot_OHTA_black.gif)

Remember all the above images were all generated from the same randomized source image. The different effects you see are the results of different ways reducing the number of colors in the image.
You can see how the "`-virtual-pixel`" setting defining what pixel colors blur sees the areas beyond the image bounds has a strong influence on shapes of the color areas.

------------------------------------------------------------------------

## Annotate Argument Usage

IM Version 6 provided a new command line option for text drawing "`-annotate`" which bypasses the older "`-draw`" method to use the `Annotate()` API directly. This provides some new features to command line users.
For this example I choose Arial Black font, for its straight lettering so that the rotation should be quite clear.
  
        convert -font ArialB -pointsize 24 -gravity center \
                -size 55x55 xc:white -annotate 0x0+0+0 'Text' \
                annotate_source.jpg

  
[![\[IM Output\]](annotate_source.jpg)](annotate_source.jpg)
The format of this option is...
      -annotate {SlewX}x{SlewY}+{X}+{Y} 'Text String' 

The *X* and *Y* offset of the above is the gravity effected position of the annotated text that is to be drawn.
However the *SlewX* and *SlewY* represents a form of rotation. If both of these values are the same then a normal rotation is performed. But if they differ, some very interesting effects can result..
  
[![\[IM Output\]](annotate_montage.jpg)](annotate_montage.jpg)

As you can see some of the arguments resulted in no text being drawn, basically when the text would have been drawn all in a single line. This is to be expected.
However you can see that we can draw the text flipped, flopped, rotated, italicized, in all manner of ways. A most useful image operator.

------------------------------------------------------------------------

## Splice: Creating a New Image Operator

Just after the first release of ImageMagick version 6, a discussion developed in response to a question on the [ImageMagick Mailing List](http://www.imagemagick.org/script/mailing-list.php). The question involved adding extra space (rows and columns) into the middle of an image.
The example below is the complex set of commands that resulted from this discussion, using the heavy magic of IM version 6, and detailed exactly what should be done.
From this example the "`-splice`" operator was created (for details see examples in [Splicing and Chopping Rows and Columns into Images](../crop/#splice)). As such this command line is the defining operations of this new command, and both should work in exactly the same way.
  
      convert rose:  -size 20x10 xc:blue   -background blue \
              \( -clone 0  -crop 40x0 +repage +clone -insert 1 +append \) \
              -swap 0,-1 +delete +repage \
              \( -clone 0  -crop 0x30 +repage +clone -insert 1 -append \) \
              -delete 0 -delete 0 +repage  splice_rose_seq.gif

  
[![\[IM Output\]](splice_rose_seq.gif)](splice_rose_seq.gif)
In the above we split up the rose into lots of vertical slices, then insert a spacing image into that sequence, before appending them all together again. Basically we added a vertical column of pixels into the rose image.
Then replacing our original image with the modified one, we repeated the same operations, but horizontally. A little clean up of working images and we are done.
This example also highlighted to the mailing list the usefulness of the new ordered command line handling and the image sequence operations of version 6 ImageMagick. In older releases of IM, this would have required a large number of separate commands and temporary images to achieve the same result.

------------------------------------------------------------------------

## Border, Frame, and the use of BorderColor

There is a debate, that "`-bordercolor`" should only be used to only add a border to images with the "`-border`" or "`-frame`". That is many users think it should *not* be used to set the background behind images with transparency.
For example, under IM this sets the transparent areas of the star image to the "`-bordercolor`" and completely ignores the "`-background`" color setting.
  
      convert star.gif -bordercolor LimeGreen   -background Gold \
                       -border 10       star_border.gif

  
[![\[IM Output\]](star_border.gif)](star_border.gif)
  
The main reason "`-bordercolor`" is used to set the background of transparenent images is because this makes "`montage`" come out in a nice way when given a random set of images which could contain transparencies, with minimal settings from the user.
  
        montage star.gif  -frame 6  -geometry '64x64+5+5>' star_montage.gif

  
[![\[IM Output\]](star_montage.gif)](star_montage.gif)
If the transparency was preserved then the "`montage`" results above would not look nearly as good.
  
That does not mean that you can't preserve the transparency of images when using "`-border`" or "`-frame`" operators. It just means you need to supply a extra "`-compose`" setting to tell IM to preserve the transparency.
  
      convert star.gif  -bordercolor LimeGreen \
              -compose Copy  -border 10   star_border_copy.gif
      montage star.gif  -bordercolor LimeGreen \
              -compose Copy -background None    -frame 6 \
              -geometry '64x64+0+0>'   star_montage_copy.gif

  
[![\[IM Output\]](star_border_copy.gif)](star_border_copy.gif)  
 [![\[IM Output\]](star_montage_copy.gif)](star_montage_copy.gif)
For more information on preserving a images transparent background, while adding a "`-border`" or "`-frame`", see [adding borders](../crop/#border). and for "`montage`", see [montage background and transparency handling examples](../montage/#bg).
One alturnative that has been suggested was to set image area background in these operators to the "`-background`" color, but this will interfer with its use in "`montage`".
You can of course always [Remove the Transparency](../masking/#remove) of the image yourself, before any extra frame or border is added. In that case the use of "`-compose Copy`" becomes irrelevent.
  
      montage star.gif -background Gold -alpha remove \
              -frame 6  -geometry '64x64+5+5>' -size 16x16 \
              -bordercolor LimeGreen  -background SeaGreen \
              star_montage_texture.gif

  
[![\[IM Output\]](star_montage_texture.gif)](star_montage_texture.gif)
It is just a lot easier to use a "`-compose`" setting, to preserve the transparency, rather that have border preserve it and cause other problems. It may not be obvious to new users, but then that is what these example pages are all about.

------------------------------------------------------------------------

## List Operator Testing

All the following commands should produce exactly the same image, but all images are produced in slightly different ways, demonstrating the new, IM version 6, [Image List Operators](../basics/#image_list).
  
      convert eye.gif news.gif  storm.gif  +append  list_test_01.gif

[![\[IM Output\]](list_test_01.gif)](list_test_01.gif)
  
      convert \( \) eye.gif news.gif  storm.gif  +append  list_test_02.gif

[![\[IM Output\]](list_test_02.gif)](list_test_02.gif)
  
      convert eye.gif news.gif  storm.gif \( \) +append  list_test_03.gif

[![\[IM Output\]](list_test_03.gif)](list_test_03.gif)
  
      convert \( eye.gif news.gif  storm.gif \) +append  list_test_04.gif

[![\[IM Output\]](list_test_04.gif)](list_test_04.gif)
  
      convert \( eye.gif news.gif  storm.gif  +append \) list_test_05.gif

[![\[IM Output\]](list_test_05.gif)](list_test_05.gif)
  
      convert eye.gif \( news.gif storm.gif +append \) +append list_test_06.gif

[![\[IM Output\]](list_test_06.gif)](list_test_06.gif)
  
      convert \( eye.gif news.gif +append \) storm.gif +append  list_test_07.gif

[![\[IM Output\]](list_test_07.gif)](list_test_07.gif)
  
      convert \( storm.gif -flop \) \( news.gif -flop \) \( eye.gif -flop \) \
              +append -flop  list_test_08.gif

[![\[IM Output\]](list_test_08.gif)](list_test_08.gif)
  
      convert \( eye.gif -rotate 90 \) \( news.gif  -rotate 90 \) \
              \( storm.gif -rotate 90 \) -append  -rotate -90   list_test_09.gif

[![\[IM Output\]](list_test_09.gif)](list_test_09.gif)
  
      convert eye.gif tree.gif news.gif storm.gif   -delete 1 \
              +append list_test_10.gif

[![\[IM Output\]](list_test_10.gif)](list_test_10.gif)
  
      convert eye.gif tree.gif news.gif storm.gif  -delete -3 \
              +append list_test_11.gif

[![\[IM Output\]](list_test_11.gif)](list_test_11.gif)
  
      convert eye.gif news.gif storm.gif tree.gif   +delete \
              +append list_test_12.gif

[![\[IM Output\]](list_test_12.gif)](list_test_12.gif)
  
      convert news.gif storm.gif eye.gif  +insert  +append list_test_13.gif

[![\[IM Output\]](list_test_13.gif)](list_test_13.gif)
  
      convert eye.gif storm.gif news.gif  -insert 1  +append list_test_14.gif

[![\[IM Output\]](list_test_14.gif)](list_test_14.gif)
  
      convert news.gif eye.gif storm.gif   -swap 0,1  +append list_test_15.gif

[![\[IM Output\]](list_test_15.gif)](list_test_15.gif)
  
      convert storm.gif news.gif eye.gif   -swap 0  +append list_test_16.gif

[![\[IM Output\]](list_test_16.gif)](list_test_16.gif)
  
      convert eye.gif storm.gif news.gif   +swap  +append list_test_17.gif

[![\[IM Output\]](list_test_17.gif)](list_test_17.gif)
  
      convert eye.gif storm.gif news.gif   \( -clone 1 \) \
              -delete 1   +append list_test_18.gif

[![\[IM Output\]](list_test_18.gif)](list_test_18.gif)
  
      convert eye.gif -negate \( +clone -negate \) news.gif  storm.gif \
              -delete 0   +append list_test_19.gif

[![\[IM Output\]](list_test_19.gif)](list_test_19.gif)
  
      convert storm.gif news.gif eye.gif \( -clone 2,1,0 \) \
              -delete 2,1,0   +append  list_test_20.gif

[![\[IM Output\]](list_test_20.gif)](list_test_20.gif)
  
      convert storm.gif news.gif eye.gif \( -clone 2-0 \) \
              -delete 0-2   +append  list_test_21.gif

[![\[IM Output\]](list_test_21.gif)](list_test_21.gif)
  
      convert {balloon,medical,present,shading}.gif  -delete 0--1 \
              {eye,news,storm}.gif   +append  list_test_22.gif

[![\[IM Output\]](list_test_22.gif)](list_test_22.gif)
  
      convert balloon.gif -delete 0,0,0,0,0,0,0,0,0 \
              eye.gif news.gif  storm.gif  +append  list_test_23.gif

[![\[IM Output\]](list_test_23.gif)](list_test_23.gif)
  
      convert eye.gif balloon.gif news.gif storm.gif \
              -delete 1,1,1,1,1   +append  list_test_24.gif

[![\[IM Output\]](list_test_24.gif)](list_test_24.gif)
  
      convert {balloon,medical,present,shading}.gif {eye,news,storm}.gif \
              -delete 0--4   +append   list_test_25.gif

[![\[IM Output\]](list_test_25.gif)](list_test_25.gif)
  
      convert eye.gif news.gif storm.gif \
              -delete 0--4   +append   list_test_26.gif

[![\[IM Output\]](list_test_26.gif)](list_test_26.gif)
  
      convert storm.gif news.gif eye.gif -reverse +append  list_test_27.gif

[![\[IM Output\]](list_test_27.gif)](list_test_27.gif)

------------------------------------------------------------------------

Created: 6 November 2004  
 Updated: 13 March 2008  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/misc/`
