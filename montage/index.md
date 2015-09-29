# Montage, Arrays of Images

The original use of "`montage`" is to generate tables of image thumbnails, that is, to reference thumbnails of large collections of images, especially photos.
While it still can be used for that purpose, it can also do a lot more.
This page examines what you can do with "`montage`", and how you can use it on your own images.

---

## Montage, Introduction {#montage}

The "`montage`" command is designed to produce an array of thumbnail images - sort of like a proof sheet of a large collection of images.

The default "`montage`" with no options is very plain, with quite large containment squares, no frame, labels, or shadows.

~~~ 
montage balloon.gif medical.gif present.gif shading.gif  montage.jpg
~~~

[![\[IM Output\]](montage.jpg)](montage.jpg)

### Geometry - Tile Size and Image Resizing {#geometry_size}

The "`-geometry`" setting, is probably the most important control sizing of "`montage`" as it controls the size of the individual thumbnail images, and the spacing between them.

The size part of the geometry is used as an argument to the [Resize Operator](../resize/#resize), including all its special purpose flags.
The position part of the option is interpreted as the amount of border space to leave around the image, so making this smaller will make the gaps between the images smaller.

The default "`-geometry`" setting is '`120x120>+4+3`' which means to fit any image given into a box 120x120 pixel in size.
If the image is larger shrink it, but don't resize smaller images (as per the [Only Shrink Larger ('&gt;') Flag](../resize/#larger).
The 'tile' size is then set to the largest dimensions of all the resized images, and the size actually specified.
That means you will never get a tile size that is smaller than the specified "`-geometry`" size.

You can remove huge size of the tiles in the previous example space by modifing the "`-geometry`" default.
For example, by removing the 'size' component, none of the images will be resized, and the 'tile' size will be set to the largest dimensions of all the images given.
For example, here I ask "`montage`" to tile using the largest image given with a small gap between tiles.
This is a very typical setting to use when all the input images are small and roughly same size.

~~~  
montage balloon.gif medical.gif present.gif shading.gif \
   -geometry +2+2   montage_geom.jpg
~~~

[![\[IM Output\]](montage_geom.jpg)](montage_geom.jpg)

For example, here I replaced one image with a larger 'logo' image, but set a the resize setting to '`48x48`' to resize both smaller and larger images.

~~~ 
montage balloon.gif medical.gif present.gif logo: \
   -geometry 48x48+2+2   montage_geom_size.jpg
~~~

[![\[IM Output\]](montage_geom_size.jpg)](montage_geom_size.jpg)

And here I again restrict the resize to just images larger than the specified tile size.

~~~
montage balloon.gif medical.gif present.gif logo: \
   -geometry 48x48\>+2+2   montage_geom_larger.jpg
~~~

[![\[IM Output\]](montage_geom_larger.jpg)](montage_geom_larger.jpg)

As you can see, the spacing between images appears to be larger than the requested 2 pixel spacing.
But that is not the case.
The tiles are still separated by 2 pixels, but the images themselves do not fill the 48x48 tile size requested. The 'logo' image was still resized to fit into the 48x48 pixel tile.

If you don't want any resizing, then only define the spacing between the tiles.

Alternatively, use a special size such as '`1x1<`' which tells IM to only resize smaller images to the given size.
As no image can be smaller than 1 pixel, no image will be resized.
The tile size will thus be again the largest dimention of all the images on the page - see [Zero Geometry, caution required](#zero_geometry) for reasons why you may like to do this.

### Geometry - Tile Spacing {#geometry_spacing}

The positional part of the "`-geometry`" setting will add space between the individual 'tiles', by adding a [Border](../crop/#border) of those dimensions around the tiles before [Appending](../layers/#append) them together.

That means for the default "`-geometry`" setting of '`+4+3`', the tiles will be spaced from the left and right edges of the final image by 4 pixels, and will have a 8 pixel (twice the size given) spacing horizontally between the tiles.
The same goes for the vertical spacing.
Note how the space bewteen the tiles when all the images were resized (second last example) is twice the size of the space around the edges.

### Tile Layout Controls {#tile}

The next most important option in "`montage`" is the "`-tile`" setting.
This tells "`montage`" what limits you want on how the tiled images are to be laid out on the final result.

In ImageMagick version 6 "`montage`" will make an educated guess as to how best to tile a given number of images, when you provide no "`-tile`" hints.
It does, however, assume that the images being tiled are roughly squarish in nature, as it does not look at the images' aspect ratios.

~~~
montage font_1.gif      -geometry 16x16+1+1  tile_1.gif
montage font_[12].gif   -geometry 16x16+1+1  tile_2.gif
montage font_[123].gif  -geometry 16x16+1+1  tile_3.gif
montage font_[1-4].gif  -geometry 16x16+1+1  tile_4.gif
montage font_[1-5].gif  -geometry 16x16+1+1  tile_5.gif
montage font_[1-6].gif  -geometry 16x16+1+1  tile_6.gif
montage font_[1-7].gif  -geometry 16x16+1+1  tile_7.gif
montage font_[1-8].gif  -geometry 16x16+1+1  tile_8.gif
montage font_[1-9].gif  -geometry 16x16+1+1  tile_9.gif
montage font_[0-9].gif  -geometry 16x16+1+1  tile_0.gif
~~~

[![\[IM Output\]](tile_1.gif)](tile_1.gif) [![\[IM Output\]](tile_2.gif)](tile_2.gif) [![\[IM Output\]](tile_3.gif)](tile_3.gif) [![\[IM Output\]](tile_4.gif)](tile_4.gif) [![\[IM Output\]](tile_5.gif)](tile_5.gif) [![\[IM Output\]](tile_6.gif)](tile_6.gif) [![\[IM Output\]](tile_7.gif)](tile_7.gif) [![\[IM Output\]](tile_8.gif)](tile_8.gif) [![\[IM Output\]](tile_9.gif)](tile_9.gif) [![\[IM Output\]](tile_0.gif)](tile_0.gif)

  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> The strange "`[1-5]`" syntax is a UNIX shell shorthand, which is expanded into a list of filenames.
> The "`montage`" command itself does not see these characters, just the resulting list of files.

ImageMagick is pretty good at figuring out the right "`-tile`" setting to use for a specific number of input images.
Here is a table of number of input images and the tile setting IM will use to lay out those images.

<!-- :ATTENTION: Table needs fixing -->
Num Images
Tile Setting
1
1x1
2
2x1
3
3x1
4
2x2
5 - 6
3x2
7 - 8
4x2

Num Images
Tile Setting
9
3x3
10 - 12
4x3
13 - 15
5x3
16 - 20
5x4
21 - 24
6x4
25
5x5

Num Images
Tile Setting
26 - 30
6x5
31 - 36
7x5
31 - 35
7x5
36
6x6
37 - 42
7x6
43 - 48
8x6

Note that IM will not automatically select a 'perfect fit' 6x3 tile setting for 18 images, nor a 7x4 setting for 28 images.

However, if you specify a specific "`-tile`" setting, "`montage`" will always create an image big enough to hold that many 'tiles'.

~~~
montage font_[1-7].gif  -tile 9x1  -geometry 16x16+1+1  tile_9x1.gif
montage font_[1-7].gif  -tile 4x3  -geometry 16x16+1+1  tile_4x3.gif
montage font_[1-7].gif  -tile 3x3  -geometry 16x16+1+1  tile_3x3.gif
montage font_1.gif      -tile 2x3  -geometry 16x16+1+1  tile_2x3.gif
~~~

[![\[IM Output\]](tile_9x1.gif)](tile_9x1.gif) [![\[IM Output\]](tile_4x3.gif)](tile_4x3.gif) [![\[IM Output\]](tile_3x3.gif)](tile_3x3.gif) [![\[IM Output\]](tile_2x3.gif)](tile_2x3.gif)

As you can see, "`montage`" created an image that is large enough to hold the number of tiles specified, regardless of how many images are available to fill the tile space requested, be it 7 images, or just 1 image.

It will only fill the space row by row, no option is currently provided to do a column-by-column fill of the tile space.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Before IM v6.1 "`montage`" would automatically truncate the extra space if the number of images did not use that space.
> As such, a setting such as the first "`9x1`" image would have been truncated to produce a "`7x1`" tile image.
>  
> Because of this, past users of "`montage`" often used large numbers such as "`999x1`" to generate a single row of images.
> Now such a argument will produce a very long image, and could take a long time for IM to complete.
> As such...
  
**Avoid the use of very large tile numbers in IM "`montage`"!**

You can avoid the problems of extra space, and multiple images, especially for an unknown number of input images, by removing either a row, or the column number, from the "`-tile`" setting.
The missing number will be taken by "`montage`" as being variable and "`montage`" will only create enough tile space to hold ALL the input images, producing only one image, never multiple images.

~~~  
montage font_[1-7].gif  -tile x1  -geometry 16x16+1+1  tile_x1.gif
montage font_[1-7].gif  -tile x2  -geometry 16x16+1+1  tile_x2.gif
montage font_[1-7].gif  -tile x4  -geometry 16x16+1+1  tile_x4.gif
montage font_[1-7].gif  -tile 4x  -geometry 16x16+1+1  tile_4x.gif
montage font_[1-7].gif  -tile 5x  -geometry 16x16+1+1  tile_5x.gif
montage font_[1-7].gif  -tile 9x  -geometry 16x16+1+1  tile_9x.gif
~~~

[![\[IM Output\]](tile_x1.gif)](tile_x1.gif) [![\[IM Output\]](tile_x2.gif)](tile_x2.gif) [![\[IM Output\]](tile_x4.gif)](tile_x4.gif) [![\[IM Output\]](tile_4x.gif)](tile_4x.gif) [![\[IM Output\]](tile_5x.gif)](tile_5x.gif) [![\[IM Output\]](tile_9x.gif)](tile_9x.gif)

This is the more typical use of the "`-tile`" setting, as it ensures the montage is sized correctly, while still allowing it some control in determining the final array size.

Note the last image, in the above where we requested 9 columns of images.
IM still generated the requested 9 columns, even though less than 9 images were given.
On the other hand, the first image (one row requested), is exactly the right length to hold all the images.

If you have more input images than "`montage`" can tile into the space given by a "`-tile`" setting, then multiple images can be generated by "`montage`", either resulting in image sequence numbers being added to the filename, or some sort of GIF animation, being created - see [Writing Multiple Images](../files/#write_list) for details.

For example, here I have asked "`montage`" to save separate images for each page generated, by supplying a '`%d`' for the frame/scene/page number of each image filename.

~~~ 
montage  font_*.gif  -tile 4x1  -geometry +2+2  multi_%d.gif
~~~

[![\[IM Output\]](multi_0.gif)](multi_0.gif) [![\[IM Output\]](multi_1.gif)](multi_1.gif) [![\[IM Output\]](multi_2.gif)](multi_2.gif)

### Frame Decoration {#frame}

The best part of using "`montage`" to arrange images is that it provides a lot of extra controls to add extra 'fluff' around each image.

For example, you can better define the images being displayed by adding a "`-frame`" around each image.

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -tile x1  -frame 5  -geometry +5+5   frame.jpg
~~~

[![\[IM Output\]](frame.jpg)](frame.jpg)

This is not like the same option in "`convert`" - see [Adding a 3D frame](../crop/#frame) example).
The "`montage`" frame option will automatically figure out default values for the internal and external bevel of the frame.
As such only a single argument number is needed.

### Border Decoration {#border}

Sometime around IM v6.1.0, "[`-border`](../option_link.cgi?border)" became a new decorative option of "`montage`".
It now adds extra 'padding' around each image, after it has been resized according to the "[`-geometry`](../option_link.cgi?geometry)" setting.

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -tile x1  -border 5 -geometry +5+5   border.jpg
~~~

[![\[IM Output\]](border.jpg)](border.jpg)

  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> The "[`-border`](../option_link.cgi?border)" decoration does not currently work when the [Frame Decoration](#frame) is also applied.


> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Before IM v6.1.0 (approx) [**-border**](../option_link.cgi?border) would been applied to images at the point in which it appeared in the "`montage`" command line, just like it would have with "`convert`"
  
That is, border would have been thus added to the image long before the images get resized (according to "[`-geometry`](../option_link.cgi?geometry)"), which resulted in different border widths around each image depending on the size of the image at that point.
It was to remove this inconsistency that [**-border**](../option_link.cgi?border) became a special "`montage`" setting.

### Shadow Decoration {#shadow}

Adding a shadow with the frame is also quite good.

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -tile x1  -frame 5  -shadow  -geometry +5+5   frame_shadow.jpg
~~~

[![\[IM Output\]](frame_shadow.jpg)](frame_shadow.jpg)

Of course, you don't actually need a frame to generate image shadows

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -tile x1  -shadow  -geometry +5+5  -background lightblue \
   shadow_noframe.jpg
~~~

[![\[IM Output\]](shadow_noframe.jpg)](shadow_noframe.jpg)

As of IM v6.3.1 when 'soft shadows' were implemented, the shadows will now be shaped according to the transparency of the images being displayed!

~~~
montage font_1.gif  font_7.gif  font_2.gif  font_0.gif \
   -tile x1  -shadow  -geometry +3+5 -background none \
   shadow_shaped.png
~~~

[![\[IM Output\]](shadow_shaped.png)](shadow_shaped.png)
As you can see, the shadow used by "`montage`" is actually a semi-transparent color, allowing the background to affect its final color.
This means if you create a montage with textured background, or use a transparent background and overlay it, the shadow will do the right thing.

Of course, you need to use an image format that can handle semi-transparent colors, like PNG.
Remember, because of [GIF Boolean Transparency](../formats/#boolean_trans) you can not use GIF image file format for this purpose.

Note that shadows do not care about the "[`-geometry`](../option_link.cgi?geometry)" spacing between the images.
As such, if the images are too close together, the shadow of previous images can be obscured by later images.
For example...

~~~  
montage balloon.gif medical.gif present.gif shading.gif \
   -tile x1  -shadow  -geometry +1+1  -background none \
   shadow_spacing.png
~~~

[![\[IM Output\]](shadow_spacing.png)](shadow_spacing.png)

It is thus recommended that a reasonable amount of "[`-geometry`](../option_link.cgi?geometry)" spacing be provided when using shadow.

To avoid 'edge clipping' shadows too much, the "[`-shadow`](../option_link.cgi?shadow)" option will add 4 extra edge spacing pixels the right and bottom edges of the final image.
This is on top of the normal "[`-geometry`](../option_link.cgi?geometry)" spacing provided.
However as you can see above, this is not always enough space.

"`Montage`" currently also provides no controls for the offset, color or the 'softness' of the generated shadow (at least not yet), but then, you didn't have such control with hard rectangular shadow that was provided by older versions of "`montage`".

### Labeling Montage Images {#label}

You can also tell "`montage`" to label images with their source filenames, though you probably need to resize the image frames, or the labels may not fit, truncating the text label.

In this case, we added a "`60x60>`" to the geometry string, which tells IM to shrink larger images to fit into this space, but *not* to enlarge images if they are smaller.
This is probably the most typical use of "`montage`".

~~~
montage -label '%f'  balloon.gif medical.gif rose: present.gif shading.gif \
   -tile x1  -frame 5  -geometry '60x60+4+4>'  label_fname.jpg
~~~

[![\[IM Output\]](label_fname.jpg)](label_fname.jpg)

The '`%f`' is a special format character, which can pull out various details about the images in memory - see [Image Property Escapes](http://www.imagemagick.org/script/escape.php) for details of other information you can extract from images.

You don't have to use a "`-frame`" when labeling thumbnails.
The labels are not shadowed, so that they remain clearly readable.

~~~
montage -label '%f'  balloon.gif medical.gif logo: present.gif shading.gif \
   -tile x1 -shadow -geometry '60x60+2+2>'  label_shadow.jpg
~~~

[![\[IM Output\]](label_shadow.jpg)](label_shadow.jpg)

And as of IM v 6.2.1, you can now re-label images after they have been read in using the "`-set`" image attribute operator.

Let's use the "`-set`" operator to add more information about the images, and also a few more "`montage`" settings...

~~~
montage balloon.gif medical.gif logo: present.gif shading.gif \
   -tile x1  -geometry '90x32+2+2>'  -pointsize 10 \
   -set label '%f\n%wx%h'   -background SkyBlue   label_fname3.jpg
~~~

[![\[IM Output\]](label_fname3.jpg)](label_fname3.jpg)

As we showed in the examples above, you can use the "`-label`" setting to define the default label for an image, as they are read in, or you can re-label the image afterward using the "`-set`" operator.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Note that '`%wx%h` gives the current pixel width and height of the image as it is in memory.
> If the image size was modified, such as during input this may be different from the image's in disk (or creation) size.
> Use '`%[width]x%[height]`' instead if you want its in memory pixel size.

You can also label images differently by setting the labels of individual images.
Either option can be used, though you will need to make use of parentheses to limit what images the "`-set`" operator will be applied to.

Here, for example, we use both forms of labeling.
But let's also add a title to the montage, just because we can...

~~~
montage -label Balloon   balloon.gif  \
      -label Medical   medical.gif  \
      \( present.gif  -set label Present  \) \
      \( shading.gif  -set label Shading  \) \
      -tile x1  -frame 5  -geometry '60x60+2+2>' \
      -title 'My Images'     titled.jpg
~~~

[![\[IM Output\]](titled.jpg)](titled.jpg)

You can turn off image labeling for the next image(s) by using a "`-label '' `" or "`+label`".
However, as you will see later these two settings are not quite the same.
The same applies for a post reading, label "`-set`" operation.

~~~
montage balloon.gif \
      -label 'My Image'  medical.gif \
      +label             present.gif \
      -label ' '         shading.gif \
      -tile x1  -frame 5  -geometry '60x60+2+2>'   labeling.jpg
~~~

[![\[IM Output\]](labeling.jpg)](labeling.jpg)

The last image shows how using a space for an image label, you can create a image label space, but leave it blank.

This presents a good rule of thumb when using "`montage`"...
**Either label all your images, or none of them!**

You don't have to label your images during the montage operation itself.
Both the MIFF and PNG formats, can store a label as part of their image format.

"`Montage`" will automatically label any image read in that already contains a label.
This is automatic and does not need to be specified, and I have used this technique to generate some very complex image montages.
For example, the montage array in [Annotate Angle Examples](../misc/#annotate) was created using this technique.

If you do not want this automatic labeling, you must specifically tell "`montage`" to reset all the labels being read in or created to the empty string, using "`-label ''`" before reading the image.
Or you can just delete the label meta-data using "`+set label`" after reading the images.

This is where "`+label`" differs from using an empty label ("`-label ''`").
The former will reset the default behavior back to automatically using any label meta-data that the image being read-in may have, while the latter replaces the label with an empty string, which effectively removes the label.
You can also preserve the original label of the image using "`-label '%l'`", which can be useful as a NO-OP labeling option in image processing scripts.

Note that "`-set`" cannot restore the original label of an image, once it has been modified or removed, either by using "`-label`" or "`-set`":

~~~
convert -label 'medical'  medical.gif  label_medical.png
convert -label 'logo'     logo:        label_logo.png
convert -label 'rose'     rose:        label_rose.png

montage           label_medical.png \
      -label '' label_logo.png    \
      +label    label_rose.png    \
      -tile x1  -frame 5  -geometry '60x60+2+2>' label_control.jpg
~~~

[![\[IM Output\]](label_control.jpg)](label_control.jpg)

In the above, you can see that the first image was labeled using the label supplied with the image itself.
The second had the incoming label removed by a "`-label '' `" setting, while the third also used the image's label because we turned off the label setting with "`+label`".

### Using Saved Image MetaData {#metadata}

When generating images for later use by "`montage`", it is important to know what sort of image metadata a specific image file format can save.
For example, only PNG, and MIFF image file format can actually store '`label`' meta-data in their saved image file format...

~~~
convert -label 'GIF'  balloon.gif  label.gif
convert -label 'JPG'  medical.gif  label.jpg
convert -label 'PNG'  present.gif  label.png
convert -label 'MIFF' shading.gif  label.miff

montage label.gif label.jpg label.png label.miff \
      -tile x1  -frame 5  -geometry '60x60+2+2>' label_files.jpg
rm label.*
~~~

[![\[IM Output\]](label_files.jpg)](label_files.jpg)

However, all the common file formats allow you to use '`comment`' meta-data, which you can use by specifying a '`%c`' argument to "`-label`".

~~~
convert -comment 'GIF'  balloon.gif  comment.gif
convert -comment 'JPG'  medical.gif  comment.jpg
convert -comment 'PNG'  present.gif  comment.png
convert -comment 'MIFF' shading.gif  comment.miff

montage -label '%c' comment.gif comment.jpg comment.png comment.miff \
      -tile x1  -frame 5  -geometry '60x60+2+2>' comment_files.jpg
rm comment.*
~~~

[![\[IM Output\]](comment_files.jpg)](comment_files.jpg)

This is often more useful for pictures saved in the JPEG file format, though JPEG image comments generally are too large (often whole paragraphs describing the image), for use as montage labels, as they will not be word wrapped (see [Montage of Polaroid Photos](#polaroid) for an alternative method of labeling using image 'comment' meta-data).

Many other programs also automatically add 'made-by' labels and comments to images they save (YUCK) so some caution is recommended.
The [GIMP](http://www.gimp.org/) program particularly likes to add such comments and labels, unless you tell it not to, every time you save an image.

Note that IM is generally not used to add comments to saved JPEG files, (due to [JPEG Lossy Compression](../formats/#jpg)) unless processing them for other reasons.
Instead, they are usually added by some other method in order to avoid reading and re-writing the image data and thereby degrading the JPEG image files in which you are adding comments - see [lossless JPEG Processing](../formats/#jpg_lossless) options, for some such methods.

It is also important to note that labeling (and image 'comments') is not specific to "`montage`" - it just makes automatic use of image labels if present.
Labels and comments are attached to images, and the their specific file formats, and is not "`montage`" or even IM specific.

The PNG and MIFF file format also allow you to use a less commonly used '`caption`' meta-data.

~~~
convert  balloon.gif -set caption 'GIF'  caption.gif
convert  medical.gif -set caption 'JPG'  caption.jpg
convert  present.gif -set caption 'PNG'  caption.png
convert  shading.gif -set caption 'MIFF' caption.miff

montage -label '%[caption]' caption.gif caption.jpg caption.png caption.miff \
      -tile x1  -frame 5  -geometry '60x60+2+2>' caption_files.jpg
rm caption.*
~~~

[![\[IM Output\]](caption_files.jpg)](caption_files.jpg)

Actually, both these file formats allow you to use ANY [Image Property Meta-data](../basics/#property) that may be present in an image when it is saved!

~~~
convert  balloon.gif -set my_data 'GIF'  my_data.gif
convert  medical.gif -set my_data 'JPG'  my_data.jpg
convert  present.gif -set my_data 'PNG'  my_data.png
convert  shading.gif -set my_data 'MIFF' my_data.miff

montage -label '%[my_data]' my_data.gif my_data.jpg my_data.png my_data.miff \
      -tile x1  -frame 5  -geometry '60x60+2+2>' my_data_files.jpg
rm my_data.*
~~~

[![\[IM Output\]](my_data_files.jpg)](my_data_files.jpg)

### Leaving Gaps in a Montage {#null}

While you can leave extra space in a montage at the bottom by judicious use of the "`-tile`" setting and controlling the number of images given, leaving an empty tile space in the middle of a montage requires the use of a special image.

The "`null:`" generated image was defined specifically for this purpose.
The position in which it appears will not receive any label (even if one is defined), nor will it have any frame or shadow 'fluff' added.
The tile is just left completely empty except for the background color (or texture) of the montage drawing canvas itself.

~~~
montage -label 'Image' medical.gif null: present.gif \
      -tile x1  -frame 5  -geometry +2+2   montage_null.jpg
~~~

[![\[IM Output\]](montage_null.jpg)](montage_null.jpg)

Note that to other IM commands the "`null:`" image is represented a single pixel transparent image. It is also used as a 'error image' for options like "`-crop`" or "`-trim`" which could produce a 'zero' or empty image as a result of the operation.

This special image cannot be saved and then later used to leave gaps, currently it is only 'special' if given on the command line of "`montage`".
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> There is no method, at this time, to allow montaged images to span multiple rows or columns, as you can in HTML tables.
> Nor can you generate variable sized rows and columns to best fit the array of images being generated.
> If you really need this sort of ability you will need to develop your own "`montage`" type of application.
> If you do develop something, then please contribute, and we'll see about merging it into the existing "`montage`" application.
  
Some solutions for this includes labeling and framing the image thumbnails yourself and then using either [Append Images](../layers/#append) or use a more free form [Layering Image](../layers/#layer_examples) technique.

---

## More Montage Settings {#settings}

The "`montage`" settings I have shown above are only the basic controls for "`montage`".
There are a lot of other settings you may like to consider for your own needs.

### Montage Color Settings {#color}

- `-background`
The color outside the drawn frame.
Often this is set to the '`none`' or '`transparent`', for use on web pages.
The [-texture](../option_link.cgi?texture) setting will be used instead if given.

- `-bordercolor`
The fill color inside the frame for images, or any border padding.
Any transparent areas in an image will become this color, unless no such decoration is added.

- `-mattecolor`
The color used as the frame color.
Note that the color is also made lighter and darker to give the frame a beveled 3D look.
So this setting really defines 5 colors - see also [Framing Images](../crop/#frame_border)
- `-fill`
The fill color for text labels and titles.
- `-stroke`
The stroke color for text labels and titles.

### Montage Control Settings {#controls}

> `-tile {cols}x{rows}`
> The number of images across and down used to fill a single montage image. If more images were read in or created than fits in a single montage image, then multiple images will be created. (See [Tile Controls](#tile) above)

> `-title {string}`
> Set a title over the whole montage, using the same font (but larger) as that used to label the individual images.

> `-frame {width}`
> Create a frame around the box containing the image, using the *width* provided (must be at least 2, but 5 or 6 is a good value). If used any transparency in images will also become the border color.

> `-border {width}`
> Create a border around the image, using the *width* provided. If used any transparency in images will also become the border color.

> `-shadow`
> Generate a shadow of the frame.
> Note that no argument is required or expected.

> `-texture {filename}`
> Use the given texture (tiled image) for the background instead of a specific color.
> See the section on [Background and Transparency](#bg) below for more information.

> `-geometry {W}x{H}+{X}+{Y}     `
> Resize images after they have all been read in before "`montage`" overlays them onto its canvas.
> It also defines the size and the spacing between the tiles into which the images are drawn.
> If no size is specified the images will not be resized.

> `-gravity {direction}`
> if the image is smaller than the frame, where in the frame is the image to be placed. By default it is centered.

Added to the above are all the font settings that the "`label:`" image creation operator understands - see [Label Image Generator](../text/#label).
These settings are used for the creation of labels added underneath the displayed image.
These include settings such as "`-font`", "`-pointsize`" (ignored for "`-title`"), "`-density`", "`-fill`", "`-stroke`", and "`-strokewidth`".
As long as any, or all, of the above settings are defined or reset, before the final 'output filename' argument, "`montage`" will use them as you have requested.

### Re-Using Settings for Image Read/Creation {#reuse}

Note, however, that many of these options are also used for other purposes, in either the generation of images or during image processing.
But thanks to the 'do things as you see them' command line handling on IM v6, this presents no problem to the "`montage`" command.

That means you are free to use any of these option settings to read, create, or modify the images being read in, then reset those settings after all the images have been read in or created.
The final setting value will be what "`montage`" will use for its final processing.

This was not the case in versions of IM before version 6, in which it was generally impossible to separate image creation settings, from montage settings, without generating intermediate images - such as in the [Image Labels](#image_labels) example above.

Here is a practical example of setting reuse.
I wanted to make a table of some of the fonts I have been using in these example pages, then reset the settings to other values for the final processing of the images by "`montage`".

~~~
montage -pointsize 24  -background Lavender \
      -font Candice      -label Candice      label:Abc-123 \
      -font Corsiva      -label Corsiva      label:Abc-123 \
      -font SheerBeauty  -label SheerBeauty  label:Abc-123 \
      -font Ravie        -label Ravie        label:Abc-123 \
      -font Arial        -label Arial        label:Abc-123 \
      -font ArialI       -label ArialI       label:Abc-123 \
      -font ArialB       -label ArialB       label:Abc-123 \
      -font ArialBk      -label ArialBk      label:Abc-123 \
      -font CourierNew   -label CourierNew   label:Abc-123 \
      -font LokiCola     -label LokiCola     label:Abc-123 \
      -font Gecko        -label Gecko        label:Abc-123 \
      -font Wedgie       -label Wedgie       label:Abc-123 \
      -font WebDings     -label WebDings     label:Abc-123 \
      -font WingDings    -label WingDings    label:Abc-123 \
      -font WingDings2   -label WingDings2   label:Abc-123 \
      -font Zymbols      -label Zymbols      label:Abc-123 \
      \
      -frame 5  -geometry +2+2   -font Arial -pointsize 12 \
      -background none  -bordercolor SkyBlue  -mattecolor DodgerBlue \
      montage_fonts.gif
~~~

[![\[IM Output\]](montage_fonts.gif)](montage_fonts.gif)

Note the two stages to the "`montage`" command, which I clearly marked using an extra almost empty line.

The first part is essentially exactly as you would define multiple images using the normal IM "`convert`" command, and is processed in the same, 'do it as you see it' order.

The second part, defines *all* the settings I wanted the "`montage`" command itself to use.
That is the framing, image resizing, fonts and colors I wanted to use in the final montage image.
I especially take care to reset the "`-font`" and "`-pointsize`" settings for the labeling underneath the montaged images.

While you can separate the options of "`montage`" like this, you can actually define the montage settings at any time on the command line.
As long as those settings do not interfere with your image creating and processing options, and are still defined correctly when the end of the command line is reached, "`montage`" will use them.

ASIDE: You may like to look at the shell script I wrote to do something similar to the above (and which works with earlier versions of "`montage`") to display a directory of truetype (.ttf) fonts, called "`show_fonts`".
Another shell script example is "`show_colors`".

### Montage vs Convert Option Differences {#diff}

Now while "`montage`" generally allows you to use any "`convert`" settings and operators in reading and processing its input images, there are a few differences which need to be highlighted.
These "`convert`" operators and settings are different when used within "`montage`".

- `-tile`
In "`convert`" the "`-tile`" setting defines an image to use as a texture instead of using the "`-fill`" color. In "`montage`" it defines how to lay out the individual image cell 'tiles' - see [Tile Layout Controls](#tile) above for more detail.

- `-frame`
In "`convert`" this is an operator used to add a 3D frame border around images, and requires 4 arguments to work correctly - see [Convert Frame](../crop/#frame) examples, and see [Frame Decoration](#frame) for more detail.

- `-border`
Sometime around IM v6.1.0 this operator became a special "`montage`" option.
As such, like the previous frame option it only takes one number as an argument, rather than two arguments as per the [Convert Border](../crop/#border) - see [Border Decoration](#border) for more detail.

- `-shadow`
The "`-shadow`" option in "`convert`" takes an argument which is used to create a soft blurry shadow which can be placed under a second copy of the original image.
However, in "`montage`" this is only a Boolean setting that just turns the rectangular shadowing abilities, on and off - see [Shadow Decoration](#shadow) for more detail.

- `-geometry`
The "`-geometry`" option in "`montage`" is simply saved to provide the size of the images within each cell of the final montage, and the spacing between the cells.
In "`convert`" it resizes just the last image, and defines the offset for [Image Composition](../compose/#compose).

If you really need to use the "`convert`" form of these options, then you will need to pre-process your images using "`convert`" before passing them to "`montage`".

One method using intermediate files was demonstrated in the [Image Labels](#image_labels) example above.

Another is to just do your processing in "`convert`" and just pipe the resulting multiple images into "`montage`".
This separation is easy to do if you always do your image input handling first, then set the "`montage`" specific settings afterward, such as I have done in all these examples.
This is especially clearly shown in the last font example above.
For example, let's frame our images using the "`convert`" frame, and then frame them again using the "`montage`" labeled frames.

~~~
convert -label %f   balloon.gif medical.gif present.gif shading.gif \
	-mattecolor peru  -frame 10x5+3+0    miff:-  |\
  montage  -   -tile x1  -frame 5  -geometry '64x56+5+5>' double_frame.jpg
~~~

[![\[IM Output\]](double_frame.jpg)](double_frame.jpg)

You can also see the extra arguments required by the "`convert`" form of the "`-frame`" operator.

---

## Indexes of Image Directories {#index}

### HTML Thumbnail Image Maps {#html}

"`Montage`" is especially designed for generating thumbnail maps of images.
For example, here I have created an index of the [Photo Images](../img_photos/) source directory, which holds the digital photos used for examples throughout IM Examples.
Click the 'art' image below to view the result.

~~~
montage -label '%t\n%[width]x%[height]' \
   -size 512x512 '../img_photos/*_orig.*[120x90]' -auto-orient \
   -geometry +5+5 -tile 5x  -frame 5  -shadow  photo_index.html
~~~

[![\[IM Output\]](../img_www/doc_html.png)  

IM Examples  
Photo Store](photo_index.html)
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Note the use of '`%[width]x%[height]`' instead of just '`%wx%h`'.
> This is important as the image is being resized as it is read in.
> The former will label the images with their original pixel size as it is on disk, while the latter will use the current resized size of the image.
> This is something that is easily overlooked by users.

The result of this command were three files...

* **[photo_index.png](http://imagemagick.org/Usage/montage/photo_index.png)** :\
    The montage of all thumbnails of the images
* **[photo_index_map.shtml](http://imagemagick.org/Usage/montage/photo_index_map.shtml.txt)** :\
    An HTML 'image map' for the thumbnail image
* **[photo_index.html](http://imagemagick.org/Usage/montage/photo_index.html.txt)** :\
    The HTML thumbnail index page for the World Wide Web. This also includes a copy of the previous image map.

Of course, you don't have to generate an HTML index file if you only want an index image.
In that case, just replace "`INDEX.html`" in the command above with the image you want to generate.

Note the use of the [Image Property Escape](http://www.imagemagick.org/script/escape.php) '`%t`' for the image "`-label`".
This is the filename of the image without any 'path' components.
Though the HTML link will still contain the appropriate 'path' components allowing you to build the index image in a different directory to the images themselves.

The source images "`'*_orig.*'`" in the above examples is quoted, so the "`montage`" command does the expansion of '\*' itself, and not the command line shell.
This avoids any command line length limits that you may have problems with.
Also I do some initial resizing of images '`[120x190]`' as I read them - see [Read Image Modifiers](../files/#read_mod).

For JPEG images I also specified a smaller "`-size`" setting so the JPEG library can do some very rough initial scaling, and not read the whole image into memory.
If this is not done, then very large JPEG images could use up an enormous amount of memory and CPU cycles when there is no real need.
I also "`-strip`" any profiles that the images may have.
For more info see [Profiles, Stripping, and JPEG Handling](../thumbnails/#profiles) and [Reading JPEG Images](../formats/#jpg_read).

Remember the montage "`-geometry`" option can also specify a final resize setting, though in this case it is isn't needed as I did it during the read process, so I don't set any 'size' in that setting.

Finally, the "`-tile`" option of '`5x`' is used to ensure all images appear in a single image, otherwise "`montage` could generate multi-page HTML files, which are not correctly linked together.
This will hopefully change, though HTML generation is not a primary goal of ImageMagick.

For other ways of generating thumbnails and HTML index pages, read the [Thumbnail Examples Page](../thumbnails/).

### Smaller HTML Index Maps, using JPEG images {#html_jpeg}

The above index image generated a PNG format index image.
This was used because it is a lossless format, which can be important when the images being indexed are of wildly different colors.
It also enables the use of the new 'soft shadows' features of "`montage`" if the background color is set to '`transparent`' or '`none`'.

Very very old IM's will have generated a GIF image for the above.
However, this has some heavy color reduction on the results as part of the formats limitations.
It also did not allow the use of semi-transparent 'soft shadows' as PNG allows.

JPEG also does not allow semi-transparency, but that is not a problem if you do not use a transparent background for the image.
It is, however, a lot smaller than PNG, which provides a way to drastically reduce the size of the index image, especially for web use, and still handle a large range of colors.

However, HTML output above only generates PNG format images, so you will need to not only convert the PNG to JPEG, but also some extra processing to fix the HTML file.

~~~
montage -label '%t\n%[width]x%[height]' \
   -size 512x512 '../img_photos/*_orig.*[120x90]' -auto-orient \
   -geometry +5+5 -tile 5x  -frame 5  -shadow  photo_jpeg.html
convert photo_jpeg.png photo_jpeg.jpg
perl -i -lpe 's/src="photo_jpeg.png"/src="photo_jpeg.jpg"/' photo_jpeg.html
rm -f  photo_jpeg.png  photo_jpeg_map.shtml
~~~

[![\[IM Output\]](../img_www/doc_html.png)  
IM Examples  
Photo Store](photo_jpeg.html)

The above commands are rather tricky so here is what happens...

-   First, I generate a montage thumbnail HTML index, as I did previously. This generated the files: "`photo_jpeg.html`" and "`photo_jpeg.png`"
-   I then converted the PNG image to a smaller, lossy, JPEG image.
-   Then I used a small '`perl`' one line script to change HTML file to use the JPEG image instead of PNG.
-   And finally I removed the PNG image, as well as the SHTML map file which I don't need.

And hey presto, we have a Thumbnail index using a very small JPEG image for the thumbnail index image.

Here are comparisons of the file sizes of the thumbnail index image...
  
[![\[IM Text\]](photo_index_sizes.txt.gif)](photo_index_sizes.txt)

That is the image used for the index is only about 15% of the size of the original PNG image.
A big saving for a downloadable web page of thumbnails!

You can make the JPEG image even smaller by using a smaller "`-quality`" setting, though the default setting produces a very reasonable result.
Other possible options include using "`-sampling-factor 2x1`" to make it even smaller.

### Visual Index Images (a non-montage solution) {#vid}

An alternative to using "`montage`", is to use a special "visual index" input format...

~~~
convert  'vid:../img_photos/*_orig.*' vid_index.gif
~~~

[![\[IM Output\]](../img_www/doc_art.png)  
Visual Index of  
Photo Store](vid_index.gif)
And can also generate 'clickable' HTML index files.

~~~
convert  'vid:../img_photos/*_orig.*' vid_index.html
~~~

[![\[IM Output\]](../img_www/doc_html.png)  
Visual HTML of  
Photo Store](vid_index.html)
It is obvious that "`VID:`" uses "`montage`" internally to generate the index array.
However, you do not have the same controls as you do if you had used "`montage`" directly.

Note that a VID HTML index creates a PNG format thumbnail image.

### A Montage of Polaroid Photos {#polaroid}

With the advent of a [Complex Polaroid Transform](../transform/#polaroid) it is now possible to generate quite a different style of montage, and montage indexing.

~~~
montage -size 256x256 '../img_photos/*_orig.*' -auto-orient \
      -auto-orient -thumbnail 128x128 \
      -set caption '%t' -bordercolor AliceBlue -background grey20 \
      +polaroid \
      +set label   -background white  -geometry +1+1  -tile 4x \
      polaroid_index.html
~~~

[![\[IM Output\]](../img_www/doc_html.png)  
Polaroid  
Montage](polaroid_index.html)

Note that as I used "`+polaroid`" to frame and label the images, I needed to resize the image (using "`-thumbnail`") myself, and make sure the "`-background`" and image "`-label`" has been reset before actually creating the "`montage`" index array.

The [Polaroid Transform](../transform/#polaroid) however tends to blur the text during the addition of the 'curl' to the thumbnail image.
You can improve the overall by generating the polaroid images at a larger size then shrinking the result by 50%.
The only drawback is the reduced 'shadow' effect.

~~~
montage -size 400x400  '../img_photos/*_orig.*' \
      -auto-orient -thumbnail 200x200 \
      -set caption '%t' -bordercolor Lavender -background grey40 \
      -pointsize 9  -density 144x144  +polaroid  -resize 50% \
      +set label   -background white  -geometry +1+1  -tile 5x \
      polaroid_index2.html
~~~

[![\[IM Output\]](../img_www/doc_html.png)  
Sharper  
Polaroid  
Montage](polaroid_index2.html)

This fancy montage, as well as other techniques shown above was used to create a script "`generate_index`" to generate a montage thumbnail index in the actual "`photo_store`" directory.
See [Photograph Store Index](../img_photos/INDEX.html) for the results of this script.

---

## Special Techniques using Montage {#special_usage}

### Montage into Columns {#columns}

By default "`montage`" can only place the images in the order given (typically sorted order) row by row.
However, sometimes you would like to have them shown in column order.

This can not be done with a single command, but requires a pipe-line of at least two commands.
For example, here I generate a page of 5x3 tiles, using two montages.

~~~
montage font_*.gif  -tile 1x3  -geometry 16x16+1+1  miff:- |\
   montage -  -geometry +0+0 -tile 5x1  montage_columns.gif
~~~

[![\[IM Output\]](montage_columns.gif)](montage_columns.gif)

Note that it is the first "`montage`" that creates the tiles and performs any of the geometry tile sizing, framing, labeling and spacing needed.
It will then output one image for each column of tiles.
The second "`montage`" then simply concatenates the columns into 'page' images without adding any more space between columns.

If you only want a single image of a variable number of columns, you can replace the second "`montage`" with a "`convert`" to concatenate without adding extra space of 'pages'.
For example...

~~~
montage font_*.gif  -tile 1x3  -geometry 16x16+1+1  miff:- |\
   convert - +append montage_columns_2.gif
~~~

[![\[IM Output\]](montage_columns_2.gif)](montage_columns_2.gif)

### Overlapped Montage Tiles {#overlap}

In the [IM User Forum](forum_link.cgi?f=1), during a discussion between, [Fred Weinhaus](http://www.fmwconcepts.com/fmw/fmw.html) , aka *[fmw42](../forum_link.cgi?u=9098)* and another user *[pooco](../forum_link.cgi?u=10889)*, it was discovered that if you set the inter-tile space (set in the "`-geometry`" setting) to a negative number you can actually overlap the tiled areas into which the images are drawn.

For example, here we use a negative horizontal inter-tile spacing, for a single row of images.

~~~
montage null:   font_*.gif   null: \
   -tile x1 -geometry -5+2  montage_overlap.jpg
~~~

[![\[IM Output\]](montage_overlap.jpg)](montage_overlap.jpg)

Rotating the images will make the overlapping series even more interesting...

~~~
montage null: font_*.gif null: -background none -rotate 30 \
   -background white -tile x1 -geometry -8+2  montage_rot_overlap.jpg
~~~

[![\[IM Output\]](montage_rot_overlap.jpg)](montage_rot_overlap.jpg)

Note that I needed to add a special "`null:`", spacing image at the start and end of the row of images so the images do not overflow the canvas, "`montage`" calculates and generates.

This presents us with some interesting possibilities.
For example, you could generate a very interesting row of overlapping thumbnails, by making use of the randomly rotated [Polaroid Transform](../transform/#polaroid).

~~~
montage -size 400x400 null: ../img_photos/[a-m]*_orig.* null: \
   -auto-orient  -thumbnail 200x200 \
   -bordercolor Lavender -background black +polaroid -resize 30% \
   -gravity center -background none -extent 80x80 \
   -background SkyBlue -geometry -10+2  -tile x1  polaroid_overlap.jpg
~~~

[![\[IM Output\]](polaroid_overlap.jpg)](polaroid_overlap.jpg)

The use of [extent](../crop/#extent) in the above is intended to remove the randomness of image size that "`+polaroid`" can produce on different 'runs', giving more control of the final spacing and overlap between images.

This is a very interesting result, though it should actually be classed as a BUG, as this is not the intended purpose of "`montage`".
I also would not expect any HTML image mapping to work correctly, without some fixing by the user.

However, a more complex, and user controllable solution for overlapping images is demonstrated using a scripted form of [Layer Merging](../layers/#merge), which is the recommended and more logical solution - see examples in [Programmed Positioning of Layered Images](../layers/#example).

### Montage Concatenation Mode {#concatenate}

As you saw, "`montage`" has a special concatenation mode, which can be used to join images together without any extra spaces just like the "`-append`" option.
I do, however, recommend you set the "`-tile`" option appropriately, so as to direct the appending either horizontally, vertically or in an array.

For example, here we use a "`-tile x1`" to append images horizontally.

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -mode Concatenate  -tile x1  montage_cat.jpg
~~~

[![\[IM Output\]](montage_cat.jpg)](montage_cat.jpg)

But you can also use it to just as easily create an array of images.
Preferably, the images are the same size, so they fit together properly.

~~~
montage balloon.gif medical.gif present.gif shading.gif \
   -mode Concatenate  -tile 2x2  montage_array.jpg
~~~

[![\[IM Output\]](montage_array.jpg)](montage_array.jpg)

When concatenating images of different sizes, the images are concatenated with 'top' vertical alignment, then 'left' horizontal row alignment.

~~~
montage medical.gif rose:       present.gif shading.gif \
   granite:    balloon.gif netscape:   recycle.gif \
   -mode Concatenate  -tile 4x  montage_cat2.jpg
~~~

[![\[IM Output\]](montage_cat2.jpg)](montage_cat2.jpg)

However, vertical alignment goes weird when framing is also added.

~~~
montage medical.gif rose:       present.gif shading.gif \
   granite:    balloon.gif netscape:   recycle.gif \
   -mode Concatenate  -tile 4x  -frame 5  montage_cat3.jpg
~~~

[![\[IM Output\]](montage_cat3.jpg)](montage_cat3.jpg)

Of course, framing is not really part of concatenate mode, so if "`-frame`" is set before the "`-mode`" setting, it will be turned off.
As such, this quirk is not likely to be seen, except by mistake when you accidentally use a 'zero geometry' (see below).
  
> ![](../img_www/warning.gif)![](../img_www/space.gif)
> :WARNING:
> Montage Concatenation to the 'HTML' image indexing format, produces incorrect image maps.
> Basically, the resulting image map will be as if the generated montage was a true equally divided 'array' of images, rather than a concatenation of the images in line.
> In other words it is wrong for lines of 'short' images.

### Zero Geometry, caution required {#zero_geometry}

With only "`-geometry`" spacing values (no image resizing specified), all montaged image frames are set to the same size, so that both the widest and tallest image will fit, without being resized.

This is itself a useful behaviour...

~~~
montage present.gif rose: shading.gif \
   -frame 5  -geometry +1+1   montage_geom_1.jpg
~~~

[![\[IM Output\]](montage_geom_1.jpg)](montage_geom_1.jpg)

However a 1 pixel gap was left around and between the image frames.

But if you try to remove those gaps with a position of "`+0+0`", you run into a very unusual problem...

~~~
montage present.gif rose: shading.gif \
   -tile x1  -frame 5  -geometry +0+0  montage_geom_0.jpg
~~~

[![\[IM Output\]](montage_geom_0.jpg)](montage_geom_0.jpg)

The 'zero geometry' you specified (that is "`-geometry 0x0+0+0`" ), has the extra effect of putting "`montage`" in a 'concatenation' mode (see above), which is NOT what we were after in the above.

For single images, it also does not matter if we use a zero "`-append`" (and thus concatenation mode).
The desired result is what we want, no extra borders.
As such a "`-geometry +0+0`" is fine if you are only using "`montage`" to [add a label to an image](../annotating/#labeling).

The concatenation mode will, however, not be invoked if you specify a non-zero geometry 'size' for your images, even though you used a zero offset.
This in turn gives us a tricky solution to our original problem.

What we do is set a geometry image size of "`1x1`" but also tell IM never to shrink images (using a "`<`" character) to this size!
In other words, never resize an image ever, just use a zero offset, in a non-zero geometry argument.

~~~
montage present.gif rose: shading.gif \
   -frame 5  -geometry '1x1+0+0<'  montage_geom_1x1.jpg
~~~

[![\[IM Output\]](montage_geom_1x1.jpg)](montage_geom_1x1.jpg)

This brings up another good rule of thumb...
**Always set a non-zero geometry when using "`montage`"**
Even if it is only the 'fake' geometry such as I used above.

### Background and Transparency Handling {#bg}

By default, images are overlaid onto the montage canvas, which is created using the "`-background`" color setting, as you can see here.

~~~
montage font_9.gif  \( recycle.gif -set label recycle \)  medical.gif \
   -tile x1  -geometry +5+5  -background lightblue   bg_lightblue.gif
~~~

[![\[IM Output\]](bg_lightblue.gif)](bg_lightblue.gif)
Instead of a solid color, you can instead use "`-texture`" to define a tile image to use instead of the "`-background`" color.

~~~
montage font_9.gif  \( recycle.gif -set label recycle \)  medical.gif \
   -tile x1  -geometry +5+5   -texture bg.gif      bg_texture.gif
~~~

[![\[IM Output\]](bg_texture.gif)](bg_texture.gif)
Adding frames (which add extra border space into the tiles) just adds more drawn 'fluff' on top of the background canvas.

~~~
montage font_9.gif  \( recycle.gif -set label recycle \)  medical.gif \
   -tile x1  -frame 5  -geometry '40x40+5+5>' \
   -bordercolor lightblue  -texture bg.gif  bg_frame.gif
~~~

[![\[IM Output\]](bg_frame.gif)](bg_frame.gif)

Note that when framed, the "`-bordercolor`" setting will be used to fill in the inside the frame, effectively becoming the background color of the image.
Also notice that any transparent areas of the image are also set to this color.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Before version 6.1.4 of IM, what was seen in the transparent areas of images was undefined.
> In some versions, you would see through the framed image to the background color or texture.
> On others you might get black, or white.
> In still other versions you would be able to see though all the layers and the final image would be transparent where the original image was transparent.
> Upgrade NOW if this is a problem for you.

Also new to IM version 6.1.4 is the ability to use a special 1 pixel wide frame.
This will basically remove the frame around the image cells completely, but retaining the internal "`-bordercolor`" padding around (and underneath) the image.
For example, compare a frame of '`1`' with the minimal frame width of '`2`'.

~~~
montage font_1.gif  \( recycle.gif -set label recycle \)  medical.gif \
   -tile x1  -frame 1  -geometry '40x40+5+5>' \
   -bordercolor lightblue  -texture bg.gif  bg_frame_1.gif
~~~

[![\[IM Output\]](bg_frame_1.gif)](bg_frame_1.gif)

~~~
montage font_2.gif  \( recycle.gif -set label recycle \)  medical.gif \
   -tile x1  -frame 2  -geometry '40x40+5+5>' \
   -bordercolor lightblue  -texture bg.gif  bg_frame_2.gif
~~~

[![\[IM Output\]](bg_frame_2.gif)](bg_frame_2.gif)
But what if you want your montage to have a transparent background?
Particularly, if you plan to use it on a web page containing a texture mapping.

Simple, just use a "`-background`" color of '`None`' or '`Transparent`', without any "`-texture`" image to override that setting.

For example, here we generate a transparent montage.
Note that "`-geometry`" is still used to add space around and between the images.

~~~
montage font_9.gif  recycle.gif  medical.gif \
   -tile x1  -geometry +2+2  -background none   bg_none.gif
~~~

[![\[IM Output\]](bg_none.gif)](bg_none.gif)

Of course, if you also use "`-frame`", you need to make the "`-bordercolor`" transparent too.

~~~
montage font_9.gif  recycle.gif  medical.gif \
   -tile x1 -frame 5 -geometry '40x40+5+5>' \
   -bordercolor none  -background none    bg_framed_trans.gif
~~~

[![\[IM Output\]](bg_framed_trans.gif)](bg_framed_trans.gif)
Note that the montage "[`-shadow`](../option_link.cgi?shadow)" option is completely unaffected by all the above.
It is applied according to the final transparent shape of the cells, before it is overlaid onto the background color or texture.

~~~
montage font_9.gif  recycle.gif  medical.gif \
   -tile x1  -shadow  -geometry '40x40+5+5>' \
   -texture bg.gif  bg_shadow.gif
~~~

[![\[IM Output\]](bg_shadow.gif)](bg_shadow.gif)

~~~
montage font_9.gif  recycle.gif  medical.gif \
   -tile x1 -frame 5 -shadow  -geometry '40x40+5+5>' \
   -bordercolor none   -texture bg.gif  bg_shadow_framed.gif
~~~

[![\[IM Output\]](bg_shadow_framed.gif)](bg_shadow_framed.gif)
  
Any suggestions, ideas, or other examples of using "`montage`" are of course always welcome.
The same goes for anything in these example pages.

---------------------------------------------------------------------------

Montage Image Output Size

The mathematics of "`montage`" is straightforward...

Basically the montage width should be....
(geometry_size + 2*frame_size + 2*geometry_offset) * images_per_column

That is each 'cell' of montage has a fixed sized frame and spacing (border) added around it before the cells are appended together.

In essence, the size of a montage is also a multiple of the tile size, which can make it easy to break up montage, or re-arrange the 'cells', if so desired, as they are simple fixed sized tiles in a rectangular array.

The height is similar but with the additional spacing needed for labels and the optional montage title, both of which are much more difficult to calculate, as they depend heavily on text, font, pointsize, and density settings.

There is also an effect of adding a shadow to the montage in this calculation, but that appears to be a simple small fixed addition to the bottom and right edges.
It does not appear to affect the tile size used.

---
title: Montage, Arrays of Images
created: 3 January 2004
updated: 27 December 2009
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.6.9-7
url: http://www.imagemagick.org/Usage/montage/
---
