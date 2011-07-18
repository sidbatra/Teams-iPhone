//
//  DWTeamFollowersViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersViewController.h"

@class DWTeam;
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


/**
 * Init with team whose followers are being displayed
 */
- (id)initWithTeam:(DWTeam*)team;

@end
