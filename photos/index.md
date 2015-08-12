# Digital Photo Handling

One of the prime uses of ImageMagick is the handling and modification of photographs that were taken with the new modern digital camera.

These cameras generally take quite large, high resolution photos, and include in them meta-data about the time, scale, zoom, camera, orientation, and so on.
There are even plans to link cameras to mobile phones, so that it can even make a guess as to where you were when the photo was taken and who might be in the photo (from what mobile phones are in font of it).

Here we look at the basics of handling digital photos, and even converting them for other purposes, such as artistic renderings.

Special thanks goes to Walter Dnes, a digital camera user, for his help in the enhancement of digital photos.

----

## Digital Camera Meta-Data, the EXIF Profile {#exif}

When a digital camera takes a photo, it also includes a lot of extra information in the JPEG save file.
This meta-data is known as the EXIF profile, and is provided specifically for photographic labs and development.
The ImageMagick "`identify`" with a "`-verbose`" setting will display this Exif information.

Here is the EXIF data of a photo I took of a [Pagoda, Kunming Zoo, in Southern China](pagoda_sm.jpg).

~~~
identify -format "%[EXIF:*]" pagoda_sm.jpg |\
     sed 's/\(.\{46\}\).*/\1/' | column -c 110
~~~

[![\[IM Text\]](pagoda_sm_exif.txt.gif)](pagoda_sm_exif.txt)

> ![](../img_www/warning.gif)![](../img_www/space.gif)
>
> The EXIF data, or any identify output, should be processed in a case in-sensitive way.
> Many older versions of IM for example, will output "`EXIF:`" (uppercase) rather than "`exif:`" (lowercase).

Here is a similar example but using 'globbing' (shell-like) expression to limit output to EXIF fields involving Time...

~~~
identify -format "%[exif:*time*]" pagoda_sm.jpeg
~~~

[![\[IM Text\]](pagoda_sm_time.txt.gif)](pagoda_sm_time.txt)

There is a lot of information about this photo in the EXIF profile.
For example:

-   My camera is a Panasonic ('`Make`'), DMC-LZ1 ('`Model`')
-   The camera was rotated ('`Orientation`').
    But I must have corrected that rotation without adjusting the EXIF data.
    The camera was also tilted upward slightly, but that info is not recorded.
-   The '`FocalLength`' of '`37mm` shows that I did not make use of my cameras 'Optical Zoom' feature.
    My camera could go up to a 6X optical zoom for a '`FocalLength`' of '`366/10`' or '`222mm`.
-   And '`DigitalZoomRatio`' shows I did not digitally zoom either.
-   The camera also used a fast 1/8 second '`ExposureTime`', and a aperture '`MaxApertureValue`' of 3mm, or '`FNumber`' of  '`5.6`' and a '`ISOSpeedRating`' of '`64`'.
-   The flash ('`LightSource`') was not used.
-   The original image was 1728 by 2304 pixels ('`ExifImageLength`' and '`ExifImageWidth`').
    Though the actual image, if you like to check is smaller, so I must have cropped and/or resized it.
-   And probably most importantly, it was taken around 14:05pm on 9th of July 2005, according to the '`DateTime`' string.
    That assumes that I had the cameras time set correctly (which I did).
-   More modern cameras may even have a GPS location and posibily a compass direction of the view!

Also included by not listed above is a small 'thumbnail' preview image that the camera used on its own display.

There is also features to mark photos you want to be 'developed' or printed by photographic printers, and to adjust other printing parameters.
However this is rarely used by most people.

Many of these settings can be very useful to users, but the most useful to people is generally the Date and Time of the photo.
This of course assumes Most people however are most interested in the Date/Time of the photo, and the orientation of the image so they can rotate it correctly.
That is what we'll look at next.

All this data, and especially the preview image, can take up quite a lot of space in the image.
And it may be that I don't actually want everyone in the world knowing that I was in Kunming, China in July 2005.
As such you may like to remove EXIF data from your images before actually publishing it on the World Wide Web.

Also the size of an image from a digital camera usually very large, allowing you to print it at photo quality level, but is far too large for use of the WWW, and especially not for thumbnails.
As such unless you want users to actually print photo quality images, I would not publish the original image directly.

The above image for example has been cropped and resized for IM examples usage, but I purposely left the EXIF data intact for the example.
Normally I would strip this information.

----

## Digital Photo Orientation {#orient}

I have been told that Photoshop will automatically rotate digital images based on the EXIF '`Orientation`' setting, IM will also do this by including a "`-auto-orient`" operator, after reading in the image.

However, and this is important:
**JPEG Format is Lossy**

