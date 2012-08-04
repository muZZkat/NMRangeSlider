//
//  NMDemoTVC.h
//  NMRangeSlider
//
//  Created by Murray Hughes on 4/08/12.
//  Copyright (c) 2012 Null Monkey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMRangeSlider.h"

@interface NMDemoTVC : UITableViewController

@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *metalSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *steppedSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *steppedContinuouslySlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *setValuesSlider;

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;

- (IBAction)labelSliderChanged:(NMRangeSlider*)sender;

@end
