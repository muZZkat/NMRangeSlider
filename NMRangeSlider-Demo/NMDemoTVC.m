//
//  NMDemoTVC.m
//  NMRangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//


#import "NMDemoTVC.h"

@interface NMDemoTVC ()

@end

@implementation NMDemoTVC


// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureStandardSlider];
    [self configureMetalSlider];
    [self configureSingleThumbSlider];
    [self configureLabelSlider];
    [self configureSetValueSlider];
    [self configureSteppedSlider];
    [self configureSteppedSliderAlternative];
    [self configureCrossOverSlider];
    [self configureProgramically];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSliderLabels];
    [self updateSetValuesSlider];
    
    if([self.view respondsToSelector:@selector(setTintColor:)])
    {
        self.view.tintColor = [UIColor orangeColor];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Standard Slider


- (void) configureStandardSlider
{
    self.standardSlider.lowerValue = 0.23;
    self.standardSlider.upperValue = 0.53;
}


// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Metal Theme Slider

- (void) configureMetalThemeForSlider:(NMRangeSlider*) slider
{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider-metal-trackBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    slider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider-metal-track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider-metal-handle"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider-metal-handle-highlighted"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
}

- (void) configureMetalSlider
{
    [self configureMetalThemeForSlider:self.metalSlider];
    
    self.metalSlider.lowerValue = 0.2;
    self.metalSlider.upperValue = 0.8;
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Standard Slider


- (void) configureSingleThumbSlider
{
    // Disabling the lower slider lets you use the control as a regular UISlider but with
    // the added themes and stepping functions.
    
    [self configureMetalThemeForSlider:self.singleThumbSlider];
    
    self.singleThumbSlider.upperValue = 0.53;
    self.singleThumbSlider.lowerHandleHidden = YES;
    self.singleThumbSlider.stepValue = 0.2;
    self.singleThumbSlider.stepValueContinuously = YES;
    
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    
    self.labelSlider.minimumRange = 10;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Set Values  Slider

- (void) configureSetValueSlider
{
    [self configureMetalThemeForSlider:self.setValuesSlider];

    self.setValuesSlider.minimumRange = 0.1;

}

- (void) updateSetValuesSlider
{
    float value1 = (float)random()/RAND_MAX;
    float value2 = (float)random()/RAND_MAX;
    
    [self.setValuesSlider setLowerValue:MIN(value1, value2) upperValue:MAX(value1, value2) animated:YES];

    // OR set them individually
    //[self.setValuesSlider setLowerValue:MIN(value1, value2) animated:YES];
    //[self.setValuesSlider setUpperValue:MAX(value1, value2) animated:YES];
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Stepped  Sliders

- (void) configureSteppedSlider
{
    self.steppedSlider.stepValue = 0.2;
}

- (void) configureSteppedSliderAlternative
{
    self.steppedContinuouslySlider.stepValue = 0.2;
    self.steppedContinuouslySlider.stepValueContinuously = YES;
    
}


// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Crossover Slider


- (void) configureCrossOverSlider
{
    // you can set a negative minimum range so the lower and upper values can actually
    // cross over. When they cross over, the track changes color. Custom images can be set.
    self.crossOverSlider.minimumRange = -1.0;
    
    self.crossOverSlider.upperValue = 0.23;
    self.crossOverSlider.lowerValue = 0.53;
    
}


// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - Programic Sliders

- (void) configureProgramically
{
    NMRangeSlider* rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(16, 6, 275, 34)];
    rangeSlider.lowerValue = 0.54;
    rangeSlider.upperValue = 0.94;
    [self.programaticallyContainerCell addSubview:rangeSlider];
}

// ------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].tag==1)
    {
        [self updateSetValuesSlider];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}



// ------------------------------------------------------------------------------------------------------

// Nothing to see here, move along

@end
