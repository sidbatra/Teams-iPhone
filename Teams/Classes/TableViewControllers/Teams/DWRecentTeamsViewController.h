//
//  DWRecentTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTeamsViewController.h"

@class DWRecentTeamsDataSource;

/**
 * Table view to display the recently created teams
 */
@interface DWRecentTeamsViewController : DWTeamsViewController {
    DWRecentTeamsDataSource     *_recentTeamsDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWRecentTeamsDataSource *recentTeamsDataSource;

@end
