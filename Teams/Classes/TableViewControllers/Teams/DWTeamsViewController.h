//
//  DWTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTeam;
@class DWTableViewController;
@protocol DWTeamsViewControllerDelegate;

/**
 * Base table views that display a list of teams
 */
@interface DWTeamsViewController : NSObject {
    DWTableViewController   *_tableViewController;
    
    id <DWTeamsViewControllerDelegate> _delegate;
}

/**
 * The table view controller which contains the teams view controller object
 */
@property (nonatomic,assign) DWTableViewController *tableViewController;

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
