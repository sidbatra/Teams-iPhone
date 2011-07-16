//
//  DWTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWTeam;
@protocol DWTeamsViewControllerDelegate;

/**
 * Base table views that display a list of teams
 */
@interface DWTeamsViewController : DWTableViewController {
    id <DWTeamsViewControllerDelegate> _delegate;
}

/**
 * Delegate receives events based on the DWTeamsViewControllerDelegate
 */
@property (nonatomic,assign) id<DWTeamsViewControllerDelegate> delegate;

@end


/**
 * Delegate protocol for the DWTeamsViewController
 */
@protocol DWTeamsViewControllerDelegate

/**
 * Fired when the user selects a team
 */
- (void)teamSelected:(DWTeam*)team;

@end
