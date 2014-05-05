//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

#import "NMRangeSlider.h"


#define IS_PRE_IOS7() (DeviceSystemMajorVersion() < 7)

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}



@interface NMRangeSlider ()
{
    float _lowerTouchOffset;
    float _upperTouchOffset;
    float _stepValueInternal;
    BOOL _haveAddedSubviews;
}

@property (retain, nonatomic) UIImageView* lowerHandle;
@property (retain, nonatomic) UIImageView* upperHandle;
@property (retain, nonatomic) UIImageView* track;
@property (retain, nonatomic) UIImageView* lowerTrack;
@property (retain, nonatomic) UIImageView* upperTrack;
@property (retain, nonatomic) UIImageView* trackBackground;

@end


@implementation NMRangeSlider

#pragma mark -
#pragma mark - Constructors

- (id)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureView];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self configureView];
    }
    
    return self;
}


- (void) configureView
{
    //Setup the default values
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    _minimumRange = 0.0;
    _stepValue = 0.0;
    _stepValueInternal = 0.0;
    
    _continuous = YES;
    
    _lowerValue = _minimumValue;
    _upperValue = _maximumValue;
    
    _lowerMaximumValue = NAN;
    _upperMinimumValue = NAN;
    _upperHandleHidden = NO;
    _lowerHandleHidden = NO;
    
    _verticalMode = NO;
    
    _trackWidth = NAN;
    _trackBackgroundWidth = NAN;
    
    _trackEndPadding = 0.0;
    _trackBackgroundEndPadding = 0.0;
    
    _handleHeight = NAN;
    _handleWidth = NAN;
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Properties

- (CGPoint) lowerCenter
{
    return _lowerHandle.center;
}

- (CGPoint) upperCenter
{
    return _upperHandle.center;
}

- (void) setLowerValue:(float)lowerValue
{
    float value = lowerValue;
    
    if(_stepValueInternal>0)
    {
        value = roundf(value / _stepValueInternal) * _stepValueInternal;
    }
    
    value = MIN(value, _maximumValue);
    value = MAX(value, _minimumValue);
    
    if (!isnan(_lowerMaximumValue)) {
        value = MIN(value, _lowerMaximumValue);
    }
    
    value = MIN(value, _upperValue - _minimumRange);
    
    _lowerValue = value;
    
    [self setNeedsLayout];
}

- (void) setUpperValue:(float)upperValue
{
    float value = upperValue;
    
    if(_stepValueInternal>0)
    {
        value = roundf(value / _stepValueInternal) * _stepValueInternal;
    }

    value = MAX(value, _minimumValue);
    value = MIN(value, _maximumValue);
    
    if (!isnan(_upperMinimumValue)) {
        value = MAX(value, _upperMinimumValue);
    }
    
    value = MAX(value, _lowerValue+_minimumRange);
    
    _upperValue = value;
    
    [self setNeedsLayout];
}


- (void) setLowerValue:(float) lowerValue upperValue:(float) upperValue animated:(BOOL)animated
{
    if((!animated) && (isnan(lowerValue) || lowerValue==_lowerValue) && (isnan(upperValue) || upperValue==_upperValue))
    {
        //nothing to set
        return;
    }
    
    __block void (^setValuesBlock)(void) = ^ {
        
        if(!isnan(lowerValue))
        {
            [self setLowerValue:lowerValue];
        }
        if(!isnan(upperValue))
        {
            [self setUpperValue:upperValue];
        }
        
    };
    
    if(animated)
    {
        [UIView animateWithDuration:0.25  delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             setValuesBlock();
                             [self layoutSubviews];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    else
    {
        setValuesBlock();
    }

}

- (void)setLowerValue:(float)lowerValue animated:(BOOL) animated
{
    [self setLowerValue:lowerValue upperValue:NAN animated:animated];
}

- (void)setUpperValue:(float)upperValue animated:(BOOL) animated
{
    [self setLowerValue:NAN upperValue:upperValue animated:animated];
}

- (void) setLowerHandleHidden:(BOOL)lowerHandleHidden
{
    _lowerHandleHidden = lowerHandleHidden;
    [self setNeedsLayout];
}

- (void) setUpperHandleHidden:(BOOL)upperHandleHidden
{
    _upperHandleHidden = upperHandleHidden;
    [self setNeedsLayout];
}

//ON-Demand images. If the images are not set, then the default values are loaded.

- (UIImage *)trackBackgroundImage
{
    if(_trackBackgroundImage==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-trackBackground"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
            _trackBackgroundImage = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-trackBackground"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
            _trackBackgroundImage = image;
        }
    }
    
    return _trackBackgroundImage;
}

- (UIImage *)trackImage
{
    if(_trackImage==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-track"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)];
            _trackImage = image;
        }
        else
        {
            
            UIImage* image = [UIImage imageNamed:@"slider-default7-track"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            _trackImage = image;
        }
    }
    
    return _trackImage;
}


- (UIImage *)trackCrossedOverImage
{
    if(_trackCrossedOverImage==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-trackCrossedOver"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 7.0, 7.0, 7.0)];
            _trackCrossedOverImage = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-trackCrossedOver"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
            _trackCrossedOverImage = image;
        }
    }
    
    return _trackCrossedOverImage;
}

- (UIImage *)lowerHandleImageNormal
{
    if(_lowerHandleImageNormal==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-handle"];
            _lowerHandleImageNormal = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
            _lowerHandleImageNormal = image;
        }

    }
    
    return _lowerHandleImageNormal;
}

