# Animation Optimization

These examples start to make use of the [Basic Animation Handling](../anim_basics/), to try to optimize the final display and file size of an animation.
This is especially important for complex GIF animations where smaller sub-frame overlays can be used, as well as three types of disposal methods controlling how an animation is handled.

------------------------------------------------------------------------

## Introduction to Animation Optimization {#intro}

Optimizing an animation is not easy, especially a GIF animation that has color restrictions, as well as a choice of different frame disposal techniques, and the ability to use smaller 'sub-frame' overlays from one frame to the next.

When optimizing animation you should try to optimize them in the following order:

-   [Minor Optimizations](#minor_opt)
-   [Semi-Transparency Handling](#semitrans_opt)
-   [Color Optimizations](#color_opt)
-   [Frame Optimizations](#frame_opt)
-   [Compression Optimizations](#compress_opt)
-   [Single Global Color Table](#colortables)

That, however, is not the order we will look at these optimization techniques.
For GIF animations, [Frame Optimization](#frame_opt) is the most basic optimization technique, and where the most gains can be made.
As such, it will be looked at first.

Probably the hardest aspect of optimization that users have trouble with is [Color Optimizations](#color_opt) caused by the color limitations of GIF animations.
One aspect of this [Single Global Color Table](#colortables) has to be done as the last step before saving to GIF or you may lose the operator's effect on the final GIF file save.

------------------------------------------------------------------------

## General Purpose GIF Optimizer of ImageMagick {#optimize}

The "`-layers`" method '`Optimize`' will use a number of the techniques, that we will discuss in detail below, to attempt to optimize a GIF animation in a single reasonable step.

Currently this option is equivalent to (in order)...

-  A [Coalesce](../anim_basics/#coalesce) of the animation,
-  basic [Frame Optimization](#optframe),
-  and [Transparency Optimization](#opt_trans)

at which point you can immediately save the GIF animation.

These are reasonably safe optimization steps that can be applied to most animation sequences, however there is no guarantee, that it will result in a smaller GIF animation.
This is particularly true of a raw video sequence where a [Transparency Optimization](#opt_trans) will generally result in a worsening of the LZW compression ratio.

However, for most GIF animations, involving cartoon-like images, the '`Optimize`' operator should produce a good, well optimized animation.

The operator however is still in development, and in future is likely to also include extra standard optimization steps, such as...

-   A 50% Threshold of the alpha channel, just as IM does normally does when saving to the GIF file format, to remove semi-transparent pixels.
    You can still do the semi-transparency handling yourself beforehand to override this, if you like.
    See [GIF Boolean Transparency](../formats/#boolean_trans) for more detail.
-   Some type of [Color Optimization](#color_opt) technique.
    Exactly what, is still to be decided, and may be selected depending on the animation and the number of colors involved.
    *Suggestions Welcome*.
-   A [Single Global Color Table](#colortables), "`+map`" operation.

In other words, it is hoped that '`Optimize`' will eventually become the IM generic GIF animation optimizer, for quick and easy use by IM users.
Until then, be careful of its use, especially in scripts, as it will change.

Of course, many optimization steps may not be worth the effort for a specific animation.
This option will also likely become quite slow.

This is the plan, and the goal that this IM Examples section was looking toward.

------------------------------------------------------------------------

## Frame Optimizations {#frame_opt}

Frame optimization is based on overlaying a smaller sub-image rather than a complete overlay of the whole image.
This obviously produces a smaller number of pixels and thus a smaller file on disk, or to be sent across the network.
Also overlaying a smaller frame means the client computer does not have to do as much work in changing pixels on screen.

However, there are different disposal methods available in the GIF format to handle the last frame displayed, and that can result in different size overlays.
Not only that, but it is possible to split up the overlays into multiple parts, or update actions, to bring about a more complex, but more optimized, animation.

Because of the complexity of doing frame optimizations, any existing frame optimizations are typically always removed first by using "`-coalesce`" operation.
See [Coalesce Examples](../anim_basics/#coalesce).

Naturally, that means any hand optimizations that may have existed are also removed, so some caution is advised.

### Basic Frame Optimization {#optframe}

The "`-deconstruct`" method will produce a basic frame optimization for a GIF animation.
However, as was shown in the [Deconstruct Examples](../anim_basics/#deconstruct) of the previous section, this operator does not cope with all GIF animations when transparent pixels are involved.
Specifically clearing any colored pixels to transparency.

That is it will only work with [Overlay Animations](#overlay).

The "`-layers`" method '`OptimizeFrame`' is designed to be a GIF Frame Optimizer, which will try to find the smallest sub-frames overlays, using any GIF disposal method.

The result is generally a [Mixed Disposal Animation](#mixed) though often it will also generate [Cleared Frame Animations](#clear) and [Pure Overlay Animations](#overlay), if that was determined to be the best solution for the specific animation.

Remember the input animation must be a '*coalesced animation*', so it consists of a sequence of complete image frames, all the same size, and no canvas offsets.
Of course, any existing dispose methods in a coalesced animation are completely irrelevant, and will be ignored by the '`OptimizeFrame`' method.

For example, let's try this with a basic [Dispose Previous Animation](../anim_basics/#previous).

~~~
convert  canvas_prev.gif -coalesce  -layers OptimizeFrame  optframe.gif
gif_anim_montage optframe.gif optframe_frames.gif
~~~

[![\[IM Output\]](optframe.gif)](optframe.gif)  
[![\[IM Output\]](coalesce_frames.gif)](coalesce_frames.gif)  
[![\[IM Output\]](optframe_frames.gif)](optframe_frames.gif)

As you can see, "`-layers OptimizeFrame`' correctly returned our animation back into its original frame optimized form, using [Previous Disposal](../anim_basics/#previous).

This optimization even works properly for the trickier to handle [Background Dispose Animations](../anim_basics/#background)...

~~~
convert  canvas_bgnd.gif -coalesce -layers OptimizeFrame optframe_erase.gif
gif_anim_montage optframe_erase.gif optframe_erase_frames.gif
~~~

[![\[IM Output\]](optframe_erase.gif)](optframe_erase.gif)  
[![\[IM Output\]](optframe_erase_frames.gif)](optframe_erase_frames.gif)

The animation is perfectly frame optimized using [Background Disposal](../anim_basics/#background).

This operator will work correctly for all GIF animations, and will generally return the best possible simple 'dispose and frame optimization' possible.

One word of warning, however, sometimes the best optimization for an image involves not overlaying any pixels.
For example, here is a simple animation that repeats the starting image every second frame.

*Simple repeated animation wanted HERE*

When we frame optimize this animation, we get a very special and unique GIF disposal sequence.

*Frame Optimized result of the above*

What is happening is that rather than overlaying the original frame, IM chose to recover that image using a '[Previous](../anim_basics/#previous) GIF disposal.
As that recovered frame is left as is, there are no changed pixels.
So the sub-frame overlay gets reduced to nothing.

Unfortunately, neither IM nor the GIF format allow you to have a zero sized image, so a special one transparent pixel minimal image is used instead.
This image is known as a [Missed Image](../crop/#crop_missed) as it is also extensively used when "`-crop`" 'misses' the actual image data, producing the same result.

This image, in effect, only preserves the frame's meta-data, such as: [Dispose Method](../anim_basics/#dispose), [Time Delay](../anim_basics/#delay), and [Loop Iterations](../anim_basics/#loop).
As such, it is an essential part of the animation, even though it is 'empty'.
  
Now for some bad news about any type of simple frame optimization, such as what IM provides...
 
While '`OptimizeFrame`' returns the best possible frame optimization for a given animation that IM can figure out, there are a number of special cases where it does not do well.

These include...

-   Animations where pixel clearing (returning to transparency) is needed, but the frame overlays are too large to efficiently clear the small areas of pixels that need to be cleared (see the [move hole animation](#hole) below).
-   Animations involving two or more small areas of change that are distantly separated.
    These are actually quite common, and horrible to frame optimize.
    (See [Splitting Frame Updates](#splitting) below)
-   Animations with very complex backgrounds that remain static for long periods (more than 3 frames), but then change slightly before remaining static for another long period, etc., etc., etc...
    Or a static background that becomes greatly obscured for a very short period.

    It can be near impossible for any computer algorithm to figure out the 'best' frame optimization in this complex situation (i.e.: What should be regarded as a static background?).
    Only humans with their intuitive grasp on what they see, can generate a good optimal frame overlay sequence in these cases.

*Examples of difficult to optimize animations wanted, please contribute.*

If you find an example of an animation for which IM fails to produce a good optimization, please mail it to me for further study.
This is how new techniques and possible automatic solutions can be developed.
I will naturally publish your name as a contributor.

### Moving Hole Animation - difficult to frame optimize {#hole}

Here is one extreme case of GIF animation that does not frame optimize very well by any normal optimization method.

This animation basically consists of a simple unchanging background image but with a transparent 'hole' through that background that changes position from frame to frame.

To create it, I needed to make a coalesced image sequence, where I cut a hole in a fixed background image, using [Layer Alpha Composition](../anim_mods/#compose).
I also used a "`+antialias`" switch to ensure only four colors are used - three blues and the transparency.
So we don't need to deal with [Color Optimization Problems](#colors).

~~~
convert +antialias -size 100x100 -delay 100 xc:SkyBlue -loop 0 \
        -fill DodgerBlue -draw 'circle 50,50 15,25' \
        -fill RoyalBlue  -draw 'circle 50,50 30,25' \
        null: \( -size 100x100 xc:none -draw 'circle 40,25 27,22' \) \
              \( +clone -rotate 90 \) \( +clone -rotate 90 \) \
              \( +clone -rotate 90 \) -compose DstOut -layers Composite \
        -set dispose background  moving_hole.gif
gif_anim_montage moving_hole.gif moving_hole_frames.gif
~~~

[![\[IM Output\]](moving_hole.gif)](moving_hole.gif)  
[![\[IM Output\]](moving_hole_frames.gif)](moving_hole_frames.gif)

~~~{.hide data-capture-out="moving_hole_size.txt"}
ls -l moving_hole.gif | awk '{printf "%d", $5}'
~~~

As you can see, the animation works, with a round 'hole' showing the background color of this page, producing an animation file of [![\[IM Text\]](moving_hole_size.txt.gif)](moving_hole_size.txt) bytes in size.

So let's try a straight-forward frame optimization for this animation.

~~~
convert moving_hole.gif  -layers OptimizeFrame  moving_hole_opt.gif
gif_anim_montage moving_hole_opt.gif moving_hole_opt_frames.gif
~~~

[![\[IM Output\]](moving_hole_opt.gif)](moving_hole_opt.gif)  
[![\[IM Output\]](moving_hole_opt_frames.gif)](moving_hole_opt_frames.gif)

Hang on, nothing happened!
The best optimization IM could achieve was no change at all!
Is the above coalesced version of this animation its most optimal?

Well for the animation as it stands...
Yes, this really is the best simple optimization that can be achieved by pure frame disposal optimization!
Not good.

The problem is that for a GIF animation to 'clear' or 'erase' the pixels drawn by previous frames, it needs to use a '[Background](../anim_basics/#background)' dispose method.
Though in some special situations a '[Previous](../anim_basics/#previous)' dispose method can also be used.

However '[Background](../anim_basics/#background)' dispose only can clear areas that were just overlaid.
As the first frame was a complete overlay of the whole image, the whole image will be cleared.
Even though only a small section of the animation needs to have its pixels cleared.

As a consequence, the whole of the second frame needs to be overlaid, even though most of that frame was just previously displayed!
This horrible catch-22 situation continues all the way across the rest of the animation, producing no basic frame optimizations.

I did say this animation would be difficult to frame optimize.

### Frame Doubling - a method to frame optimize 'holes' {#doubling}

All is not lost however.
By adding some extra frames to the animation, you can give the '`OptimizeFrame`' method some room in which to make better use of the GIF disposal methods available.

Here for example, we add an extra frame by doubling up the first image, but giving it a zero time delay so as not to change the overall timings of the animation.

~~~
convert moving_hole.gif[0] -set delay 0   moving_hole.gif \
        -layers OptimizeFrame    moving_hole_dup.gif
gif_anim_montage moving_hole_dup.gif moving_hole_dup_frames.gif
~~~

[![\[IM Output\]](moving_hole_dup.gif)](moving_hole_dup.gif)  
[![\[IM Output\]](moving_hole_dup_frames.gif)](moving_hole_dup_frames.gif)

~~~{.hide data-capture-out="moving_hole_dup_size.txt"}
ls -l moving_hole_dup.gif | awk '{printf "%d", $5}'
~~~

By doubling the first frame the animation was now reduced from [![\[IM Text\]](moving_hole_size.txt.gif)](moving_hole_size.txt) bytes down to [![\[IM Text\]](moving_hole_dup_size.txt.gif)](moving_hole_dup_size.txt) bytes in size.
So even though the animation now has five frames, it is now much smaller in overall size, because of the massive reduction in the size of the sub-frame image overlays.

Doubling essentially separates the pixel clearing function of the dispose method, from the pixel overlaying function performed by the next frame.
Both the dispose and the overlay are done as part of the same frame update by GIF animation programs, so no loss of speed or quality should be noticeable.

This is a complex and tricky technique, and one that is rarely seen or understood by GIF animation designers or GIF optimization programs, but its benefits are well worth it then it is needed.

However, the reduction in sub-frame image sizes only lasts for a short time, as later frames having to also clear out pixels for the next frame, get larger again to continue to clear out later pixels.
That is because of pixel clearing - frames only get larger, never smaller.

So let's try and double *all* the frames (except the last which never needs doubling) to see how that affects the final image...

~~~
convert moving_hole.gif  \( -clone 0--1 -set delay 0 \) \
        +delete -insert 2 -insert 1 -insert 0 \
        -layers OptimizeFrame  moving_hole_double.gif
gif_anim_montage x2 moving_hole_double.gif moving_hole_double_frames.gif
~~~

[![\[IM Output\]](moving_hole_double.gif)](moving_hole_double.gif)  
[![\[IM Output\]](moving_hole_double_frames.gif)](moving_hole_double_frames.gif)

~~~{.hide data-capture-out="moving_hole_double_size.txt"}
ls -l moving_hole_double.gif | awk '{printf "%d", $5}'
~~~

As you can see, while we have almost twice as many frames, all the image sizes are much smaller, producing an animation that is [![\[IM Text\]](moving_hole_double_size.txt.gif)](moving_hole_double_size.txt) bytes in size, a smaller result, though not nearly as big a saving as the first single frame doubling we performed.

So that you can follow what is happening, the '`Background`' frame is an exact duplicate of the previous frame, making no change to what is being displayed.
However, it defines the area of the animation that needs to cleared before the next frame image is overlaid.

The following '`None`' frame then fills in the pixels that need to be changed, as well as the pixels that the previous frame's disposal also cleared.
In the above animation, that means the pixels that were needed to shape the new hole, as well as the pixels that were used to fill-in the previous 'hole'.

The result is smaller, but not nearly as much, since adding extra frames has its own cost.
At least each of the added frames also does not have its own color table, or this animation would have in fact become larger, due to the size of the extra color tables!

### Layer Optimize Plus - Automatic frame doubling Optimization {#optimizeplus}

I am pleased to say that, as of version 6.2.7, IM can now do frame doubling optimization automatically, as part of its normal frame optimization handling.
However, as adding frames to make an animation smaller is so radical a move, it was given its own separate "`-layers`" method '`OptimizePlus`'.

For example, let's get IM to do the frame doubling optimization...

~~~
convert moving_hole.gif  -layers OptimizePlus   moving_hole_oplus.gif
gif_anim_montage x2 moving_hole_oplus.gif moving_hole_oplus_frames.gif
~~~

[![\[IM Output\]](moving_hole_oplus.gif)](moving_hole_oplus.gif)  
[![\[IM Output\]](moving_hole_oplus_frames.gif)](moving_hole_oplus_frames.gif)

~~~{.hide data-capture-out="moving_hole_oplus_size.txt"}
ls -l moving_hole_oplus.gif | awk '{printf "%d", $5}'
~~~

That is, IM gave you the same result as our previous frame doubling example.
Thus the GIF file is still [![\[IM Text\]](moving_hole_oplus_size.txt.gif)](moving_hole_oplus_size.txt) bytes in size.
However '`OptimizePlus`' will only frame double if the number of pixels in the current and next frame of the resulting animation (3 frames) is reduced, so we can let IM decide whether to frame double or not.

As "`-layers`" method '`OptimizePlus`' adds extra frames as it creates a frame optimized GIF animation, it also will remove any unneeded or extra frames that make no change to the final animation (merging delay times as appropriate).
That is, it will also do an automatic '`RemoveDups`' - see next.
The '`OptimizeFrame`' method will not do this.

### Remove Duplicate Frames - merging consecutive duplicate images {#removedups}

Unfortunately, if you [coalesce](../anim_basics/#coalesce)" this animation, you will also get all the extra frames that the above added.

~~~
convert moving_hole_oplus.gif -coalesce gif:- |\
   gif_anim_montage x2 - moving_hole_oplus_cframes.gif
~~~

[![\[IM Output\]](moving_hole_oplus_cframes.gif)](moving_hole_oplus_cframes.gif)

To let you remove such useless duplicate frames from a coalesced animation, a '`RemoveDups`' method has been provided.
This compares each frame with the next frame in the animation, and removes the first frame if they are identical (with color similarity set by the current [Fuzz Factor](../color_basics/#fuzz)).

Also, to ensure that any timings in the animation are not lost, the [Timing Delays](../anim_basics/#delay) of the two frames are also merged.

For example...

~~~
convert moving_hole_oplus.gif -coalesce -layers RemoveDups  gif:- |\
   gif_anim_montage - moving_hole_oplus_rmdups_frames.gif
~~~

[![\[IM Output\]](moving_hole_oplus_rmdups_frames.gif)](moving_hole_oplus_rmdups_frames.gif)

And we now have our original coalesced form of the animation.

For another method of removing the extra frames see the '`RemoveZero`' method below.

### Splitting Frame Updates - separately updating two distant changes {#splitting}

As you have seen with frame doubling, by splitting the 'clearing of pixels' from the overlaying of new pixels, we can reduce the overall size of a single frame overlay.

However, this animation still produces some very large overlays, which mostly consist of pixels that don't actually change from one frame to the next.
That is, the main overlay frame is only updating two rather small areas that are quite distant from each other thereby producing a single large overlay image.

Rather than trying to update both changes simultaneously as well as including all the unchanged pixels in-between, we instead split the update into two.
That is we *split the frame update*.
You can think of it as changing the animation to use two fast frame updates to handle changes to two very well separated areas of update.

It does not actually matter (except with possible regard to disposals) which order the changes are made in, but you should try to be logical about it.
It may also be that one change is easier to create than another.

For example, here I insert extra frames to fill in the old hole as a separate update to the 'digging' of the new hole.
This is the easier intermediate frame to generate as well as the most logical ordering of actions.
Of course you do not need to do this for the last frame, as that frame is just junked before the animation loops.

~~~
convert moving_hole.gif \
        \( +antialias -size 100x100 -delay 0 xc:SkyBlue \
           -fill DodgerBlue -draw 'circle 50,50 15,25' \
           -fill RoyalBlue  -draw 'circle 50,50 30,25' \) \
        \( +clone \) -insert 1 \( +clone \) -insert 3  +swap \
        -set dispose background  moving_hole_split.gif
gif_anim_montage x2 moving_hole_split.gif moving_hole_split_frames.gif
~~~

[![\[IM Output\]](moving_hole_split.gif)](moving_hole_split.gif)
[![\[IM Output\]](moving_hole_split_frames.gif)](moving_hole_split_frames.gif)

Remember the added intermediate frame is different from the surrounding user displayed frames (the ones with a non-zero time delay).
This is not simple 'frame doubling', but the separating of two distinct small changes.

This addition of intermediate frames is not a simple step that can be automated.
Although it is possible that a smart heuristic could be developed to generate these intermediate frames, it is not always obvious what should be done, let alone if it should be done.
*If you like to try to generate such an heuristic, please mail me.*

So let's try a standard frame optimization after adding these extra frames...

~~~
convert moving_hole_split.gif \
             -layers OptimizeFrame     moving_hole_split_opt.gif
gif_anim_montage x2 moving_hole_split_opt.gif \
                    moving_hole_split_opt_frames.gif
~~~

[![\[IM Output\]](moving_hole_split_opt.gif)](moving_hole_split_opt.gif)  
[![\[IM Output\]](moving_hole_split_opt_frames.gif)](moving_hole_split_opt_frames.gif)

~~~{.hide data-capture-out="moving_hole_split_opt_size.txt"}
ls -l moving_hole_split_opt.gif | awk '{printf "%d", $5}'
~~~

The addition of these 'zero delay intermediate frames', allows this animation to be better optimized than the original unoptimized animation, producing a [![\[IM Text\]](moving_hole_split_opt_size.txt.gif)](moving_hole_split_opt_size.txt) byte animation.
However, for this specific case it isn't as good as using an automated [Frame Doubling](#double) technique (See the '[OptimizePlus](#optimizeplus)' layers method above).

Adding 'zero delay intermediate frames' does not stop you from also doing that 'frame doubling' technique as well...

~~~
convert moving_hole_split.gif \
             -layers OptimizePlus moving_hole_split_oplus.gif
gif_anim_montage x2 moving_hole_split_oplus.gif \
                    moving_hole_split_oplus_frames.gif
~~~

[![\[IM Output\]](moving_hole_split_oplus.gif)](moving_hole_split_oplus.gif)  
[![\[IM Output\]](moving_hole_split_oplus_frames.gif)](moving_hole_split_oplus_frames.gif)

~~~{.hide data-capture-out="moving_hole_split_oplus_size.txt"}
ls -l moving_hole_split_oplus.gif | awk '{printf "%d", $5}'
~~~

This animation now has two extra 'zero delay intermediate frames' per frame update.
The first fills in the old hole, the second clearing an area that will contain transparent pixels, before finally restoring the pixels that should not have been cleared.

The result is the most optimal frame optimization possible for this specific problem animation, resulting in [![\[IM Text\]](moving_hole_split_oplus_size.txt.gif)](moving_hole_split_oplus_size.txt) bytes in the final file size.

That is, our 4 frame animation was made smaller, by adding 6 extra zero time delay frames!
More than double the original number of frames.
Weird but true!

Of course, it would also be nice if GIF animation programs actually recognized [Zero Delay Intermediate Frames](../anim_basics/#zero) for what they are, namely, intermediate updates between the real frames of the animation.
But even so when the updates are highly separated, and very small, the slight pause caused by the extra frames is rarely visible.

Of course, if the two separated parts of the animation are not actually related, then they do not need to be time synchronized.
Another alternative is to split up the animation into completely separate animation images that you can rejoin when displaying on a web page.
See [Splitting up an Animation](../anim_mods/#split).

This particular animation however cannot be split up into separate time disjoint animations.
First the distant changes need to be time synchronised, and second the four areas that do change, overlap in both the horizontal and vertical directions.
This means a simple HTML 'table' cannot rejoin the sub-animations into a complete whole, without some type of CSS trickery.
*Can you prove me wrong?*

*FUTURE: reference to a better example of animating 'two distant objects' in 'Animation Handling', say involving two separately moving objects.*

### Remove Zero Delay Frames - removing intermediate updates {#removezero}

Of course, sometimes you are not interested or want to remove these added intermediate frames from an animation, leaving just the frames that will actually be shown to a user for some period of time.

You can't just [coalesce](../anim_basics/#coalesce") the animation and use the '`RemoveDups`' method as not all 'Intermediate Frames' are similar to the surrounding frames, and are thus not duplicates.

However as these types of frame have a [Zero Time Delay](../anim_basics/#zero) you can use another special "`-layers`" method, '`RemoveZero`' which will remove any frame that has a zero time delay.

This same method will also remove the frames added using [Frame Doubling](#double) and '`OptimizePlus`' techniques as well.

For example...

~~~
convert moving_hole_split_oplus.gif -coalesce -layers RemoveZero gif:- |\
   gif_anim_montage - moving_hole_split_rmzero_frames.gif
~~~

[![\[IM Output\]](moving_hole_split_rmzero_frames.gif)](moving_hole_split_rmzero_frames.gif)

Which again returns the animation back to just the user viewable frames, simplifying the animation.

Of course after removing [Zero Delay Intermediate Frames](../anim_basics/#zero), it is very difficult to re-add them as the change information contained is lost.
Consequently the animation may not frame optimize very well afterward.
Optimization is one of the main purposes of such frames after all.

### Frame Optimization Results and Summary {#frame_results}

Let's summarize our optimizations of the moving hole animation...

~~~{.hide data-capture-out="moving_hole_sizes.txt"}
( ls -l moving_hole.gif; \
  ls -l moving_hole_opt.gif; \
  ls -l moving_hole_dup.gif; \
  ls -l moving_hole_double.gif; \
  ls -l moving_hole_oplus.gif; \
  ls -l moving_hole_split_opt.gif; \
  ls -l moving_hole_split_oplus.gif; \
) | awk '{printf "%6s %s\n", $5, $NF}' -
~~~

[![\[IM Text\]](moving_hole_sizes.txt.gif)](moving_hole_sizes.txt)

As you can see, by using some complex frame handling, with the help of IM and some human intervention, we were able to frame optimize the 'moving hole' animation to almost half its original size, though with just under three times the number of frames of the original.

Of course, results can vary greatly from animation to animation, but the techniques we used for frame optimization are the same.
It just needs a little care and fore-thought, which humans are good at, and computers are not.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> There is the point, that IM should not only account for the number of pixels in current set of frames being looked at, but also the overall size of the extra frame added, and perhaps the overall compression results obtained, when making the decision about how to frame optimize the image.
>  
> On the other hand, IM also does not look at the resulting savings in the number of pixels that may result, beyond the frames that are directly involved.
> That is, later frames sizes may also be smaller as a result of frame doubling, or the disposal method used.
> This is especially true when the choice is whether to use 'previous image dispose' method, which can have substantial pixel count reductions later in an animation sequence, rather than immediately in the very next frame.
> A good choice here often requires human input.
>  
> As such, I can make no guarantee that IM will produce the best optimization choices, for a specific animation.
> However, it certainly gives it a good try, without the use of recursion, to make that choice.
> That is only using immediate pixel counts for its decision.
>  
> A recursive algorithm, one that makes a choice, then see what the best final size of the animation that results from that choice, (including recursive choices further along) can produce a guaranteed best optimization.
> However, it could also be an extremely slow operator, and for a large animation could take years to make the final decision.
> It would also need to include [compression optimization](#compress_opt") choices, as these could affect the final outcome.
> In other words, while such an algorithm could guarantee the best optimization, it does so at a heavy computational cost.
>  
> Of course, a human being with an intimate knowledge of what the animation is trying to achieve, will generally do better in complex animations, as you saw above with [splitting frame actions](#splitting).
>  
> If you would like to try and create a recursive GIF optimization operator please do.
> I will help in any way I can.
> It would beat just about every other GIF optimization program on the market.
> Also most GIF animation developers will probably be very grateful of your efforts (money-wise).

------------------------------------------------------------------------

## Semi-Transparency Handling {#semitrans_opt}

The GIF file format does not allow the use of semi-transparent pixels (See [GIF Boolean Transparency](../formats/#boolean_trans)).
This is a fact, and before you can properly optimize an animation, or even save it to GIF format, you need to handle any semi-transparent pixels that may be present, in a way that is suitable for the animation.

By default, if you don't handle these pixels, IM will use a 50% threshold to convert these pixels into either fully-transparent or fully-opaque.
However, that may not be the best way to handle the problem, particularly in images that contain large areas of semi-transparent pixels, such as shadow effects.

For example, I wanted to create a Stargate Asgard Teleport animation that could take just about any sub-image as the object being teleported.

~~~
convert -channel RGBA -fill white \
        \( medical.gif -repage 100x100+34+65 -coalesce -set delay 200 \) \
        \( +clone -motion-blur 0x20+90 -blur 0x3 -colorize 100% \
              +clone -colorize 30%  +swap  -composite  -set delay 10  \) \
        \( +clone -roll +0-20 -blur 0x3 -colorize 30% \
           -motion-blur 0x15+90 -motion-blur 0x15-90 -set delay 10 \) \
        \( +clone -colorize 30% \
           -motion-blur 0x30+90 -blur 0x5 -crop +0+10\! \) \
        \( +clone -motion-blur 0x50+90 -blur 0x2 -crop +0+20\! \) \
        \( +page -size 100x100 xc:none -set delay 200 \) \
        -set dispose background -coalesce   -loop 0     teleport.miff
gif_anim_montage teleport.miff teleport_frames.png
~~~

[![\[IM Output\]](teleport_frames.png)](teleport_frames.png)

I purposely left the animation in the IM internal MIFF: file format as this ensures that the original image is preserved without modification, and used a PNG: file format to display the frames so that you can see all the semi-transparent pixels contained in it!

This is not only important for animations with semi-transparent pixels, but also ones with lots of colors.
Once the image sequence has been saved into GIF, your chances of generating a good color optimization go from good, to difficult.
  
Okay I have an animation sequence.
If I attempt to save this directly as GIF, IM will just threshold all those semi-transparent pixels.

~~~
convert teleport.miff teleport_thres.gif
gif_anim_montage teleport_thres.gif teleport_thres_frames.gif
~~~

[![\[IM Output\]](teleport_thres.gif)](teleport_thres.gif)
[![\[IM Output\]](teleport_thres_frames.gif)](teleport_thres_frames.gif)

The result doesn't really look anything like what we wanted.
The default 50% transparency handling makes the animation look like a shrinking 'egg' - definitely not what I want to achieve with this animation.

If this type of transparency handling is acceptable, this is the way to apply it, before continuing with your other optimizations...

~~~{.skip}
convert teleport.miff -channel A -threshold 50% +channel \
               ...do further processing now...       teleport.gif
~~~

An extra advantage of using the above DIY, is that you can control the threshold level.
Say '`10%`' to remove almost every semi-transparent pixel present, to '`90%`' to make them all opaque.

~~~
convert teleport.miff -channel A -threshold 90% +channel teleport_thres90.gif
gif_anim_montage teleport_thres90.gif teleport_thres90_frames.gif
~~~

[![\[IM Output\]](teleport_thres90.gif)](teleport_thres90.gif)
[![\[IM Output\]](teleport_thres90_frames.gif)](teleport_thres90_frames.gif)

But applying a threshold for animations, like this one, is not a good solution, as it really spoils the transparency effect I am trying to achieve.
  
The best overall solution to preserving all the special effects in the above animation is to just [Add a Solid Color Background](../anim_mods/#flatten).

~~~
convert teleport.miff -bordercolor skyblue \
                -coalesce -border 0 teleport_bgnd.gif
gif_anim_montage teleport_bgnd.gif teleport_bgnd_frames.gif
~~~

[![\[IM Output\]](teleport_bgnd.gif)](teleport_bgnd.gif)
[![\[IM Output\]](teleport_bgnd_frames.gif)](teleport_bgnd_frames.gif)

This removes ALL the transparency from the animation, but at the cost of only allowing the animation to work on specific background color.
But if you are creating the animation for a specific web page, that may be quite acceptable.

Note however for images with sharp outlines, using a dither pattern like this can produce a 'dotty' outline to the sharp edges.
As such, it is not recommended for the general case.

The other solution is to try and generate some pattern of transparent and opaque pixels so as to try and preserve the image's semi-transparency.
And for this IM offers a large range of dithering options that can solve this problem.

*FUTURE: some link to a to be created section on transparency dithering, such as [Quantization and Dithering](../quantize/#color_trans).*

Note that the obvious first solution of using a [Monochrome Dithering](../quantize/#monochrome) of the alpha channel is not simple, probably requiring some advanced [Multi-Image Composition](../anim_mods/#composite) to do correctly.
  
A simple solution is to use a [Diffused Pixel Ordered Dither](../quantize/#ordered-dither) technique, which can be restricted to just the alpha channel, to remove the semi-transparent pixels.

~~~
convert teleport.miff -channel A -ordered-dither o8x8  teleport_od.gif
gif_anim_montage teleport_od.gif teleport_od_frames.gif
~~~

[![\[IM Output\]](teleport_od.gif)](teleport_od.gif)
[![\[IM Output\]](teleport_od_frames.gif)](teleport_od_frames.gif)

The result is reasonable, but looks like a dissolving object than teleporting.
  
Using a [Halftone](../quantize/#halftone) will produce a much nicer effect by making the transparency pattern bolder.

~~~
convert teleport.miff -channel A -ordered-dither h8x8a teleport_htone.gif
gif_anim_montage teleport_htone.gif teleport_htone_frames.gif
~~~

[![\[IM Output\]](teleport_htone.gif)](teleport_htone.gif)
[![\[IM Output\]](teleport_htone_frames.gif)](teleport_htone_frames.gif)

  
But for this specific animation, I found that using a [User Designed Dither Map](../quantize/#thresholds_xml) to produce vertical lines (from a horizontal line dither pattern) produces an effect that enhances the teleporting animation while removing semi-transparent pixels.

~~~
convert teleport.miff -rotate 90 \
        -channel A -ordered-dither hlines -rotate -90 teleport_lines.gif
gif_anim_montage teleport_lines.gif teleport_lines_frames.gif
~~~

[![\[IM Output\]](teleport_lines.gif)](teleport_lines.gif)
[![\[IM Output\]](teleport_lines_frames.gif)](teleport_lines_frames.gif)

So as you can see there are quite a number of possibilities to handling the semi-transparency in a GIF animation.

------------------------------------------------------------------------

## Color Optimization {#color_opt}

Handling semi-transparent pixels is only the first limitation of the GIF file format.
The next one is a 256 color limit for each color table in the animation.
You are allowed to have a separate color table for each frame.
This means a single animation can have more than 256 colors.
However, even that may not always be a good idea.

If you just like a quick summary of the color optimization options available, I suggest you jump to the examples on [Video to GIF](../video/#gif) conversion where the color problems of an animation are at their worst.

### GIF Color Problem {#color_problem}

GIF animations in particular, have problems in handling colors, as you know it first does not allow semi-transparent colors, then has a 256 color limit per frame, and a 256 global color limit.

Finally your best frame optimization will not work very well unless the colors used for a pixel in one frame also match the same color, in the next frame, when that part of the image did NOT change!
This may seem like an easy problem but [Color Reduction](../quantize/#intro) is itself an extremely complex field, which required its own full section in IM Examples.

Color problems are actually why most GIF animations you find on the World Wide Web are of the cartoon variety, or are very bad looking.
Especially if resized from a larger version of the animation.
In [Resizing Animations](../anim_mods/#resize) will probably require more effort in color optimization, than in the actual resize process itself.

Here I will assume you have the original source of the animation.
But that is not always possible, so if you are optimizing a modified GIF animation, some extra caution may be needed.
However, if you have an animation with too many colors, the first thing you need to remember is...

**Do not save directly to GIF format, use the MIFF file format, or separate PNG images.**

As soon as you save to GIF, you have lost control of your GIF color optimization efforts, and you probably have a very bad looking GIF animation that will not optimize very well using various [Frame Optimization](#frame_opt) techniques.

### Speed Animation - an Animation with too many colors {#speed}

First we need to generate a GIF animation with a vast number of colors, so that we can really test out the problems involved in color optimization.

~~~
convert -dispose none -channel RGBA \
        \( medical.gif -repage 100x60+5+14  -coalesce -set delay 100 \) \
        \( medical.gif -repage 100x44+34+6  -coalesce -set delay 10 \
           -motion-blur 0x12+0  -motion-blur 0x12+180 -wave -8x200 \) \
        \( medical.gif -repage 100x60+63+14 -coalesce -set delay 100 \) \
        \( medical.gif -repage 100x44+34+6  -coalesce -set delay 10 \
           -motion-blur 0x12+0  -motion-blur 0x12+180 -wave +8x200 \) \
        null: \( +page  -size 120x15 xc:SkyBlue xc:RoyalBlue \
                 -size 120x70 gradient:SkyBlue-RoyalBlue \
                 +swap -append -blur 0x3 -background white -rotate -25 \
              \) -gravity center -compose DstOver -layers Composite \
        -loop 0   speed.miff

convert   speed.miff  speed.gif
gif_anim_montage  speed.gif  speed_frames.gif
~~~

[![\[IM Output\]](speed.gif)](speed.gif)
[![\[IM Output\]](speed_frames.gif)](speed_frames.gif)

Note that I did not save the animation directly to the GIF format but saved it in a MIFF format file, "`speed.miff`" first.
This preserves all aspects of the originally created (or modified) animation, including GIF meta-data, timing delays, as well as all the colors of the image without distortion.

Only after preserving the original animation, did I directly convert the original animation to GIF format.
That way I could show what the above code is meant to achieve, and why I called it 'speed'.
This was done also to provide a base line GIF animation for study and later comparison.

So, let's look at various details of our original animation..

~~~{data-capture-out="speed_nframes.txt"}
identify -format "Number of Frames: %n\n" speed.miff | head -1
~~~

[![\[IM Text\]](speed_nframes.txt.gif)](speed_nframes.txt)

~~~{data-capture-out="speed_ncf.txt"}
identify -format "Colors in Frame %p: %k\n"  speed.miff
~~~

[![\[IM Text\]](speed_ncf.txt.gif)](speed_ncf.txt)

~~~{data-capture-out="speed_ncolors.txt"}
convert speed.miff +append  -format "Total Number of Colors: %k"  info:
~~~

[![\[IM Text\]](speed_ncolors.txt.gif)](speed_ncolors.txt)

As you can see, each image in the animation has a very large number of colors.
Not only does each frame have a different number of colors, but the first and third frames are very similar color-wise, though not quite exactly the same.

However the GIF file format can only save a maximum of 256 color per frame, and when ImageMagick saved this to GIF format it did so in the fastest, and dumbest way possible...

It reduced the number of colors of each frame in the animation (a process called [Color Quantization](../quantize/#colors))...

~~~{data-capture-out="speed_ncolors2.txt"}
identify -format "Colors in Frame %p: %k\n"  speed.gif
convert speed.gif +append  -format "Total Number of Colors: %k"  info:
~~~

[![\[IM Text\]](speed_ncolors2.txt.gif)](speed_ncolors2.txt)

Because the reduced number of colors in each frame is slightly different, IM also needed to supply a separate colormap for each frame in the animation.
This means that the GIF file has not only one 'Global Color Table' as it always does, but also three, additional, separate 'Local Color Tables'.

The "`identify`" command cannot tell you how many such local color tables a GIF file has, as the information is too format specific, and not important to the image processing IM normally does.
However, the more specific "`Giftrans`" program can tell you how many low level local color tables were used...

~~~{data-capture-out="speed_ctables.txt"}
giftrans -L speed.gif 2>&1 | grep -c "Local Color Table:"
~~~

[![\[IM Text\]](speed_ctables.txt.gif)](speed_ctables.txt)

As you can see, this animation has [![\[IM Text\]](speed_ctables.txt.gif)](speed_ctables.txt) local color tables, one less than the number of frames present in the image, just as I predicted.

Not only does each frame have a different set of colors, but also a slightly different pattern of colors (the image dither pattern), as described in [Problems with Error Correction Dithers](../quantize/#dither_sensitive).

Normally this default operation of IM [Color Quantization and Dithering](../quantize/) is very good, and perfectly suited for pictures, especially real life photos.
In fact the individual frames of an animation will generally look great.
All the problems arise when we try to later string those individually color reduced frames back together into an single animation sequence.

### Frame Opt before Color Opt? {#color_frame_first}

As you saw above, saving an animation directly to a GIF format, works, but you will get quite a lot of color differences from one frame to the next, which is bad for later [Frame Optimization](#optframe).

To prevent color differences causing such problems you can do the [Frame Optimization](#optframe) before saving the animation, and thus avoid the introduced color differences from one frame to another.
However be warned that doing frame optimization before color reducing however changes the dynamics of the color reduction.
Often, less of the static areas will appear in the optimized sub-frame, which means that the color quantization for that frame can give those colors less importance, and therefore fewer colors.

### Fuzzy Color Optimization {#color_fuzz}

However, sometimes you don't have access to the original animation before it was saved to GIF format.
This is especially true if you downloaded the original animation from the WWW.
That means you have an animation with all those GIF color distortions already present, producing problems with later optimizations.

Now because a slightly different set of colors are used from one frame to the next, and a different pattern of pixels are used for each frame in the animation, each frame can be regarded as a completely different image.

For example, let's compare the first and third frames, which share a large amount of the same background image....

~~~
compare  speed.gif'[0,2]' speed_compare.gif
~~~

[![\[IM Output\]](speed_compare.gif)](speed_compare.gif)

The red areas of the above example show two solid square areas of the areas that are different, just as you would expect.
But it also shows bands of color differences outlining the background of the two frames.
These represent the 'churning' dither pattern along the edges of the background gradient where different color pixels were used to represent the exact same background.

This was also the frame pair showing least background disturbances caused by using different sets of colors, and dither patterns.
The actual consecutive frame differences are far worse, producing a near solid red difference.
  
> ![](../img_www/reminder.gif)![](../img_www/space.gif)
> :REMINDER:
> Image differences like this are also a problem if your source images were stored using the JPEG image format.
> This format uses a lossy-compression method which, even at 100% quality, causes slight color differences in the images.
> However, the differences are generally confined to a halo around the actual areas of difference, rather than throughout the image.
>  
> All I can say is, avoid JPEG images for use in animations unless you plan to use one single image as a static background image for ALL your frames.

As so many pixels in the animation are different from one frame to the next it is not surprising then, that when we try to [Frame Optimize](#frame_opt) the animation, we get no optimization at all...

~~~
convert speed.gif  -layers OptimizeFrame  speed_opt2.gif
gif_anim_montage  speed_opt2.gif  speed_opt2_frames.gif
~~~

[![\[IM Output\]](speed_opt2_frames.gif)](speed_opt2_frames.gif)

However, most of the color differences between unchanging parts of the animation frames are actually rather small.
It wouldn't have been a very good [Color reduction](../quantize/#intro), if this wasn't the case.
That means that by asking IM to relax its color comparisons a little, you can ask it to ignore minor color differences.
This is done by setting an appropriate [Fuzz Factor](../color_basics/#fuzz).

~~~
convert speed.gif  -fuzz 5%  -layers OptimizeFrame  speed_opt3.gif
gif_anim_montage speed_opt3.gif speed_opt3_frames.gif
~~~

[![\[IM Output\]](speed_opt3_frames.gif)](speed_opt3_frames.gif)

As you can see with the addition of a small [Fuzz Factor](../color_basics/#fuzz), IM will now ignore the pixels that are only slightly different, producing a reasonable [Frame Optimization](#frame_opt).
How much of a fuzz factor you need, depends on just how much trouble IM had in color reducing the original images.
In this case, not a lot, so only a very small factor was needed.

If a small fuzz factor produces an acceptable result, then just set it for your [Frame Optimization](#optframe) and [Transparency Optimization](#trans_opt).
Just remember you still have a separate color table for each frame to take care of, which is the next point of discussion.

Note also that the [Frame Optimization](#frame_opt) decided to use a '[Previous Disposal](../anim_basics/#previous) for the second frame.
That is, after displaying the second frame, return the image to the previous frame disposal (the first image) before overlaying.
This resulted in a smaller overlay image size, than if no disposal was used thoughout.

If you wanted just a simple [Overlay Animation](../anim_basics/#overlay), only using [None Disposal](../anim_basics/#none) thoughout, you could have used the old [Deconstruct](../anim_basics/#deconstruct) operator (also known as [Layers CompareAny](../anim_basics/#compareany)) to generate it instead.

~~~
convert speed.gif  -fuzz 5%  -deconstruct  speed_opt4.gif
gif_anim_montage speed_opt4.gif speed_opt4_frames.gif
~~~

[![\[IM Output\]](speed_opt4_frames.gif)](speed_opt4_frames.gif)

### Generating a Single Global Color Table {#colortables}

Now, as each and every frame has a different set of colors, IM was forced to save the image with a separate color table for every frame; one global one for the first frame, and 3 local color tables for the later frames.

For example, here I used the very simple program "`Giftrans`" program to report how many frame color tables were created.

~~~{data-capture-out="speed_ctables.txt"}
giftrans -L speed.gif 2>&1 | grep -c "Local Color Table:"
~~~

[![\[IM Text\]](speed_ctables.txt.gif)](speed_ctables.txt)

For a fully-coalesced (or film strip like) animation, having separate color tables for each frame is perfectly fine and reasonable, and in such situations this is not a problem.
That is for slide shows of very different images, separate color tables will produce the best looking result.
As such this is the normal working behavior of IM.

All these extra color tables are, however, very costly, as each colortable can use a lot of space.
Up to 768 bytes (256 colors × 3 bytes per color or 3/4 kilobytes) for each frame in the image.
Not only that, but the GIF compression does not compress these color tables, only pixel data!

If having this much file space for separate color tables is a problem, especially for an image that doesn't change color a lot, as is the case with most GIF animations, then you can get IM to only use the required global color table, and not add any local color tables.

- - -

To remove local color maps all the image must become type "palette" and all use the same palette.
From the command line, you can do this by setting a "-map image" to define the common palette - you cannot use "-colors" as that works on individual images.

The command line solution is a special "`+map`" option, that does a global color reduction to a common palette that is added to all images.

NOTE any change to the image will likely invalidate the palette, so while color reduction should be done BEFORE you do GIF frame and/or compression optimizations, the common palette needs to be last, just before saving.
If "`+map`" does not need to reduce the number of colors in an image it will not do it or dither colors, just add a common palette across all images.

- - -

IM can generate a single global color table, if all the frames use the same color palette.
In IM, color palettes are only assigned to an image either by reading them in from an image format that uses such a palette, or by assigning one using the "`-map`" color reduction operator.
See [Dither with Pre-defined Colormap](../quantize/#map) for more details.

One way to generate this single color table is to simply "`-append`" all the frames together, then use the "`-colors`" command to reduce the number of colors to a minimal set - less than 256, or even smaller if you want a smaller color table.
The resulting color table can then be applied to the original image using "`-map`".

For example, here reduce the image to a single set of 64 colors.
This uses the special [MPR in-memory register](../files/#mpr) to assign the generated color map to the "`-map`" command.

~~~
convert speed.gif \
        \( -clone 0--1 -background none +append \
            -quantize transparent  -colors 63  -unique-colors \
           -write mpr:cmap    +delete \) \
        -map mpr:cmap      speed_cmap.gif
~~~

[![\[IM Output\]](speed_cmap.gif)](speed_cmap.gif)

If you examine the resulting animation using "`Giftrans`" you will find that the image now uses a single 'global' color table, rather than a separate color table for each frame.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> I use a "`-background`" color of '`None`' before appending the images together, allowing you to use this on un-coalesced animations, without risking the addition of extra unneeded colors.
>  
> The special "`-quantize`" setting of '`transparent`' colorspace was used to ensure that IM does not attempt to generate semi-transparent colors in its colormap.
> A useless thing as we are saving the result to GIF which cannot handle semi-transparency.
>
> Finally I color reduce to 63 colors, to leave space for a transparent color.
> Some animations need transparency, while others (like this one) may still need it later for [Compression Optimization](#compress_opt).

To make this easier, IM also provides a special option "`+map`" which will generate a common color map (of 256 colors) over all the frames, applying it globally.
This is a lot simpler than the DIY method above.

~~~
convert speed.miff  +matte +map   speed_map.gif
~~~

[![\[IM Output\]](speed_map.gif)](speed_map.gif)

~~~{.hide data-capture-out="speed_map_ctables.txt"}
giftrans -L speed_map.gif 2>&1 | grep -c "Local Color Table:"
~~~

~~~{.hide .assert}
[ "`cat speed_map_ctables.txt`" != 0 ] && echo >&2 \
  "ASSERTION FAILURE: Map Common Palette did not remove Local Color Tables!"
~~~

This resulted in [![\[IM Text\]](speed_map_ctables.txt.gif)](speed_map_ctables.txt) 'local' (or extra unwanted) color tables in the resulting image.

I will be using the single color table version of the animation for the next optimization sections, though you could actually do this at any point in your animation optimizations and especially before the final save.

~~~{.hide}
ls -l speed.gif | awk '{printf "%d", $5}' > speed_size.txt
ls -l speed_map.gif | awk '{printf "%d", $5}' > speed_map_size.txt
txt2gif speed_size.txt
txt2gif speed_map_size.txt
~~~

As a result of color table optimization, the animation which was [![\[IM Text\]](speed_size.txt.gif)](speed_size.txt) bytes for our directly converted GIF, is now [![\[IM Text\]](speed_map_size.txt.gif)](speed_map_size.txt) bytes, after using the "`+map`" operator.
The more frames (and 'local color tables') an animation has, the larger the saving.

Now, as any modification to an animation will generally remove the saved palette for each of the images, it is important that the "`+map`" operator be the last operation before saving the animation to GIF.

Remember

**Removal of local color maps should be the last optimization, before saving to GIF format.**

### Ordered Dither, removing the 'static'

**![](../img_www/const_barrier.gif) Under Construction ![](../img_www/const_hole.gif)**

Note however, that in all the techniques we have looked at so far, all can have a dither pattern that changes from one overlay to another.
A churning of the pixels that can look like TV static.

~~~{.skip}
... small number of colors ...
~~~

With a frame optimization of a smaller unmoving area, you can even get rectangular areas of static that look even worse.

~~~{.skip}
... Ordered Dither ...
~~~

For now refer to the more practical and less detailed [Video to GIF, Optimization Summary](../video/#gif).

------------------------------------------------------------------------

## Compression Optimization {#compress_opt}

Once you have your animation saved into a GIF format, by handling semi-transparent pixels and using color and frame optimizations, you are also able to get some additional, smaller file size reductions by catering to the GIF compression algorithm.

The LZW compression or Run-length Compression that the GIF file format can use will compress better if it finds larger areas of constant color, or pixel sequences that repeat over and over.

### Transparency Optimization {#opt_trans}

As you saw in [Frame Optimization](#frame_opt) an overlaid image will often be just repeating what is already being displayed.
That is it is overlaying the same colored pixels that are already present after the GIF disposal methods have been applied.

But why bother repeating those pixels?
If you are already using transparency in an image, you have a transparent pixel color available.
By converting those areas into transparency, you get larger areas of uniform transparent pixels.
That can compress better, than using a mix of different colors, needed to match the same area being overlaid.

For example, here is a simple [Frame Optimized](#frame_opt), [Overlay Animation](../anim_basics/#overlay)...
  
[![\[IM Output\]](bunny_bgnd_frames.gif)](bunny_bgnd_frames.gif)
  
[![\[IM Output\]](bunny_bgnd.gif)](bunny_bgnd.gif)

Let's now use the "`-layers`", method '`OptimizeTransparency`' (Added IM v6.3.4-4) to replace any pixel that does change the displayed result with transparency.

~~~
convert bunny_bgnd.gif -layers OptimizeTransparency \
                                  +map   bunny_bgnd_opttrans.gif
gif_anim_montage bunny_bgnd_opttrans.gif bunny_bgnd_opttrans_frames.gif
~~~

[![\[IM Output\]](bunny_bgnd_opttrans.gif)](bunny_bgnd_opttrans.gif)
[![\[IM Output\]](bunny_bgnd_opttrans_frames.gif)](bunny_bgnd_opttrans_frames.gif)

As you can see, the sub-frames now have large transparent areas, which do not affect the final resulting animation.
Areas that need the pixels changed are still overlaid, but the areas that do not change have been made transparent.
That includes within the object being animated as well, leaving rather horrible looking 'holes'.

~~~{.hide}
ls -lH bunny_bgnd.gif | awk '{printf "%d", $5}' > bunny_bgnd_size.txt
ls -l  bunny_bgnd_opttrans.gif | awk '{printf "%d", $5}' > bunny_bgnd_opttrans_size.txt
txt2gif bunny_bgnd_size.txt
txt2gif bunny_bgnd_opttrans_size.txt
~~~

As the larger constant transparent colored areas will (in theory) compress better, the resulting 'messy' animation is a lot smaller, reducing the file size from the frame optimized result of [![\[IM Text\]](bunny_bgnd_size.txt.gif)](bunny_bgnd_size.txt) bytes down to [![\[IM Text\]](bunny_bgnd_opttrans_size.txt.gif)](bunny_bgnd_opttrans_size.txt) bytes.
This is quite a big saving for a very small effort.

Note that the optimization method did not need to be a [Coalesced Animation](../anim_basics/#coalesced), and that the size of the sub-frames is left unchanged, so as to preserve the disposal needs of this and later frames.
As such, any saving is just in terms of improved compression ratios for the same number of pixels in the animation, and not in that actual number of pixels saved into the file.
It should thus be done after you have completed any [Frame Optimization](#frame_opt) needed, as one of your final optimization steps.

~~~{.skip}
FUTURE: link to a 'remove background' from animation
~~~

Of course, like most of the other "`-layers`" methods (comparison or optimization) you can specify a [Fuzz Factor](../color_basics/#fuzz) to adjust, 'how similar' colors are thought to be.
That lets you handle animations that were badly color dithered, though if you had studied the [Color Optimization](#color_opt) above you should not have that problem.

The free animated GIF tool "`InterGIF`" also provides this same type of transparency compression optimization shown above, but without the ability to also support a 'fuzz factor' to also make 'close' color changes transparent.
I do not recommend it, except as an alternative when IM is not available.

### LZW Optimization - (non-IM) {#opt_lzw}

Some applications can further optimise the compression ratio of the images in an animation to make it even smaller.
However to do this requires a specialized knowledge of the LZW compression that the GIF image file format typically uses.

Basically, if a specific sequence of pixels has already been handled by the LZW compression algorithm, it will not bother to convert them into transparent pixels as doing so will not improve the image's compression.

It sounds weird but it works.

Unfortunately *ImageMagick will not do this*, as it is such a complex process that takes a great deal of skill and resources to get a reasonably good heuristic to produce a good result in the general case.

I can however give you a practical example of this technique using the "`Gifsicle`" application at its highest '`-O2`' optimization level.

~~~
gifsicle -O2 bunny_bgnd.gif -o bunny_bgnd_lzw_gifsicle.gif
gif_anim_montage bunny_bgnd_lzw_gifsicle.gif bunny_bgnd_lzw_frames.gif
~~~

[![\[IM Output\]](bunny_bgnd_lzw_gifsicle.gif)](bunny_bgnd_lzw_gifsicle.gif)
[![\[IM Output\]](bunny_bgnd_lzw_frames.gif)](bunny_bgnd_lzw_frames.gif)

~~~{.hide}
ls -l bunny_bgnd_lzw_gifsicle.gif | awk '{printf "%d", $5}' > bunny_bgnd_lzw_gifsicle_size.txt
txt2gif bunny_bgnd_lzw_gifsicle_size.txt
~~~

LZW compression optimization reduced the image from [![\[IM Text\]](bunny_bgnd_opttrans_size.txt.gif)](bunny_bgnd_opttrans_size.txt) bytes with simple transparency optimization, to [![\[IM Text\]](bunny_bgnd_lzw_gifsicle_size.txt.gif)](bunny_bgnd_lzw_gifsicle_size.txt) bytes for '`Gifsicle`'.
Not a large improvement.

The more important aspect however, is that while LZW optimization converted unchanged pixels to transparency (as we did using [Transparency Optimization](#opt_trans) above), it did not change a sequence of pixels that had already been seen.
That is, only groups of pixels that have *not* already been repeated within the animation were changed, as those pixel would (presumably) already compress well using LZW compression patterns.

Note that the selection of which pixels should be made transparent, to generate repeated pixel patterns, is very complex and difficult, and can even depend on the exact LZW implementation as well.
It is a heuristic, not a perfectly predictable algorithm.
As such, different programs will generally produce different results depending on the specific image being compressed.
One program may produce a better compression ratio for one image, and another may be better for a different image.

*Do you know of other free GIF optimization programs available for Linux? -- Mail me, so I can also try them out, and let me show the results of different LZW optimizations.*

### Lossy LZW Optimization - (non-IM) {#opt_lzw_lossy}

Another compression improvement method involved the slight modification of the pixel colors themselves to 'close color matches' so as to increase the repetition of the color references in the image.
A repeated pattern naturally compresses better, and as such can produce higher compression ratios.
  
> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> For one example of such an algorithm that was patented for use by Photoshop see [US Patent 7031540 - Transformation to increase the lempel-ziv compressibility of images with minimal visual distortion](http://www.patentstorm.us/patents/7031540-fulltext.html).
> It is heavy reading but details the methods it uses to achieve better compression.

Unfortunately this method involved changing the resulting image, and as such the optimization is lossy, as it can lose subtle color information.
On the plus side, it allows you to compress the individual frames, rather than the frame-to-frame optimization.

Of course [Color Quantization and Dithering](../quantize/) is itself a lossy operation and is usually needed anyway, so using a lossy compression method for GIF images is not regarded as very bad.

Ideally this compression should be merged with the color reduction and dithering aspects to produce an even better lossy compression.
But that is only a factor when creating the initial GIF animation from other sources, so I am not surprised that I have not seen a program to do this.

### Ordered Dithered LZW Optimization {#opt_lzw_dithered}

As the dithering process is usually a more lossy process than LZW optimizations, a better solution may be to try to introduce the repeatable patterns as part of the dithering process.
That can be achieved by using [Ordered Dithering](../quantize/#ordered-dither) to produce such patterns, and thus much stronger LZW compression savings than the previous LZW Optimization method.
As a bonus it can also improve the [Frame Optimization](#frame_opt) of real life animations with static backgrounds.
That would be especially true if you artificially clean up the background so it does become a static, unchanging background.

Of course, Ordered Dither Compression Optimization only works for images that have not previously been dithered or otherwise color optimized.
As such, it only works for animations that have yet to be optimized for the GIF image format.

Also currently IM Ordered dither only works for a uniform color palette.
IM has yet to have a 'best color' or 'user supplied' palette implementation of ordered dither, though I have seen programs that use such an algorithm for very limited (and fixed) color palettes.
*Do you know of such an algorithm?*

For a practical example of using ordered dither for improved LZW compression optimization, see [Ordered Dithered Video](../video/#gif_ordered_dither).

### Other LZW Optimization {#opt_lzw_other}

Other improvements in LZW optimization can also be achieved by other re-arrangements of the 'dither pattern' in the image.
And some GIF tools can do exactly that.

However any such optimization should always be checked by a human eye before being approved, as sometimes a subtle but bad color change can result.

### Compression Optimization Summary

Here is a complete summary of the final file sizes achieved using compression optimizations.

~~~{.hide data-capture-out="bunny_bgnd_compress_sizes.txt"}
( ls -lH bunny_bgnd.gif; \
  ls -l  bunny_bgnd_opttrans.gif; \
  ls -l  bunny_bgnd_lzw_gifsicle.gif; \
) | awk '{printf "%6s %s\n", $5, $NF}' -
~~~

[![\[IM Text\]](bunny_bgnd_compress_sizes.txt.gif)](bunny_bgnd_compress_sizes.txt)

As you can see, only slight improvements in the final animation size were achieved by using the very complex [LZW Optimization](#lwz_opt), over the built-in [Transparency Optimization](#trans_opt).

However, the results are also highly variable between the many GIF optimization application programs available, and the specific animation that is being optimized.

If you really need to get the very last byte from a file size, then a [LZW Optimization](#lwz_opt) may be just what you need.
And if you really need the very best results, you should try a number of different programs (and thus heuristic implementations) to see which one compresses your specific animation better, including what other optimization features they provide.

Typically a [Transparency Optimization](#trans_opt) is good enough for most purposes.
With [LZW Optimization](#lwz_opt) only producing a slightly better result, producing a very minor saving for network transmission sizes, rather than disk storage size, as the latter uses larger 'chunks' or 'blocks' of storage.
Because of this I feel the [LZW Optimization](#lwz_opt), overkill, and I don't think it is worth the effort, or the money (most of these tools are commercially sold).

> ![](../img_www/expert.gif)![](../img_www/space.gif)
> :EXPERT:
> Unfortunately I have found that these GIF optimizers do not handle ALL types of pre-optimized animations very well.
>  
> For example, my tests show that "`Gifsicle`" fails to handle an animation that was already optimized using a 'background disposal' technique.
>  
> On the other hand, I found that "`InterGIF`" will not handle animations that have already been optimized to use an initial canvas and 'previous disposals' technique.
> It also is limited to the use of [Transparency Optimization](#trans_opt), which IM now provides.
>   
> I thus recommend you do not mix GIF optimization utilities by feeding one utility's output into another.
> At least not without first coalescing the animation to remove any previous frame optimizations.
>  
> IM, Gifsicle and InterGIF, all provide such coalescing options to remove their own optimizations, though I cannot guarantee the non-IM applications will coalesce ALL animations correctly.
> IM will.

Because you can't use these programs reliably with IM's advanced [Frame Optimization](#frame_opt) techniques (which selects and switches to using different GIF disposal techniques automatically), I have often found that IM will often produce an overall better result than just using these LZW compression optimizers.

I also suggest you [Coalesce](../anim_basics/#coalesce) the result again afterward and compare its frames against the original un-optimized animation, to ensure that the non-IM program did not somehow stuff up the animation entirely (see note above).
Believe me, I have seen it happen, and scripts should double check animations remain valid.

Another tutorial (using Windows tools) about this type of optimization is [WebReference Frame Optimation](http://www.webreference.com/dev/gifanim/frame.html).
Note that the site is mis-named as it is about compression optimization.

------------------------------------------------------------------------

## Minor Optimizations {#minor_opt}

There are a few other optimization techniques that you can use with GIF animations that are often so obvious that they are overlooked.

**Remove GIF comments.**

:    Many GIF animations have a large text comment added.
     Often these were added automatically by graphical editors as a form of advertising.
     For example, "`Gimp`" by default adds "`Created with The GIMP`" to images.
     If the comment is not needed, it is a waste of space.
     Remove them by adding a "`+set comment`" operator to the IM "`convert`" command before the GIF is saved.
     
     Please note however that if the comment is a copyright notice, it may not be a good idea to remove it for legal reasons.

**Reduce the number of colors.**

:    If animation looks okay with fewer colors, use a smaller color table.
     The color tables are always a power of two, so if you can use less than 32 colors, that is a lot smaller than using 256 colors.
     This is especially important as color tables are not compressed by the LZW compression used for the GIF image data.
     
     Also using fewer colors will generally produce better LZW compression as more common pixel sequences are found.
     This is not always the case however as color dithering (due to the color reduction) can also make the compression worse.
     Turning off dithering or using an ordered dither can be important here.

**Half the number of user visible frames.**

:    If you can handle a less smooth animation, then halving the total number frames can produce a good improvement in the final file size.
     Of course you don't get a file half the size, and the animation quality is reduced.
     But it can produce a very large file size reduction.

**Crop/Resize the animation.**

:    A smaller image size means a smaller file size.
     So if you don't need a big animation, don't use a big animation.
     A small thumbnail to represent a larger animation or video, is often preferable in a listing than the real thing.

**Alternative Compressions.**

:    If you do not plan to use the animation as an animation, that is you just want to store it, turn off the LZW compression, and "gzip" or "bzip2" compress the WHOLE file for storage!
     
     The result is a lot smaller, though it requires web servers to give the right 'content' and 'compression' hints to browsers for it to be directly usable by client browsers.
     The "`Apache`" web server, doesn't do this by default, but can be made to do so.
     
     Better still, archive the whole directory of uncompressed animations into a single file, for even better storage compression.

If you have any other optimization ideas, please let me know.

------------------------------------------------------------------------

## Other Sources of Information on GIF Optimization {#gif_links}

The above completes the various basic methods and techniques for handling animations.
However to form a complete picture, you should continue into the next IM Examples page, which details techniques for handling actual problems with real [Animations of Images](../anim_mods/).
Also, many of the above techniques are demonstrated in the practical examples of [Video to GIF Optimization](../video/#gif).

I also recommend you thoroughly read about [Color Quantization](../quantize/), if you are really serious about dealing with GIF animations, as color reduction is often the key to good GIF animation handling.

Other useful sources for GIF Animation Optimization techniques that I have found on the WWW include...

-   [Dr Dobb's - Optimizing GIF Animations](http://www.ddj.com/documents/s=2904/nam1012433888/index.html)
-   [Optimizing Animated GIFs](http://www.webreference.com/dev/gifanim/)

Mail me if you think you have a page I should list here.
I will only add pages of useful content, so no guarantees about adding your link.

---
title: Animation Optimization
created: 22 March 2007 ((sub-division of "animation")  
updated: 23 April 2007  
author: "[Anthony Thyssen](http://www.ict.griffith.edu.au/anthony/anthony.html), &lt;[A.Thyssen@griffith.edu.au](http://www.ict.griffith.edu.au/anthony/mail.shtml)&gt;"
version: 6.5.1-9
url: http://www.imagemagick.org/Usage/anim_opt/
---
