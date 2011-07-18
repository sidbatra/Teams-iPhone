//
//  DWTeamViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWTeamsController.h"
#import "DWUsersController.h"

@class DWResource;

/**
 * Datasource for the team view data source
 */
@interface DWTeamViewDataSource : DWTableViewDataSource<DWTeamsControllerDelegate,DWUsersControllerDelegate> {
    
    DWTeamsController   *_teamsController;
    DWUsersController   *_usersController;
    
    DWResource          *_followers;
    DWResource          *_members;
    
    NSInteger           _teamID;
}

/**
 * Interface to the teams service
 */
@property (nonatomic,retain) DWTeamsController *teamsController;

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * TeamID for the team being displayed
 */
@property (nonatomic,assign) NSInteger teamID;


/**
 * Initiate the process to load data for the table view
 */
- (void)loadData;

@end