What this means is that any time you decode and save the JPEG file format you will degrade the image slightly.
As a general image processor, IM will always completely decode and re-encode the format, as such it will always degrade JPEG images when it re-saves the image.
For more information on the nature of the JPEG format see [JPEG Image File Format](../formats/#jpg).

The point is to only use IM to correct digital photo orientation (using "`-auto-orient`") when you are also performing other image modifying operations, such as [Thumbnail Creation](../thumbnails/#creation), [Annotating Images](../annotating/#anno_on), [Watermarking](../annotating/#watermarking) or even [Exposure Adjustments](#brightening).

*FUTURE: quick thumbnail example*

IM can extract the current orientation (as a number) from the photo using an [Image Property Escape](http://www.imagemagick.org/script/escape.php)...

~~~
identify -format '%[exif:orientation]' pagoda_sm.jpg
~~~

[![\[IM Text\]](orient_show.txt.gif)](orient_show.txt)
IM provides a special "`-orient`" operator (use "`-list orientation`" to see possible values).

~~~
convert pagoda_sm.jpg -orient bottom-right \
         -format '%[exif:orientation]'   info:
~~~

[![\[IM Text\]](orient_setting.txt.gif)](orient_setting.txt)

These meta-data setting methods, allow you to adjust the orientation of photos you have modified, especially ones you have rotated.
Note that a correctly orientated photo has a orientation of '`Top-Left`' or 1.

Of course you should not remove the EXIF meta-data (using either "`-strip`" or "`-thumbnail`"), if you plan to use "`-auto-orient`" later in the image processing.
Use it before stripping the image meta-data.

If you do want to correct the orientation of your photo, without degrading or otherwise modifying your image, I suggest you use the [JHead](http://www.sentex.net/~mwandel/jhead/) program.
For example here I correct a photos orientation, and delete the built-in preview thumbnail all the digital photos in a directory.

~~~
jhead -autorot  *.jpg
~~~


> ![](../img_www/warning.gif)![](../img_www/space.gif)
>
> :WARNING:
> The JPEG lossless rotation will only work correctly for images that have a size that is divisible by 8 or 16.
> This is true with most (but not all) digital camera photos.
> If you try this with an image that is a odd size the right or bottom edge blocks (containing the partial size) will not be positioned correctly in the final image, as these block can only exist on the right or bottom edge.
>
> For an example of this see this [specific discussion](../forum_link.cgi?t=16784&p=62157)

The [JHead](http://www.sentex.net/~mwandel/jhead/) program will also let you adjust the photos date (if your camera time was set wrong, or you have travelled to different time zones), extract/remove/replace the preview thumbnail, set the comment field of the image, remove photoshop profiles, and do basic image cropping (to remove that stranger exposing himself ;-) so on, without degrading the JPEG image data.

I recommend this program, or other programs like it (see [Other JPEG Processing Programs](../formats/#jpg_non-im)), to fix this information.
Just be sure that it does not actually decode/re-encode the JPEG image data.

One final point about orientation.
If you pointed your camera almost straight up or down, the EXIF orientation setting may not resolve correctly.
The same goes for angled or slanted shots.
The orientation (and cameras) just have no senses for these situations.

Your only choice for such photos is to do the rotates yourself using the lower level non-lossy "`jpegtrans`", or IM "`-rotate`", and then either reset the EXIF orientation setting (using [JHead](http://www.sentex.net/~mwandel/jhead/) or the IM "`-orient`" operator), or just strip the EXIF profile.


    Other IM Lossy Modifications...
      If you are also resizing or otherwise modifying the image, such as reducing
      its quality and size for use on the web, then data loss is already a fact.
      As such during those operations IM can do similar things, allowing you to do
      all the required operations in a single 'load-save' cycle.

      Rotate ALL images to landscape   -rotate 90\<
                           portrait    -rotate -90\>

----

## Color Improvements {#color}

Before proceeding, it is recommended that you first look at [Color Modifications](../color_mods/) for an introduction to general color modification techniques that will be used.

[Normalizing](../color_mods/#normalize) (using "`-normalize`") high-contrast line art and graphics can be great.
But normalized photos may look unreal, and, as was said earlier, may not print well either.
The "`-contrast-stretch`" operator can limit the "boundaries" of the normalization, but the "`-levels`" and/or "`-sigmoidal-contrast`" operator can make "smoother" adjustments (see [Histogram Adjustments](../color_mods/#histogram) for a lower level discussion of what these operators do).

The above input is courtesy of "Tong" form the IM Mailing List.

### Brightening Under-exposed Photos Contributed by Walter Dnes {#brightening}

Sometimes there simply isn't enough available light to allow for a proper exposure.
At other times, you may have to use shorter exposure times than optimal, in order to eliminate motion-blur.

Underexposed digital photos can have darker areas preferentially brightened, without blowing highlights, by using the "`-sigmoidal-contrast`" operator, with a '`0%`' threshold level.
See [Sigmoidal Non-linearity Contrast](../color_mods/#sigmoidal) for more details.

Here is a minor underexposure example, which was taken at a free concert after sunset.
This has lots of brightly lit areas, which are clear, but also dark areas I would like to make more visible.

~~~
convert night_club_orig.jpg  -sigmoidal-contrast 4,0%  night_club_fixed.jpg
~~~

[![\[IM Output\]](night_club_tn.gif)](night_club_orig.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](night_club_fixed.gif)](night_club_fixed.jpg)


> ![](../img_www/reminder.gif)![](../img_www/space.gif)
>
> :REMINDER:
> As always, you should use a non-lossy format like TIFF or PNG for intermediate work.
> The JPEG format is only used here to reduce disk space and download bandwidth for web publishing.
>
> Select image to see the enlarged version actually used by the examples rather than the small thumbnail shown.

And here is a major underexposed example, which was a night-time shot from my balcony looking southwards towards the city of Toronto.

~~~
convert night_scape_orig.jpg -sigmoidal-contrast 10,0%  night_scape_fixed.jpg
~~~

[![\[IM Output\]](night_scape_tn.gif)](night_scape_orig.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](night_scape_fixed.gif)](night_scape_fixed.jpg)

The main parameter controls the amount of brightening.
The more brightening required the higher value used.
And the grainier the output picture will look.
This is due to the smaller pixel errors also being enhanced.

Sigmoidal contrast brightening tends to de-emphasize the red end of the spectrum.
You may end up having to select a parameter that results in the most natural flesh tones, rather than the brightness level you really want.

In the case of major underexposure, you will end up with a glorified grainy black-and-white image after brightening.
This is a physical limitation of digital image enhancement.
If there's no colour data present, IM won't generate it for you.
In real life the bricks on the right-hand side of my balcony are reddish, and the trees below are green.

### Binning -- Reducing Digital Noise (Contributed by Walter Dnes) {#binning}

A lot of serious photographers are unhappy with the side-effects of the "megapixel race" by digital camera manufacturers.

Manufacturers pack more megapixels into a digital camera's sensor by making them smaller.
Smaller pixels result in a noisier picture at the same ISO setting, which forces people to use lower ISO settings.
Using lower ISO ratings to avoid noise requires longer exposure times.
This, in turn, means that most consumer digital cameras are effectively useless indoors beyond the 10-foot range of their built-in flash for anything except a still-life picture taken with the camera on a tripod.

Many digital camera users would gladly trade some pixels for less noisy pictures at higher ISO settings, but the marketeers who control the companies refuse to consider this as an option.

Fortunately, the trade-off can be done after the fact on digital photos.
The technical term is 'binning'.
The simplified theory goes like so...

-   Take an n-by-n grid of pixels, and average their components to obtain one "super-pixel".
-   Signal is proportional to the combined pixel area, which means that the amount of signal has increased by a factor of n^2
-   Noise is random.
    Which means that it is proportional to the square root of the combined pixel area, a factor of n.
    The net result is that SNR (signal-to-noise ratio) has increased by a factor of n.
    See [Photo Glossary, Binning](http://www.noao.edu/outreach/aop/glossary/binning.html) for more details.

When a 1600x1200 digital photo is binned down to 800x600 (i.e. a 2x2 grid) the signal-to-noise ratio is doubled.
Similarly, a 2560x1920 picture binned 3x3 to 853x640 pixels will have a factor of 3 improvement in signal-to-noise ratio.

> ![](../img_www/reminder.gif)![](../img_www/space.gif)
>
> :REMINDER:
> In order to make use of binning, the photo image must be a whole number multiple of the final desired size.

In ImageMagick, the special "`-filter`" setting '`box`' will average groups of pixels down to a single pixel when you "`-resize`" an image (See [Resampling Filters](../filter/#filter) for details.
This means that to do a 'binning' you only need to resize the image correctly.

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

Walter Dnes also provided the original script [binn](binning/binn) to perform the calculations, minimally crop the image and perform the 'binning'.

[Binning examples 3](binning/sample3.html)

[Binning examples 4](binning/sample4.html)

----

## Photo Conversion Cookbook {#cookbook}

### Minor Rotation Correction -- Make a photo more level {#rotation}

Typical situation.
You have taken a photo, but the image isn't level, and you want to correct it.

[![\[IM Output\]](beijing_tn.png)](beijing_md.jpg)

For example here is a photo I took using a hand held camera in Beijing, 2008, from the hill in Jingshan Park, immediately behind the Forbidden City.
No it isn't of the Forbidden City itself, but a temple on the other side of the hill.

*Click on the thumbnail, to see a larger image.*

Yes the image is small, and you should apply the solution to the original image not a small thumbnail, but the techniques is the same for any image.
In this case the image needs to be rotated by -1.8 degrees, to correct it.

Now if you just simply rotate the image you will get a slightly larger image containing areas of color in the corners, making the correction look obvious and horible.

~~~
convert beijing_tn.png -rotate -1.95  beijing_rotate.png
~~~

Even if you were to crop the image back to its original size, such as demonstarted in [Simple Image Rotations](../warping/#rotate) you will still get some colored corners.

[![\[IM Output\]](beijing_rotate.png)](beijing_rotate.png)

The simplist solution would be to now crop that result so as to remove those borders, but then your image becomes a rather odd size, which is again rather obvious that something has been done.
Though the formula to do that clipping is not simple, but is demonstrated in [Distortion Rotation Methods](../distorts/#rotate_methods).

The better solution is to not only rotate the image, but scale it slightly so as to produce a rotated image that is the same size as the original.

~~~
angle=-1.95
convert beijing_tn.png -distort SRT \
   "%[fx:aa=$angle*pi/180;(w*abs(sin(aa))+h*abs(cos(aa)))/min(w,h)], $angle" \
   beijing_rot_correction.png
~~~

[![\[IM Output\]](beijing_rot_correction.png)](beijing_rot_correction.png)

And the image is clean looking with a perfectly level wall.

The angle calculation is reasonably straightforward trigonometry, using the pixel locations at the ends of a long straight line in the image.
However I found that simply rotating the image at various small angles by trial and error will find a good rotation angle relatively quickly.

When looking how good a particular angle is, take a very close zoomed in look at the pixels along the line or edge you using.
The top of the wall in this photo.
And remember in image rotations a left or anti-clockwise rotation is negative (due to Y-axis pointing downward).

Also remember that if at all possible, always apply operations to the original image, avoiding the use intermediate images (and especially intermediate JPEG images).
It is always better to apply any photo modification starting with the original source than any saved intermediate copy.

### Tilt-Shift Effect -- make scenery look like a artificial model {#tilt_shift}

[![\[IM Output\]](beijing_tn.png)](beijing_md.jpg)

The 'Tilt-Shift' is a technique which causes a image be be blurred at the top and bottom, while leaving the center of the image unblurred.
It was originally done in very old bellow type cameras where the lens was tilted to bring the top and bottom of the image out of focus.
Thanks of the introduction of [Variable Blur Mapping](../mapping/#blur), added to ImageMagick in v6.5.4-0 this is now easy to do.

If you add to this a very high contrast so as to enhance shadows, and saturate the colors, a typical result is that a normal image can be made to look artificial.
Almost as if you were taking a photo of a small, highly detailed, and brightly lit, model.

The first thing we need to do, is enhance the colors in the image to give it a very high contrast, and perhaps brighten it a bit to make it look like it is very well lit with strong studio lights.

~~~
convert beijing_md.jpg -sigmoidal-contrast 15x30% beijing_contrast.jpg
~~~


[![\[IM Output\]](beijing_contrast_tn.gif)](beijing_contrast.jpg)

Note how I used a strong [Sigmodial Contrast Operation](../color_mods/#sigmoidal-contrast), to achieve these color effects.
I did not just simply use a linear contrast as I did not want to 'clip' the brightest and darkest colors of the image.
The contrasting value of '`15`' is a very very strong contrast.
I also brightened the image a bit by offsetting the center of the contrast threshold to a '`30%`' gray value.

If the colors of the contrast enhanced image does not come out cartoonish enough, you may like to try increasing the color saturation of the image, using the [Modulate Operator](../color_mods/#modulate).
This image did not need it as it as the tiled roof and bright green trees already provides enough color effects.

If you look at a enlargement of the image (*Click on the thumbnail*), you will see that even just enhancing colors gives the image a feel of artificial lights, though it does not look like a model, with too much detail to the cars in the background, and people in the foreground.

Now for the tilt-shift.

For this we prepare a gradient image that is white at the top and bottom, and black in the middle.
Some people might use a linear gradient for this, but I find a parabolic gradient better.

~~~
convert beijing_contrast.jpg \
        -sparse-color Barycentric '0,0 black 0,%h white' \
        -function polynomial 4,-4,1   beijing_blurmap.jpg
~~~


[![\[IM Output\]](beijing_blurmap_tn.gif)](beijing_blurmap.jpg)

Note that I used the original image itself with a two point [Barycentric Sparse Coloring](../canvas/#barycentric) to generate a linear gradient over the whole image.
That linear gradient is then modified using a basic [Polynomial Function](../transform/#function_polynomial) to make it a parabolic gradient with black in the middle.

Now it is simply a matter of blurring the image according to the blur map to create a 'tilt-shift' effect.
The result is that the original image looks rather like a scale model, rather than quick snap-shot of the real thing.

~~~
convert beijing_contrast.jpg  beijing_blurmap.jpg \
        -compose Blur -set option:compose:args 10 -composite \
        beijing_model.jpg
~~~

[![\[IM Output\]](beijing_model.jpg)](beijing_model.jpg)

As you can see in the final image, the trees and the buildings look very artificial, due to the strong colors, while the blurring of the near and far parts gives the image a 'small' model-like feel to it.
Though this must have been a very detailed model!

The result could have been improved further by performing a [Rotation Correction](#rotation) (see previous) as part of the tilt shift processing.
A perfect camera orientation would simply added to the artificial feel.

Of course you can string all these operations together to to it all in one command, and avoid temporary files, or loss of quality.

~~~
convert beijing_md.jpg -sigmoidal-contrast 15x30% \
        \( +clone -sparse-color Barycentric '0,0 black 0,%h gray80' \
           -solarize 50% -level 50%,0 \) \
        -compose Blur -set option:compose:args 10 -composite \
        beijing_model.jpg
~~~

In the above I replaced the parabolic gradient with a more traditional linear black-white-gray gradient (with the same slope) to the 'tilt-shift' blur map.
The [Solarize & Level](../color_mods/#solarize) technique was used to make the linear gradient peak horizontally about 1/3 from the bottom of the image.
However I find that the area of focus in a linear gradient too small and not very practical.

There are many other way of generating a suitable gradient for a tilt shift effect.
For example using [Resized Gradients](../canvas/#gradient_resize).
Or horizontally scaling a [Shepards Sparse Color](../canvas/#shepards) of single column of pixels.
Sine curve gradients may also be useful.

##### Speed Optimization

The [Variable Blur Mapping](../mapping/#blur) operation is essentially using a single pass 2-dimensional blurring method (equivalent to a uniform Gaussaian Blur).
However you can get a general speed boost by doing the bluring operation in two 1-dimensional variable blur operations.

For example here I first blur horizontaly, the vertially...

~~~
convert beijing_md.jpg -sigmoidal-contrast 15x30% \
        \( +clone -sparse-color Barycentric '0,0 black 0,%h gray80' \
           -solarize 50% -level 50%,0 -write mpr:blur_map \) \
        -compose Blur -set option:compose:args 10x0 -composite \
        mpr:blur_map \
        -compose Blur -set option:compose:args 0x10 -composite \
        beijing_model_2pass.jpg
~~~

The result is practially identical (though does differ somewhat), but is a lot faster to process.

ASIDE: I believe that swaping the operations (blur vertical then horizontally) will generate a more accurite result for this type of blur mapping.
Basically as the horizontal blur is a constant in the direction of that blur pas, so should be done last.

##### Problems with Tilt-Shift Effect vs A Real Model

If you examine the resulting photo carefully, you will be able to tell it is a fake tilt-shift, and not a photo of a real model.

You can see this in that the roof of the larger building is too blurry when compared to the base of the building.
Even though it is about the same distance as the base.
Similarly the base of the 'wall' is more blurry than the top of the wall.
That is it can be seen to be fake, of a fake.

The problem is that large vertical objects, should be blurred by the same amount over the whole surface, and not just variably blurred by height.
Remember the blur gradient is meant to represent the focal depth, or distance of the various objects in the image, as such the surface of a vertical object should all be the same 'distance' and thus blurred by the same amount.

To fix I would need to adjust the blur gradient to make those areas have a with a constant (or near constant) color of the 'base' of that object, relative to rest of the image.
That is vertical surfaces have a constant blur amount while all the horizontal surfaces have a blur gradient.

Basically the blurred gradient should represent the actual 'depth' of each point in the image, which for most images is a very complex gradient.
This adjustment can be difficult to achieve, as it most likely requires some human interpretation of what is a horizontal wall and how far the object is in the image.
It is also unlikely to be easily automated.
What can you do with this effect? Mail me your tilt-shift images! I'll reference them here.
Or perhaps you can correct the tilt-shift faults in the above example.

### PNG-JPEG Layered Images {#png_jpg}

By separating a large newspaper or magazine page into a text layer that is saved as a PNG, and a image layer saved as JPG, both using just a white background, it is possible to use much less disk space than the two images combined!

More importantally images can use a lossy compression (JEPG), the text components will remain sharp an clear (PNG).

It sounds silly and weird but it is actually true.
The separated images can save 3 to 4 times the disk space used by a single combined image.

Usually the two images are generated during the publication process as separate layers.
But you can also separate images after the fact too.

The images are just overlayed together...

~~~
convert  ny_family.jpg ny_family.png -composite   ny_family_merged.jpg
~~~

[![\[IM Output\]](ny_family_tn.jpg)](ny_family.jpg)
![==&gt;](../img_www/multiply.gif)
[![\[IM Output\]](ny_family_tn.png)](ny_family.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](ny_family_merged_tn.jpg)](ny_family_merged.jpg)  

Select the resulting images to see a larger copy.

This uses a normal [Over Composition](../compose/#over), which requires the PNG (overlay) image to be transparent.
This transparency comes in two forms.
Either as a boolean (pure on/off) mask, such as seen in the above.

Example code for image separation welcome.

### Overlapping Photos -- blurred overlaps of appended photos {#overlap}

Creating a series of overlapping photos (and I don't mean a panarama) is a common task, especially in web site creation.
But is can be tricky to do unless you have the right knowledge of IM operators.

The simplest method is to use a [Masked Composite](../compose/#mask) of the two images, and a mask to select which image to overlay.

First however you need to do simple mathematics.
For this example, I am using two thumbnail images 120x90 pixels in size and I want to overlap them horizontally by 40 pixels.
This means the resulting image should be 120 + 120 - 40 pixels wide, or a 200x90 pixel image.

Next we need a mask.
This needs to black one one side, white on the other, with a 40 pixel gradient in the middle, the size of the final output image.
That is 120 pixels - 40 pixel gives an 80 pixel area for each of the two non-overlapped areas.

So lets generate a masking image...

~~~
convert -size 90x80 xc:white xc:black   -size 90x40 gradient: \
        +swap -append -rotate 90    overlap_mask.png
~~~

[![\[IM Output\]](overlap_mask.png)](overlap_mask.png)

An alternative way of generating the masking image is to use Fred Weinhaus's "`plmlut`" horizontal gradient generator script.
This has finer controls for the curvature of the gradient rather than a sharp linear gradient I generate above.

Now that all of the math is out of the way, all that is left is to do a three image masked composition, using the mask we just generated.
However we will also need to enlarge the destination (left) image so as to provide enough space for the overlapping right image (any color), and position the second image correctly using the appropriate gravity (right, or '`East`').

~~~
convert holocaust_tn.gif -extent 200x90  spiral_stairs_tn.gif \
        overlap_mask.png  -gravity East -composite   overlap_photos.jpg
~~~

[![\[IM Output\]](holocaust_tn.gif)](holocaust_tn.gif)
[![\[IM Output\]](spiral_stairs_tn.gif)](spiral_stairs_tn.gif)
![ +](../img_www/plus.gif)
[![\[IM Output\]](overlap_mask.png)](overlap_mask.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](overlap_photos.jpg)](overlap_photos.jpg)

And we now have two images, which are overlapped using a linear gradient.

Of course the two commands can be merged into a single command, so that you don't need to save the 'mask' intermediate image.
This is left as an exercise to the reader.

A slight improvement is to use a more curved gradient over a larger overlap between the images.
This reduces the sharp change visible at the start and end of the overlap area of the final image.
Especially with images contain large areas of very different colors.

For example, this uses some [Distorted Gradient](../canvas/#gradient_distort) techniques to not only generate a smoother gradient curve, but also to rotate that gradient so as to have a highly angled overlap.

~~~
convert -page +0-15 -size 1x30 gradient: \
        -sigmoidal-contrast 5,50% -contrast-stretch 0 \
        -set option:distort:viewport 180x90-90-45 \
        +distort SRT 115 +repage \
        holocaust_tn.gif -extent 180x90 +swap \
        spiral_stairs_tn.gif +swap \
        -gravity East -composite   overlap_angled.jpg
~~~


[![\[IM Output\]](overlap_angled.jpg)](overlap_angled.jpg)

Yes, the above is rather complex, but it shows just what is possible.

If you plan to do more than two images, a better method is to use the mask to directly set the transparency of the second and later images.
The multiple images can then be overlaid together using a techniques seen in [Layered Image Examples](../layers/#layer_prog).

Some of these techniques do not require you calculate the final image size, as IM can do this for you.
You only need to make sure you position the images correctly.

For example, here I add a 30 pixel gradient to a second and third image, requiring the images to be placed every 90 pixels (width 120 minus 30 pixel overlap) from each other.
When all images are given the appropriate transparency and positioning, we just [Mosaic](../layers/#mosaic) the layers together (all offsets are positive), letting IM figure out the final canvas size.

~~~
convert -size 90x90 xc:white -size 90x30 gradient: -append -rotate 90 \
        hatching_tn.gif \
        \( chinese_chess_tn.gif -clone 0 \
               -compose CopyOpacity +matte -composite -repage +90+0 \) \
        \( holocaust_tn.gif -clone 0 \
         -compose CopyOpacity +matte -composite -repage +180+0  \) \
        \( spiral_stairs_tn.gif -clone 0 \
               -compose CopyOpacity +matte -composite -repage +270+0 \) \
        -delete 0   -compose Over  -mosaic     overlap_series.jpg
~~~

[![\[IM Output\]](overlap_series.jpg)](overlap_series.jpg)

This can be continued to a longer sequence with relative ease, especially using the looped technique shown in [Programmed Positioning of Images](../layers/#layer_prog).
However overlapping photos like this works best for images with a reasonably common overall color.

One point with such overlapping images.
You may notice that for the images at the end of the sequence, a centered subject may not look very centered due to the overlap on one side of the image only.
This problem can be improved either by fading the outside edge of those images into transparency, or chopping of some of outside edge to help re-center the subject of those images.

*`ASIDE: It may be that doing the composition in a different colorspace may work better.
Anyone like to experiment and report on your results, good or bad?  `*

### Double Exposures -- mixing multiple photos of the same scene {#double}

With old time film based cameras, there was a technique where a picture was take two or more times without 'rolling' the film.
This allowed you to create what was known as double exposures, where two images taken at slightly different times were merged together.
The result was often a ghosting or dimming of parts of the image which moved or changed.

However with careful control of the subjects in the image, the lighting effects, and even the development process, it became possible to make some very weird or even 'impossible' photos.
With digital images it is even easier as you have even better control of the images.

Basically...
*Seeing may be believing, but cameras lie!*

For example suppose I wanted a image in which I appear in twice! Well that is easy to do.
Here for example are the thumbnails of two quick photos I took specifically for this example, using a tripod and timer, which I'll use directly.

[![\[IM Output\]](anthony_1.jpg)](anthony_1.jpg)
[![\[IM Output\]](anthony_2.jpg)](anthony_2.jpg)

*Perhaps you can supply a better more amusing photo set?*

I will apply the double exposure techniques directly to these thumbnails, though more typically I would do this using original image files as inputs, so as to get a result of the highest quality.

Now if I used a traditional film-like 'double exposure' with a old style camera, the result would be an average of these two images, generating see-thru 'ghosts' of myself.
Here is the digital simulation of this technique...

~~~
convert anthony_1.jpg anthony_2.jpg -average  anthony_ghosts.jpg
~~~


[![\[IM Output\]](anthony_ghosts.jpg)](anthony_ghosts.jpg)

However, what if I don't want ghosts, but properly solid images of myself.
Well then you need to use a mask to select which parts you want to come from which image.

This mask can be generated in two ways.
You can just manually create the mask by dividing the image along the static or unchanging parts.
A rather simple matter in this particular case...

~~~
convert -size 100x90 xc: -draw 'rectangle 0,0 50,89' \
        -blur 0x3  anthony_mask.jpg
~~~


[![\[IM Output\]](anthony_mask.jpg)](anthony_mask.jpg)

Note that I blurred the mask, so as to 'feather' the cut-over between the two images.
And here I use a [Masked Composition](../compose/#mask) to merge the images.

~~~
convert anthony_1.jpg anthony_2.jpg anthony_mask.jpg \
        -composite  anthony_doubled.jpg
~~~


[![\[IM Output\]](anthony_doubled.jpg)](anthony_doubled.jpg)

How if you had two (or more) family photos, where some people had eyes closed, were speaking, pulling faces, or just looking away.
You could pick and choose each 'head' from different images and merge the multiple images to form a montage, so as to get a photo where everyone is looking at the camera, and have their eyes open.

By swapping the input images, or just negating the mask, you can remove me completely from the image, so get an unrestricted view of the static background.

~~~
convert anthony_2.jpg anthony_1.jpg anthony_mask.jpg \
        -composite  anthony_removed.jpg
~~~


[![\[IM Output\]](anthony_removed.jpg)](anthony_removed.jpg)

This can be handy when taking photos of a public monument, where you can't afford the expense of crowd control.
Just take lots and lots of photos from a tripod, and hopefully you can combine them to remove everyone from the scene! Generating the average image as a guide can be helpful with process, especially if you generate masks using the second method (see next)...

The other way of generating the mask image is by taking the time to get a photo of the scene without the subject in it (or generate one like in the last example).
Or in the case of a 'busy' scene using an average of hundreds of images, so as to turn all the people into a light haze of 'ghosts' that can be discounted.

With a clean background photo, we we can threshold a difference image to mask out the parts of the image that changed.
You may need to use some further blurring and threshold to expand that mask appropriately to cover not only the object within the image, but any shadows or reflections it may cast on the background scenery.
A little trial and error may also be needed to get it right.

~~~
convert anthony_removed.jpg anthony_2.jpg \
        -compose difference -composite \
        -threshold 5% -blur 0x3 -threshold 20% -blur 0x3 \
        anthony_automask.jpg
~~~


[![\[IM Output\]](anthony_automask.jpg)](anthony_automask.jpg)

Now lets use this mask to mix my 'ghosts' image with the original image so it looks like my conscience is 'haunting' me for making such 'impossible' pictures.

~~~
convert anthony_1.jpg anthony_ghosts.jpg anthony_mask.jpg \
        -composite  anthony_haunted.jpg
~~~


[![\[IM Output\]](anthony_haunted.jpg)](anthony_haunted.jpg)

As a final point, all the above techniques assumes the photos were taken from a camera that was locked down securely on a stationary tripod.
If this was not the case, but just taken from a hand held position, I can guarantee that the images will not match-up or 'align' properly, no matter how hard you tried to do it.
In such cases you may require some [Affine](../distorts/#affine) or even [Perspective](../distorts/#perspective) distortion of at least one of the two images to get the backgrounds to align properly.
The more complex the background, the more exacting the needed re-alignment.

If a flash was used, or the day was cloudy with variable light, you may also need some brightness adjustments to the photo.
The cause is that most cameras 'auto-adjust' the brightness of the images, and a flash, or variable light can change its handling of the 'auto-level' adjustment for each and every image.

As a final example, here is another image I created from two separate photos, of my nephew fencing with himself, in front of a climbing wall.
As I was holding the camera and used a flash, I did need to do some affine distortion adjustments, as well as slight brightness adjustment to get the seamless result you see.

[![\[IM Output\]](jacob_vs_jacob_md.jpg)](jacob_vs_jacob_md.jpg)

***Jacob* vs *Jacob***

If you were trying to decide if this photo was fake or not, you would look at the lighting, shadows and reflections.
In the above, a close examination of the floor will show that the right 'Jacob' does not have a proper reflection on the floor (it was clipped by the photos edge).
But you would really need to study the photo well to notice this!

Now think of the possibilities you can use this 'double exposure' technique for.
For example how about some [Funny Mirrors](http://todaypictures.blogspot.com/2006/03/funny-mirror.html).
Email me your results!

If you like to get into this further the research paper "[Interactive Digital Photomontage](http://grail.cs.washington.edu/projects/photomontage/photomontage.pdf)", goes into using "Double Exposures" (or as it terms it "photo montage"), but making use of user selections expanded using "image segmentation", to select what parts of the image is to come from where.

One example is if you have a number of photos of a large group of people, in each photo someone does not 'look good'.
You can use this technique to select which person comes from which image so that you can get a perfect group photo where everyone is: facing front, with eyes open, and smiling!

### Protect Someone's Anonymity -- fuzzing out some part of a photo {#anonymity}

The above technique of using a 3 image composite mask can also be used in other ways.
For example you can 'pixelate' and image, then use a mask to limit the effect to just the face of a person, so as to "Protect their Identity".

~~~
convert zelda_tn.gif -scale 25%  -scale 400%  zelda_pixelate.gif

convert zelda_tn.gif -gamma 0 -fill white \
        -draw 'circle 65,53 50,40'   zelda_face_mask.gif

convert zelda_tn.gif zelda_pixelate.gif zelda_face_mask.gif \
        -composite   zelda_anonymity.png
~~~

[![\[IM Output\]](zelda_tn.gif)](zelda_tn.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](zelda_pixelate.gif)](zelda_pixelate.gif)
[![\[IM Output\]](zelda_face_mask.gif)](zelda_face_mask.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](zelda_anonymity.png)](zelda_anonymity.png)

Of course you can do this all in one go, and even smooth the change from pixelated to normal.
For example..

~~~
convert zelda_tn.gif \( +clone -scale 25%  -scale 400% \) \
        \( +clone -gamma 0 -fill white \
           -draw 'circle 65,53 50,40' -blur  10x4 \) \
        -composite  zelda_anonymity.jpg
~~~


[![\[IM Output\]](zelda_anonymity.jpg)](zelda_anonymity.jpg)

Of course rather than pixelate the offending part, you can also blur the area instead.
Just replace the two "`-scale`" operators with a single "`-blur`" to fuzz out the details.

### Removing Text and Logos -- filling in 'holes' in a photo {#removing}

Often you have an image with unwanted text or logo on it.
If that text or logo is in a clean area of the image it is usually quite easy to just paint it out, but with photos that use very rarely the case.
More commonly than not, the text is written somewhere within the image proper.

For example here I create a image with some ugly text overlaid.

~~~
convert zelda_tn.gif -gravity Southwest -annotate +8+20 Zelda zelda_text.jpg
~~~


[![\[IM Output\]](zelda_text.jpg)](zelda_text.jpg)

Now the first step in removing any unwanted material from an image, just as it was with [Double Exposures](#double) and [Protecting Someone's Anonymity](#anonymity) is to create a mask of the part of the image that is unwanted.

This is naturally complex and highly dependant on the image involved, (see [Masking](../masking/) for more info).
For our purpose here I'll just generate a mask from the text I overlaid.

~~~
convert zelda_text.jpg -gamma 0 -fill white -stroke white -strokewidth 2 \
        -gravity Southwest -annotate +8+20 Zelda zelda_text_mask.gif
~~~


[![\[IM Output\]](zelda_text_mask.gif)](zelda_text_mask.gif)

The mask will completely overlay the unwanted part, including any and all anti-aliasing semi-transparent pixels.
So it is generally a good idea to ensure it is at least one pixel larger, so as include these pixels.

You can check its coverage by overlaying the mask on the image.

~~~
convert zelda_text.jpg \
        \( zelda_text_mask.gif -background white -alpha shape \) \
        -flatten zelda_mask_overlay.jpg
~~~

[![\[IM Output\]](zelda_mask_overlay.jpg)](zelda_mask_overlay.jpg)

By adjusting the color of the mask overlay you can remove the text, though the result is rarely very nice.

What you want is to color the masked area based on the colors surrounding the mask.
And that can be achieved by 'cutting out' the area, leaving a transparent 'hole' in the image.
Then by blurring the image, you can 'fill in' the hole, using just the surrounding colors.

~~~
convert zelda_text.jpg \( zelda_text_mask.gif -negate \) \
        -alpha off -compose CopyOpacity -composite \
        -channel RGBA -blur 0x2 +channel -alpha off \
        zelda_text_fill.jpg
~~~


[![\[IM Output\]](zelda_text_fill.jpg)](zelda_text_fill.jpg)

The trick with the above that you replaced the unwanted text with transparency, which IM knows has *no defined color* when bluring using "`-channel RGBA`".
As a result every pixel in the 'hole' will recieve a new color that is basied on the surrounding nearby colors.

Of course the resulting pixels will also have some transparency, so we simply 'turn-off' transparency again to remove that, to leave the hole-filling color.

Now you have the appropriate replacement colors within the 'hole', you can do a 3 image masked overlay to overlay just those pixels, so as to remove just the text or logo, and leave the rest of the image as it was.

~~~
convert zelda_text.jpg zelda_text_fill.jpg zelda_text_mask.gif \
        -composite   zelda_text_removed.png
~~~

[![\[IM Output\]](zelda_text.jpg)](zelda_text.jpg)
[![\[IM Output\]](zelda_text_fill.jpg)](zelda_text_fill.jpg)
[![\[IM Output\]](zelda_text_mask.gif)](zelda_text_mask.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](zelda_text_removed.png)](zelda_text_removed.png)

And the text has been removed.
Of course you can do the last two steps in the same command, and in fact as you are using the mask to cut a hole in the image, you can use that as a short cut in the processing.

~~~
convert zelda_text.jpg \( zelda_text_mask.gif -negate \) \
        -alpha off -compose CopyOpacity -composite \
        \( +clone -channel RGBA -blur 0x2 +channel -alpha off \) \
              +swap -compose Over -composite \
        zelda_text_remove_2.jpg
~~~

[![\[IM Output\]](zelda_text_remove_2.jpg)](zelda_text_remove_2.jpg)

Of course it is not very neat, as the blurring of colors in that area makes it obvious that something was removed.
You can especially see this in the blurring of the background window frame.
But as the original information that overlayed by the text has been lost, you can never restore the image perfectly.
It is pretty close however.

There are other ways of 'hole-filling' as I call it, but they have yet to be exampled.
If you like to know more.
Ask on the IM forum.

Here is another removal example, this time removing Zelda's cheeky grin, in a way reminiscent of "The Matrix".

~~~
convert zelda_tn.gif \( +clone -gamma 0 -stroke white -strokewidth 4 \
            -draw 'stroke-linecap round line 59,60 70,59' -negate \) \
              -alpha off -compose CopyOpacity -composite \
              \( +clone -channel RGBA -blur 0x2.5 +channel -alpha off \) \
              +swap -compose Over -composite \
              zelda_lips_removed.jpg
~~~


[![\[IM Output\]](zelda_lips_removed.jpg)](zelda_lips_removed.jpg)

There are other ways of 'hole-filling' a particular area of an image, rather than simply blurring (averaging nearby colors).
For example filling in color using color morphology can produce a much better result.
This is shown by Fred Weinhaus's reply in the IM Discussion Forum on [Text Removal](../forum_link.cgi?p=41498).

Another method is the use of [Sparse-Color](../canvas/#sparse-color) image generation, using the pixels along the edges of the hole.
Even better methods involves linking up similar colors on either size of the mask image so that any continuing lines, details and patterns are not destroyed, but made to continue across the cleared space.
One of the best publically available algorithms for this is part of [GrayCStation Image Inpainting](http://cimg.sourceforge.net/greycstoration/demonstration.shtml).

*If you have any ideas on better 'hole-filling' methods, please let me know.*

### Add a Texture to an Image {#texture}

The [Hardlight](../compose/#hardlight) alpha compositing method or even any of the various [Lighting Composition Methods](../compose/#light) provide ways to give an image a texture pattern.

For example here I add a texture of course fabric to a photo I took of a pagoda at the Kunming Zoo, in southern China.

~~~
convert tile_fabric.gif -colorspace gray  -normalize \
        -fill gray50 +level 35%      texture_fabric.gif

composite texture_fabric.gif  pagoda_sm.jpg \
          -tile   -compose Hardlight    photo_texture.jpg
~~~

[![\[IM Output\]](tile_fabric.gif)](tile_fabric.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](texture_fabric.gif)](texture_fabric.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](photo_texture.jpg)](photo_texture.jpg)

Note that if you want to actually *tile* the texture over the image you need to use the "`composite`" command rather than the more versatile "`convert`" command, though there are a number of other ways to [Tile Images in Memory](../canvas/#tile_memory) using convert.

Also note that when adding a texture like this, the smaller details in the original photo can be lost by excess noise of the overlaid texture, textures should ge hept either simple, or their effect appropriatally moderated, such as the [Decontrasting Level Adjustment](../color_mods/#level_plus) used above.

To use an image pattern as a texture it should be modified so that a perfect gray color is used for areas that is unchanged in the original image.
That is the average color of the image should be about 50% gray.
In the example I demonstrate one way that you can do this with just about any tileable image, though this specific method may not always work well.

Such textures can be found all over the web, as various background patterns for web pages.
They may not even look like a texture, be colorful, or even very bright or very dark.
After adjustment however you will find that you can get some very interesting effects.

Just as we did previously, you can limit what parts of an image is actually textured by creating an appropriate mask.
For example lets create a mask of just the near 'white' sky in the pagoda photo.

~~~
convert pagoda_sm.jpg -fuzz 10% -transparent white \
        -alpha extract -negate  pagoda_mask.png

convert pagoda_sm.jpg  photo_texture.jpg  pagoda_mask.png \
        -composite  photo_texture_masked.jpg
~~~

[![\[IM Output\]](pagoda_mask.png)](pagoda_mask.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](photo_texture_masked.jpg)](photo_texture_masked.jpg)

Now imagine an picture of a lady wearing a dress.
You can get any pattern shade it appropriately, and then overlay that on the original image so as to replace the dress with a completely different design.

Of course there are lots of variations on the above to achieve the final result, and which specific technique you use is up to you, but the basic idea is the same.
Texture the image, mask and overlay the result.

As an aside, I also recommend you look at the [Overlay](../compose/#overlay) alpha composing method, which is simply the same as [Hard\_Light](../compose/#hardlight) composition, but with the two images swapped.
There is also a lot of other [Shading Composition Methods](../compose/#shade) that can be used to texture an image in various ways.

[![\[IM Output\]](shirt.jpg)](shirt.jpg)

### Chroma Key Masking -- Modifying by areas of specific color {#chroma_key}

The photo to the left was given by a user in a [IM Forum Discussion](../forum_link.cgi?t=18094).
he wanted to change the color of the girls shirt, which was a nice 'pink' color.
The problem is the color is not just 'pink' but a whole range of different shades of 'pink'.

As you have seen above, to make changed to an image, the first step is typically generating an appropriate mask of the area you are interested in.
Here I will use a technique known as [Chroma Key](http://en.wikipedia.org/wiki/Chroma_key) to generate mask that specific color.

This technique generally looks for a specific color in an image for use as the mask.

It is also the technique used for 'blue' and 'green' screen effects used extensively on TV and in Movies.

This basically involves extracting the 'Hue' by [Separating Channel Images](../color_basics/#separate), then looking up the 'hue shade' wanted.
For example...
 

~~~
convert shirt.jpg -colorspace HSL -channel Hue -separate shirt_hue.jpg
~~~


However this Hue image has a couple of problems.

-   First a 'pink' color is very close to 'red' which is at the division where Hue 'rolls over'.
    To ensure this is not a problem I use [Modulate](../color_mods/#modulate) to adjust the hue away from that 'discontinuity' in the hue.
    This is not a problem for extracting a 'chroma key' for 'green' or 'blue' screens.
-   This 'pink' color is also not a highly saturated color, but has a very low saturation value.
    This means its 'hue' is not as strong as it should be.
-   The other problem is the gray background!!!!! Gray is has very little hue, so I need to remove any areas with little to no saturation from my final mask, or I'll be changing things in the background.
    Note that this is technically not needed if I limit changes to hue rolls, which does not effect unsaturated colors.

In short, the input image would have worked better with a brighter stronger color that was also not as simial to skin (or hair) color.
A strong blue or green shirt for example.
But I will work with what I was given.

[![\[IM Output\]](shirt_hue.jpg)](shirt_hue.jpg)

So lest extract and combine the two channel masks.
Note that Hue = Gray64 after the image hues was 'rolled' using module, and Saturated = Black for the grey background.

~~~
convert shirt.jpg -modulate 100,100,33.3  -colorspace HSL \
        -channel Hue,Saturation -separate +channel \
        \( -clone 0 -background none -fuzz 5% +transparent grey64 \) \
        \( -clone 1 -background none -fuzz 10% -transparent black \) \
        -delete 0,1  -alpha extract  -compose multiply -composite \
        shirt_mask.png
~~~

That just leaves a number of small isolated 'specks' that can be removed with some [Morphology Smoothing](../morphology/#smooth) (`-morphology Smooth Square`).
It isn't perfect but it will do the job.
The better way would be to edit the mask by hand to clean it up.

Now a mask can be used with [Composite Masking](../compose/#mask) much like we did with [Double Exposures](#double) and [Anonymity](#anonymity) examples above.

However If you are using a mask to modify an existing image (without distorting, or changing the images size), then it is easier to use it to define what areas are un-writable.
These are known as [Clip or Write Masks](../masking/#clip-mask) (see "`-mask`"

[![\[IM Output\]](shirt_mask.png)](shirt_mask.png)

Here I cleanup the previous mask of the small defects (optional), and negate it to define what areas I want to 'write protect'.
Then I set this mask, shift the hues to turn 'pink' into a 'light blue' color, and save the resulting image.

~~~
convert shirt_mask.png -morphology Smooth Square \
        -negate   shirt_write_mask.png

convert shirt.jpg  -mask shirt_write_mask.png \
        -modulate 100,100,25     +mask shirt_blue.jpg
~~~

Yes there is a slight 'pink' border, especially in the inside sleeve.
Also a small area of skin on her arm turned a rather dark blue.
Basically these are mask defects, and with a little more work in perfecting the mask you can fix these problems.
But it is not bad result.

One method of generating a better mask is to use a much larger higher resolution image.
When the resulting image is later resized these small defects will (hopefully) also be reduced to insignificance.

[![\[IM Output\]](shirt_blue.jpg)](shirt_blue.jpg)

The real problem with this specific example, is the 'key color' is so close to a normal skin color you are really just asking for trouble! This is why people using this technique use 'green' and 'blue' screens, as those colors are as different as possible from 'skin' color of people in front of the screen.

Note that you are better off NOT using JPEG as your source or working images.
Really JPEG should only be used for your final images only! This is part of the reason why so many 'mask defects' was generated in the first place.

### Green Screen {#green_screen}

*FUTURE: example, using Chroma Key Masking of a 'green screen background'. Expanded from the wikipedia artical, [Chroma Key](http://en.wikipedia.org/wiki/Chroma_key)*

Real problems in 'green screen' handling is the 'color spill', with fine light color hair (blonde) and semi-transparent areas producing the worse color spill effects.

Simplistic Colorspill removal (color fix)

`g(r,g,b) => (r, min(g, b), b)`

Alpha determination...

`a(r,b,g) =>  K0 * b − K1 * g + K2`

Using values of 1.0 for all K coefficients is good initial guess.

As the Background color is well known, and once the 'alpha' is known you can use techniques shown in [Background Removal using Two Backgrounds](../masking/#two_background) to remove any 'green screen halo' that may be present better that the first color formula.

### Artist Charcoal Sketch of Image {#charcoal}

The [Charcoal Sketch Transform](../transform/#charcoal), offers users a very simple way of generating a simplified gray-scale rendering of the image.

It does not work well for 'busy images' but for simpler images it can produce a very striking result.

~~~
convert holocaust_sm.jpg -charcoal 5 charcoal.gif
~~~

[![\[IM Output\]](holocaust_sm.jpg)](holocaust_sm.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](charcoal.gif)](charcoal.gif)

### Children's Color-In Outline Image {#color-in}

In a long discussion about [Generating Coloring-In Pages](../forum_link?t=6974) on the IM Users Forum, the following cookbook recipe was developed to convert a simple photo into something children can color in.
Here is the best result we have so far, applied to a photo I took of the holocaust memorial, Berlin.

~~~
convert holocaust_sm.jpg \
        -edge 1 -negate -normalize \
        -colorspace Gray -blur 0x.5 -contrast-stretch 0x50% \
        color-in.gif
      # For heavily shaded pictures...
      #     #-segment 1x1 +dither -colors 2 -edge 1 -negate -normalize \
~~~

[![\[IM Output\]](holocaust_sm.jpg)](holocaust_sm.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](color-in.gif)](color-in.gif)

The final operations in the above attempt to smooth out the lines and improve the overall result.

Of course the above technique is only useful for images with good sharp color changes, and preferably a higher resolution image than I used above.

For cartoon images that already have black outlines with a light colored background, the use of [Edge Detection](../transform/#edge) with the above method will directly produce a 'twinning' effect of the black outlines.
You can see this effect in the twinned lines of tiles on the path leading into the memorial, in the lower-left corner.

This is an artifact of the way [Edge Detection](../transform/#edge) works, and you can see more examples of this in that section of IM Examples.

The solution is to negate images of this type before using "`-edge`" to outline the colored areas.

~~~
convert piglet.gif -background white -flatten \
        -colorspace Gray -negate -edge 1 -negate -normalize \
        -threshold 50% -despeckle \
        -blur 0x.5 -contrast-stretch 0x50% \
        color-in_cartoon.gif
~~~

[![\[IM Output\]](piglet.gif)](piglet.gif)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](color-in_cartoon.gif)](color-in_cartoon.gif)

I also "`-threshold`" so I can then remove individual dots that "`-edge`" seem to like to generate.
After that I again attempt to smooth out the aliased lines in the image.

The above was added to in a discussion on [GIMP Photocopy Filter](../forum_link?t=6974) to make use of the [Compose Divide](../compose/#divide) method, to find outlines.

~~~
convert taj_mahal_sm.png -colorspace gray \
        \( +clone -blur 0x2 \) +swap -compose divide -composite \
        -linear-stretch 5%x0%   photocopy.png
~~~

[![\[IM Output\]](taj_mahal_sm.png)](taj_mahal_sm.png)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](photocopy.png)](photocopy.png)

The "`-linear-stretch`" operation in the above adjusts how black the dark areas of the images will be, while the "`-blur`" 'sigma' defines the shading sharpness.

### Pencil Sketch {#pencil}

Using a [Photoshop (PSP) tutorial](http://www.state-of-entropy.com/) on converting images to [Pencil Sketches](http://www.state-of-entropy.com/sketching.htm), *[dognose](../forum_link.cgi?u=3441)* from the [IM Users Forum](../forum_link.cgi?f=1), managed to create the equivalent ImageMagick commands.
Here is his conversion, simplified into a few IM commands, allowing you to batch process lots of images into a 'artists pencil sketch' form.

First we need a special "`pencil.gif`" image.
This can take a long time, so for this example I made it a bit smaller, while preserving its ability to be tiled across larger images.
See [Modifying Tile Images](../canvas/#tile_mod) for details of the techniques.

This only needs to be done once and can then be re-used.
As such you can generate a much larger one for your own use, so as to avoid any tiling effects.
Ideally make it as large as the images you plan to convert.

~~~
convert -size 256x256 xc:  +noise Random  -virtual-pixel tile \
           -motion-blur 0x20+135 -charcoal 1 -resize 50% pencil_tile.gif
~~~

[![\[IM Output\]](pencil_tile.gif)](pencil_tile.gif)

Now it is only a matter of overlaying and blending this 'pencil' shading image with a photo.
The pencil image is tiled to make a canvas the same size as the image we are processing.
Then it is applied to the image using techniques found in [Tiled Canvases](../canvas/#tile).
This is then merged into a gray-scaled copy of the original image.

~~~
convert pagoda_sm.jpg -colorspace gray \
        \( +clone -tile pencil_tile.gif -draw "color 0,0 reset" \
           +clone +swap -compose color_dodge -composite \) \
        -fx 'u*.2+v*.8' sketch.gif
~~~

[![\[IM Output\]](pagoda_sm.jpg)](pagoda_sm.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](sketch.gif)](sketch.gif)

Note that as the "`-blend`" operator of the "`composite`" command is not available to the "`convert`" command, I opted to do the equivalent using the DIY "`-fx`" operator.
There are probably better, faster but more complicated ways of doing this.
(suggestions are welcome)

This is not the final version, as the operator misses some edge enhancement aspects needed for outline some of the more lighter but sharp color changes in the image.
Can you improve the above?

The above algorithm was built into IM as a artistic transform "`-sketch`", though without the "`-resize`" smoothing for the generated 'pencil tile'...

~~~
convert pagoda_sm.jpg -colorspace gray -sketch 0x20+120 sketch_new.gif
~~~

[![\[IM Output\]](pagoda_sm.jpg)](pagoda_sm.jpg)
![==&gt;](../img_www/right.gif)
[![\[IM Output\]](sketch_new.gif)](sketch_new.gif)

### Vignette Removal {#vignettation}

When taking photos (digital or otherwise, the camera lens generally darkens the edges and corners of the image.

This is called 'vignetting'.
In fact this lens effect is so common, it is often faked on purpose using the "`-vignette`" operator.
See the [Vignette Transform](../transform/#vignette).

Martin Herrmann &lt;Martin-Herrmann@gmx.de&gt; wanted to remove camera vignetting from the photos.
Basically he took a photo of a white sheet of paper in a bright light without using a flash.
He then wanted to combine this with his actual photos to brighten the edges and corners of the image appropriately.

Basically what we want to do is divide the original photo by the grey-scale image of the photo of the brightly lit white piece of paper and it will then brighten the parts of the image by the amount that the 'white paper' photo was darkened.

This is basically the compose method '`Divide`' which divides the 'source' image by the 'background' image.
For example,

~~~
convert nikon18-70dx_18mm_f3.5.jpg  vegas_orig.jpg \
        -compose Divide -composite  vegas_fixed.jpg
~~~

[![\[photo\]](vegas_tn.gif)](vegas_orig.jpg)
![ +](../img_www/plus.gif)
[![\[photo\]](nikon18-70dx_18mm_f3.5.gif)](nikon18-70dx_18mm_f3.5.jpg)
![==&gt;](../img_www/right.gif)
[![\[photo\]](vegas_fixed.gif)](vegas_fixed.jpg)\
(click to see larger photo image)

However as the photo of the 'white paper' will probably not be a true white, and you probably do not want to brighten the image by this 'off-white' color.
To fix this we need to multiply the divisor image by its the center pixel color.

Here is the final solution provided to Martin, which used the very slow [FX DIY Operator](../transform/#fx).
This pre-dated the addition of a [Divise Compose Method](../compose/#divide) which can be used to speed up this process enormously.

The white photo was also grey scaled to remove any color distortion as well, note that I changed the ordering which will also preserve any 'meta-data' that was in the original (as it is the 'destination' image in this case.

~~~
convert vegas_orig.jpg \( nikon18-70dx_18mm_f3.5.jpg -colorspace Gray \) \
        -fx '(u/v)*v.p{w/2,h/2}'   vegas_fixed_fx.jpg
~~~

[![\[photo\]](vegas_fixed_fx.gif)](vegas_fixed_fx.jpg)

If you look carefully at the enlarged photos, particularly the top-left and top-right 'sky' corners, you can see the vignetting effects, and the correction that was made.

It is not a perfect solution, and could use a little more tweaking.
For example rather than using a scaling pixel, we could pre-process the 'white page' image, and also adjust it for a better vignette removal result.

Note that using JPEG is not recommended for any sort of photographic work, as the format can introduce some artifacts and inconsistencies in the results.
The format is only good for storage and display of the final results.

A major discussion on correcting vignettation is in the IM User Forums in the discussion [Algorithmic vignetting correction for pinhole cameras?](../forum_link.cgi?f=1&t=18944).

Things that can effect vignettation include...

-   Distance of film from lens, further away means more light spread.
-   Area of the aperture 'circle' (lens or pinhole) due to angle of light.
-   Arrangement of camera material around the aperture.
    For example the lens holder or pinhole thickness.

---
created: 21 July 2006
updated: 16 June 2011
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html) &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.9-8
url: http://www.imagemagick.org/Usage/photos/
---
