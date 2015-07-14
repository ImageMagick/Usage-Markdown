# Annotating Images

**Index**
[![](../img_www/granitesm_left.gif) ImageMagick Examples Preface and Index](../)
[![](../img_www/granitesm_right.gif) Labeling Images](#annotating) ![](../img_www/space.gif) (techniques for labeling images)
-   [Labeling below (or above) an Image](#anno_below)
-   [Labeling on top of the Image Itself](#anno_on)

[![](../img_www/granitesm_right.gif) Overlaying Images](#overlay) ![](../img_www/space.gif) (overlaying and merging images on top of each other)
[![](../img_www/granitesm_right.gif) Watermarking](#watermarking) ![](../img_www/space.gif) (annotating for copy protection)
-   [Watermarking with Symbols](#wmark_symbol)
-   [Watermarking with Text](#wmark_text)
-   [Watermarking with Images](#wmark_image)

[![](../img_www/granitesm_right.gif) Text and Image Positioning Methods](#text_position)
-   [The 'Gravity' of the Situation](#gravity)
-   [Image Positioning using Gravity](#gravity_image)
-   [Text Positioning using Gravity](#gravity_text)
-   [Text on Left Edge using Gravity](#gravity_left)
-   [Text Positioning using Draw](#draw)
-   [Text Positioning using Distort](#distort)

This document presents various ways of annotating a large image with either text or some other image. The annotation may be bold and highly visible, or subtle and hidden.
Reasons for annotating images are varied, but are usually either to
-   Mark the image with information about what the image is about.
-   Point out or highlight some aspect of the image.
-   Add copyright or logos to the image as a form of copy protection.

[ImageMagick](http://www.imagemagick.org/) provides a lot of ways to do these things, but not all are easy to discover from the manuals on your own. This page tries to present the common methods used. Many of the specific methods are discussed more fully on other example pages.
If you are interested in annotating or watermarking a GIF animation, I suggest you first look though this document, then jump to [Annotating GIF Animations](../anim_mods/#annotating), to start you off.

------------------------------------------------------------------------

## Annotating Images

The basic problem with labeling an image is doing so the text is readable no matter what the image. The following show many methods, show of which can be expanded to do more complex tasks.
In these examples, I am limiting myself to the default font of ImageMagick. You are encouraged to use different fonts and point sizes appropriate to what you want to achieve.
### Labeling Below (or Above) an Image

  
**Append a Label** with centering is now possible, from IM v6.4.7-1, as [Image Appending](../layers/#append) now follows the gravity setting, for alignment purposes.
  
      convert dragon.gif   -background Khaki  label:'Faerie Dragon' \
              -gravity Center -append    anno_label.jpg

  
[![\[IM Output\]](anno_label.jpg)](anno_label_append.jpg)
  
By reordering the images you can append the label above the image.
  
      convert dragon.gif   -background Orange  label:'Faerie Dragon' \
              +swap  -gravity Center -append    anno_label2.jpg

  
[![\[IM Output\]](anno_label2.jpg)](anno_label2.jpg)
  
**Splice and Draw** is very simple way of adding extra space to an image to allow us to draw/annotate the label into the image.
  
      convert dragon.gif \
              -gravity South   -background Plum   -splice 0x18 \
              -annotate +0+2 'Faerie Dragon'   anno_splice.gif

  
[![\[IM Output\]](anno_splice.gif)](anno_splice.gif)
  
The same method can be used to draw a label above the image, just replace the gravity setting of '`South`' with '`North`'. Easy!
  
      convert dragon.gif \
              -gravity North   -background YellowGreen  -splice 0x18 \
              -annotate +0+2 'Faerie Dragon'   anno_splice2.gif

  
[![\[IM Output\]](anno_splice2.gif)](anno_splice2.gif)
The "`-draw`" operator is no longer recommended for direct drawing onto images, unless part of more complex drawing functions. See the section on [Text to Image Handling](../text/) for more details of other text drawing methods and techniques.
  
**Label using Montage** The montage command in ImageMagick is often overlooked by users as only useful for creating a display of a whole directory of images. It does provide a very simple way to add labels an image.
  
      montage -label "Faerie Dragon"  dragon.gif \
              -geometry +0+0 -background Gold anno_montage.jpg

  
[![\[IM Output\]](anno_montage.jpg)](anno_montage.jpg)
  
Montage can also add a frame and other things to the image for you, so this form of labeling has a lot of extra possibilities beyond that of simple labeling of the image.
  
      montage -label "Faerie Dragon" dragon.gif \
              -font Candice -pointsize 15 \
              -frame 5  -geometry +0+0 anno_montage2.jpg

  
For more info about using montage see [Montage, Arrays of Images](../montage/).
  
[![\[IM Output\]](anno_montage2.jpg)](anno_montage2.jpg)
  
**Label using Polaroid** An alternative to using montage, is to use the [Polaroid Image Transformation](../transform/#polaroid), to generate a rather fancy commented image.
  
      convert -caption "Faerie Dragon" dragon.gif -gravity center \
               -background black +polaroid anno_polaroid.png

  
Warning this image is distorted, (curved and rotated) with some randomization, as such the final image size can vary, unless rotation is disabled. It also contains complex shadow and transparency effects, so a PNG format image was used to save the resulting image.
  
[![\[IM Output\]](anno_polaroid.png)](anno_polaroid.png)
You can reduce the 'fuzziness' in the resulting image caused by the rotation by using a 'Super Sampling' technique. See [Polaroid Image Transformation](../transform/#polaroid) for an example of this.
### Labeling on top of the Image itself...

The problem with writing text directly on a picture is that you can't be sure the text will be readable in the color you have chosen. The image being drawn onto could be black, white or a rainbow of colors.
  
**Outlined Label**: The simplest method is to draw the string with a outline to separate the text from the image. However as the "`-stroke`" font setting adds thickness to a font both inward and outward, reducing its effectiveness (See [Stroke and StrokeWidth](../draw/#stroke) for more information.
  
The better way to draw an font with a background outline is to draw the text twice.
  
      convert dragon.gif -gravity south \
              -stroke '#000C' -strokewidth 2 -annotate 0 'Faerie Dragon' \
              -stroke  none   -fill white    -annotate 0 'Faerie Dragon' \
              anno_outline.jpg

  
[![\[IM Output\]](anno_outline.jpg)](anno_outline.jpg)
As you can see it works, but not very well. It does work better with a thicker font, than the default '`Times`' or '`Arial`' font.
For more details of this technique see [Thick Stroke Compound Font](../fonts/#thick_stroke).
  
**Draw Dim Box**: The more classical method of making the annotated text more visible is to 'dim" the image in the area the text will be added, then draw the text in the opposite color. For example...
  
      convert dragon.gif \
              -fill '#0008' -draw 'rectangle 5,128,114,145' \
              -fill white   -annotate +10+141 'Faerie Dragon' \
              anno_dim_draw.jpg

  
[![\[IM Output\]](anno_dim_draw.jpg)](anno_dim_draw.jpg)
This method works well, but as you can see I decided not to use "`-gravity`" in this example to place the text, as the darkened rectangle cannot be positioned with gravity (this may change in the future). Also its size and position can depend on the image and final text size, which may require some extra math calculations.
  
**Undercolor Box**: Instead of trying to draw the background box yourself, you can get ImageMagick to use an 'undercolor' on the box. See [Text Undercolor Box](../text/#box).
  
The text 'undercolor' (as used in the library API), can be specified on the command line using the "`-undercolor`" option.
  
      convert dragon.gif  -fill white  -undercolor '#00000080'  -gravity South \
              -annotate +0+5 ' Faerie Dragon '     anno_undercolor.jpg

  
[![\[IM Output\]](anno_undercolor.jpg)](anno_undercolor.jpg)
As you can see it is a lot simpler that drawing the dimmed box yourself, though an extra space at the start and end of the drawn text is recommended, to pad out the box slightly.
  
**Composited Label**: The more ideal solution is to prepare a text image before-hand and then overlay it as an image.
  
Here we create a simple label on a semi-transparent background, and overlay it.
  
      convert -background '#00000080' -fill white label:'Faerie Dragon' miff:- |\
        composite -gravity south -geometry +0+3 \
                  -   dragon.gif   anno_composite.jpg

  
[![\[IM Output\]](anno_composite.jpg)](anno_composite.jpg)
This last technique has very some distinct advantages. The dimmed box can be sized to fit the label, and it can be position with "`-gravity`" to position it correctly, without needing any specific knowledge of the image it is being added to, or of the drawn font being used.
  
 Also you are not limited to using just a simple dimmed box. Instead you can prepare very complex font image, either before-hand, so you can apply it many times, or on the fly on a per image basis. Just about all the [Compound Font Effects](../fonts/) styles are also available to you, allowing you to make your text additions very exciting and professional looking.
**Auto-Sized Caption**: With the release of IM v6.3.2, the "`caption:`" can now automatically adjust the size of text to best fit a box of a particular size.
  
But to make proper use of this for an overlay you really need to know how wide the image being annotated is. Here I gather that info then create and overlay a caption such that the text is automatically sized to best fit the space provided, with word wrapping.
  
      width=`identify -format %w dragon.gif`; \
      convert -background '#0008' -fill white -gravity center -size ${width}x30 \
              caption:"Faerie Dragons love hot apple pies\!" \
              dragon.gif +swap -gravity south -composite  anno_caption.jpg

  
[![\[IM Output\]](anno_caption.jpg)](anno_caption.jpg)
This technique is ideal for overlaying image comments onto an image, though doing so on the command line has its own problems as you are creating a new image, not annotating an old image. See [User defined option escapes](../text/#user_escapes) for a solution to this problem.
**Fancy Label**: As a final example I will overlay a text string created using a fancy [soft outlined font](../fonts/#denser_soft_outline) to make sure it remains visible, but without creating a rectangular box for the annotation.
  
      convert -size 100x14 xc:none -gravity center \
              -stroke black -strokewidth 2 -annotate 0 'Faerie Dragon' \
              -background none -shadow 100x3+0+0 +repage \
              -stroke none -fill white     -annotate 0 'Faerie Dragon' \
              dragon.gif  +swap -gravity south -geometry +0-3 \
              -composite  anno_fancy.jpg

  
[![\[IM Output\]](anno_fancy.jpg)](anno_fancy.jpg)
If you are planning to composite the same label (say a copyright message) onto a lot of images, it would probably be better to generate your label separately and compose that label onto each image using the "[mogrify](../basics/#mogrify)" command.
The "`-geometry +0-3`" offset in the above is used to position the composite overlay closer to the edge, as the soft fuzzy outline of this image is often larger that is necessary.
  
 All the above examples should of course be adjusted to suit your own requirements. Don't be a sheep and follow what everyone else does. Experiment, and give your own web site or program a distinct flavor from everyone else. And more importantly tell the IM community about it.
    FUTURE: select the black or white color based on the images relative
    intensity.  This uses a number if very advanced techniques.

      convert input.jpg  -font myfont -pointsize 25 \
          \( +clone -resize 1x1  -fx 1-intensity -threshold 50% \
             -scale 32x32 -write mpr:color +delete \)  -tile mpr:color \
           -annotate +10+26 'My Text'              output.jpg

    Explanation:  Copy of image is resized to 1 pixel to find the images
    average color.  This is then inverted and greyscaled using -fx, then
    thresholded to either black or white, (as appropriate).
    This single color pixel is now scaled to a larger tiling image, and
    saved into a named memory register (mpr:).

    The image is then used to set the fill tile, for the annotated text.
    Their is however no simple method (at this time) to set the outline -stroke
    color of the draw text to its inverse.

    Other techniques are to use some text as a 'negate image' mask, or even a color
    burn or color dodge compose operation, to distort the image with the text.

------------------------------------------------------------------------

## Overlaying Images

The "`composite`" command and the "`-composite`" image operator in ImageMagick provides the primary means to place image on top of other images in various ways. The details of these methods are given in [Alpha Compositing](../compose/) Examples Page.
However there are more higher level operators that also make use of alpha compositing of images. These include [Image Layering](../layers/), as well as [Positioning Images with Gravity](#image_gravity), further down this examples page.
The default compose method of compose is "`Over`" which just overlays the overlay image onto the background image, handling transparencies just as you would expect.
The background image also determines the final size of the result, regardless of where the overlay is placed (using the "`-geometry`" option). It doesn't matter if the overlay is in the middle, halfway off the background image, or far far away, the output image is the same size as the background image.
The geometry position of the image is also effected by "`-gravity`", so the positioning of the overlaid image can be defined relative to any of nine (9) different locations. See "[Positioning Images and Text](#gravity)" below.
On top of "`-geometry`" of the compose overlay, individual images can also have a page or canvas information (set using "`-page`" and "`-repage`" options), that can effect the final position of the images. This image specific information is however not effected by "`-gravity`".
On with the examples...
**Overlaying** is probably the most common form of image annotation, and is very simple to do. Here I overlay a 32x32 icon of a castle in the middle of a prepared button frame.
  
      composite -gravity center  castle.gif  frame.gif  castle_button.gif

[![\[IM Output\]](castle.gif)](castle.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](frame.gif)](frame.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](castle_button.gif)](castle_button.gif)

You can also position the sub-images exactly. Here we set a hand to point out the small craws of the faerie dragon.
  
      composite -geometry +31+105  hand_point.gif dragon.gif \
                dragon_claw_pointed.jpg

[![\[IM Output\]](hand_point.gif)](hand_point.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](dragon.gif)](dragon.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](dragon_claw_pointed.jpg)](dragon_claw_pointed.jpg)

Exactly how a image is drawn on the background is controlled by the "`-compose`" setting. The default as used above is "`-compose over`" which just overlays the image on the background. Most of the other compose methods provided are not very usable except in very specific situations, but here are some of them. For more details of this setting and its effects see [Alpha Compositing](../compose/).
**Bumpmap** is a tricky compose method and basically darkens the background image in accordance to the brightness of the overlay image. Anything that is white in the overlay is handled like it is transparent, while anything black becomes black on the output image. It is a bit like using the overlay as a ink stamp and that is a good way of picturing this operation.
As a hint, overlaying with a bumpmap works best with light colored images. So you may need to prepare the bumpmap image before using.
Here we resize our dragon image before using "`-compose bumpmap`" to draw it on a paper scroll image.
  
      composite \( dragon.gif -resize 50% \) scroll.gif \
                -compose bumpmap -gravity center   dragon_scroll.gif

[![\[IM Output\]](dragon.gif)](dragon.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](scroll.gif)](scroll.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](dragon_scroll.gif)](dragon_scroll.gif)

Bumpmaps can also be used to set a overall effect on an image, in this case we tile a light colored background pattern over our dragon. Remember that a bumpmap image is treated as a grey-scale image, so any color in our overlay image is lost.
  
      composite -compose bumpmap  -tile rings.jpg \
                dragon.gif  dragon_rings.jpg

[![\[IM Output\]](rings.jpg)](rings.jpg) ![ +](../img_www/plus.gif) [![\[IM Output\]](dragon.gif)](dragon.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](dragon_rings.jpg)](dragon_rings.jpg)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The "`-tile`" option above only works for compose operations using the "`composite`" command. In "`convert`" you will have to use the "`tile:`" image generator with a "`-size`" to specify the extent. You can of course make your source image overlay larger than the background image you are overlaying, as the result will be the size of the background or destination image.*
**Multiply** compose method is best known for its ability to merge two images with white backgrounds (like onto a page of text). Unlike the '`bumpmap`' compose method, it does not pre-convert the overlaid image into grey-scale.
  
      mesgs PictureWords |\
          convert -pointsize 18 text:-  -trim +repage \
                  -bordercolor white -border 10x5   text.gif
      composite -compose multiply -geometry +400+3 \
                paint_brush.gif  text.gif  text_multiply.gif

[![\[IM Output\]](paint_brush.gif)](paint_brush.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](text.gif)](text.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](text_multiply.gif)](text_multiply.gif)

ASIDE: The complex command to generate "`text.gif`" above is just to create a typical text only image, the "`mesgs`" command just outputs a specific quotation, like "`fortune`" does but with more control.
This method works very well in a lot of situations, but generally only if one (either) image is basically black (or greyscale) on a mostly white background. If both images contain regions of color, then you may get unusual results.
In other words, this technique is perfect for overlaying line drawings, diagrams or images of text, on white (or reasonably light colored) images, such as images of printed or scanned pages.

------------------------------------------------------------------------

## Water Marking

Watermarking is an important job, as it provides a way of marking an image as belonging to some company or web site. Unfortunately this involves trashing the image in some way, to the detriment of the image itself.
The basic goals of watermarking is
-   The mark should be clearly visible regardless of whether the image is light or dark in color.
-   It should be difficult to erase.
-   and it shouldn't be too annoying to viewers.

All these factors are in conflict, and this is one reason why watermarking is so difficult to do well.
### Watermarking with Symbols

One of the simplest, and most annoying forms of watermarking is to just to place a very small but specific image somewhere on the image being watermarked. Here we generated a image (using "`logo:`") that we want to watermark, using a small 'eyes' symbol.
  
      convert logo: -resize x180  -gravity center  -crop 180x180+0+0  logo.jpg
      composite -geometry +160+13 eyes.gif   logo.jpg  wmark_symbol.jpg

[![\[IM Output\]](logo.jpg)](logo.jpg) ![ +](../img_www/plus.gif) [![\[IM Output\]](eyes.gif)](eyes.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](wmark_symbol.jpg)](wmark_symbol.jpg)

The best idea for the placement of the small image is to add it so it looks to be actually part of the original image. In the above I added the "eyes" image so it looks almost like it is part of the wizards hat, (you don't want it to become too integrated into the image either). Consequently, this technique requires the human touch, which makes it impossible to fully automate.
The small image can also be very difficult to remove, as it destroys completely the part of the image it overlaid. And if done well, is hardly noticeable, unless you are specifically looking for it.
I have seen it used to good effect in many places on the web. One web site used a small dagger-like symbol. Images stolen from that website became very obvious when I spotted that same dagger symbol on images I found on other web sites.
### Watermarking with Text

Just drawing text on an image is also a simple way of watermarking, and any of the [label on image](#anno_on) examples above can be used as a type of wartermark.
However to do this properly you should use two different colors to prevent the text from disappearing when drawn on different colored backgrounds. As such some sort of [Compound Font Effects](../fonts/) should be used.
  
      convert logo.jpg  -font Arial -pointsize 20 \
              -draw "gravity south \
                     fill black  text 0,12 'Copyright' \
                     fill white  text 1,11 'Copyright' " \
              wmark_text_drawn.jpg

  
This works well and can be automated, but it is too bold to be used as a good watermark as it stands out too well from the image.
  
[![\[IM Output\]](wmark_text_drawn.jpg)](wmark_text_drawn.jpg)
But by doing some preparation, a image with transparent background can be created that will be less evasive. For details of the steps being used to generate the watermark text, see [Font Masking](../fonts/#mask). Also the mask examples of [Masking Images](../masking/#masks) may be useful for you understanding.
  
      convert -size 300x50 xc:grey30 -font Arial -pointsize 20 -gravity center \
              -draw "fill grey70  text 0,0  'Copyright'" \
              stamp_fgnd.png
      convert -size 300x50 xc:black -font Arial -pointsize 20 -gravity center \
              -draw "fill white  text  1,1  'Copyright'  \
                                 text  0,0  'Copyright'  \
                     fill black  text -1,-1 'Copyright'" \
              +matte stamp_mask.png
      composite -compose CopyOpacity  stamp_mask.png  stamp_fgnd.png  stamp.png
      mogrify -trim +repage stamp.png

[![\[IM Output\]](stamp.png)](stamp.png)

  
Now we have a watermark font we can apply it to our image...
  
      composite -gravity south -geometry +0+10 stamp.png  logo.jpg \
                wmark_text_stamped.jpg

  
As you can see the watermark is not as bold as before, and even uses shades of grey rather the pure white and black. Even so it is still highly visible no matter what the background. The [Compound Font Effects](../fonts/) page details a lot of font styles that can be used in this way without overwhelming the image being watermarked.
  
[![\[IM Output\]](wmark_text_stamped.jpg)](wmark_text_stamped.jpg)
You can also tile the text over the whole image.
Here we also avoid the need for a intermediate image by using a 'pipeline' of commands, with the output of one, feeding the next.
  
      convert -size 140x80 xc:none -fill grey \
              -gravity NorthWest -draw "text 10,10 'Copyright'" \
              -gravity SouthEast -draw "text 5,15 'Copyright'" \
              miff:- |\
        composite -tile - logo.jpg  wmark_text_tiled.jpg

  
This takes advantage of the fact that an image (like a photograph, not a diagram) will generally have some areas in which the tiled test string will be visible. You might like to make the text semi-transparent for your own watermarking (using say a half transparent grey such as "`'#80808080'`").
  
You may also like to keep this tiling technique in mind with the following proper watermarking techniques.
  
[![\[IM Output\]](wmark_text_tiled.jpg)](wmark_text_tiled.jpg)
### Watermarking with Images

  
ImageMagick also provides a number of options that are specifically useful for more subtle watermarking, over a larger area. This is usually what is more commonly referred to, when you 'watermark' an image.
  
To the right is a "water dragon" image I will use for these demonstrations. It has some transparency, which I used to check that IM is doing the right thing with respect to transparency, avoiding any horrible 'square' look to the results.
  
[![\[IM Output\]](wmark_image.png)](wmark_image.png)
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM version 6, the options "[`-watermark`](../option_link.cgi?watermark)" and "[`-dissolve`](../option_link.cgi?dissolve)" were broken with their handling of the alpha channel (transparency) for the overlaying image, producing some very strange effects.*
**Watermark** compositing was meant to watermark images, and while it works, it tends only to work with pure white and black overlay images, producing ugly edge artifacts.
  
      composite -watermark 30% -gravity south \
                wmark_image.png  logo.jpg    wmark_watermark.jpg

For more detailed information on this option see the [Watermark Option Usage](../compose/#watermark) page.
[![\[IM Output\]](wmark_watermark.jpg)](wmark_watermark.jpg)
**Dissolve** was found by me and others to work better.
  
      composite -dissolve 25% -gravity south \
                wmark_image.png   logo.jpg  wmark_dissolve.jpg

This works very well, but parts of the watermark will disappear on images with pure white and black pixels. That is dissolving white on white and black on black will not be visible in the final image. As these two colors are very common, it is better to do some extra pre-processing of the watermark so that is uses various shades of grey rather than pure white and black. (See "Greyed Dissolve" below)
[![\[IM Output\]](wmark_dissolve.jpg)](wmark_dissolve.jpg)
For more detailed information on this option see the [Dissolve Option Usage](../compose/#dissolve) page.
**Tiled:** You can also tile the watermark across the background image instead of just adding it in one location. Just replace your gravity position with "`-tile`" instead. Of course in that case you may want to make the watermark even less intrusive.
  
      composite -dissolve 15 -tile \
                wmark_image.png   logo.jpg  wmark_tiled.jpg

[![\[IM Output\]](wmark_tiled.jpg)](wmark_tiled.jpg)
**Greyed Bumpmap:** To use bumpmap properly as a watermark the image needs some preparation to make both white and black a lighter grey color range, using a [Grey-Scale Adjustment](../color_basics/#greying) technique. If this is not done the result would be very very bold.
  
      convert wmark_image.png  -fill Gray91 -colorize 80  miff:- |\
      composite -compose bumpmap -gravity south \
                -  logo.jpg    wmark_bumpmap.jpg

[![\[IM Output\]](wmark_bumpmap.jpg)](wmark_bumpmap.jpg)
The biggest problem with bumpmap as a watermark is that the operation will only darken an image. As such this technique is fairly useless for very dark images.
**Greyed Dissolve:** The same preprocessing technique can also be useful with dissolve method so the white parts of the watermark image darken slightly on white background, and ditto also to lighten black areas of the watermark on black parts of the image.
  
      convert wmark_image.png  -fill grey50 -colorize 40  miff:- |\
      composite -dissolve 30 -gravity south -  logo.jpg wmark_dissolve_grey.jpg

[![\[IM Output\]](wmark_dissolve_grey.jpg)](wmark_dissolve_grey.jpg)
This I'd say is just about ideal as a watermark, satisfying all the requirements. I would however further adjust the final dissolve to make the watermark even less noticeable.
  
**Tiled Greyed Dissolve:** This is exactly as above but tiled over the image with a even lower dissolve value.
  
      convert wmark_image.png  -fill grey50 -colorize 40  miff:- |\
      composite -dissolve 15 -tile  -  logo.jpg wmark_dissolve_tile.jpg

  
[![\[IM Output\]](wmark_dissolve_tile.jpg)](wmark_dissolve_tile.jpg)
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
*The "`composite`" command does not know how to handle multi-image files such as animations. However other methods do allow you to do this. See [Modifying Animations, Annotating](../anim_mods/#annotating) for examples of annotating and overlaying multi-image files.*

------------------------------------------------------------------------

## Positioning Images and Text with Gravity

### The 'Gravity' of the Situation

As you can see above, being able to position images and text in a larger image can be just as important as anything else. Naturally the "`-gravity`" setting is one of the most important aspects of this.
On the ImageMagick Mailing list, Tim Hunter declared
*“ Gravity will make you crazy until you get the hang of it. ”*
This is a sentiment to which I agree wholeheartedly.
Gravity will only be applied in the following situations...
-   Any operation that involves a 'geometry' like setting, like "`-crop`" and "`-geometry`" positioning of images for [Alpha Composition](../compose/), including [Multi-image Layered Composition](../anim_mods/#composite).
-   It is also used, as means of specifying the text justification by the various text to image generators such as "`label:`" and the text justification by the various text to image generators such as "`caption:`".
-   The "`-annotate`" text drawing operator also uses it for text positioning as well as justification.
-   And finally it is used by the "`-draw`" method for its '`text`' and "`image`' methods, and ONLY those methods.

However "`-gravity`" is **NOT** used for
-   Any image list or layer operators, such as "`-mosaic`", "`-flatten`" and most "`-layers`" methods, and especially not in GIF animations.
    All of these operations uses image offsets on a larger virtual canvas (set using the "`-page`", "`-repage`" meta-data settings) to position images. Such offsets are always relative to the top-left corner of the images virtual canvas. No understanding of "`-gravity`" is used in this methodology.
-   Any other "`-draw`" method does not use "`-gravity`" for positioning. It is also unlikely to do so as "`-gravity`" is not defined under the SVG draft which IM follows for these low level functions.

What does all this this mean?
First and most importantly it defines the origin point that "`-geometry`" uses to position overlay text and images relative to the images edges, sides and center, without the user needing to know the actual size of the image. This is its primary function.
Secondly it defines horizontal and vertical justification of the overlaid object (text or image) relative to that defined point of gravity. For example, with '`East`' gravity the text or image will be placed to the right (right justification) of the defined point.
Justification should technically be a separate setting to "`-gravity`", though closely related, however IM currently combines both into a single setting.
There is a push to separate the two aspects such if a "`justification`" setting is undefined it falls back to using the current "`-gravity`" setting. If you find you need this, request it from Cristy (via the mail list). If enough users ask for it I am sure it will eventually be implemented.
### Image Positioning using Gravity

Here is an example of using gravity to position images on a background.
  
      composite label:Default                      rings.jpg gravity_default.jpg
      composite label:Center    -gravity center    rings.jpg gravity_center.jpg
      composite label:South     -gravity south     rings.jpg gravity_south.jpg
      composite label:East      -gravity east      rings.jpg gravity_east.jpg
      composite label:NorthEast -gravity northeast rings.jpg gravity_northeast.jpg

[![\[IM Output\]](gravity_default.jpg)](gravity_default.jpg) [![\[IM Output\]](gravity_center.jpg)](gravity_center.jpg) [![\[IM Output\]](gravity_south.jpg)](gravity_south.jpg) [![\[IM Output\]](gravity_east.jpg)](gravity_east.jpg) [![\[IM Output\]](gravity_northeast.jpg)](gravity_northeast.jpg)

Note that the actual position of the image is also justified according to the the "`-gravity`" setting. That is a gravity of "`South`" will center the image at the bottom of the larger image, but above that gravity point. This will become more important later with text rotation.
The other thing to remember is that the position specified by any "`-geometry`" setting is relative to the position gravity places the image. Not only that the direction of the position is also modified so that a position direction is inward.
For example the "`-gravity South -geometry +10+10`" will move the label image further into the background. That is the Y direction of the geometry position has been reversed, while the X direction was left alone.
  
      composite label:Default   -geometry +10+10 \
                rings.jpg gravity_default_pos.jpg
      composite label:South     -geometry +10+10 -gravity south \
                rings.jpg gravity_south_pos.jpg
      composite label:NorthEast -geometry +10+10 -gravity northeast \
                rings.jpg gravity_northeast_pos.jpg

[![\[IM Output\]](gravity_default_pos.jpg)](gravity_default_pos.jpg) [![\[IM Output\]](gravity_northeast_pos.jpg)](gravity_northeast_pos.jpg) [![\[IM Output\]](gravity_south_pos.jpg)](gravity_south_pos.jpg)

You can also use "`-gravity`" with "`-draw image`", to multiple images with a single command.
  
      convert rings.jpg \
              -gravity Center     -draw "image Over     0,0 0,0 'castle.gif'" \
              -gravity NorthEast  -draw "image Bumpmap  0,0 0,0 'castle.gif'" \
              -gravity SouthWest  -draw "image Multiply 0,0 0,0 'castle.gif'" \
              gravity_image.jpg

  
[![\[IM Output\]](gravity_image.jpg)](gravity_image.jpg)
And you can also now use "`-composite`" to overlay images onto the background as well...
  
      convert rings.jpg \
              -gravity Center     castle.gif  -compose Over     -composite \
              -gravity NorthWest  castle.gif  -compose Bumpmap  -composite \
              -gravity SouthEast  castle.gif  -compose Multiply -composite \
              gravity_image2.jpg

  
[![\[IM Output\]](gravity_image2.jpg)](gravity_image2.jpg)
For more detail of about the "`-compose`" settings used above see [Alpha Composition](../compose/). For other methods of overlaying combining and overlaying multiple images into one single image, see The IM Examples section [Layers of Multiple Images](../layers/).
### Text Positioning with Gravity

That is all well and good for images but what about drawing text directly on images. Well the same basic effects as for images apply.
As mentioned above gravity will also effect the positioning of text using either the "`-draw`" '`text`' method, or the better "`-annotate`" text drawing operator.
  
      convert rings.jpg -resize 120x120  \
              -gravity northwest  -annotate 0 'NorthWest' \
              -gravity east       -annotate 0 'East' \
              -gravity center     -annotate 0 'Center' \
              -gravity south      -annotate 0 'South' \
              -gravity northeast  -annotate 0 'NorthEast' \
              gravity_text.jpg

[![\[IM Output\]](gravity_text.jpg)](gravity_text.jpg)
There is one very important difference between positioning images and text. If you draw a text string, without defining any form of "`-gravity`", the string will be drawn relative to the 'baseline' of the font.
  
For example, lets actually do this...
  
      convert rings.jpg -annotate 0 'String' gravity_text_none.jpg

  
[![\[IM Output\]](gravity_text_none.jpg)](gravity_text_none.jpg)
If you look carefully you will only see the small loop tail of the 'g' in 'String' was visible at the top edge of the resulting image. The rest of the string has been drawn outside the background image.
However if you set "`-gravity`" to '`NorthWest`' the text will be positioned as if it was an image. That is relative to its [bounding or undercolor box](../text/#box) as defined by the font.
  
For example...
  
      convert rings.jpg -gravity NorthWest -annotate 0 'String'  gravity_text_nw.jpg

  
[![\[IM Output\]](gravity_text_nw.jpg)](gravity_text_nw.jpg)
The reason for the distinction is to ensure that IM text drawing remains compatible with other vector drawing image formats like the "SVG". These formats do not use gravity, so turning on gravity tells IM to follow the same rules as image placement when doing text drawing, rather than the vector graphics rules, involving the font 'baseline' and 'start' point of the text.
If you do turn on gravity and then want to later turn it off, you can use either "`-gravity none`" or "`+gravity`" to reset it back to the default 'no gravity' setting.
  
Lets apply a text offset and draw both the default '`None`' and '`NorthWest`' arguments for "`-gravity`", just so you can see how closely the two forms are related.
  
      convert rings.jpg \
              -gravity NorthWest -annotate +10+20 'NorthWest' \
              -gravity None      -annotate +10+20 'None' \
              gravity_text_pos.jpg

  
[![\[IM Output\]](gravity_text_pos.jpg)](gravity_text_pos.jpg)
While it may not look it in this example, these two strings can overlap, particularly with regard to descenders on letters such as '`g`', and '`p`'. That this the two string are not properly separated by 'pointsize' units, but only by the fonts baseline height.
The best idea is not to mix the two modes in your own image processing. Either use gravity, or don't. The choice is yours.
#### Text on Left Edge using Gravity

As a final example here is the way to actually annotate centered along the left edge of an image.
The problem here is that when you rotate text, it rotates around the text 'handle'. Unfortunatally this handle is set by gravity BEFORE the text is rotated, and as such does not work very well, unless you use restrict yourself to 'centered text'.
  
For example here is a typical 'first try' to positioning text so that it is positioned along the center of the left edge of the image. Of course it fails rather unexpectally!
  
      convert rings.jpg \
              -gravity West -annotate 90x90+10+0 'String' \
              gravity_text_left_fail.jpg

  
[![\[IM Output\]](gravity_text_left_fail.jpg)](gravity_text_left_fail.jpg)
As you can see the text was positioned on the left edge, but only so that start (where the pre-rotated 'handle' is) is centered.
The cause of this problem is that in IMv6 the "`-gravity`" setting is also directly used to set the text 'justification' (which sets the 'handle' used to position the text).
There is some animated demos of gravity effects on rotated text written in PerlMagick API (Download "`im_annotation.pl`". I also created a shell script version of the same program, "`im_annotation`", and "`im_annotation_2`".
  
A trick to making this work to rotate the whole image first then use center south! It is a non-sensical solution, but it works.
  
      convert rings.jpg -rotate -90 \
              -gravity South -annotate +0+2 'String' \
              -rotate 90  gravity_text_left.jpg

  
[![\[IM Output\]](gravity_text_left.jpg)](gravity_text_left.jpg)
An alternative method is shown below in [Text Positioning using Distort](#distort).
### Text Positioning using Draw

While in the above I used a 'text offset' to position the text relative to the "`-gravity`" point, it is not the only way to do so. The other method is to use a "-draw translate" option to position the text.
This has the advantage in that you can arrange to position text without gravity effects, while still using gravity to 'justify' the positioning 'handle' within the text.
In these examples I added some extra construction lines (which are also not gravity effected) to show how the position is applied from the center point of the image.
Text with an offset...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan  -draw 'line 50,50 70,70' \
              -fill red   -draw 'line 68,70 72,70 line 70,68 70,72' \
              -fill blue  -draw "text 20,20 'Offset'" \
              text_offset.jpg

  
[![\[IM Output\]](text_offset.jpg)](text_offset.jpg)
Text with a translation...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan -draw 'line 50,50 70,70' \
              -fill red  -draw 'line 68,70 72,70  line 70,68 70,72' \
              -fill blue -draw "translate 20,20 text 0,0 'Translate'" \
              text_translate.jpg

  
[![\[IM Output\]](text_translate.jpg)](text_translate.jpg)
As you can see both produce the same effective result. But as the "`-draw text`" requires you to give an offset that was part of its arguments, it is more commonly used to position the drawn text from the command line.
However while both of these methods produce the same result, they will produce completely different results when text rotation is also applied. Basically due to the order in which the actions are being applied.
#### Draw Rotated Text

There are two separate ways of positioning drawn text: use a 'text offset', or 'translate' the text to the final position. The effects of these two positioning methods produce very different results when rotation is also applied. The reason for this is complex, but essentially involves how IM does [Drawing Surface Warps](../draw/#transform).
Having said that lets look at what happens if you rotate some text using the two different positions.
Just a offset, without rotation...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan -draw 'line 50,50 70,70' \
              -fill red  -draw 'line 68,70 72,70  line 70,68 70,72' \
              -fill blue -draw "text 20,20 'None'" \
              rotate_none.jpg

  
[![\[IM Output\]](rotate_none.jpg)](rotate_none.jpg)
Rotating Text with an offset...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan -draw 'line 50,50 50,78' \
              -fill red  -draw 'line 48,78 52,78  line 50,76 50,80' \
              -fill blue -draw "rotate 45 text 20,20 'Offset'" \
              rotate_offset.jpg

  
[![\[IM Output\]](rotate_offset.jpg)](rotate_offset.jpg)
Rotating Text with translation...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan -draw 'line 50,50 70,70' \
              -fill red  -draw 'line 68,70 72,70  line 70,68 70,72' \
              -fill blue -draw "translate 20,20 rotate 45 text 0,0 'Translate'" \
              rotate_translate.jpg

  
[![\[IM Output\]](rotate_translate.jpg)](rotate_translate.jpg)
This is actually what most people want. Though the offset rotation can be useful for some special effects. Note how order of these [Drawing Surface Warps](../draw/#transform) are reversed to the order they are given. The rotation is performed first, and the translation is performed second. If you reverse the 'rotate' and 'translate' methods you will get the same result as a ordinary 'text offset', a rotated offset.
The "`-annotate`" operator was designed specifically to make positioning rotated text easier, by specifically asking IM to draw the text with rotation, instead of 'doing surface warping'.
Annotate with rotate and offset...
  
      convert -size 100x100 xc:white -gravity Center \
              -fill cyan -draw 'line 50,50 70,70' \
              -fill red  -draw 'line 68,70 72,70  line 70,68 70,72' \
              -fill blue -annotate 45x45+20+20 'Annotate' \
              rotate_annotate.jpg

  
[![\[IM Output\]](rotate_annotate.jpg)](rotate_annotate.jpg)
The problem with the above examples is that the IMv6 "`-gravity`" setting not only refers to the position on the background image, but also the position in the overlay image that is to be drawn.
IMv7 will be adding 'Text Justification', which refers to the overlay position, as a separate (but related) setting to gravity (background position).
#### Text Positioning using Distort

Using [SRT Distortion](../distort/#srt) with [Layering Images](../layers/#flatten), is particularly good method for placing images (or text in images).
Basically it allows you complete low level control over both the point at which the image is placed, as well as how the image is to be arranged at relative to that point.
To start with here we create a 'text image' with a transparent background and simply 'layer' the image onto the background image.
  
      convert rings.jpg -background none label:'Some Text' \
              -flatten  layer_simple.jpg

  
[![\[IM Output\]](layer_simple.jpg)](layer_simple.jpg)
As you can see the text simply added to image at top left corner.
Lets rotate it using distort (layers variant) -- Not the use of parenthesis to limit what image we distort!
  
      convert rings.jpg \( -background none label:'Some Text' \
                 +distort SRT 70 \
              \) -flatten  layer_rotate.jpg

  
[![\[IM Output\]](layer_rotate.jpg)](layer_rotate.jpg)
Note that the text position was NOT changed! All that happens was that the distort rotated the text around the center point (the handle), but so that relative to the 'virtual canvas' that point did not move. Thus when the now larger image is [Flattened](../layers/#flatten) its point of rotation 'the center of the text image' did not move.
The next step is to move that handle, but for this we need to use almost the full set of [SRT Distortion](../distort/#srt) arguments.
Because we want to continue to use the 'center handle' as well we need to use some [Image Property Percent Escapes](http://imagemagick.org/script/escape.php), or more specifically [FX Percent Escapes](../transform/#fx_escapes).
So lets place the center at '`+60+60`' in the background image
  
      convert rings.jpg \( -background none label:'Some Text' \
                 +distort SRT '%[fx:w/2],%[fx:h/2] 1 70 60,60' \
              \) -flatten  layer_translate.jpg

  
[![\[IM Output\]](layer_translate.jpg)](layer_translate.jpg)
Another way of moving a 'layer image' is using the [Repage Operator](../basics/#page). Especially a relative move using a '`!`' flag. The 'handle' for this is by the nature of layer images, the top left corner.
The [SRT Distortion Operator](../distort/#srt) will not only translate the image using the handle specified, but can use sub-pixel (floating point) positions for both of those handles. That is it can distort the text by sub-pixel increments to any location, without the integer restrictions most other operations have.
The final example is placing the 90 degree rotated text on the left edge.
The handle of the text to rotate around and position will this time be at the be the center bottom of the text, before it was rotated. That is a calculated position of '`%[fx:w/2],%h`'.
Position on the background image must also now be calculated to be the center left edge, ('`0,%[fx:h/2]`'). The problem is the [SRT Distortion Operator](../distort/#srt) does not have access to the background image when it is distorting the text image.
The solution is to do this position calculation when the background image available, and save it into some 'personal setting' which can then be added to the distort arguments. This technique is looked more closely in [Extract Information from Other Images](../transform/#fx_other).
So here is the result. First calculate the position on the background image. Then distort the text image so its 'handle' is also moved to that pre-calculated position.
  
      convert rings.jpg -set option:my:left_edge '0,%[fx:h/2]' \
              \( -background none label:'Some Text' \
                 +distort SRT '%[fx:w/2],%h 1 90 %[my:left_edge]' \
              \) -flatten  layer_on_left.jpg

  
[![\[IM Output\]](layer_on_left.jpg)](layer_on_left.jpg)
The '`my:`' string can be anything that does not clash with existing prefixes. That is I use it to hold MY settings, separate to any other settings ImageMagick may use for coders or specific options. Prefixing '`my:`' is a good choice for this.
Percent escapes are handled purely as string substitutions, and in fact we could generate the whole Distort option as a string. The only problem is you can not do math on your '`my:`' settings, after they have been set. So any mathematics must be done before hand. This is something that will be looked at for IMv7, so that FX expresions use % escape variables.

------------------------------------------------------------------------

Created: 16 December 2003  
 Updated: 22 April 2012  
 Author: [Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;  
 Examples Generated with: ![\[version image\]](version.gif)  
 URL: `http://www.imagemagick.org/Usage/annotating/`
