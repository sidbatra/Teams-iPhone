//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"

@class DWSegmentedController;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController {
    DWSegmentedController   *_segmentedController;
}

/**
 * Segmented controller for displaying the Popular, Search and Recent segments
 */
@property (nonatomic,retain) DWSegmentedController *segmentedController;

@end
