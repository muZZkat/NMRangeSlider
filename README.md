
# NMRangeSlider

* * * * * * * * * * *

NMRangeSlider is custom iOS control that gives you a UISlider like UI for selecting a range of values. This project was inspried by: https://github.com/buildmobile/iosrangeslider.

The range slider can be configured using a set of images in much the same way as UISlider. (Background, Track and Thumbs)

In addition to the regular UISlider features it can:

* Handle stepped values. The handles will snap to points along the slider with a couple different options
* Access to the centre location of handle image. This can be used to arrange subviews.
* (New) Disable lower handle so it behaves like a regular UISlider but still use other features.
* (New) Set a negative min range so the thumbs can cross over. (with custom track image)
* (New) Automatic iOS 7 theme with tint color support

See the demo application for some examples on how the to configure the slider.

# ![Screenshot](https://raw.github.com/muZZkat/NMRangeSlider/master/NMRangeSlider-ScreenShot.png)

## TODO

If anyone would like to help here a few things I would like to add:

* Custom images for other control states. UISlider lets the user set different images for any number of UIControlStates.
* Have a designer provide a few more sample graphics.
* Ability to set a tint colour that is applied to the default images (or drawn using CoreGraphics)


## Authors

* Murray Hughes ([@muzzkat](https://twitter.com/muzzkat))

## License

Copyright 2012 Null Monkey Pty Ltd

Licensed under the MIT License, enjoy!

