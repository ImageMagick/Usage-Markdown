# Creating Thumbnails and Framing

One of the biggest uses ImageMagick is put to is the creation of thumbnails for family photo albums, sports and hobby pages, catalogs, and so on.
Typically for use on the world wide web or in photo CDs.

This page provides examples and techniques used to generate thumbnails.

------------------------------------------------------------------------

## Thumbnail Storage {#storage}

I would like to first start with one very important point.

The original image from video cameras and photo scanning should be kept in a safe place in the original format, preferably a non-lossy format (not the JPEG image format), without any modification resizing or other change, except possibly a file name change.
Of course a scanned image can be re-scanned, but it is simpler to re-use your original scanning than to re-do it again later.

This is VERY important as any form of modification will mean a loss of some information in the image, and provides a source from which you can re-work your image for other uses.
The original image does not have to be your working image, which may be resized or color adjusted for display, just be sure to have your image saved and backed up somewhere safe for future use.

The next thing to do, even before you create any thumbnails, is to decide how you want to save your thumbnail relative to your normal sized image format, then stick to that scheme.
This is especially important for web pages.

Schemes include...

-   Save the main photo image in the lossy JPEG format at the size you want or need, then use the same name for the generated thumbnail but using the GIF image format.
    EG Same filename but a different format and suffix.
    Main Image: `photo_name.jpg` ![](../img_www/space.gif) Thumbnail: `photo_name.gif`
-   Store the thumbnails with the same name in a sub-directory called for example "`thumbs`" or whatever is convenient for you.
    Main Image: `photo_name.jpg` ![](../img_www/space.gif) Thumbnail: `thumbs/photo_name.jpg`
-   Use the same format as the original image, but with an extra string added to the file name.
    Typical string additions include "`_tn`", "`_small`", "`_thumb`", etc...
    Main Image: `photo_name.jpg` ![](../img_www/space.gif) Thumbnail: `photo_name_tn.jpg`
-   Some combination of the above.
    There is no reason why you cannot save thumbnails in different image format, with a extra image suffix appended to the filename, and saved in a subdirectory!
    Main Image: `images/photo_name.jpg` ![](../img_www/space.gif) Thumbnail: `thumbs/photo_name.jpg.gif`
    This is actually quite common on the WWW, and I have even seen the the two directories stored on completely separate machines!

The first scheme can use "`mogrify`" to generate all your thumbnails, without destroying the original image, by using a "`-format`" setting to specify the output image format.

As of IM v3.2.0, the second scheme is now also possible to do with "`mogrify`" thanks to the addition of a special "`-path`" setting that specifies a different directory in which to save the modified images.

For example, this converts JPG images into GIF thumbnails in a "`thumbs`" sub-directory that was just created.
  
      mkdir thumbs
      mogrify  -format gif -path thumbs -thumbnail 100x100 *.jpg

