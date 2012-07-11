//
//  DWTeamItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWTeamsController.h"
#import "DWFollowingsController.h"

@class DWTeam;
@class DWFollowing;
@protocol DWTeamItemsDataSourceDelegate;

/**
 * Data source for the team items view controller
 */
@interface DWTeamItemsDataSource : DWItemsDataSource<DWTeamsControllerDelegate,DWFollowingsControllerDelegate> {
    DWTeamsController       *_teamsController;
    DWFollowingsController  *_followingsController;
    
    DWTeam                  *_team;
    DWFollowing             *_following;
    
    NSInteger               _teamID;
    BOOL                    _followingLoaded;
}

/**
 * Interface to the teams service
 */
@property (nonatomic) DWTeamsController  *teamsController;

/**
 * Interface to the follow service
 */
@property (nonatomic) DWFollowingsController *followingsController;

/**
 * Team whose items are being displayed
 */
@property (nonatomic) DWTeam *team;

/**
 * Following between the current user and the team
 */
@property (nonatomic) DWFollowing *following;

/**
 * teamID for the team whose items are being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

/**
 * Redefined delegate object
 */
@property (nonatomic,unsafe_unretained) id<DWTeamItemsDataSourceDelegate,NSObject> delegate;


/**
 * Fetch the team from the server
 */
- (void)loadTeam;

/**
 * Fetch the following between the team and the current user
 */
- (void)loadFollowing;

/**
 * Invert the current following state - follow if not following and vice versa
 */
- (void)invertFollowingState;

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
