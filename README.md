
# NMRangeSlider (erisler additions)

* * * * * * * * * * *

* Added "vertical mode" to slider to render and operate vertically. NOTE: because 0,0 is the upper left in iOS, the control is rendered upside down to the way you would expect it to function. This means that the handle at the top actually represents the "lower" value and if you slide it up, the lower value will decrease toward 0 (the opposite being true for the "upper" handle). For now (until myself or someone else changes the code) you will have to convert the upper and lower values after reading them. I've included this code in the example to illustrate.

* Added track and track background width property so you can explicitly set both. These values will only take effect if the track and background images have insets on them.

* Added track and track background padding property so you can inset the track from the end of the control's bounds.

* Updated default theme images and added new vertical theme

* Added lower and upper track image properties. These currently only apply if you enable the double slider (lowerHandleHidden==NO && upperHandleHidden==NO). Note - at this time the "upper" track in vertical mode is in fact the bottom track. This is because (0,0) is at the top. 

* Updated demo project showing new features.

* Added thumb width+height properties. If you set insets for the thumb images you can resize them using these properties.






