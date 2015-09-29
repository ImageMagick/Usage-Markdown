# Compose Tables

The following tables of most of the IM compose methods with various shapes and gradients.
They form a summary of these important alpha compositing methods, and was vital in helping me figure out exactly what each composition method did and for what purpose they can be used.

The command that is being run is generally...

~~~
convert {Dst} {Src} \
        -gravity center -compose {method} -composite \
        {result}
~~~

A shell script "`compose_table`" also generates and displays various tables (with various options) of compose methods, and was developed later.

For these first set of tables with I am using two images which are similar to the test images used in the documentation for [SVG Alpha Compositing](http://www.w3.org/TR/SVG12/rendering.html).
They are perfect for demonstrating the 12 'Duff-Porter' compose operators.
They are triangular images containing no semi-transparent pixels (only transparent and opaque colors.

However I have found that using overlapping circles, such as typically used in 'Ven Disgrams' for set theory to be more useful.

As some of compositing operators will modify the whole background (destination) image, including outside the overlaid area, or even if the source is completely transparent.
Because of this I have increased the size of the background (destination) image slightly, and added a "`-gravity center`" setting.

Operators that clear the area outside the overlayed region are: `Clear`, `Src`, `In`, `Dst_In`, `Out`, and `Dst_Atop`.
However if you do not want this you can use the operational setting "`-define compose:outside-overlay=false`" to turn off this aspect of Duff-Porter Composition.

[![\[IM Output\]](montage_triangles.jpg)](montage_triangles.jpg)
[![\[IM Output\]](montage_circles.jpg)](montage_circles.jpg)

------------------------------------------------------------------------

However while the Duff-Porter methods are useful for basic image overlays, Their are a set of math methods that are much more useful with image masks.
To demonstrate I created some black and white images of circles which overlap, so you can see the results.

[![\[IM Output\]](montage_circles_1.jpg)](montage_circles_1.jpg)
[![\[IM Output\]](montage_circles_2.jpg)](montage_circles_2.jpg)

Note the 'edge' effects that result in some of the above images.
These are caused by the edges of the circles being some shade of gray (anti-aliasing), rather than purely black or white.
They appear in '`ModulusAdd`' and '`ModulusSubtract`' as these are 'modulus wrapped'.
(See the specific section on [Add](../#add) and [Subtract](../#subtract), mathematical composition for more details.

------------------------------------------------------------------------

Gradients make the best demonstration of the mathematical methods as well as "Channel Coping" and "Color Manupliation" alpha blending methods.

[![\[IM Output\]](montage_gradient_1.jpg)](montage_gradient_1.jpg)
[![\[IM Output\]](montage_gradient_2.jpg)](montage_gradient_2.jpg)
[![\[IM Output\]](montage_gradient_3.jpg)](montage_gradient_3.jpg)
[![\[IM Output\]](montage_gradient_4.jpg)](montage_gradient_4.jpg)
[![\[IM Output\]](montage_gradient_5.jpg)](montage_gradient_5.jpg)

---
title: Compose Tables
created: 5 January 2004  
updated: 11 July 2009  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.7.2-8
url: http://www.imagemagick.org/Usage/compose/tables/
---
