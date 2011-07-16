//
//  DWRecentTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWTeamsViewController.h"

@class DWRecentTeamsDataSource;

/**
 * Table view to display the recently created teams
 */
@interface DWRecentTeamsViewController : DWTableViewController {
    DWRecentTeamsDataSource     *_recentTeamsDataSource;
    DWTeamsViewController       *_teamsViewController;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWRecentTeamsDataSource *recentTeamsDataSource;

/**
 * Teams view controller encapsulates the common functionality needed by a
 * table view controller that contains a list of teams
 */
@property (nonatomic,retain) DWTeamsViewController *teamsViewController;


/**
 * Set a teams view controller delegate
 */
- (void)setDelegate:(id<DWTeamsViewControllerDelegate>)delegate;

@end