- (UIImage *)lowerHandleImageHighlighted
{
    if(_lowerHandleImageHighlighted==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-handle-highlighted"];
            _lowerHandleImageHighlighted = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
            _lowerHandleImageNormal = image;
        }
    }
    
    return _lowerHandleImageHighlighted;
}

- (UIImage *)upperHandleImageNormal
{
    if(_upperHandleImageNormal==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-handle"];
            _upperHandleImageNormal = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
            _upperHandleImageNormal = image;
        }
    }
    
    return _upperHandleImageNormal;
}

- (UIImage *)upperHandleImageHighlighted
{
    if(_upperHandleImageHighlighted==nil)
    {
        if(IS_PRE_IOS7())
        {
            UIImage* image = [UIImage imageNamed:@"slider-default-handle-highlighted"];
            _upperHandleImageHighlighted = image;
        }
        else
        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
            _upperHandleImageNormal = image;
        }
    }
    
    return _upperHandleImageHighlighted;
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Math Math Math

//Returns the lower value based on the X potion
//The return value is automatically adjust to fit inside the valid range
// erisler@myntpartners.com - when slider is in vertical mode if uses the y axis. Name of method could porbably be updated.
-(float) lowerValueForCenterX:(float)x
{
    float _padding = (self.verticalMode ? _lowerHandle.frame.size.height/2.0f : _lowerHandle.frame.size.width/2.0f);
    float value = _minimumValue + (x-_padding) / ((self.verticalMode ? self.frame.size.height : self.frame.size.width) -(_padding*2)) * (_maximumValue - _minimumValue);
    
    value = MAX(value, _minimumValue);
    value = MIN(value, _upperValue - _minimumRange);
    
    return value;
}

//Returns the upper value based on the X potion
//The return value is automatically adjust to fit inside the valid range
// erisler@myntpartners.com - when slider is in vertical mode if uses the y axis. Name of method could porbably be updated.
-(float) upperValueForCenterX:(float)x
{
    float _padding = (self.verticalMode ? _upperHandle.frame.size.height/2.0 : _upperHandle.frame.size.width/2.0);
    
    float value = _minimumValue + (x-_padding) / ( (self.verticalMode ? self.frame.size.height : self.frame.size.width) -(_padding*2)) * (_maximumValue - _minimumValue);
    
    value = MIN(value, _maximumValue);
    value = MAX(value, _lowerValue+_minimumRange);
    
    return value;
}

