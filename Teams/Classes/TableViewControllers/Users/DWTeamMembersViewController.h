//
//  DWTeamMembersViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersViewController.h"

@class DWTeam;
@class DWTeamMembersDataSource;

/**
 * Display the members of a team
 */
@interface DWTeamMembersViewController : DWUsersViewController {
    DWTeamMembersDataSource     *_teamMembersDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamMembersDataSource *teamMembersDataSource;


/**
 * Init with team whose members are being displayed
 */
- (id)initWithTeam:(DWTeam*)team;

@end
