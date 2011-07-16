//
//  DWPopularTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWTeamsViewController.h"

@class DWPopularTeamsDataSource;

/**
 * Table view for displaying popular teams
 */
@interface DWPopularTeamsViewController : DWTableViewController {
    DWPopularTeamsDataSource    *_popularTeamsDataSource;  
    DWTeamsViewController       *_teamsViewController;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWPopularTeamsDataSource *popularTeamsDataSource;

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
