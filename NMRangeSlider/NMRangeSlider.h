//
//  RangeSlider.h
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//
// Inspried by: https://github.com/buildmobile/iosrangeslider

#import <UIKit/UIKit.h>

@protocol NMRangeSliderDelegate <NSObject>

@optional
/**
 *  When lower handle image view is selected.
 *
 *  @param view      The slider view.
 *  @param imageView The lower image view.
 */
- (void)rangeSliderView:(UIView *)view didSelectLowerHandleImageView:(UIImageView *)imageView;

/**
 *  When upper handle image view is selected.
 *
 *  @param view      The slider view.
 *  @param imageView The upper image view.
 */
- (void)rangeSliderView:(UIView *)view didSelectUpperHandleImageView:(UIImageView *)imageView;

/**
 *  When slider stopped moving.
 *
 *  @param view The slider view.
 */
- (void)rangeSliderViewDidEndSelect:(UIView *)view;

/**
 *  When lower handle image view did move.
 *
 *  @param view      The slider view.
 *  @param imageView The lower image view.
 */
- (void)rangeSliderView:(UIView *)view didMoveLowerHandleImageView:(UIImageView *)imageView;

/**
 *  When upper handle image view did move.
 *
 *  @param view      The slider view.
 *  @param imageView The upper image view.
 */
- (void)rangeSliderView:(UIView *)view didMoveUpperHandleImageView:(UIImageView *)imageView;

@end

@interface NMRangeSlider : UIControl

@property (weak, nonatomic) id <NMRangeSliderDelegate> delegate;

// default 0.0
@property(assign, nonatomic) float minimumValue;

// default 1.0
@property(assign, nonatomic) float maximumValue;

// default 0.0. This is the minimum distance between between the upper and lower values
@property(assign, nonatomic) float minimumRange;

// default 0.0 (disabled)
@property(assign, nonatomic) float stepValue;

// If NO the slider will move freely with the tounch. When the touch ends, the value will snap to the nearest step value
// If YES the slider will stay in its current position until it reaches a new step value.
// default NO
@property(assign, nonatomic) BOOL stepValueContinuously;

// defafult YES, indicating whether changes in the sliders value generate continuous update events.
@property(assign, nonatomic) BOOL continuous;

// default 0.0. this value will be pinned to min/max
@property(assign, nonatomic) float lowerValue;

// default 1.0. this value will be pinned to min/max
@property(assign, nonatomic) float upperValue;

// center location for the lower handle control
@property(readonly, nonatomic) CGPoint lowerCenter;

// center location for the upper handle control
@property(readonly, nonatomic) CGPoint upperCenter;

// maximum value for left thumb
@property(assign, nonatomic) float lowerMaximumValue;

// minimum value for right thumb
@property(assign, nonatomic) float upperMinimumValue;

@property (assign, nonatomic) UIEdgeInsets lowerTouchEdgeInsets;
@property (assign, nonatomic) UIEdgeInsets upperTouchEdgeInsets;

@property (assign, nonatomic) BOOL lowerHandleHidden;
@property (assign, nonatomic) BOOL upperHandleHidden;

@property (assign, nonatomic) float lowerHandleHiddenWidth;
@property (assign, nonatomic) float upperHandleHiddenWidth;

// Images, these should be set before the control is displayed.
// If they are not set, then the default images are used.
// eg viewDidLoad


//Probably should add support for all control states... Anyone?

@property(retain, nonatomic) UIImage* lowerHandleImageNormal;
@property(retain, nonatomic) UIImage* lowerHandleImageHighlighted;

@property(retain, nonatomic) UIImage* upperHandleImageNormal;
@property(retain, nonatomic) UIImage* upperHandleImageHighlighted;

@property(retain, nonatomic) UIImage* trackImage;

// track image when lower value is higher than the upper value (eg. when minimum range is negative
@property(retain, nonatomic) UIImage* trackCrossedOverImage;

@property(retain, nonatomic) UIImage* trackBackgroundImage;

@property (retain, nonatomic) UIImageView* lowerHandle;
@property (retain, nonatomic) UIImageView* upperHandle;


- (void)addSubviews;

//Setting the lower/upper values with an animation :-)
- (void)setLowerValue:(float)lowerValue animated:(BOOL) animated;

- (void)setUpperValue:(float)upperValue animated:(BOOL) animated;

- (void) setLowerValue:(float) lowerValue upperValue:(float) upperValue animated:(BOOL)animated;

@end