//returns the rect for the track image between the lower and upper values based on the trackimage object
- (CGRect)trackRect
{
    CGRect retValue;
    
    UIImage* currentTrackImage = [self trackImageForCurrentValues];
    
    retValue.size = CGSizeMake(currentTrackImage.size.width, currentTrackImage.size.height);
    
    // override width heigth if there are insets.
    if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom)
    {
        retValue.size.height=self.bounds.size.height;
    }
    if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right)
    {
        retValue.size.width=self.bounds.size.width/*-(self.verticalMode?0:4)*/;
    }
    
    // if there is a max width set then constrain width or height
    // only set the width if there are insets on the image.
    if (!isnan(_trackWidth)) {
        if (self.verticalMode) {
            if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right) {
                retValue.size.width = _trackWidth;
            }
        } else {
            if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom) {
                retValue.size.height = _trackWidth;
            }
        }
    }
    
    if (self.verticalMode) {
        float lowerHandleHeight = _lowerHandleHidden ? 2.0f : _lowerHandle.frame.size.height;
        float upperHandleHeight = _upperHandleHidden ? 2.0f : _upperHandle.frame.size.height;
        
        float yLowerValue = (( self.bounds.size.height - lowerHandleHeight) * (_lowerValue - _minimumValue) / (_maximumValue - _minimumValue))+(lowerHandleHeight/2.0f);
        float yUpperValue = (( self.bounds.size.height - upperHandleHeight) * (_upperValue - _minimumValue) / (_maximumValue - _minimumValue))+(upperHandleHeight/2.0f);
        
        retValue.origin = CGPointMake((self.bounds.size.width/2.0f) - (retValue.size.width/2.0f), yLowerValue+_trackEndPadding);
        retValue.size.height = yUpperValue-yLowerValue-_trackEndPadding;

    } else {
        float lowerHandleWidth = _lowerHandleHidden ? 2.0f : _lowerHandle.frame.size.width;
        float upperHandleWidth = _upperHandleHidden ? 2.0f : _upperHandle.frame.size.width;
        
        float xLowerValue = ((self.bounds.size.width - lowerHandleWidth) * (_lowerValue - _minimumValue) / (_maximumValue - _minimumValue))+(lowerHandleWidth/2.0f);
        float xUpperValue = ((self.bounds.size.width - upperHandleWidth) * (_upperValue - _minimumValue) / (_maximumValue - _minimumValue))+(upperHandleWidth/2.0f);
        
        retValue.origin = CGPointMake(xLowerValue+_trackEndPadding, (self.bounds.size.height/2.0f) - (retValue.size.height/2.0f));
        retValue.size.width = xUpperValue-xLowerValue-_trackEndPadding;
    }

    return retValue;
}

//returns the rect for the track image between the lower handle and the slider start
- (CGRect)lowerTrackRect
{
    CGRect retValue;
    
    UIImage* currentTrackImage = [self lowerTrackImage];
    
    retValue.size = CGSizeMake(currentTrackImage.size.width, currentTrackImage.size.height);
    
    // override width heigth if there are insets.
    if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom)
    {
        retValue.size.height=self.bounds.size.height;
    }
    if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right)
    {
        retValue.size.width=self.bounds.size.width/*-(self.verticalMode?0:4)*/;
    }
    
    // if there is a max width set then constrain width or height
    // only set the width if there are insets on the image.
    if (!isnan(_trackWidth)) {
        if (self.verticalMode) {
            if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right) {
                retValue.size.width = _trackWidth;
            }
        } else {
            if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom) {
                retValue.size.height = _trackWidth;
            }
        }
    }
    
    // Calculate the rect
    if (self.verticalMode) {
        float lowerHandleHeight = _lowerHandleHidden ? 2.0f : _lowerHandle.frame.size.height;
        
        float yLowerValue = (( self.bounds.size.height - lowerHandleHeight) * (_lowerValue - _minimumValue) / (_maximumValue - _minimumValue))+(lowerHandleHeight/2.0f);
        
        retValue.origin = CGPointMake((self.bounds.size.width/2.0f) - (retValue.size.width/2.0f), 0+_trackEndPadding);
        retValue.size.height = yLowerValue;
        
    } else {
        float lowerHandleWidth = _lowerHandleHidden ? 2.0f : _lowerHandle.frame.size.width;
        
        float xLowerValue = ((self.bounds.size.width - lowerHandleWidth) * (_lowerValue - _minimumValue) / (_maximumValue - _minimumValue))+(lowerHandleWidth/2.0f);
        
        retValue.origin = CGPointMake(0+_trackEndPadding, (self.bounds.size.height/2.0f) - (retValue.size.height/2.0f));
        retValue.size.width = xLowerValue;
    }
    
    return retValue;
}

