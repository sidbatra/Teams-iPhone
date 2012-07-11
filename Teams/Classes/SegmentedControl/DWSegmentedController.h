//
//  DWSegmentedController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWSegmentedControl.h"

/**
 * 
 */
@interface DWSegmentedController : UIViewController<DWSegmentedControlDelegate> {
    
    DWSegmentedControl	*_segmentedControl;
    
	NSArray				*_subControllers;
    
    UIViewController    *__unsafe_unretained _parentForSubControllers;
    
    CGRect              _controllerFrame;
}

/**
 * Segmented control contains the UI for displaying the segments
 * and handling their user interaction
 */
@property (nonatomic) DWSegmentedControl *segmentedControl;

/**
 * The sub controllers corresponding to the segmentedControl. They
 * are added and removed from the parentForSubController
 * as the user interacts with the segmentedControl
 */
@property (nonatomic) NSArray *subControllers;

/**
 * Parent view controller where the sub controllers are added and removed from
 */
@property (nonatomic,unsafe_unretained) UIViewController *parentForSubControllers;


/**
 * Init with the frame of the segmentedControl and an array
 * containing info about the UI of all the segments
 */
- (id)initWithFrame:(CGRect)controllerFrame
    andSegmentsInfo:(NSArray*)segmentsInfo;

@end
