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
@property (nonatomic) DWUsersController *usersController;

/**
 * TeamID for the team being displayed
 */
@property (nonatomic,assign) NSInteger teamID;


/**
 * Initiate the process to load data for the table view
 */
- (void)loadData;

@end