// return the track rect between the upper handle and the slider end
- (CGRect)upperTrackRect
{
    CGRect retValue;
    
    UIImage* currentTrackImage = [self upperTrackImage];
    
    retValue.size = CGSizeMake(currentTrackImage.size.width, currentTrackImage.size.height);
    
    // override width heigth if there are insets.
    if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom)
    {
        retValue.size.height=self.bounds.size.height;
    }
    if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right)
    {
        retValue.size.width=self.bounds.size.width/*-(self.verticalMode?0:4)*/;
    }
    
    // if there is a max width set then constrain width or height
    // only set the width if there are insets on the image.
    if (!isnan(_trackWidth)) {
        if (self.verticalMode) {
            if(currentTrackImage.capInsets.left || currentTrackImage.capInsets.right) {
                retValue.size.width = _trackWidth;
            }
        } else {
            if(currentTrackImage.capInsets.top || currentTrackImage.capInsets.bottom) {
                retValue.size.height = _trackWidth;
            }
        }
    }
    
    if (self.verticalMode) {
        float upperHandleHeight = _upperHandleHidden ? 2.0f : _upperHandle.frame.size.height;
        
        float yUpperValue = (( self.bounds.size.height - upperHandleHeight) * (_upperValue - _minimumValue) / (_maximumValue - _minimumValue))+(upperHandleHeight/2.0f);
        
        retValue.origin = CGPointMake((self.bounds.size.width/2.0f) - (retValue.size.width/2.0f), yUpperValue);
        retValue.size.height = self.bounds.size.height - yUpperValue - _trackEndPadding;
        
    } else {
        float upperHandleWidth = _upperHandleHidden ? 2.0f : _upperHandle.frame.size.width;
        
        float xUpperValue = ((self.bounds.size.width - upperHandleWidth) * (_upperValue - _minimumValue) / (_maximumValue - _minimumValue))+(upperHandleWidth/2.0f);
        
        retValue.origin = CGPointMake(xUpperValue, (self.bounds.size.height/2.0f) - (retValue.size.height/2.0f));
        retValue.size.width = self.bounds.size.height - xUpperValue - _trackEndPadding;
    }
    
    return retValue;
}


- (UIImage*) trackImageForCurrentValues
{
    if(self.lowerValue <= self.upperValue)
    {
        return self.trackImage;
    }
    else
    {
        return self.trackCrossedOverImage;
    }
}

//returns the rect for the background image
 -(CGRect) trackBackgroundRect
{
    CGRect trackBackgroundRect;
    
    trackBackgroundRect.size = CGSizeMake(_trackBackgroundImage.size.width, _trackBackgroundImage.size.height);
    
    // override width heigth if there are insets.
    if(_trackBackgroundImage.capInsets.top || _trackBackgroundImage.capInsets.bottom)
    {
        trackBackgroundRect.size.height=self.bounds.size.height/*-(self.verticalMode?4:0)*/;
    }
    if(_trackBackgroundImage.capInsets.left || _trackBackgroundImage.capInsets.right)
    {
        trackBackgroundRect.size.width=self.bounds.size.width/*-(self.verticalMode?0:4)*/;
    }
    
    // if there is a max width set then constrain width or height base
    if (!isnan(_trackBackgroundWidth)) {
        if (self.verticalMode) {
            // only set the width if there are insets on the image.
            if(_trackBackgroundImage.capInsets.left || _trackBackgroundImage.capInsets.right) {
                trackBackgroundRect.size.width = _trackBackgroundWidth;
            }
        } else {
            // only set the width if there are insets on the image.
            if(_trackBackgroundImage.capInsets.top || _trackBackgroundImage.capInsets.bottom) {
                trackBackgroundRect.size.height = _trackBackgroundWidth;
            }
        }
    }
    
    
    if (self.verticalMode) {
        // adjust the length to allow for user specified padding.
        trackBackgroundRect.size.height -= (_trackBackgroundEndPadding*2);
        trackBackgroundRect.origin = CGPointMake((self.bounds.size.width/2.0f) - (trackBackgroundRect.size.width/2.0f), 0+_trackBackgroundEndPadding);
    } else {
        // adjust the length to allow for user specified padding.
        trackBackgroundRect.size.width -= (_trackBackgroundEndPadding*2);
        trackBackgroundRect.origin = CGPointMake(0+_trackBackgroundEndPadding, (self.bounds.size.height/2.0f) - (trackBackgroundRect.size.height/2.0f));
    }
    
    return trackBackgroundRect;
}

