//
//  DWTeamFollowersViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersViewController.h"

@class DWTeamFollowersDataSource;

/**
 * Display the followers of a team
 */
@interface DWTeamFollowersViewController : DWUsersViewController {
    DWTeamFollowersDataSource   *_teamFollowersDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamFollowersDataSource *teamFollowersDataSource;

@end
