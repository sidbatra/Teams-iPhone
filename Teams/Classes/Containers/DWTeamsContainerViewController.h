//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"

@class DWPopularTeamsViewController;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController {
    DWPopularTeamsViewController    *_popularTeamsViewController;
}

/**
 * Displays the currently "popular" teams
 */
@property (nonatomic,retain) DWPopularTeamsViewController *popularTeamsViewController;

@end