//returms the rect of the tumb image for a given track rect and value
- (CGRect)thumbRectForValue:(float)value image:(UIImage*) thumbImage
{
    CGRect thumbRect;
    UIEdgeInsets insets = thumbImage.capInsets;

    // default to the image size.
    thumbRect.size = CGSizeMake(thumbImage.size.width, thumbImage.size.height);
    
    // if there are insets, stretch the thumb across the track.
    if (self.verticalMode) {
        if(insets.left || insets.right)
        {
            thumbRect.size.width=self.bounds.size.width;
        }
    } else {
        if(insets.top || insets.bottom)
        {
            thumbRect.size.height=self.bounds.size.height;
        }
    }
    
    if (self.verticalMode) {
        // set the thumb height/width?
        if (!isnan(_handleHeight)) {
            if (insets.top || insets.bottom) {
                thumbRect.size.height = _handleHeight;
            }
        }
        if (!isnan(_handleWidth)) {
            if (insets.left || insets.right) {
                thumbRect.size.width = _handleWidth;
            }
        }
        
        float yValue = ((self.bounds.size.height-thumbRect.size.height)*((value - _minimumValue) / (_maximumValue - _minimumValue)));
        thumbRect.origin = CGPointMake((self.bounds.size.width/2.0f) - (thumbRect.size.width/2.0f) ,yValue);
    } else {
        // set the thumb height/width?
        if (!isnan(_handleHeight)) {
            // the "height" is the dimension that follows the track, so in this case it's the thumb's width.
            if (insets.left || insets.right) {
                thumbRect.size.width = _handleHeight;
            }
        }
        if (!isnan(_handleWidth)) {
            if (insets.top || insets.bottom) {
                thumbRect.size.height = _handleWidth;
            }
        }
        
        float xValue = ((self.bounds.size.width-thumbRect.size.width)*((value - _minimumValue) / (_maximumValue - _minimumValue)));
        thumbRect.origin = CGPointMake(xValue, (self.bounds.size.height/2.0f) - (thumbRect.size.height/2.0f));
    }
    
    return CGRectIntegral(thumbRect);

}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Layout


- (void) addSubviews
{
    //------------------------------
    // Track Brackground
    self.trackBackground = [[UIImageView alloc] initWithImage:self.trackBackgroundImage];
    self.trackBackground.frame = [self trackBackgroundRect];
    
    //------------------------------
    // Track
    self.track = [[UIImageView alloc] initWithImage:[self trackImageForCurrentValues]];
    self.track.frame = [self trackRect];
    if (self.lowerTrackImage) {
        self.lowerTrack = [[UIImageView alloc] initWithImage:[self lowerTrackImage]];
        self.lowerTrack.frame = [self lowerTrackRect];
    }
    if (self.upperTrackImage) {
        self.upperTrack = [[UIImageView alloc] initWithImage:[self upperTrackImage]];
        self.upperTrack.frame = [self upperTrackRect];
    }
    
    //------------------------------
    // Lower Handle Handle
    self.lowerHandle = [[UIImageView alloc] initWithImage:self.lowerHandleImageNormal highlightedImage:self.lowerHandleImageHighlighted];
    self.lowerHandle.frame = [self thumbRectForValue:_lowerValue image:self.lowerHandleImageNormal];
    
    //------------------------------
    // Upper Handle Handle
    self.upperHandle = [[UIImageView alloc] initWithImage:self.upperHandleImageNormal highlightedImage:self.upperHandleImageHighlighted];
    self.upperHandle.frame = [self thumbRectForValue:_upperValue image:self.upperHandleImageNormal];
    
    [self addSubview:self.trackBackground];
    [self addSubview:self.track];
    if (self.lowerTrack) {
        [self addSubview:self.lowerTrack];
    }
    if (self.upperTrack) {
        [self addSubview:self.upperTrack];
    }
    [self addSubview:self.lowerHandle];
    [self addSubview:self.upperHandle];
}


-(void)layoutSubviews
{
    if(_haveAddedSubviews==NO)
    {
        _haveAddedSubviews=YES;
        [self addSubviews];
    }
    
    if(_lowerHandleHidden)
    {
        _lowerValue = _minimumValue;
    }
    
    if(_upperHandleHidden)
    {
        _upperValue = _maximumValue;
    }

    self.trackBackground.frame = [self trackBackgroundRect];
    self.track.frame = [self trackRect];
    self.track.image = [self trackImageForCurrentValues];
    
    if (self.lowerTrack) {
        self.lowerTrack.frame = [self lowerTrackRect];
        self.lowerTrack.image = [self lowerTrackImage];
    }
    if (self.upperTrack) {
        self.upperTrack.frame = [self upperTrackRect];
        self.upperTrack.image = [self upperTrackImage];
    }

    // Layout the lower handle
    self.lowerHandle.frame = [self thumbRectForValue:_lowerValue image:self.lowerHandleImageNormal];
    self.lowerHandle.image = self.lowerHandleImageNormal;
    self.lowerHandle.highlightedImage = self.lowerHandleImageHighlighted;
    self.lowerHandle.hidden = self.lowerHandleHidden;
    
    // Layoput the upper handle
    self.upperHandle.frame = [self thumbRectForValue:_upperValue image:self.upperHandleImageNormal];
    self.upperHandle.image = self.upperHandleImageNormal;
    self.upperHandle.highlightedImage = self.upperHandleImageHighlighted;
    self.upperHandle.hidden= self.upperHandleHidden;
    
}

