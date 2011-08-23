//
//  DWTeamViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWTeamsController.h"
#import "DWUsersController.h"

@class DWResource;
@protocol DWTeamViewDataSourceDelegate;

/**
 * Datasource for the team view data source
 */
@interface DWTeamViewDataSource : DWTableViewDataSource<DWTeamsControllerDelegate,DWUsersControllerDelegate> {
    
    DWTeamsController   *_teamsController;
    DWUsersController   *_usersController;
    
    DWResource          *_invite;
    DWResource          *_share;
    
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
 * Resource object representing the invite people cell
 */
@property (nonatomic,retain) DWResource *invite;

/**
 * Resource object representing the share team cell
 */
@property (nonatomic,retain) DWResource *share;

/**
 * TeamID for the team being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

/**
 * Redefined delegate object
 */
@property (nonatomic,assign) id<DWTeamViewDataSourceDelegate,NSObject> delegate;


/**
 * Initiate the process to load data for the table view
 */
- (void)loadData;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWTeamViewDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Fired when the current team has been updated
 */
- (void)teamUpdated;

/**
 * Fired when the team members are loaded
 */
- (void)teamMembersLoaded;

@end
