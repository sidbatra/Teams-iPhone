//
//  DWJoinTeamDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"

@class DWTeam;


@interface DWJoinTeamDataSource : DWTableViewDataSource<DWUsersControllerDelegate> {
    DWUsersController   *_usersController;
    
    NSInteger           _teamID;
}

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/*
 * Add the team to the beginning of the objects array
 */
- (void)addTeam:(DWTeam*)team;

/*
 * Load the members for a team
 */
- (void)loadMembers;

@end
