//
//  NMVerticalRangeSlider.m
//  NMRangeSlider
//
//  Created by Mihail Velikov on 12/1/15.
//  Copyright © 2015 Null Monkey. All rights reserved.
//

#import "NMVerticalRangeSlider.h"

@implementation NMVerticalRangeSlider

//Returns the lower value based on the X potion
//The return value is automatically adjust to fit inside the valid range
-(float) lowerValueForCenterX:(float)x
{
    float _padding = self.lowerHandle.frame.size.height/2.0f;
    float value = self.minimumValue + (x-_padding) / (self.frame.size.height-(_padding*2)) * (self.maximumValue - self.minimumValue);
    
    value = MAX(value, self.minimumValue);
    value = MIN(value, self.upperValue - self.minimumRange);
    
    return value;
}

//Returns the upper value based on the X potion
//The return value is automatically adjust to fit inside the valid range
-(float) upperValueForCenterX:(float)x
{
    float _padding = self.upperHandle.frame.size.height/2.0;
    
    float value = self.minimumValue + (x-_padding) / (self.frame.size.height-(_padding*2)) * (self.maximumValue - self.minimumValue);
    
    value = MIN(value, self.maximumValue);
    value = MAX(value, self.lowerValue+self.minimumRange);
    
    return value;
}


@end
