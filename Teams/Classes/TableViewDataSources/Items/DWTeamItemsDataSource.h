//
//  DWTeamItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWTeamsController.h"

@class DWTeam;
@class DWFollowing;
@protocol DWTeamItemsDataSourceDelegate;

/**
 * Data source for the team items view controller
 */
@interface DWTeamItemsDataSource : DWItemsDataSource<DWTeamsControllerDelegate> {
    DWTeamsController   *_teamsController;
    NSInteger           _teamID;
}

/**
 * Interface to the teams service
 */
@property (nonatomic,retain) DWTeamsController  *teamsController;

/**
 * teamID for the team whose items are being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

/**
 * Redefined delegate object
 */
@property (nonatomic,assign) id<DWTeamItemsDataSourceDelegate,NSObject> delegate;


/**
 * Fetch the team from the server
 */
- (void)loadTeam;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWTeamItemsDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Provide the fetched user object to the table view to update the UI
 */
- (void)teamLoaded:(DWTeam*)team 
     withFollowing:(DWFollowing*)following;
@end