- (CGSize)intrinsicContentSize
{
    if (self.verticalMode) {
        return CGSizeMake(MAX(self.lowerHandleImageNormal.size.width, self.upperHandleImageNormal.size.width), UIViewNoIntrinsicMetric);
    } else {
        return CGSizeMake(UIViewNoIntrinsicMetric, MAX(self.lowerHandleImageNormal.size.height, self.upperHandleImageNormal.size.height));
    }
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Touch handling

// The handle size can be a little small, so i make it a little bigger
// TODO: Do it the correct way. I think wwdc 2012 had a video on it...
- (CGRect) touchRectForHandle:(UIImageView*) handleImageView
{
    float xPadding = 5;
    float yPadding = 5; //(self.bounds.size.height-touchRect.size.height)/2.0f

    // expands rect by xPadding in both x-directions, and by yPadding in both y-directions
    CGRect touchRect = CGRectInset(handleImageView.frame, -xPadding, -yPadding);;
    return touchRect;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    
    //Check both buttons upper and lower thumb handles because
    //they could be on top of each other.
    
    if(CGRectContainsPoint([self touchRectForHandle:_lowerHandle], touchPoint))
    {
        _lowerHandle.highlighted = YES;
        if (self.verticalMode) {
            _lowerTouchOffset = touchPoint.y - _lowerHandle.center.y;
        } else {
            _lowerTouchOffset = touchPoint.x - _lowerHandle.center.x;
        }
    }
    
    if(CGRectContainsPoint([self touchRectForHandle:_upperHandle], touchPoint))
    {
        _upperHandle.highlighted = YES;
        if (self.verticalMode) {
            _upperTouchOffset = touchPoint.y - _upperHandle.center.y;
        } else {
            _upperTouchOffset = touchPoint.x - _upperHandle.center.x;
        }
    }
    
    _stepValueInternal= _stepValueContinuously ? _stepValue : 0.0f;
    
    return YES;
}


-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!_lowerHandle.highlighted && !_upperHandle.highlighted ){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    
    if(_lowerHandle.highlighted)
    {
        //get new lower value based on the touch location.
        //This is automatically contained within a valid range.
        float newValue = 0.0f;
        if (self.verticalMode) {
            newValue = [self lowerValueForCenterX:(touchPoint.y - _lowerTouchOffset)];
        } else {
            newValue = [self lowerValueForCenterX:(touchPoint.x - _lowerTouchOffset)];
        }
        
        //if both upper and lower is selected, then the new value must be LOWER
        //otherwise the touch event is ignored.
        if(!_upperHandle.highlighted || newValue<_lowerValue)
        {
            _upperHandle.highlighted=NO;
            [self bringSubviewToFront:_lowerHandle];
            
            [self setLowerValue:newValue animated:_stepValueContinuously ? YES : NO];
        }
        else
        {
            _lowerHandle.highlighted=NO;
        }
    }
    
    if(_upperHandle.highlighted )
    {
        float newValue = 0.0f;
        if (self.verticalMode) {
            newValue = [self upperValueForCenterX:(touchPoint.y - _upperTouchOffset)];
        } else {
            newValue = [self upperValueForCenterX:(touchPoint.x - _upperTouchOffset)];
        }

        //if both upper and lower is selected, then the new value must be HIGHER
        //otherwise the touch event is ignored.
        if(!_lowerHandle.highlighted || newValue>_upperValue)
        {
            _lowerHandle.highlighted=NO;
            [self bringSubviewToFront:_upperHandle];
            [self setUpperValue:newValue animated:_stepValueContinuously ? YES : NO];
        }
        else
        {
            _upperHandle.highlighted=NO;
        }
    }
     
    
    //send the control event
    if(_continuous)
    {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    //redraw
    [self setNeedsLayout];

    return YES;
}



-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _lowerHandle.highlighted = NO;
    _upperHandle.highlighted = NO;
    
    if(_stepValue>0)
    {
        _stepValueInternal=_stepValue;
        
        [self setLowerValue:_lowerValue animated:YES];
        [self setUpperValue:_upperValue animated:YES];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