The other methods will require you to either, first make a copy of the original image, before running "`mogrify`", create a special script to process the images, or some other DIY method.
A number of the simpler non-IM techniques are detailed at the end of the example section for [Batch Processing - Without using "`mogrify`"](../basics/#mogrify_not).

Whatever method you choose the important thing is to choose a scheme for thumbnail storage, and then stick with it.
By using the same scheme for all your thumbnails you can then write shell or Perl scripts to make thumbnail generation and even generation of the HTML links easy.
More on this later.

### Selection of the Thumbnail format {#formats}

The format in which you save a thumbnail can make a big difference to its final size on disk and download speed for web pages.
In this regard I recommend you study the summary of the various [Common File Formats](../formats/#summary).

Specifically you should note...

**JPEG** compresses well and is lossy, but is designed for large real world images, not small thumbnails.
It also does NOT allow any form of transparency.
In summary, the format is good for large images, bad for thumbnails.
Watch out for profiles (see next section).

While JPG is not recommended for thumbnails, for viewing images on the WWW it is recommended you use smaller 800x600 pixel image, at a much lower "`-quality`" percentage (say 50 or even 30%), though it will not look very good.

It has also been suggested that using "`-sampling-factor     2x1`" will also produce a smaller JPEG image size.

I do not recommend the full original image never be placed directly on the web, unless temporarily (at a referenced location) for a friend to download.
Remember do not link to it, (even by directory indexing), and never for more than a day, or it may be Googled.

**GIF** works for simple small images, and compresses okay.
It has a color limit of 256, but for small images this is rarely noticeable.
It can also do cartoon like animations of images, not that that is needed for thumbnails, unless you really what to get fancy.

What is a problem is that the format only has Boolean (on/off) transparency, which makes for horrible looking borders on shaped images.
The solutions to that is to design the thumbnail to only use Boolean transparency, or arrange it so it can only be used on a specific background color.
For details see the examples on [GIF's on a background color or pattern](../formats/#bgnd).

**PNG** is the modern ideal format for thumbnails.
It has a good compression, and internal format styles.
It is non-lossy, and can display all colors, and these days it is understood by almost all browsers, (though for Microsoft Internet Explorer, before v7, needs some java scripting added to web pages).

More importunately this format understands semi-transparent color, making shadows and edges sharp and clear, or faded and blurry as you wish.
This format however does not do animations, though the related MNG format does.
Very few browsers seem to support that format however.

For thumbnails you can reduce the size of the final image by reducing the depth and number of colors, as well as setting a higher "`bzip`" compression quality (first digit in "`-quality`") for your final thumbnail image.

For example, the following is suggested for small PNG thumbnails that does not involve transparency.
  
            -strip  -quality 95  PNG8:thumbnail.png
        

Which uses a smaller, 8 bit, or 256 color limited, PNG format.

You can also re-process the final image though secondary applications (See [Non-IM PNG Processing](../formats/#png_non-im)) which can automatically find the best PNG compression for that specific image.
There are also programs to do that color reduction to the smaller internal PNG format, while preserving semi-transparent colors.
This is something IM currently does not handle.

**One final word about formats...** No matter what format you use for your thumbnails, if you must save an intermediate unfinished image, use a PNG (without any color reduction) or MIFF image format.
Doing this will preserve as much color information about the image as possible in the intermediate stage.
Only do color reduction, or save to GIF or JPEG formats as a absolute final step.

This is important, so I repeat...

**Do NOT use JPEG, PNG8, or GIF for intermediate working images!
Better to use PNG or MIFF.**

### Profiles, Stripping, and JPEG Handling {#profiles}

Many images from digital cameras, scanning software, and some paint programs (photoshop is notorious for this), save extra information about the image in the form of **profiles**.
This includes image formats such a JPEG, PNG, TIFF and as of IM v6.2.4-1 GIF.
Of course the IM specific format, MIFF also does this.
(See [Image Profiles](../formats/#profiles) for more detailed information).

These profiles can be up to 60 Kb in size, so can make a big difference to your file size, and by default IM will preserve this profile information.
Thumbnails have no need for this data and often not even the main image needs it.

You can also remove the profiles from your images with the IM commands...
  
      convert input.jpg  -strip output.jpg

      mogrify -strip  *.jpg

You can also use the option "`-profile '*' `" to remove the profiles.

It is however recommended you only strip profiles when you modify an image, especially if reducing it in size for web displays, or thumbnail images.

Stripping profiles while resizing, particularly for generating smaller thumbnail images, is so common that both "`-resize`" and "`-strip`" were combined into a new operation, just for this very purpose.
Naturally enough this resize operation is called "`-thumbnail`".

For example...
  
      convert -define jpeg:size=240x180 image.jpg -thumbnail 120x90 thumbs/image.gif

      mogrify -path thumbs -format gif -define jpeg:size=240x180 -thumbnail 120x90 '*.jpg'

  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.5.4-7 the "`-thumbnail`" would strip ALL profiles from the image, including the ICC color profiles.
From this version onward the color profiles will be preserved.
If the color profile is not wanted then "`-strip`" all profiles.*

The "`mogrify`" will of course generate thumbnails for a whole directory of JPEG images, but be careful it does not overwrite any thumbnails you want to keep.
For a number of other non-IM methods for looping over a large number of images see the example section for [Batch Processing - Without using Mogrify](../basics/#mogrify_not).

For very large images the "`-thumbnail`" resize operator goes further and first scales the image down to 5 times the final thumbnail size first, before doing the actual resize operation.
This speeds up the thumbnail generation further.

However for thumbnailing JPEG images, a even better method of limiting the initial image size can be used, by just not reading the whole image into memory in the first place.

The "`-define jpeg:size=`" setting (as shown in the above example) is a special hint to the JPEG image library to reduce the amount data that is read in from VERY BIG JPEG images.
See [Reading JPEG Files](../formats/#jpg_read).
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
Before IM v6.5.6-0 this coder setting was extracted from the "`-size`" setting.
This caused problems when users used "`-size`" for image creation but then had JPEG reading produce unexpected results.
As such this was changed to be a special coder setting instead.
  
In older versions of IM you may need to reset the setting using "`+size` before reading JPEG images, because of this 'dual' role.

From IM version 6.2.6-2, a new [Read Image Modifier](../files/#read_mods) was added, which lets you resize the input image immediately after it is read in.
This option will work with ANY image format, not just JPEG image.
It is however no substitute for using a "`-define jpeg:size=`" setting for JPEG images.

As such the recommended way of resizing ANY input image format is now...
  
      convert -define jpeg:size=240x180 input.img'[120x90]' \
              -strip  output_thumbnail.gif

Well on with the practical IM thumbnail examples...

------------------------------------------------------------------------

## General Thumbnail Creation {#creation}

### Generate Thumbnails in General (specific height) {#height}

Lets convert a [large sample JPEG image](hatching_orig.jpg) to a GIF thumbnail 90 pixels high with the width automatically adjusted (within the 250 pixel width limit) preserve the aspect ratio of the image.
  
      convert -define jpeg:size=500x180  hatching_orig.jpg  -auto-orient \
              -thumbnail 250x90   -unsharp 0x.5  thumbnail.gif

  
[![\[IM Output\]](thumbnail.gif)](thumbnail.gif)

Note that I used the "`-thumbnail`" option above.
This not only resizes the image, but strips any and all profile and comment information that may be present in the original JPEG image.
Also as it uses the "`-sample`" resize operator for the initial downsizing of the image, it is reasonably fast, and produces good results for small thumbnails.

I also set a minimum "`-define jpeg:size=`" for the image being read in.
This is passed to the JPEG library, which will return an image somewhere between this size and double this size (if possible), rather that the whole very large original image.
Basically don't overflow the computers memory with an huge image when it isn't needed.

The JPEG size hint I use is at least double that of the final thumbnail so that resize will still generate a reasonable looking result.

The "`-auto-orient`" operator ensures that the image, if from a digital camera, is rotated correctly according to the camera's orientation.
This is not needed for the 'desktop' image I am using, but I included it in the above for digital camera users.

The result is a thumbnail of a specific height, but variable width.
I use this thumbnail for my own web pages so that a series of image in a row, will all match up height wise, forming a neat look.

The 250 pixel width limit in the above is important.
If left unset, IM would have complete width freedom (EG: using "`-thumbnail x90`" ).
This could result in problems when generating thumbnails of long thin images such as those shown in [Web Line Images](http://www.cit.griffith.edu.au/images/FancyLines/Images.html).
The result in that case would be very very long, *enlargement* of the image, instead of a small thumbnail.

Some people (including myself) find that while IM's resize is one of the best implementations (See [IM Resize vs Other Programs](../filter/#photoshop)), the result is still a little blurry.
As such you can improve the above result by sharpening the image slightly (using "`-unsharp`") after the "`-thumbnail`" resize operation.
For more information see [Sharpen Resized Images -- Photoshop Resize Technique](../resize/#resize_unsharp), But really it all comes down to a matter of personal taste.

The "`mogrify`" version is the same as the "`convert`" command (with no initial input images), but will but will generate automatic thumbnails of *every* JPEG image in the current directory.
The image argument is quoted so that IM itself will scan the directory, and not the command line shell.
This prevents 'line limit overflow errors' on directories containing a huge number of images.
  
      mogrify  -format gif -define jpeg:size=500x180 -auto-orient \
                    -thumbnail 250x90 -unsharp 0x.5  '*.jpg'

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
Note that "`mogrify`" will blindly create thumbnails, replacing any existing images of the same name.
GIF images in this case.
Extreme caution is always advised when using this command.
  
Backup copies are always recommended before doing any processing.
  
![](../img_www/expert.gif)![](../img_www/space.gif)
  
*Instead of specifying a different format (using "`-format`") so as to prevent "`mogrify`" from overwriting the original source images, you can use a "`-path`" setting to define a separate thumbnail directory.
You can use both output options.*

While "`mogrify`" can output the new images with a different suffix ("`-format`") or directory ("`-path`"), they are your only options using this command.

If you are also wanting to change the name of the image, such as adding a "`_tn`" or "`_sm`" to denote thumbnail or small versions of the image, then I recommend you create a shell script to do the job for you, processing them one at a time using "`convert`".
    *I wrote such a script to do this, while simultaneously generating HTML indexes at the same time.*  

### Resize Thumbnail to Fit {#fit}

Another form of automatic thumbnail generation is shrink image to fit a fixed sized box, say "`100x100`" but keeping the images aspect ratio.
Well that is the default meaning for a resize geometry setting.
  
However I prefer not to enlarge images which already fit such a box.
For that you need to add a "`>`" to the geometry string.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg \
              -thumbnail '100x100>' rectangle.gif

  
[![\[IM Output\]](rectangle.gif)](rectangle.gif)

As before the aspect ratio of the image is preserved, as such the thumbnail is unlikely to be exact 100 pixels square.
However at least one of the images dimensions will be 100 pixels.

### Pad Out the Thumbnail {#pad}

The next most common request is to generate thumbnails that fill out the image with borders of a specific color (usually '`black`', or '`transparent`' but for these examples I will use '`skyblue`') so the thumbnail is exactly the size you wanted.

For example: An image which is 400x300 pixels shrunk to fit a 100x100 pixel box will normal (with the above) have a size of 100x75 pixels.
We want to add some padding borders to the top and bottom of the image (and to the sides to be sure) to make the final thumbnail image always 100x100 pixels in size.
  
There are a number of ways to do this, and as of IM v6.3.2 the best way is using the "`-extent`" option.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg -thumbnail '100x100>' \
              -background skyblue -gravity center -extent 100x100 pad_extent.gif

  
[![\[IM Output\]](pad_extent.gif)](pad_extent.gif)
  
Before IM v6.3.2 the best way was to add extra borders and do a centered "`-crop`" on the image after adding a large border around the image.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg -thumbnail '100x100>' \
              -bordercolor skyblue  -border 50 \
              -gravity center  -crop 100x100+0+0 +repage pad_crop.gif

  
[![\[IM Output\]](pad_crop.gif)](pad_crop.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The "`+repage`" operator is important to remove any 'virtual canvas' or 'page' information that crop preserves.
IM v5 users need to use "`-page +0+0`" instead.*
  
As of IM version 6.2.5, you can also use a [Viewport Crop](../crop/#crop_viewport), and flatten the result onto a background color.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg -thumbnail '100x100>' \
              -gravity center  -crop 120x120+0+0\! \
              -background skyblue  -flatten    pad_view.gif

  
[![\[IM Output\]](pad_view.gif)](pad_view.gif)
  
Another method to pad out an image is to overlay the thumbnail onto a background image (actual image, solid color or tiled canvas) that is the right size, in this case the 128x128 "`granite:`" built-in image.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg -thumbnail '100x100>' \
              granite: +swap -gravity center -composite pad_compose.gif

  
[![\[IM Output\]](pad_compose.gif)](pad_compose.gif)

This method is probably the best method to use with older versions of IM (such as IM v5), though the "`-composite`" operation will need to be done by the separate "`composite`" command, rather than the above single command method.

### Cut the Thumbnail to Fit {#cut}

An alternative, is rather than pad out the image to fit the specific thumbnail size we want, is to instead cut off the parts of the image that does not fit the final size.

Of course this means you actually lose some parts of the original image, particularly the edges of the image, but the result is a enlarged thumbnail of the center part of the image.
This is usually (but not always) the main subject of the image, so it is a practical method of thumbnail creation.

As of IM v6.3.8-3 the special resize option flag '`^`' was added to make this easier.
We just resize using this flag then crop off the parts of the image that overflows the desired size.
  
      convert -define jpeg:size=200x200 hatching_orig.jpg  -thumbnail 100x100^ \
              -gravity center -extent 100x100  cut_to_fit.gif

  
[![\[IM Output\]](cut_to_fit.gif)](cut_to_fit.gif)

As you can see the thumbnail of the image is much larger and more detailed, but at a cost of cutting off the sides off the original image.

For more information on this option see [Resize to Fill Given Area](../resize/#fill).
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Before IM v6.3.8-3 when this special flag was added, you would have needed some very complex trickiness to achieve the same result.
See [Resizing to Fill a Given Space](../resize/#space_fill) for details.*

### Area Fit Thumbnail Size {#areafit}

The last two methods will often make an image very small with a lot of extra padding, or, it will cut off a lot of the image so as to completely fill the space.
However by using a different resize flag, it is possible to get a thumbnail that is between these two extremes.

For example a 100x100 pixel thumbnail has 10,000 pixels.
Now if we ask resize to size out image to something around that many pixels in size (using the [resize '`@`' flag](../resize/#pixel)), you will have an image that will need both a little padding and a little cutting.
This maximizes the size of the resulting thumbnail, while not cutting away too much.

For example...
  
      convert -define jpeg:size=200x200 hatching_orig.jpg  -thumbnail 10000@ \
              -gravity center -background skyblue -extent 100x100  area_fit.gif

  
[![\[IM Output\]](area_fit.gif)](area_fit.gif)

As you can see the thumbnail has some padding, and the image has some cropping, but the result is probably about the best fit of image to a given thumbnail space.

### Fit to a Given Space Summary {#fit_summary}

In summary, here are the results of the three methods for thumbnailing an image to a specific sized area.
All three methods use exactly the same code, with just with a slight change in the resize argument/flag used.

[![\[IM Output\]](pad_extent.gif)](pad_extent.gif)  
Padded Fit  
resize, no flag
[![\[IM Output\]](area_fit.gif)](area_fit.gif)  
Area Fit  
resize, '@' flag
[![\[IM Output\]](cut_to_fit.gif)](cut_to_fit.gif)  
Cut to Fit  
resize, '^' flag
  

### Square Padding and Cropping {#square}

The above padding and cropping methods assume you know the final size of the area in which you want the image to fit.
But that is not always the case.

Sometimes you want to simply 'square an image', either by 'padding' it out (external square), or 'shaving' the edges (internal square).

From the IM Discussion Forums on [Squaring Images](../forum_link.cgi?f=1&t=20601) a number of methods were developed.

External Squaring can be done using [Mosaic](../layers/#mosaic) to create a larger background canvas using a rotated copy of the image.
  
      convert thumbnail.gif \
              \( +clone -rotate 90 +clone -mosaic +level-colors white \) \
              +swap -gravity center -composite    square_padded.gif

  
[![\[IM Output\]](square_padded.gif)](square_padded.gif)

Internal Squaring on the other hand is a little harder and requires more work to achieve.
This one uses some heavy mask handling to generate a smaller canvas.
  
      convert thumbnail.gif \
              \( +clone +level-colors white \
                 \( +clone -rotate 90 +level-colors black \) \
                 -composite -bordercolor white -border 1 -trim +repage \) \
              +swap -compose Src -gravity center -composite \
              square_cropped.gif

  
[![\[IM Output\]](square_cropped.gif)](square_cropped.gif)

An alternative way is to use a no-op distort using a distort viewport crop/pad the image.
Essentially it uses a 'percent escapes' to do the calculations needed for an [Extent](../crop/#extent) type of operation.

External (padding) square...
  
      convert thumbnail.gif  -virtual-pixel white -set option:distort:viewport \
         "%[fx:max(w,h)]x%[fx:max(w,h)]-%[fx:max((h-w)/2,0)]-%[fx:max((w-h)/2,0)]" \
         -filter point -distort SRT 0  +repage  square_external.gif

  
[![\[IM Output\]](square_external.gif)](square_external.gif)

The [Virtual Pixel](../misc/#virtual) setting is used to specify the padding color.

Internal (cropped) square...
  
      convert thumbnail.gif   -set option:distort:viewport \
         "%[fx:min(w,h)]x%[fx:min(w,h)]+%[fx:max((w-h)/2,0)]+%[fx:max((h-w)/2,0)]" \
         -filter point -distort SRT 0  +repage  square_internal.gif

  
[![\[IM Output\]](square_internal.gif)](square_internal.gif)

Curtisy of [Fred Weinhaus's Tidbits Page](http://www.fmwconcepts.com/imagemagick/tidbits/image.php#pad_crop_square).

This is a simplier version, but will lose any meta-data (like comment strings or profiles) the image may have.
  
      convert thumbnail.gif -set option:size '%[fx:min(w,h)]x%[fx:min(w,h)]' \
              xc:none +swap -gravity center -composite square_internal_2.gif

  
[![\[IM Output\]](square_internal_2.gif)](square_internal_2.gif)
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*IMv7 will allow you to do the above mathematics directly as part of a crop or extent argument, which will prevent loss of image meta-data.*

### Manual Cropping {#manual}

The normal way I generate thumbnail images for use on my web pages, is a mix of automatic and manual scripts.
The final setup of my images are..

-   I use a PNG or TIFF for the original ,VERY large, scan of the photo.
    OR the original JPEG image downloaded from a digital camera.
    Basically for the unmodified original source image, for archiving.
    I also now like to include the string "`_orig`" in this images filename.
-   A smaller JPEG image format for a web viewable image when the thumbnail is clicked or selected.
    This image is resized to fit a 800x800 pixel box, which is a size suitable for viewing by most web users.
    I typically add a "`_md`" for medium sized image, in the filename.
-   And lastly a GIF thumbnail resized to a fixed 90 pixel high, and variable width.
    This allows centered rows of thumbnails on web pages to look reasonable neat and tidy, but which automatically fills the browser windows width, no matter what size browser they are using.
    Again I typically now include a "`_tn`" in the images filename, to denote that it is a thumbnail.

I first generate the web viewable JPEG images (medium size) using "`mogrify`" from the original scanned image.
This is reduces the download time and viewing size of the image to something that is practical for the typical web user (who could be logged in via modem).

From these images I generate an initial set of thumbnails, again using "`mogrify`".
However I often find in typical photos that the subject of the thumbnails becomes too small to make an effective thumbnail, when viewed.

To fix this I examine the automatically generated thumbnails, and in about half the cases manually create my own 'zoomed in on subject' thumbnail.

I read in the JPEG image, and crop it down the main subject of the image effectively 'zooming in' on the subject of the photo, and removing bulk of the background context of the image.
This is then smoothed and thumbnailed, either using a "`convert -thumbnail`", or more often in the same graphic program I am viewing and cropping the images with (usually "`XV`", see below).

So instead of a thumbnail where the people in the photo are hardly visible (left), I have manually cropping around the subject, highlighting the main point of the photo (right), before thumbnailing.
That allows users to see the image content more clearly and thus better decide if they actually want to download and look at the larger JPEG version of the image.

**Queensland KiteFlyers, Ron and Val Field**
[![\[IM Output\]](kiteflyers_auto.gif)](kiteflyers_orig.jpg)  
Automatically  
GeneratedThumbnail
![](../img_www/space.gif)
[![\[IM Output\]](kiteflyers_man.gif)](kiteflyers_orig.jpg)  
Manually Cropped  
and Resized  
Thumbnail

**(Click on either image for original scanned photo)**

This is of course more manually intensive, but only needs to be done once per image, and only on images that have a lot of space such as in the above example.
Also I only do this for images I am putting the web.

Of course as "`mogrify`" will overwrite any existing, possibly hand generated thumbnails, you cannot use it again after you perform any manual thumbnail generation.
The "`mogrify`" command is useful, but also very dangerous as it overwrites lots of images.
Always think before you run "`mogrify`" globally across all your images.

### HTML Thumbnail Pages {#html}

Once I have all the thumbnail images sorted out in the directory I use a special perl script called "`thumblinks`" I wrote that look for the images (JPEG photos and GIF thumbnails), and generate HTML links, and even full HTML photo pages.

The script will read and include size of the GIF thumbnail size in the HTML, and attach pre-prepared header and footer files around the thumbnail links.
The script will also remove any thumbnail links from the list it generates, if it finds an existing link in the header or footer file itself.

This may sound complex, but it makes my HTML page generation very fast and flexible, and ensures ALL image thumbnailed images in a directory have been added to that directories index page, while still letting me comment on specific images in the index header.
It also makes the page independent of the users window size, automatically adjusting to suit.

For a simple example of my "`thumblinks`" script output see [Tomb of Castle Artworks](http://www.ict.griffith.edu.au/anthony/art/).

For a quick example and starting point for generating such links look at the examples of using the [identify command](../basics/#identify).

### FavIcon Web Page Link Thumbnail {#favicon}

The "`favion.ico`" icon often looked for by web browsers on the top level web page of a web site, for that whole site.
That image is a special multi-resolution image format and can be created as follows.
  
      convert image.png  -bordercolor white -border 0 \
              \( -clone 0 -resize 16x16 \) \
              \( -clone 0 -resize 32x32 \) \
              \( -clone 0 -resize 48x48 \) \
              \( -clone 0 -resize 64x64 \) \
              -delete 0 -alpha off -colors 256 favicon.ico

The '`large_image.png`' can be anything you like, but should be square.
If it isn't that should also be the first step in the above.

You can also include larger resolutions such as 128 or 256 pixels, but few browsers would make use of them.
The 16 and 32 pixel reolotions are much more common.
Also many browsers will fewer color reduce the images so are to reduce the space used to store it in a users bookmarks file.

This brings us to one other point.
As only the smallest of images are typically used, with further color reduction, it is recommented to keep the images as small and as well defined as posible.

As mentioned only the "`favion.ico`" image found on the top level directory of a web site is generally used, however you can also specify the location of the link thumbnail image by adding the following HTML tag to the headers of your pages...
  
      <LINK REL="icon" HREF="/path/to/favicon.ico" type="image/x-icon">
      <LINK REL="shortcut" HREF="/path/to/favicon.ico" type="image/x-icon">

The "`/path/to/favicon.ico`" can be a absolute or partical URL/URI to the location from which the browser should pick up the web pages thumbnail image.
The use of '`REL="shortcut"`' is specific to Internet Explorer (before IE9), and not offically part of the HTML specification.

It is posible to merge the two HTML tags together using '`REL="shortcut icon"`' however by keeping the tags separate you can make use of a non-ICO image file format (such as SVG) for non-IE browsers, such as firefox.

Remember if this html element is not used the "`favicon.ico`" file found on the top level directory of the web site is used instead (if present).

The ICO image format is universally understood by all modern browsers.
All except Internet Explorer also can use JPEG, PNG, and GIF image file formats, for the link thumbnail.
A few like FireFox can even make use of animated GIF's or SVG image file formats.
However as these latter formats can not typically hold multiple images at different resolutions and color counts, it is probably better to stick with the ICO file format for the "`favion.ico`" image.

------------------------------------------------------------------------

## Other Non-IM Techniques {#non-im}

The "`XV`" program I use for manual image processing also generates thumbnail images, in a sub-directory called "`.xvpics`".
The format of the images in this directory is the programs own special thumbnail format (ignoring the filename suffix in that directory).
These thumbnails are limited to 80x60 pixels so are a little on the "small" size (unless you hack "`xv`" to use larger thumbnails -- see link below).

IM understands the "`xv`" thumbnail format (which is based on the "`NetPBM`" image format), so you can generate all the thumbnails quickly using XV, then convert the XV thumbnails of the JPEG images, into GIF images for further processing...

       xv -vsmap &               # generate thumbs with the "Update" button
       rm .xvpics/*.gif          # delete XV thumbs of existing "gif" thumbnails
       mogrify -format gif .xvpics/*.jpg
       mv .xvpics/*.gif .        # move the new "gif" thumbnails to original dir

If you are sick of the small size of XV thumbnails, particularly with larger modern displays, you can hack the XV code.
See my [XV modification notes](http://www.ict.griffith.edu.au/anthony/info/graphics/xv_mods.hints), which allows you to get XV to use a larger thumbnail size.
I myself use 120x90 pixel thumbnails.

------------------------------------------------------------------------

## Further Processing -- Adding Fluff {#fluff}

The above is only the beginning of what you can do to make your thumbnails more interesting.
Beyond the basic thumbnail image you can add borders, rotations even with some random selection of style to make your thumbnail gallery that much more interesting.

Additions to thumbnails like this, is what I term 'fluff', as in the extra lint you find covering your clothes after you wash your clothes.
That is, it adds unnecessary extras to the thumbnail, but which can make web pages and index images that much more interesting.

Be warned that many of the following methods and processing is very complex and my require a deeper knowledge of the various image processing options options of ImageMagick.

### Adding image labels {#labels}

During your thumbnail creation you can also add labels either above, below or even on top of your thumbnail.

This sort of image processing is however covered more thoroughly in [Annotating Images with Labels](../annotating/#labeling).
Just remember to use the "`-thumbnail`" or "`-strip`" rather than a "`-resize`" in those examples.

For example...
  
      convert thumbnail.gif \
              -background Lavender -fill navy -font Candice -pointsize 24 \
              label:Hatching   -gravity South -append \
              labeled.gif

  
[![\[IM Output\]](labeled.gif)](labeled.gif)

With the use of [Compound Fonts](../fonts/) you can overlay some very fancy labels onto the image itself.

Here for example I used a [Denser Soft Outline Font](../fonts/#denser_soft_outline) technique to annotate the thumbnail, darkening the area around the text to ensure it always remains readable.
  
      convert -define jpeg:size=400x400  hatching_orig.jpg  -resize '120x200>' \
          \( +clone -sample 1x1\! -alpha transparent -sample 1000x200\! \
             -font SheerBeauty -pointsize 72 -gravity Center \
             -strokewidth 8 -stroke black  -fill black  -annotate 0,0 '%c' \
             -channel RGBA -blur 0x8 \
             -strokewidth 1 -stroke white  -fill white  -annotate 0,0 '%c' \
             -fuzz 1% -trim +repage -resize 115x \
          \) -gravity North -composite           -strip annotated.gif

  
[![\[IM Output\]](annotated.gif)](annotated.gif)

Note how I do not use the pre-generated "`thumbnail.gif`" image, or use the [Thumbnail Resize Operator](../resize/#thumbnail) to strip the profiles and comments from the image.

I then used "`+clone`", "`+sample`", and "`-alpha`", to generate a larger transparent working canvas, which also contains a copy of the original image's meta-data.
This lets me use the images 'comment' string with the annotate "`-annotate`" operator, to supply the text to overlay on the image.

Only at the end after I have composed the text overlay do I clean up and "`-strip`" that information.

### Raised Button {#button}

  
The "`-raise`" operator was basically created with the one purpose of highlighting the edges of rectangular images to form a raised button.
It is a simple, fast, and effective thumbnail transformation.
  
      convert thumbnail.gif  -raise 8   raised_button.gif

  
[![\[IM Output\]](raised_button.gif)](raised_button.gif)
  
The same operator has a 'plus' form that can be used to make a sunken highlighting effect.
  
      convert thumbnail.gif  +raise 8   sunken_button.gif

  
[![\[IM Output\]](sunken_button.gif)](sunken_button.gif)

### Bubble Button {#bubble}

With some trickiness the "`-raise`" operator can be used to produce a smooth 'bubble-like' raised button.
  
      convert thumbnail.gif -fill gray50 -colorize 100% \
              -raise 8 -normalize -blur 0x8  bubble_overlay.png
      convert thumbnail.gif bubble_overlay.png \
              -compose hardlight -composite  bubble_button.png

[![\[IM Output\]](thumbnail.gif)](thumbnail.gif) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](bubble_overlay.png)](bubble_overlay.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](bubble_button.png)](bubble_button.png)

See [Light Composition Methods](../compose/#light) for more information about this type of technique.

For more effects like this see [Self Framing (Internal)](#self_frame_inside) below, and to take it to the next level see [Lighting Effect Mask](#lighting_mask) below.

### Adding Borders {#border}

The humble simple "`-border`" operator can be used to generate some a complex framework around an images.
  
      convert thumbnail.gif \
              -bordercolor black -border 3   -bordercolor white -border 2 \
              \( -background black -fill white -pointsize 24 \
                 label:Hatching   -trim +repage \
                 -bordercolor black -border 10 \
              \) -gravity South -append \
              -bordercolor black -border 10   -gravity South -chop 0x10 \
              border_framework.gif

  
[![\[IM Output\]](border_framework.gif)](border_framework.gif)

### Simple Frame {#frame}

  
In a similar way the "`-frame`" operator makes it easy to add a frame around the image
  
      convert thumbnail.gif   -mattecolor peru  -frame 9x9+3+3  framed.gif

  
[![\[IM Output\]](framed.gif)](framed.gif)

This operator also has a lot more options to create a dozen or so different styles of frames.
You can see examples of the possibilities in [Frame, adding a 3D-like border](../crop/#frame).

### Montage Framing {#montage}

The montage command provides a much easier way of doing all the above, and much more.
It cannot only generate thumbnails (or whole pages of thumbnails), but it can label the thumbnails to include information like filenames, disk size, and dimensions, or a user specified string.

Here is a simple use of "`montage`" to generate a framed thumbnail.
  
      montage -define jpeg:size=240x200  -label '%c'  hatching_orig.jpg \
              -frame 6  -geometry '120x100>'  montage_simple.gif

  
The label comes from JPEG image file comment, which was added long ago to the image using the Non-IM command "`wrjpgcom`".
See [Non-IM JPEG Processing](../formats/#jpg_non-im) for more details.
  
[![\[IM Output\]](montage_simple.gif)](montage_simple.gif)
  
Even with just "`montage`" you can get really fancy with your thumbnail generation.
  
      montage -define jpeg:size=400x180  -label '%c' hatching_orig.jpg \
              -thumbnail '200x90>' -geometry '130x100>'  -mattecolor peru \
              -frame 6  -bordercolor skyblue  -font LokiCola  -pointsize 18 \
              montage_fancy.gif

  
[![\[IM Output\]](montage_fancy.gif)](montage_fancy.gif)

See the "[Montage, Arrays of Images](../montage/)" for more details.

You may be especially interesting in the [Montage HTML Thumbnail Image Maps](../montage/#html) example.
This creates a HTML index page of thumbnails in which clicking on the thumbnail will bring up the original image, in the same directory.

### Soft and Blurred Edges {#soft_edges}

The [Vignette Operator](../transform/#vignette) provides a simple means to add a blurry edge around an image.
  
      convert thumbnail.gif -alpha set \
              -background none  -vignette 0x4  vignette.png

  
[![\[IM Output\]](vignette.png)](vignette.png)

Of course as this thumbnail uses semi-transparent color so it needs to be saved in the PNG format.

The [Morphology Distance](../morphology/#distance) method provides a true transparent 'Feathering' of an image's edges.
  
      convert thumbnail.gif -alpha set -virtual-pixel transparent -channel A \
              -morphology Distance Euclidean:1,10\! +channel feathered.png

  
[![\[IM Output\]](feathered.png)](feathered.png)

The maximum distance of the transparent area is controled by the special `10\!`' distance scaling flag.
This was only added in IM v6.6.1-6.

This has the added advantage of also working for shaped images, though a more complex initialization is needed to correctly preserve and anti-aliased pixels in the distance formula.
See [Feathering Shapes using Distance](../morphology/#distance_feather) for more details.

The feathering here is a pure linear gradient, and can be further adjusted using [Sigmoidal Non-linearity Contrast Operator](../color_mods/#sigmoidal) to give it a smoother more tapered look in a number of different ways.

You can also [Feather Images using Blur](../blur/#feathering), using the same method of adding a transparent [Virtual Pixels](../misc/#virtual-pixel) before bluring just the alpha channel.
This generates a more softer feathering to the image, as well as noticeably rounded the corners of the image.
  
      convert thumbnail.gif -alpha set -virtual-pixel transparent \
              -channel A -blur 0x8  -level 50%,100% +channel  soft_edge.png

  
[![\[IM Output\]](soft_edge.png)](soft_edge.png)

The extra "`-level`" operation (adjusting only the transparency channel) ensures the edge becomes fully transparent, rather than only half transparent.
However it does fall sharply toward zero at the actual edge, due to the sigmoidal-like curve that blur generates.

It also has a additive effect in the corners, causing them to become rounded, while with a shaped image with a sharp concavity, it can cause fully-transparent pixels to become semi-transparent.
As such for shapes you may need to mask the result against the original image (using [Dst-In Composition](../compose/#dstin)).
For rectangular thumbnails however the result is satisfactory.

You can see another example of using this type of feathering in [Layered Thumbnails](../layers/#layer_thumbnails).

If instead of doing a level adjustment on the blurred feather, you can [Threshold](../quantize/#threshold) the blurred alpha channel at '`50%`', so as to add psuedo-rounded corners to the above thumbnail image.
  
      convert thumbnail.gif -alpha set -virtual-pixel transparent -channel A \
              -blur 0x8  -threshold 50% +channel rounded_corner_blur.gif

  
[![\[IM Output\]](rounded_corner_blur.gif)](rounded_corner_blur.gif)

While very simple, the result is not a really nice way to round off the corners of the image.
First the corners are not actually circular, but a 'hyperbolic' curve.
Second the result is not a smooth anti-aliased curve, but shows 'jaggies' caused by the aliasing effect of [Threshold Operation](../quantize/#threshold).
This image can however be save to a GIF file format.
See [GIF Boolean Transparency](../formats/#boolean_trans) for details.

Also note that the "`-blur`" operation can become very slow when you work with a large argument for generating a larger rounded corner.
As such this method of rounding corners on a large scale is not recommended at all.

For a more unusual blurred edge effect, you can use a [Radial Blur](../blur/#radial-blur) on just the alpha channel.
  
      convert thumbnail.gif -alpha set -virtual-pixel transparent \
              -channel A -radial-blur 0x45 +channel  radial_blur_edge.png

  
[![\[IM Output\]](radial_blur_edge.png)](radial_blur_edge.png)

This works better for perfectly square images.

As the amount of angled blur becomes larger, you will eventually generate a circular like Vignette edge.
  
      convert thumbnail.gif -alpha set -virtual-pixel transparent \
              -channel A -radial-blur 0x100 +channel  radial_blur_vignette.png

  
[![\[IM Output\]](radial_blur_vignette.png)](radial_blur_vignette.png)

The two step-like artifacts that can be seen is caused by the two image size dimensions.
No 'step' will be seen for a square image.
Adding a little extra normal blur to the last example can also improve the step problem.

### Rounded and Shaped Corners {#rounded}

While thresholding a [Soft Blurred Edge](#soft_edges) (see above) will generate a rounded corner suitable for the Boolean transparency of GIF, it does not generate a smooth 'anti-aliased' corner.

The proper way to generate an image with rounded corners, or of any other shape is to actually cut out each corner using a mask of the shape wanted.

The following method from Leif Åstrand &lt;leif@sitelogic.fi&gt; that multiplys a full image mask to generate the appropriate result.
  
      convert thumbnail.gif \
         \( +clone  -alpha extract \
            -draw 'fill black polygon 0,0 0,15 15,0 fill white circle 15,15 15,0' \
            \( +clone -flip \) -compose Multiply -composite \
            \( +clone -flop \) -compose Multiply -composite \
         \) -alpha off -compose CopyOpacity -composite  rounded_corners.png

  
[![\[IM Output\]](rounded_corners.png)](rounded_corners.png)

Basically extracts the white transparency mask from the original image, with just one black rounded corner.
This is then flipped and flopped to produce a mask with all four corners rounded.
And finally that mask is applied to the original image.

For much larger images, you may be better off applying a much smaller mask to each individual corner to reduce the total amount of processing needed.
That is more individual processing steps, but overall less processing of the actual pixels.

For example, here is the same thing but cutting a simple drawn triangular shape from each corner.
This will work with much larger images.
  
      convert thumbnail.gif -alpha set  -compose DstOut \
          \( -size 20x15 xc:none -draw "polygon 0,0  0,14 19,0" \
             -write mpr:triangle  +delete \) \
          \( mpr:triangle             \) -gravity northwest -composite \
          \( mpr:triangle -flip       \) -gravity southwest -composite \
          \( mpr:triangle -flop       \) -gravity northeast -composite \
          \( mpr:triangle -rotate 180 \) -gravity southeast -composite \
          corner_cutoff.png

  
[![\[IM Output\]](corner_cutoff.png)](corner_cutoff.png)

If you don't want transparency, but some other color, you can still do the above and then [Remove Transparency](../masking/#remove).
This can be important for JPEG images.

However a even simpler solution (in terms of complexity and memory usage) has been found in a [IM forum discussion](../forum_link.cgi?t=17626).
This overlays colored corners ('`Red`' in this case) rather than making them transparent.
  
      convert thumbnail.gif \
        \( +clone -crop 16x16+0+0  -fill white -colorize 100% \
           -draw 'fill black circle 15,15 15,0' \
           -background Red  -alpha shape \
           \( +clone -flip \) \( +clone -flop \) \( +clone -flip \) \
         \) -flatten  rounded_corners_red.png

  
[![\[IM Output\]](rounded_corners_red.png)](rounded_corners_red.png)

Unfortunately this method can not be used to simply 'erase' the image corners to transparency, due to an interaction with a 'background canvas' of the [Flatten Operation](../layers/#flatten), a future layering operator may solve this.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*The last example will fail for versions of IM before v6.6.6-5 due to both the "`-flip`" and the "`-flop`" operators not handling the virtual canvas offset correctly.*

Using a [Polar Cycle Trick](../distorts/#polar_tricks) we can generate a perfect anti-aliased circle mask for any thumbnail.

Of course we will only use the distorted image as a mask for the original image, so as to get the result.

~~~
convert thumbnail.gif -alpha set \
  \( +clone -distort DePolar 0 \
     -virtual-pixel HorizontalTile -background None -distort Polar 0 \) \
  -compose Dst_In -composite -trim +repage circle_masked.png
~~~

We will take this style of image processing further in [Border with Rounded Corners](../thumbnails/#rounded_border) below.

There we not only cutting out corners, but also overlay appropriate framing images.

### Torn Paper Edge {#torn}

Leif Åstrand &lt;leif@sitelogic.fi&gt;, contributed the following IM code to generate a edge that looks like it was torn from a fibrous paper (like newspaper)...
  
      convert thumbnail.gif \
              \( +clone -alpha extract -virtual-pixel black \
                 -spread 10 -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \) \
              -alpha off -compose Copy_Opacity -composite torn_paper.png

  
[![\[IM Output\]](torn_paper.png)](torn_paper.png)

One improvement may be to make it look like you ripped it from a newspaper corner.
  
      convert thumbnail.gif -bordercolor linen -border 8x8 \
              -background Linen  -gravity SouthEast -splice 10x10+0+0 \
              \( +clone -alpha extract -virtual-pixel black \
                 -spread 10 -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \) \
              -alpha off -compose Copy_Opacity -composite \
              -gravity SouthEast -chop 10x10   torn_paper_corner.png

  
[![\[IM Output\]](torn_paper_corner.png)](torn_paper_corner.png)

This could be improved by adding 'paper' colored borders and a curved shaped mask, so that it looks like the image was ripped roughly by hand.
Adding a 'soft shadow' (see next) will also 'lift' the resulting image from the background, making it look like it was a separate piece.

As always, suggestions and contributions are welcome.

### Adding a Shadow {#shadow}

The "`-shadow`" operator makes the [Generation of Shadows](../blur/#shadow) of any shaped image easy.

For example here a I add a semi-transparent colored shadow, to the thumbnail.
  
      convert thumbnail.gif -alpha set \
              \( +clone -background navy -shadow 60x0+4+4 \) +swap \
              -background none -mosaic   shadow_hard.gif

  
[![\[IM Output\]](shadow_hard.gif)](shadow_hard.gif)
  
But you can just as easily create soft fuzzy shadows, too.
  
      convert -page +4+4 thumbnail.gif -alpha set \
              \( +clone -background navy -shadow 60x4+4+4 \) +swap \
              -background none -mosaic     shadow_soft.png

  
[![\[IM Output\]](shadow_soft.png)](shadow_soft.png)

Note that I again used a PNG format image for the thumbnails output.
That is because the shadowed image will contain a lot of semi-transparent pixels, which GIF cannot handle.
(Yes I am repeating myself but it is important).

If you do plan to use GIF or JPG format you will need to use a more appropriate "`-background`" color for the web page or larger canvas on which you plan to display your thumbnail, as these formats do not handle semi-transparent colors.

Warning, while the above works for individual thumbnails, it will generally fail when you want to layer multiple thumbnails over the top of each other.
The reason is that shadows do not accumulate together, in the same way that normal images do.
To see how to handle shadows from multiple layered images see [Layers of Shadows](../layers/#layer_shadow).

### Adding Some Thickness {#thickness}

Adding a thickness to a image or a shape look a bit like adding a hard shadow (see above), but isn't quite the same, and needs some extra work to get right.

This is actually very tricky as we create a colored, mask of the image which is then replicated multiple times and layered under the original image (using '`DstOver`' composition) with increasing offsets to give the image thickness.
  
      convert thumbnail.gif -alpha set \
              \( +clone -fill DarkSlateGrey -colorize 100% -repage +0+1 \) \
              \( +clone -repage +1+2 \) \
              \( +clone -repage +1+3 \) \
              \( +clone -repage +2+4 \) \
              \( +clone -repage +2+5 \) \
              \( +clone -repage +3+6 \) \
              -background none -compose DstOver -mosaic  thickness.gif

  
[![\[IM Output\]](thickness.gif)](thickness.gif)

You get the idea.
Each '`\( +clone ... \)`' line adds one extra pixel to the image in a south by south-easterly direction.

Also as no semi-transparent pixels are involved (at least for a rectangular image) you can use the GIF image format for the result.

The major problem with this technique is that it is hard to specify a thickness as a variable argument or at different angles, unless you write a specific script to add thickness.
Also the edge of the angled parts of the thickness is not anti-aliased, so there is lots of room for improvement.

### Polaroid-like Thumbnails {#polaroid}

You can make your thumbnail image look like a polaroid photo, give it a shadow, and even rotate it a little so as to appear to be just sitting on a table.
  
      convert thumbnail.gif \
              -bordercolor white  -border 6 \
              -bordercolor grey60 -border 1 \
              -background  none   -rotate 6 \
              -background  black  \( +clone -shadow 60x4+4+4 \) +swap \
              -background  none   -flatten \
              poloroid.png

  
[![\[IM Output\]](poloroid.png)](poloroid.png)
  
A more complex version of the above was added to IM v6.3.1-6 as a "`-polaroid`" transformation operator.
For example...
  
      convert thumbnail.gif -bordercolor snow -background black +polaroid \
              poloroid_operator.png

  
[![\[IM Output\]](poloroid_operator.png)](poloroid_operator.png)

Note that the image not only has the polaroid frame, but the photo has also been given a bit of a 'curl' with appropriate shadow adjustments, giving the resulting image more depth.
The plus (+) form uses a randomized angle, while the normal minus (-) form lets you provide the angle of rotation.
Special thanks to Timothy Hunter for the idea behind this technique.
  
You can even add a "`-caption`", set your own shadow color, specify your own rotation (or none at all).
  
      convert -caption '%c' hatching_orig.jpg -thumbnail '120x120>' \
              -font Ravie -gravity center -bordercolor Lavender \
              -background navy  -polaroid -0     poloroid_caption.png

  
[![\[IM Output\]](poloroid_caption.png)](poloroid_caption.png)

For more information on using this operator see [Complex Polaroid Transformation](../transform/#polaroid).

For these examples though, I'll continue to use a DIY creation method, as I need finer control of the borders and shadowing effects to demonstrate proper photo 'stacking'.

And here we go...
By making multiple copies of the photograph, (or using other images), and adding polaroid borders, you can then randomly rotate and stack them up to produce a nice looking pile of photos.
  
      convert thumbnail.gif \
         -bordercolor white  -border 6 \
         -bordercolor grey60 -border 1 \
         -bordercolor none  -background  none \
         \( -clone 0 -rotate `convert null: -format '%[fx:rand()*30-15]' info:` \) \
         \( -clone 0 -rotate `convert null: -format '%[fx:rand()*30-15]' info:` \) \
         \( -clone 0 -rotate `convert null: -format '%[fx:rand()*30-15]' info:` \) \
         \( -clone 0 -rotate `convert null: -format '%[fx:rand()*30-15]' info:` \) \
         -delete 0  -border 100x80  -gravity center \
         -crop 200x160+0+0  +repage  -flatten  -trim +repage \
         -background black \( +clone -shadow 60x4+4+4 \) +swap \
         -background none  -flatten \
         poloroid_stack.png

  
[![\[IM Output\]](poloroid_stack.png)](poloroid_stack.png)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*The " `convert ...` " embedded command in the above example generates a random floating point number from -15 to +15.
For more infomation on using IM as a mathematical calculator see [FX Expressions](../transform/#fx_escapes).
An alternative is to assign random numbers to shell variables and substitute them into the above command instead.*

Of course you could substitute a set of different images rather than repeating the same image when creating the stack.
Or select a set of rotates angles so they are all reasonably different, or are more pleasing to look at.
If you are really good you can even offset the rotated images (jitter their position a little) so they are not all stacked up perfectly centered.
But you get the basic idea.

If you really want to avoid the use of the PNG format, due to its current problems with *some* browsers, you can use the GIF image format.
To do this you must be willing to accept some color limitations, and know the exact background color on which the image will be displayed.
The '`LightSteelBlue`' color in the case of these pages.
  
      convert thumbnail.gif \
              -bordercolor white  -border 6 \
              -bordercolor grey60 -border 1 \
              -background  none   -rotate -9 \
              -background  black  \( +clone -shadow 60x4+4+4 \) +swap \
              -background  LightSteelBlue  -flatten    poloroid.gif

  
[![\[IM Output\]](poloroid.gif)](poloroid.gif)

For details about this technique (and more) see [GIF images on a solid color background](../formats/#bgnd).

The above 'stacked polaroid' technique graciously provided by Ally of [Ally's Trip](http://www.allystrip.com/) and Stefan Nagtegaal for [Muziekvereniging Sempre Crescendo](http://sempre-crescendo.nl/), both of which use Polaroid-like thumbnails extensively on their web sites.

In the [IM User Forum](../forum_link.cgi?t=7530), the user *[grazzman](../forum_link.cgi?u=7473)* went a little further by overlaying images onto a rotating canvas to create a photo spread.
  
      convert -size 150x150 xc:none -background none \
              -fill white -stroke grey60 \
              -draw "rectangle 0,0 130,100" thumbnail.gif \
                    -geometry +5+5 -composite -rotate -10 \
              -draw "rectangle 0,0 130,100" thumbnail.gif \
                    -geometry +5+5 -composite -rotate -10 \
              -draw "rectangle 0,0 130,100" thumbnail.gif \
                    -geometry +5+5 -composite -rotate +10 \
              -trim +repage -background LightSteelBlue -flatten \
              poloroid_spread.gif

  
[![\[IM Output\]](poloroid_spread.gif)](poloroid_spread.gif)

Of course for a photo spread like this you really need to use a set of different photos rather using the same image over and over as I did here.

There are a few caveats you may like to consider with this technique.

-   The framing has been hardcoded into the above, and depends on the size of the thumbnail image.
    In a real application the framing may be moved to the thumbnail generation stage rather than in the above photo spread.
-   As "`-rotate`" also expands the size of the canvas the position in which images are added is changing, unless you place them using a offset from "`-gravity center`" position.
-   And finally, a constantly rotating the background frame is not a good idea in terms of quality.
    Rotating an already rotated image, adds more pixel level distortions to the result than doing one rotate for each separate image before being overlaid.

A similar randomized stacking of photos over a larger area was developed for [Stas Bekman's Photography](http://stason.org/photos/gallery/), but with a different bordering technique.

A more generalized method for creating some sort of ordered or programmed layout of photos and images, is shown and described in [Examples of Image Layering](../layers/#layer_examples), as well as in [Overlapping Photos](../photos/#overlap).

------------------------------------------------------------------------

## Framing Techniques {#framing}

Here we will look at some advanced framing techniques that use some very advanced knowledge of how IM works to achieve the desired results.

### Self Framing (External) {#self_frame}

**Self Framing** is a technique that can be used to frame an image, using the image itself to generate the framing colors and patterns.
That is to say the added frame is not fixed, but varies so as to roughly match the image being framed.

You can do this in two ways.
Extend the original image so as to create, an *External Frame*, or use part of the actual image itself to create an *Internal Frame*.

For example, if we enlarge the image and dim it, before overlaying the original image on top, we get a very nice looking frame.
  
      convert thumbnail.gif \
              \( -clone 0 -resize 130% +level 20%x100% \) \
              \( -clone 0 -bordercolor black -border 1x1 \) \
              -delete 0 -gravity center -composite  self_bordered.gif

  
[![\[IM Output\]](self_bordered.gif)](self_bordered.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*Instead of using [Level Adjustments](../color_mods/#level_plus) to brighten (or darken) the framing image, an alternative way of making the border a lighter or darker color is to [Color Tint](../color_mods/#colorize) the frame using something like... "`-fill white -colorize 30%`"*

Another way of color tinting the image to generate the frame, you can simply get IM to overlay a semi-transparent [Frame](../crop/#frame) on top of the enlarged image.
However this requires you to know the size of the thumbnail so as to exactly resize it exactly the right amount to accommodate the generated frame.
  
      convert thumbnail.gif \
              \( -clone 0 -resize 140x110\! \) \
              \( -clone 0 -bordercolor black -border 1x1 \
                          -mattecolor '#8884' -frame 9x9+0+9 \) \
              -delete 0 -composite  self_framed.gif

  
[![\[IM Output\]](self_framed.gif)](self_framed.gif)

A variation of the above uses the special [viewport](../distorts/#distort_viewport) control and the default [Virtual Pixel, Edge](../misc/#edge) setting to extend the edge of a blurred image to generate the extenal frame.
  
      convert thumbnail.gif \( +clone \
                 -set option:distort:viewport 150x120-15-15 \
                 -virtual-pixel Edge    -distort SRT 0  +repage \
                 -blur 0x3 +level 20%,100% \) \
              \( -clone 0 -bordercolor white -border 1 \) \
              -delete 0 -gravity center -compose over -composite \
              self_blurred_edge.gif

  
[![\[IM Output\]](self_blurred_edge.gif)](self_blurred_edge.gif)

Just a word of warning.
A small edge defect (such as a tree or leaf) can produce some undesirable results in a frame that was generated using only the edge of the image.

The viewport does need to know the size of the original image to enlarge and offset that viewport the appropriate amount.
However you can use [FX Escape Expressions](../transform/#fx_escapes) to calculate the viewport size (see examples below).

An alternative is to use a blurred [Virtual Pixel, Dither](../misc/#dither) in the above example.
This will spread the colors further and be not quite so 'edgy'.
But if you add blurs before and after the expansion you use the dither to produce a cloth-like effect.
  
      convert thumbnail.gif \( +clone  -blur 0x3 \
                 -set option:distort:viewport '%[fx:w+30]x%[fx:h+30]-15-15' \
                 -virtual-pixel Dither  -distort SRT 0  +repage \
                 -blur 0x0.8  +level 20%,100% \) \
              \( -clone 0 -bordercolor white -border 1 \) \
              -delete 0 -gravity center -compose over -composite \
              self_blurred_dither.gif

  
[![\[IM Output\]](self_blurred_dither.gif)](self_blurred_dither.gif)

The first blur modulates the average color, while the second adjusts how 'pixelated' or smooth the dither pattern is.

Here is another example, this time using [Virtual Pixel, Mirror](../misc/#mirror), with a [Soft Edge](#soft_edges) (blackened) which turned out to work very well for this specific image.
  
      convert thumbnail.gif  \( +clone \
                 -set option:distort:viewport '%[fx:w+30]x%[fx:h+30]-15-15' \
                 -virtual-pixel Mirror -distort SRT 0 +repage \
                 -alpha set -virtual-pixel transparent \
                     -channel A -blur 0x8 +channel \
                 -background Black -flatten \) \
              +swap -gravity center -compose over -composite \
              self_mirror.gif

  
[![\[IM Output\]](self_mirror.gif)](self_mirror.gif)

In all the above cases the frames are generated from the same image, which is then combined together to produce a frame based on the colors coming from the original image.
The framing border is thus unique and matches each thumbnail image that is framed.

Fred Weinhaus has created a script "`imageborder`" to make self framing images easier, with borders being generated from blurred magnifications of the original image, or some form of [Virtual Pixel](../misc/#virtual-pixel) setting defining the contents.

### Self Framing (Internal) {#self_frame_inside}

Rather than enlarging the image to add the new border, we can convert parts of the image itself into a border.

We have already seen some techniques of adding a frame, inside the image itself.
The [Raised Button](#button) and [Bubble Button](#bubble) techniques do this, using the "`-raise`" operator.

Here we generate a lighter blurred version of the original image which is then overlaid using a mask also generated from the original image.
A white edge is then added to separate that lighter blured version from the center un-modified part of the image.
  
      convert thumbnail.gif \( +clone -blur 0x3 +level 20%,100% \) \
              \( +clone -gamma 0 -shave 10x10 \
                 -bordercolor white -border 10x10 \) \
              -composite \
              \( +clone -gamma 0 -shave 10x10 \
                 -bordercolor white -border 1x1 \
                 -bordercolor black -border 9x9 \) \
              -compose screen -composite \
              self_blurred_border.gif

  
[![\[IM Output\]](self_blurred_border.gif)](self_blurred_border.gif)

You can also use the [Frame Operator](../crop/#frame) to achieve something a little different to the previously seen [Button](#button) effects.
The trick is to first [Shave](../crop/#shave) the original image before applying.

For example here I make a copy of the original image, shave and frame it using transparent frame, before overlaying that over the original image.
  
      convert thumbnail.gif \( +clone -shave 10x10 \
                -alpha set -mattecolor '#AAA6' -frame 10x10+3+4 \
              \) -composite  inside_frame_trans.gif

  
[![\[IM Output\]](inside_frame_trans.gif)](inside_frame_trans.gif)

The problem with this is that you will always 'lighten' or 'darken' (de-contrast) the flat parts of frame around the original image.

To avoid this we can use the same technique as the [Bubble Button](#bubble) technqiue.
We generate a frame on a perfect grey canvas, and modiy it so as to generate a [Lighting Effects Composition Mask](../compose/#light), to adjust the colors of the original image.

For example here I use a '`VividLight`' composition with the framed mask image to better preserve primary colors.
  
      convert thumbnail.gif \
              \( +clone -shave 10x10 -fill gray50 -colorize 100% \
                -mattecolor gray50 -frame 10x10+3+4 \
              \) -compose VividLight -composite  inside_frame_light.gif

  
[![\[IM Output\]](inside_frame_light.gif)](inside_frame_light.gif)

Like the [Bubble Button](#bubble) you can also blur the lighting mask before applying.
Here I used more normal '`HardLight`' compose which does not enhance primary colors, with a blurred frame lighting mask.
  
      convert thumbnail.gif \
              \( +clone -shave 10x10 -fill gray50 -colorize 100% \
                -mattecolor gray50 -frame 10x10+3+4 -blur 0x2 \
              \) -compose HardLight -composite  inside_frame_blur.gif

  
[![\[IM Output\]](inside_frame_blur.gif)](inside_frame_blur.gif)
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*Some [Light Composition Methods](../compose/#light) may require you to [Swap the Images](../basics/#swap) before you compose them to get the correct lighting effect.*

To take this type of effect even further, producing much more complex results see the advanced [Lighting Effect Mask](#lighting_mask).

### Simple Border Overlay {#border_overlay}

One simple type of framing is to create a fancy frame, or shaped image into which you can place your image, under the frame.

For example here we generate a simple frame slightly larger than our image with a fancy shaped hole.
The shape was extracted from the '`WebDings`' font (character '`Y`'), but there are a lot of possible sources for fancy shapes that could be used for picture framing.
  
      convert -size 120x140 -gravity center -font WebDings label:Y \
              -negate -channel A -combine +channel -fill LightCoral -colorize 100% \
              -background none -fill none -stroke firebrick -strokewidth 3 label:Y \
              -flatten +gravity -chop 0x10+0+0 -shave 0x10 +repage border_heart.png

  
[![\[IM Output\]](border_heart.png)](border_heart.png)

For other ways of generating a edge on an existing shaped image see the [Edge Transform](../transform/#edge).
  
You can also optionally give the frame a little depth by using a [Shadow Effect](../blur/#shadow).
  
      convert border_heart.png  \( +clone -background black -shadow 60x3+3+3 \) \
              -background none -compose DstOver -flatten   border_overlay.png

  
[![\[IM Output\]](border_overlay.png)](border_overlay.png)
  
Now that we have a simple overlay frame, we can underlay the image in the center, underneath the frame by using a '`DstOver`' composition.
  
      convert border_overlay.png  thumbnail.gif \
              -gravity center -compose DstOver -composite   border_overlaid.jpg

  
[![\[IM Output\]](border_overlaid.jpg)](border_overlaid.jpg)

Now you can generate a library of pre-prepared frames to use with your images, such as this [Autumn Leaves Image](autumn_leaves.png).
  
        convert thumbnail.gif  autumn_leaves.png +swap \
                -gravity center -compose DstOver -composite \
                border_leaves.gif

[![\[IM Text\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Text\]](autumn_leaves.png)](autumn_leaves.png) ![==&gt;](../img_www/right.gif) [![\[IM Text\]](border_leaves.gif)](border_leaves.gif)

Note that I swapped the order of the images and used '`DstOver`' to place the second, main image 'under' the frame.
That way it is the frame that determines the final size of the image, and not the original image.
However doing this would also loose any meta-data the main image has (for the same reason).

If you really want to preserve the thumbnails meta-data (such as labels and comments, such as a copyright message), then the best idea is to [Pad Out the Thumbnail](#pad) to the same size as the frame, than this use the default '`Over`' composition to overlay the frame.
That way the thumbnail is the 'destination' image and its image meta-data is preserved.

### Badge Overlay Example {#badge_overlay}

Here is another more complex pre-prepared overlay example this time using a correctly sized image (using extent as a crop method), from the IM Forum Discussion [Composite Overlay and Masking](../forum_link.cgi?f=1&t=19116).
  
        convert thumbnail.gif  -gravity center -extent 90x90 \
                badge_overlay.png -composite     badge.png

[![\[IM Text\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_overlay.png)](badge_overlay.png) ![==&gt;](../img_www/right.gif) [![\[IM Text\]](badge.png)](badge.png)

Note that the image itself is not distorted, just lightened and darkened slightly, a circle cut out and shadow added, all in the one overlay image.
If this was a real badge, or 'glass bubble' then the image should also be distorted a little too (perhaps using a [Barrel Distortion](../distorts/#barrel)), but it works well without needing such distortion.

For the next step in the 'badge' example, see [Badge using Mask and Paint](#badge_mask_paint), which adds background transparency around the outside of the badge.
  
### Mask 'n' Paint Technique {#mask_paint}

In many cases you don't just want to overlay a square border around an image, but also want to cut out the image edges, to transparency.
For this you would typically use at least two images.
One is the masked overlay containing the colors, shadows and highlights you want to add to the existing image.
And a second image containing the parts you want to remove from the original image.

The two images can be applied in two different ways.
You can either 'mask' first to remove the unwanted parts from the image, then overlay the frame, *or* you can overlay a frame, and then mask the unwanted parts of both the original image and overlaid colors to transparency.

Which method you use is critical, and the images involved will be designed for a specific technique.
You can not use images for one method in the wrong order or things will not work properly.

For example lets create more complex shaped border but this time don't worry about setting the background.
  
      convert -size 120x100 xc:none -fill none -stroke black -strokewidth 3 \
              -draw 'ellipse 60,50 30,45 0,360  ellipse 60,50 55,30 0,360' \
              -strokewidth 3  -draw 'ellipse 60,50 57,47 0,360' \
              -channel RGBA  -blur 2x1    border_ellipse.png

  
[![\[IM Output\]](border_ellipse.png)](border_ellipse.png)

Now I purposely made this border blurry, to make the edge components much more semi-transparent.
Even without that extra fuzziness, a border also contains a lot of semi-transparent anti-aliasing pixels, that make the edge look smoother and less jagged looking.
It is vital when image processing that you consider these semi-transparent pixels, so as to preserve and set them correctly.

To make it more interesting give this 'fuzzy' border a random bit of coloring.
  
      convert border_ellipse.png \
              \( -size 120x100 plasma:Tomato-FireBrick -alpha set -blur 0x1 \) \
              -compose SrcIn -composite     border_ellipse_red.png

  
[![\[IM Output\]](border_ellipse_red.png)](border_ellipse_red.png)

Okay we have a border, but we still need some way of defining what should represent the outside and inside of the border.
Basically we need a mask to define these two areas.
  
      convert -size 120x100  xc:none -fill black \
              -draw 'ellipse 60,50 30,45 0,360  ellipse 60,50 55,30 0,360' \
              border_ellipse_mask.png

  
[![\[IM Output\]](border_ellipse_mask.png)](border_ellipse_mask.png)

The color of this 'mask' image is not important, just its shape, as it basically defined what parts will be classed as inside and what will be outside.
The mask can be a gray-scale mask, or it can be a shape mask such as shown above.
Though the later is typically more useful, and can even be a shape of the parts to erase, or the parts to be kept (as above).

In this case the images are designed as a "*mask 'n' paint*" technique, meaning you should first erase the unwanted parts, then overlay the additional border colors (which also has a transparency mask involved).

For example...
  
      convert thumbnail.gif -alpha set  -gravity center -extent 120x100 \
              border_ellipse_mask.png  -compose DstIn -composite \
              border_ellipse_red.png   -compose Over  -composite \
              border_mask_paint.png

[![\[IM Output\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](border_ellipse_mask.png)](border_ellipse_mask.png) ![ +](../img_www/plus.gif) [![\[IM Output\]](border_ellipse_red.png)](border_ellipse_red.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](border_mask_paint.png)](border_mask_paint.png)

Two [Duff-Porter Alpha Composition Operations](../compose/#duff-porter) are always is needed.
One to make parts transparent, and another to overlay the additional colors to outline the border or frame.
Two images are needed and as such be kept separate.
Some formats like MIFF and GIF do allow you to save both images into the same file, for easier storage.

Of course you can combine the two images to create a single simple overlay framing image, but only if you want to use a fixed non-transparency color for the outside parts of the result.

For example pre-define the outside as a DodgerBlue color...
  
      convert border_ellipse_mask.png -alpha extract -negate \
              -background DodgerBlue -alpha shape \
              border_ellipse_red.png   -compose Over -composite \
              border_ellipse_overlay.png

  
[![\[IM Output\]](border_ellipse_overlay.png)](border_ellipse_overlay.png)

But in that case you could simply underlay a solid color or some other background image under the previously generated double masked image...
  
      convert border_double_masked.png \
              \( -size 120x100 plasma:Green-Green -blur 0x1 \) \
              +swap  -compose Over  -composite     border_background.png

  
[![\[IM Output\]](border_background.png)](border_background.png)

The point is with two images, a 'mask' and 'overlay' image, you have a lot more freedom in how you add the border to the image.
You could even define multiple 'mask' images, to define the different 'windows' of the 'overlaid' border image.
You can also add optional highlights and shadows, rather than hard coding them into a single overlay framing image.

Now for a important caveat.
The edges of the masking image **must not** coincide with the edges of the overlay image.

If they match up, you will not get the correct handling of colors along the coinciding edges, or generate other weird 'halo' effects.
As such you need to make sure the mask edges fall somewhere within the fully-opaque region of the overlay image.

Caution and fore-thought with the two masking operations is needed.

### Border with Rounded Corners {#rounded_border}

As you saw above the [Mask 'n' Paint Technique](#mask_paint) can be used to both add extra colors or 'fluff' to an image, but also remove parts, so as to shape the final image.
This presents us with an alternative way of adding rounded corners to an image.

The IM "`-draw`" operator comes with a '`roundrectangle`' method that can be used to provide an interesting frame around the image.
However you need to size the dimensions of this draw method to match the image.
IM does provide methods to extract and even do mathematical calculations based on the image size.

The coordinates at which to locate the rectangle is for the exact 'center' of the stroke-width used to define the rectangle (it can be a floating point value).
Also it is given in terms of 'pixel coordinates' (see [Pixel vs Image coordinates](../distorts/#control_coordinates)), which means that a value of 1,1 refers to the second pixel form the top and left edges, but more importantly it refers to the 'center' of the pixel which is in reality 1.5 units from the real top and left edges.

Now we will use a stoke width (SW) of 3, that makes the image 3 pixels larger on all sides.
It then means the rectangle will be positioned `SW/2 - 0.5` or 1.0 pixels from the top left, and `ImageSize + SW*1.5 - 0.5` or Image size + 4 pixels at the bottom right.

Here we use IM itself to do these calculations, generating the exact draw command that are need using fancy [FX escapes](../transform/#fx_escapes).
This is saved as a [Magick Vector Graphics File](../draw/#mvg_file) that can be directly used by draw in later commands.
  
      convert thumbnail.gif \
              -format 'roundrectangle 1,1 %[fx:w+4],%[fx:h+4] 15,15'\
              info: > rounded_corner.mvg

  
[![\[IM Text\]](rounded_corner.mvg.gif)](rounded_corner.mvg)

  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*If you can figure out the image size in a different way (using the shell, or other API language wrapper) you can substitute the appropriate draw parameters directly into the next examples, rather then use an FX mathematical expression.
Basically the above makes this whole process independent of the actual size of the thumbnail.
Any other way, including direct hard coding is also acceptable.*

Now we can use this to generate overlay and a mask image.
As part of this we create a [Transparent Canvas](../canvas/#transparent) using the original image (which is first enlarged by the stroke-width), to get the size right.
  
      convert thumbnail.gif -border 3 -alpha transparent \
              -background none -fill white -stroke none -strokewidth 0 \
              -draw "@rounded_corner.mvg"    rounded_corner_mask.png
      convert thumbnail.gif -border 3 -alpha transparent \
              -background none -fill none -stroke black -strokewidth 3 \
              -draw "@rounded_corner.mvg"    rounded_corner_overlay.png

[![\[IM Text\]](rounded_corner_mask.png)](rounded_corner_mask.png) [![\[IM Text\]](rounded_corner_overlay.png)](rounded_corner_overlay.png)

And there we have the overlay border image, and transparency mask image, we need for the double masking technique.
Note that the masks are for a image that is stroke width larger than the original image, and that the erasing shape mask (in white) does not cover the whole of the enlarged area, as there is a 1 pixel gap all around it.

So lets apply it using the [Double Masking](#double) technique...
  
      convert thumbnail.gif -alpha set -bordercolor none -border 3  \
              rounded_corner_mask.png -compose DstIn -composite \
              rounded_corner_overlay.png -compose Over -composite \
              rounded_border.png

  
[![\[IM Output\]](rounded_border.png)](rounded_border.png)

And there we have have a bordered our image with rounded corners.

The following is how you can do the above all in a single command with a little extra fanciness.
However this all-in-one command will still generate a temporary file holding the generated draw commands needed for an image of the size given.
  
      convert thumbnail.gif \
          -format 'roundrectangle 1,1 %[fx:w+4],%[fx:h+4] 15,15' \
          -write info:tmp.mvg \
          -alpha set -bordercolor none -border 3 \
          \( +clone -alpha transparent -background none \
             -fill white -stroke none -strokewidth 0 -draw @tmp.mvg \) \
          -compose DstIn -composite \
          \( +clone -alpha transparent -background none \
             -fill none -stroke black -strokewidth 3 -draw @tmp.mvg \
             -fill none -stroke white -strokewidth 1 -draw @tmp.mvg \) \
          -compose Over -composite               rounded_border_in_one.png
      rm -f tmp.mvg      # Cleanup of temporary file

  
[![\[IM Output\]](rounded_border_in_one.png)](rounded_border_in_one.png)

A better way for doing rounded corners, especially with very large images will be to use a separate corner masking image technique, which we will look at below in [Fancy Corner Overlays](#fancy).
In many ways this is an extension of the above method, but using separate masking for each corner of the image, so as to keep the working images small in size.

### Badge using Mask 'n' Paint {#badge_mask_paint}

Here is a much more complex "mask 'n' paint" example, that was developed from the image used previously in the [Badge Overlay](#badge_overlay) example above.
The generation of the two images was 'fudged', and was discussed IM forums [Composite Overlay and Masking](../forum_link.cgi?f=1&t=19116).
Idealy the two images would have been developed together.
  
      convert thumbnail.gif -alpha set -gravity center -extent 90x90 \
              badge_mask.png -compose DstIn -composite \
              badge_shading.png -compose Over -composite \
              badge_trans_bg.png

[![\[IM Text\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_mask.png)](badge_mask.png) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_shading.png)](badge_shading.png) ![==&gt;](../img_www/right.gif) [![\[IM Text\]](badge_trans_bg.png)](badge_trans_bg.png)

Note that above I said that the you should avoid trying to align transparency edges and the mask edges.
In the above example I did just that, and the edges of the resulting image will not be quite correct.
However as the coloring is really only a subtile shading rather that a strong edge, it seems to work okay in this example.
Caution however should be exercised.

For the next step in the 'badge' examples, see [Badge using Paint and Mask](#badge_paint_mask), which reverses the order of the two composition operations, requiring a different set of images.

### Paint 'n' Mask Technique {#paint_mask}

Rather than '*Mask then Paint*' you can use a different set of images and overlay the additional colors first, before masking out the background.
That is you can perform a '*Paint then Mask*'.

That is you would take your image, and overlay the border which sets not only all of the final border colors, but also masks and colors some or all the parts outside parts the original image.
You then use a separate 'outside' or 'clipping' mask to remove all the unwanted parts of the resulting image.

Also note that both 'overlay' and 'masking' image defines the inside edge separately to the outside edge of the border.
As a result one image does not completely define the whole border in a single image, which can make it a little harder to use.
However it can be simpler to implement.

For example...
  
      convert -size 120x90 xc:none -fill black -stroke black -strokewidth 0 \
              -draw 'ellipse 45,45 55,37 0,360' \
              -channel RGBA -negate -blur 0x3  +channel \
              \( granite: -auto-level -blur 0,0.7 \) \
              -compose ATop -composite border_paint.png

      convert -size 120x90 xc:none -fill black -stroke black -strokewidth 5 \
              -draw 'ellipse 59,45 56,40 0,360' border_mask.png

      convert thumbnail.gif -alpha set \
              border_paint.png -compose Over  -composite \
              border_mask.png  -compose DstIn -composite \
              border_paint_mask.png

[![\[IM Output\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Output\]](border_paint.png)](border_paint.png) ![ +](../img_www/plus.gif) [![\[IM Output\]](border_mask.png)](border_mask.png) ![==&gt;](../img_www/right.gif) [![\[IM Output\]](border_paint_mask.png)](border_paint_mask.png)

Note how some parts of the overlaid colors are removed.
This is the key feature of the *Paint 'n' Mask* technique, allowing you to use a simpler overlay, which is then adjusted by the mask.

This method of image masking is what is used in the next [Page Curl Corners](#pagecurl) example set, and again later in [Fancy Corner Borders](#fancy) below.

### Page Curl Corners {#pagecurl}

[Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html) created a special shell script called [PageCurl](http://www.fmwconcepts.com/imagemagick/pagecurl/index.php) which will, add a simple page curl to an existing image, using some very complex mathematics (in shell).
For example...
  
      pagecurl thumbnail.gif  pagecurl.png

  
[![\[IM Output\]](pagecurl.png)](pagecurl.png)

Internally it is actually using the [Paint 'n' Mask](#paint_mask) technique.
That is first overlays a slightly too large 'curl overlay', then erases (masks) the rest of the image, including a small amount of the overlay, that will become the transparent corner.

However if you want to apply a page curl to a lot of images, using the full script (above) is a rather slow technique.
It does after all do a huge amount of mathematical processing (using IM itself as a floating point calculator), to actually calculate and generate the appropriate overlay and masking images.

To apply a pagecurl to a lot of images it is better to use the script once so as to generate the overlay and transparency mask image once only.
So lets extract those two images for a smaller 64x64 pixel images (using a special '`-i "pagecurl"` option added to the script for this purpose).
  
      convert -size 64x64 xc: miff:- | pagecurl -e 0.3 -i "pagecurl" - null:

  
[![\[IM Output\]](pagecurl_overlay.png)](pagecurl_overlay.png) [![\[IM Output\]](pagecurl_mask.png)](pagecurl_mask.png)

The above command creates two image files: "`pagecurl_overlay.png`" and "`pagecurl_mask.png`" shown.
The input image itself does not matter as it is the masking images that we want.
The 'page curled' result is just junked using the special "`null:`" image file format.

Of course these images are not the same size as our thumbnail or probably any image you are wanting to apply it to, but that does not matter.
You just need to use a couple of extra options when using any masking technique with smaller images.
  
      convert thumbnail.gif -alpha set -gravity SouthEast \
              -define compose:outside-overlay=false \
              pagecurl_overlay.png -composite \
              pagecurl_mask.png  -compose DstIn -composite \
              pagecurl_thumbnail.png

  
[![\[IM Output\]](pagecurl_thumbnail.png)](pagecurl_thumbnail.png)

The "`-gravity`" setting ensures that the two overlay images are positioned in the lower right corner.
The other special [Define Setting](../basics/#define) '`compose:outside-overlay=false`' will prevent the mask image from erasing the parts of the image not covered by the smaller mask.

If you like to apply this to a lot of images you can use the "`mogrify`", using a special technique involving using "`-draw`" to do the [Mogrify Alpha Composition](../basics/#mogrify_compose).
However this method of composition does not understand the special define setting, so it will only work with images, overlays, and masks that are all the same size.
  
      pagecurl -e 0.5 -i /tmp/pagecurl  {one image} null:
      mogrify {mogrify -format and -path options} -alpha set \
              -draw 'image Over 0,0 0,0 "/tmp/pagecurl_overlay.png"' \
              -draw 'image DstIn 0,0 0,0 "/tmp/pagecurl_mask.png"' \
              {all images to be pagecurled}...

### Fancy Corner Overlay {#fancy}

Here we look a bit deeper into used this 'double masking' technique to modify an image in different ways in different areas, rather than applying a single large mask or frame to the whole image.
In this case we will only double mask the corners.
The rest of the border (to match) is added separatally.

[![\[IM Output\]](fancy_orig.gif)](fancy_orig.gif) The corner images I will use was generated from the original source (shown right) which I found in the [DIY Frames Section](http://www.ict.griffith.edu.au/anthony/icons/prog/frames/Icons.html) of [Anthony's Icon Library](http://www.ict.griffith.edu.au/anthony/icons/).
There are others in this section, so you may like to have a look.
If you find something on the net, please let me know as I like to collect interesting corners, and edging techniques.

[![\[IM Output\]](fancy_sub.gif)](fancy_sub.gif) [![\[IM Output\]](fancy_add.gif)](fancy_add.gif) A color overlay and masking image was generated, from that initial image, so that we could use a [Paint 'n' Mask](#paint_mask) technique, for overlaying the corner onto the image.

Notice that these images, did not actually use any semi-transparent pixels, or even any shading of colors.
As such this fancy border can be used to produce clean looking 'GIF' thumbnails for web pages.

The complication with using corner masks, is that they only mask the corners of the original image.
Because of this the original image first needs to be given the appropriate set of extra border colors.
After that the two corner masks, must be composted onto each of the corners of the expanded image.
  
      convert thumbnail.gif   -alpha set  -compose Copy \
              -bordercolor Black  -border 2 \
              -bordercolor Sienna -border 3 \
              -bordercolor Black  -border 1 \
              -bordercolor None   -border 2 \
              -bordercolor Black  -border 2 \
              -bordercolor Peru   -border 3 \
              -bordercolor Black  -border 1 \
              \
              -compose Over \
              \( fancy_add.gif             \) -gravity NorthWest -composite \
              \( fancy_add.gif -flip       \) -gravity SouthWest -composite \
              \( fancy_add.gif       -flop \) -gravity NorthEast -composite \
              \( fancy_add.gif -flip -flop \) -gravity SouthEast -composite \
              -compose DstOut \
              \( fancy_sub.gif             \) -gravity NorthWest -composite \
              \( fancy_sub.gif -flip       \) -gravity SouthWest -composite \
              \( fancy_sub.gif       -flop \) -gravity NorthEast -composite \
              \( fancy_sub.gif -flip -flop \) -gravity SouthEast -composite \
              fancy_border.gif

  
[![\[IM Output\]](fancy_border.gif)](fancy_border.gif)
  
![](../img_www/reminder.gif)![](../img_www/space.gif)
  
*Note that to preserve the transparent border that is being added, you must set "`-compose`" setting to '`Copy`' rather than the default of '`Over`'.
If you don't then the transparency will be filled by the next border color added, in this case with 'Black'.
See the [Border Operator](../crop/#border) for details.*

The beauty of only using corner masks is that any size image can be framed using this technique, as long as it is large enough for the corner masks being added.
That is you are not limited by the size of the framing images you have available.

Of course each of the four corner images and the borders is the same all the way around the image, just rotated.
That is the shadow or thickness effect is all 'inward'.

To fix this you would need to generate a different corner peice for each and every corner, and the addition of the extra edges around the original image would need to be asymetrical.
Basically it becomes much more complex, so as to produce true shadowing effects.
A better solution may be to remove the shadow effect from the corner piece, apply it as before, but then add shadow effects globally.
Caution is needed.

### Badge using Paint 'n' Mask {#badge_paint_mask}

The same badge image processing seen previously in [Badge Overlay](#badge_overlay) and [Badge Mask 'n' Paint](#badge_mask_paint), can also be performed by painting then masking.

Here we first paint all the colors an shades onto the then mask out the final transparency of the image.
  
      convert thumbnail.gif -alpha set -gravity center -extent 90x90 \
              badge_paint.png -composite badge_shape.png -compose DstIn -composite \
              badge_paint_mask.png

[![\[IM Text\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_paint.png)](badge_paint.png) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_shape.png)](badge_shape.png) ![==&gt;](../img_www/right.gif) [![\[IM Text\]](badge_paint_mask.png)](badge_paint_mask.png)

If this seems awkward for this specific image, you are right, it is.

The reason that that we not only need to shade and highlight the original image, but we also need to fill out any areas that will contain shadow effects with black.
Specifically any parts that will become fully transparent (and only pixels that really are fully transparent) will need to be painted with black.

On the other hand semi-transparent pixels with shadow effects will have both a partial shade effect and a partial transparency mask.
In other words shadows make an otherwise simple paint and mask technique awkward in the division of painting and masking effects.

This is why a paint and mask technique is typically not used when dealing with semi-transparent additions to an image, such as when adding shadows or a flare stars.

If the image did not contain any transparency-effects, than the paint process does not look so horrible, and can in many case be simplier than other techniques, as you can 'cut off' the painted overalys with the mask when finished.
The [Page Curl](#pagecurl) example was such a case, as we use the mask to trim the page curl overlay to make a seemless whole.

Also note the gap between the hard black region and the shading effects in the paint image.
This gap reflects warning I have mentioned before about ensuring that you do not overlap the results of any internal masking with the edges of any paint/overlay external mask.
It is only in this specific case that this required gap becomes so obvious.

For the next step in the 'badge' examples, see [Badge using Lighting Effects](#badge_lighting), which merges the two masking images into a single mask/shading image.

## Lighting Mask Technique {#lighting_mask}

### Glass Bubble Button {#glass_bubble}

The next level of complexity in thumbnail processing is the application of very complex lighting effects.
The trickiness here is not so much the application of a lighting effect to an image, but the generation of the appropriate shading effect.

For example using a [Aqua Effect](../advanced/#aqua_effects) you can give an thumbnail a very complex shading effect that makes it look like it has been enclosed by a 'bubble' of glass.
Also this works better with a thumbnail that has [Rounded Corners](#rounded).

For lets generate a rounded corners mask for our thumbnail image, using a pure gray color.
  
      convert thumbnail.gif -alpha off -fill white -colorize 100% \
         -draw 'fill black polygon 0,0 0,15 15,0 fill white circle 15,15 15,0' \
         \( +clone -flip \) -compose Multiply -composite \
         \( +clone -flop \) -compose Multiply -composite \
         -background Gray50 -alpha Shape    thumbnail_mask.png

  
[![\[IM Output\]](thumbnail_mask.png)](thumbnail_mask.png)

Now that we have a pure gray 'shape mask' we want to use, I can apply the [Aqua Effect](../advanced/#aqua_effects) effect to generate a lighting overlay, for this shape.
  
      convert thumbnail_mask.png -bordercolor None -border 1x1 \
              -alpha Extract -blur 0x10  -shade 130x30 -alpha On \
              -background gray50 -alpha background -auto-level \
              -function polynomial  3.5,-5.05,2.05,0.3 \
              \( +clone -alpha extract  -blur 0x2 \) \
              -channel RGB -compose multiply -composite \
              +channel +compose -chop 1x1 \
              thumbnail_lighting.png

  
[![\[IM Output\]](thumbnail_lighting.png)](thumbnail_lighting.png)

With a final light/shade overlay image such as the above we can easily apply it to any thumbnail image of the right size.
  
      convert thumbnail.gif -alpha Set thumbnail_lighting.png \
              \( -clone 0,1 -alpha Opaque -compose Hardlight -composite \) \
              -delete 0 -compose In -composite \
              glass_bubble.png

  
[![\[IM Output\]](glass_bubble.png)](glass_bubble.png)

Not only does this add the appropriate shading effects to any thumbnail of this size, but the same lighting image masks the thumbnail into the proper shape.

It is important to note that only the color channels are used to apply the lighting effect, the alpha channel is not used in this process.
Similarly when masking only the alpha channel is used, not the color channels.
Without this seperation of channels for different effects, you will not get the correct result.

For a discussion on extracting a lighting effect from images see the IM user forum topic [Extracting light layer from two images](../forum_link.cgi?f=1&t=19337).

This can be taken much further however in that we can also directly add shadow effects to this lighting mask.
The added color however must be pure black, and you need to ensure the lighting effect composition chosen will make a image perfectly black is the lighting mask is black.

However this is actually how shadow effects are normally added to an image, as such you can just add shadows to the "lighting effect mask" directly, and all will be well!

The same thing is true for adding lighting 'flares', but only using white pixels for the flare overlay.

In essence a "lighting effect image" can again actually merge the two [Mask 'n' Paint](#mask_paint) images back into a single image.
As you will see in the next example.

### Badge using Lighting Effects {#badge_lighting}

Using the images from [Badge using Mask 'n' Paint](#badge_mask_paint) technique, I applied them to a pure gray canvas image, so as to quickly generate a "masked lighting effect" image, Actually I could also have used the other style of masking ([Badge using Paint 'n' Mask](#badge_paint_mask)) just as easily.

I then apply the single masking image to the thumbnail reproducing the desired result.
  
      # merge "mask 'n' paint" images with a gray image,
      # to create a "lighting mask"
      convert -size 90x90 xc:gray50 -alpha set \
              badge_mask.png -compose DstIn -composite \
              badge_shading.png -compose Over -composite \
              badge_lighting.png

      # Apply the single "lighting mask"
      convert thumbnail.gif -alpha set -gravity center -extent 90x90 \
              badge_lighting.png \
              \( -clone 0,1 -alpha Opaque -compose Hardlight -composite \) \
              -delete 0 -compose In -composite \
              badge_final.png

[![\[IM Text\]](thumbnail.gif)](thumbnail.gif) ![ +](../img_www/plus.gif) [![\[IM Text\]](badge_lighting.png)](badge_lighting.png) ![==&gt;](../img_www/right.gif) [![\[IM Text\]](badge_final.png)](badge_final.png)

Actually I rather like this form of masking as the mask image itself looks almost identical to the image you are after, just the colors are missing.
That is after all how a lighting mask is created, just apply the effects to a perfect gray image, and you get a "lighting mask" image.

Just remember that with this particular technique, the semi-transparent shadow must be pure black for it to work properly.
You can not use a gray colored for any pixel that does not contain at least part of the original image.
All transparent and semi-transparent areas must be pure white or black in color, with the appropriate level of alpha transparency.

**Why does only one image work?** Previously we needed two images!

The answer is that the masking image is limited only to only adding either pure black or white shades of color.
By doing this the shading (lighting) effect, and its mask, is essentially merged into the color component of the "*Lighting Effect Mask*".

As a result of this the alpha channel becomes free to hold the previously separate transparency mask for the final image.

The limitation of this however is that you can only add white and black shades to the image.
You can not add for example a gray color to the image being masked.
Note however that it is posible to add some tints of primary and secondary colors of some color space, but only in a limited way, and I have never seen it used.

In summary you can not add specific colors or fancy borders to the image, only shades and shadows, highlights and flares, or simple black or white text.
However you should not attempt to mix or overlap added white and black effects, as the resulting gray anti-aliasing pixels between the two produces a shaded color from the underlying image, and not the expected gray color.
That is the drawback with this technique!

### Masking images with distortions {#masking_distortions}

What is more incredible is that as as the shading colors is just a gray-scale image, you can compress the lighting effects to just one color channel and the alpha channel mask.

This can then be used to free two color image channels for other image processing effects!
That is you can store other things into the single 'masking image'.

Specifically you can add distortion effects into the same mask image!
For more information on this see [Unified Distortion Image](../mapping/#distortion_unified) which does exactly this!
A sort of ultimate masking image.

------------------------------------------------------------------------

## Framing using Edge Images {#frame_edge}

[![\[IM Image\]](oak_frame_sample.jpg)](oak_frame_sample.jpg) One common way to add a complex border to an image is to use a pre-prepared framing images, to produce a frame such as the example shown (right).

However you also need to be careful with generating frames.
If you look at the given example carefully you will notice that it is not quite right.
The shading of the generated frame is actually incorrect.
The left and bottom frame edges should be swapped to produce a correctly shaded frame for a typical top-left light source.

As such before we even begin, I would like to stress the importance of using the correct image, or the correctly modified image for each edge while framing your thumbnail or photo.
It is very easy to get wrong, so double check your results when you think you have it right.

### The Frame Edge Images {#frame_edge_image}

There are may types of images that can be used to frame a image.

For example here is 'thin black with gold trim' frame that was modified from images provided by Michael Slate &lt;slatem\_AT\_posters2prints.com&gt;.

[![\[IM Image\]](blackthin_top.gif)](blackthin_top.gif) [![\[IM Image\]](blackthin_btm.gif)](blackthin_btm.gif)

There are two images, to provide two different lighting effects, one for the top and left edges, the other for the bottom and right edges.
However the colors along the length of the image does not vary.
As such you can either tile or stretch this frame to produce the length needed.

A similar set of framing pieces are this 'thin ornate gold' tileable border images.

[![\[IM Image\]](goldthin_top.png)](goldthin_top.png) [![\[IM Image\]](goldthin_btm.png)](goldthin_btm.png)

As these images has some fine detail you cannot just simply stretch the image to the desired length.
Nor can you just [Rectangular Rotate](../warping/#rect_rotate) these pieces to produce the other edge pieces, as doing so will get the shading of the fine detail wrong.

A [Diagonal Transpose](../warping/#transpose) distortion should however get the correct shading for the other edges.
Extra caution is advised when reviewing your results, to be sure the both the overall shading and the fine detail shading is correct on all four sides of the image.

Finally a framing image may only consist of a single image that can be used to generate all the framing edges, such as this 'bamboo' tiling frame image.

[![\[IM Image\]](bamboo.gif)](bamboo.gif)

The reason only one image is needed is that the frame has no specific 'inside' or 'outside' to it.
Though the frame does have both overall and fine detail lighting effects that requires you to again be careful of how you rotate/flip/transpose the image for the other edges.

The bigger problem with this frame is that if you just tile it simply, the macro detail becomes very regular, and as such you may need to randomise the tile offset, or even randomise the lengths of pieces being appended togther so as to give it a more natural look.
More on this later.

As you can see framing images can come in a variety of styles, and care must be taken to handle the chosen edging images in the correct way (with regard to lighting image), when generating the other missing edging images.

### Lengthening Framing Pieces {#frame_pieces}

Now in any use of these framing images, we will need to create a longer pieces that will cover the length of the image dimensions.
There are only two basic ways in which this can be done.

You can simply stretch the frame image using resize (without aspect preservation) so as to get the right lengths.
This works for the first set of pieces shown above, which have no internal detail, but is not appropriate for any of the other framing images presented.
Basically it will distort the internal detail, and may become a distraction to the look of the final image.

However the other lengthening method, tiling, can be used for any framing image that has a repeating pattern or detail, which is the case with all the above images presented.

If you are creating your own framing pieces, please be careful that the tiles do match up properly, and to a pixel boundary so as to ensure you have a uniform color and proper cycling of the detail in your framing images.
It you don't you can get an artificial looking joint between the tiles, the become obvious because of the repeation of the tiles.

In the real world picture framers also have the same problem in joining pieces together to make longer pieces.
Basically it is very easy to get two different shades of wood, or very different grain pattern, that when 'dove-tailed' together, makes the joint very obvious.
So really your not alone in this problem.

The 'bamboo' framing images, will need to be tiled.
Though as the detail is restricted to a small area on the image, you can get some interesting random tiling effects, that may need some randomized lengthing and shortening of the peices to remove.
I will not go into this however, and will leave it as a exercise for those that are.

For our examples, and because it works for just about all framing images I will use a simple constant tiling method to generate the longer edge lengths needed.

### Over-simplistic Append {#frame_append}

We can just lengthen the simple 'bamboo' frame above, by tiling it to the right length, then [append](../layers/#append) the images together.

The tiling is done simply by the special [Tiled Canvas](../canvas/#tile) image generator "`tile:`" to tile a image that is being read in.
  
      convert thumbnail.gif \
              \( -size 90x14  tile:bamboo.gif -transpose \) \
              \( -size 90x14  tile:bamboo.gif -transpose \) -swap 0,1 +append \
              \( -size 148x14 tile:bamboo.gif \) \
              \( -size 148x14 tile:bamboo.gif \) -swap 0,1 -append \
              frame_append.gif

  
[![\[IM Output\]](frame_append.gif)](frame_append.gif)

Note that the sizes used in the above two examples were calculated based on the known width (10 pixels) of the framing image, and the size of the image being framed (120x100 pixels).
You will need to adjust the resize arguments appropriately for your images.

One problem with tiling framing pieces (like bamboo) is that all the edges look like they are exact copies of each other!
That is the framing looks artificial.
In real life the frame will have been cut with pretty much random offsets, from longer pieces of real wood, or in this case bamboo.

To fix that you will need to also give such tiles a slightly different [Tile Offset](../canvas/#tile-offset) for each edge of the image.
  
      convert thumbnail.gif \
              \( -size 90x14  -tile-offset +50+0 tile:bamboo.gif -transpose \) \
              \( -size 90x14  -tile-offset +0+0  tile:bamboo.gif -transpose \) \
              -swap 0,1 +append \
              \( -size 148x14 -tile-offset +70+0 tile:bamboo.gif \) \
              \( -size 148x14 -tile-offset +25+0 tile:bamboo.gif \) \
              -swap 0,1 -append       frame_tile_offset.gif

  
[![\[IM Output\]](frame_tile_offset.gif)](frame_tile_offset.gif)

This method of framing isn't too bad for this specific type of edge image, though for other types of frames it can look very silly.
Basically the corners are not correct, and for most frames you really want to have the edge images meet at a 45 degree angle joint, just as you would have in a real picture frame.

One solution to this is to pre-generate by hand appropriate corner images that we can now overlay onto this image to make it correct.
This works well for a simple stretchable framing image (like 'black thin' framing image), but it will fail rather badly for a tileable image like 'bamboo' as the corner image will probably not fit the tile image properly.

The better way is to generate corner joints directly from the tiled edge images.
And I'll be showing you methods of doing this later.

### Extended Overlay Framing {#frame_extended}

Also you can make this type of edge framing look even better by extending the frames beyond the bounds of the original image.
This is often seen for a 'Home-Sweet-Home' type picture.

To do this you will need to first enlarge the original image with lots of extra space into which the longer frame pieces are overlaid.
  
      convert thumbnail.gif -alpha set -bordercolor none -border 34 \
              \( -size 144x14 -tile-offset +30+0 tile:bamboo.gif -transpose \) \
              -geometry +20+10 -composite \
              \( -size 144x14 -tile-offset +45+0 tile:bamboo.gif -transpose \) \
              -geometry +154+0 -composite \
              \( -size 178x14 -tile-offset +60+0 tile:bamboo.gif \) \
              -geometry +0+20 -composite \
              \( -size 178x14 -tile-offset +0+0  tile:bamboo.gif \) \
              -geometry +10+124 -composite \
              frame_overlaid.gif

[![\[IM Output\]](frame_overlaid.gif)](frame_overlaid.gif)

Note the measurements and positioning for this type of framing is not simple, and could use some randomization such as I hardcoded into the above example.
Also you can improve the look further by rounding of the ends of the lengths of frame, with some additional and appropriate shading.

A much better way of framing images in this manner is to generate the framing image as a complete unit, and just overlay it on a fixed size image (see [Simple Border Overlay](#border_overlay)).
However doing this means you can no longer slightly randomize the lengths and position of each framing piece.

### 45 degree corner joints {#frame_joints}

The better solution is to somehow add the framing images around the thumbnail in such a way as to actually create a 45 degree joint in each of the corners of the frame.
This is not easy, and I went though a number of drawing and masking methods until I re-discovered a magical operator called [Frame, 3D like Borders](../crop/#frame).
  
The solution then was simple.
Read in the image, and "`-frame`" it, to create a template which of the areas to be framed.
  
      convert thumbnail.gif -alpha set -bordercolor none \
              -compose Dst -frame 15x15+15  frame_template.gif

  
[![\[IM Output\]](frame_template.gif)](frame_template.gif)

Now note that this template as some interesting features.
First it is transparent in the middle, where the main image will sit.
Second it has four and only four distinct colors defining each area in which we want to place our framing images.
It does not generate 'anti-aliaing' pixels of varing colors in the corners.

Note that to make things easier the width of those areas (15 pixels) is width of the framing pieces we will add to the image.
If the vertical edges were a different thickness to the horizontal edges, this technique would not work very well.
In fact few methods would would well in such a situation.

This image is the framing template and by tiling each of our framing pieces into the four differently colored areas using [Color Fill Primitives](../draw/#color), we will get our 45 degree corner joints, very simply and easily.
  
For example...
  
      convert frame_template.gif \
              -tile blackthin_top.gif -draw 'color 1,0 floodfill' \
              frame_top_filled.gif

  
[![\[IM Output\]](frame_top_filled.gif)](frame_top_filled.gif)

You can repeat this process for the other three edges.
Using transposes to ensure that the highlights and shaodws of the internal detail remain correct.
  
      convert frame_template.gif \
              -tile blackthin_top.gif   -draw 'color 1,0 floodfill' \
              -tile-offset +0+105 -tile blackthin_btm.gif \
                                           -draw 'color 15,105 floodfill' \
              -transpose \
              -tile blackthin_top.gif      -draw 'color 1,0 floodfill' \
              -tile-offset +0+135 -tile blackthin_btm.gif \
                                           -draw 'color 15,135 floodfill' \
              -transpose \
              -gravity center thumbnail.gif -composite frame_filled.gif

  
[![\[IM Output\]](frame_filled.gif)](frame_filled.gif)

From a IM forum discussion [45 degree frame joints](../forum_link.cgi?f=1&t=21867) a simplier solution, involving pre-rotating the bottom edge was found.
Here is the full example using the [In Memory Register](../files/#mpr) to save intermediate images.
  
      convert thumbnail.gif                -write mpr:image    +delete \
              goldthin_top.png             -write mpr:edge_top +delete \
              goldthin_btm.png -rotate 180 -write mpr:edge_btm +delete \
              \
              mpr:image -alpha set -bordercolor none \
              -compose Dst -frame 25x25+25  -compose over \
              \
              -transverse  -tile mpr:edge_btm \
              -draw 'color 1,0 floodfill' -transpose -draw 'color 1,0 floodfill' \
              -transverse  -tile mpr:edge_top \
              -draw 'color 1,0 floodfill' -transpose -draw 'color 1,0 floodfill' \
              \
              mpr:image -gravity center -composite    frame_gold.png

  
[![\[IM Output\]](frame_gold.png)](frame_gold.png)

As you can see we still have a problem, it looks very artifical in the top left and bottom right corner, due to a diagonal mirror effect that results from the tiling.
To fix this we need to add a randomised "`-tile-offset`", so as to remove this mirror effect.
  
![](../img_www/warning.gif)![](../img_www/space.gif)
  
*[Tile Offset](../canvas/#tile-offset) setting was broken before IM version 6.3.9-9 in that the 'X' offset was being used for both 'X' and 'Y' offset values (the given 'Y' value was ignored).
This means that the above example will probably incorrectly tile the bottom and right edges, in older releases of IM.*

**Scripted Version**

**This needs to be re-written using the last example as template**

You can of course do all the above in a single command.
However lets do it in a scripted way.
This version uses some in-line code to generate appropriate edging images from the base images provided using [Simple Distorts](../warping/#rect_rotates) and some randomized [Image Rolls](../warping/#roll) to improve the overall look of the tiled image.
These can be adjusted depending on the type of edge framing image that was provided.

The processed edging images are then tiled using an [In-Memory Tile Image](../canvas/#tile_memory) technique and the frame template (generated) is used to mask those images, as we did above.
  
      image=thumbnail.gif
         image_w=`convert $image -format %w info:`
         image_h=`convert $image -format %h info:`

      top=goldthin_top.png
      btm=goldthin_btm.png

         width=`convert $top -format %h info:`
         length=`convert $top -format %w info:`

      # Size of the new image ( using BASH integer maths)
      new_size=$(($image_w+$width*2))x$(($image_h+$width*2))

      # IM options to read a 'randomly rolled' version for the edge pieces
      lft="( $top -roll +$(($RANDOM % $length))+0  -transpose )"
      rht="( $btm -roll +$(($RANDOM % $length))+0  -transpose )"

      # IM options to 'randomly rolled' the top and bottom pieces
      top="( $top -roll +$(($RANDOM % $length))+0 )"
      btm="( $btm -roll +$(($RANDOM % $length))+0 )"

      # Frame the image in a single IM command....
      convert -page +$width+$width  $image  +page -alpha set \
        \( +clone -compose Dst -bordercolor none -frame ${width}x$width+$width \
           -fill none -draw "matte 0,0 replace" \
              -flip   -draw "matte 0,0 replace"   -flip \) \
        \( $top $btm -append -background none -splice 0x${image_h}+0+$width \
           -write mpr:horz +delete -size $new_size tile:mpr:horz +size \
           -clone 1  -compose DstOut -composite \) \
        \( $lft $rht +append -background none -splice ${image_w}x0+$width+0 \
           -write mpr:vert +delete -size $new_size tile:mpr:vert +size \
           -clone 1  -compose DstIn -composite \) \
        -delete 1  -compose Over  -mosaic   framed_script.png

[![\[IM Output\]](framed_script.png)](framed_script.png)

And there we have a perfectly framed image with 45 degree corner joints, with randomized tiling offsets.

Yes it is a complex example.
But that is to allow the use of [In-Memory Tile Images](../canvas/#tile_memory) so we can pre-process the framing images, all in the one command.
This makes it more complex but also more versatile.

The above code has been built into a shell script, which you can download ("`frame_edges.tar.gz`" from the [IM Example Scripts](../scripts/) directory).
This tar file includes the script and a set of framing images, that the script understands how to process and use.
It also adds a 'cardboard' border between the frame and the image proper.

#### Future example

Using tiling edges with matching corner pieces.

The edge images will need to match up to pre-prepared corner pieces, but also tile neatly across the fixed length of the image.
That means that the whole tiled edge may need some stretching or compression so as to align the edge tiles with its corner pieces.
To work properly teh edge tiles must repeat at least 3 or 4 times across the smallest image edge.

An example of this type of tiled edge/corner is the implementation of a border of 'leaves' or 'fleur' effects.

---
created: 8 February 2004  
updated: 18 July 2014  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 7.0.0
url: http://www.imagemagick.org/Usage/thumbnails/
---
