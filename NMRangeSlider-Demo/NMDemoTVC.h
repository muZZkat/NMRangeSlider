//
//  NMDemoTVC.h
//  NMRangeSlider
//
//  Created by Murray Hughes on 04/08/2012
//  Copyright 2011 Null Monkey Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMRangeSlider.h"

@interface NMDemoTVC : UITableViewController

@property (weak, nonatomic) IBOutlet NMRangeSlider *standardSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *metalSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *singleThumbSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *steppedSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *steppedContinuouslySlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *setValuesSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *crossOverSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *revealedTrackSlider;

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *programaticallyContainerCell;

- (IBAction)labelSliderChanged:(NMRangeSlider*)sender;

@end
