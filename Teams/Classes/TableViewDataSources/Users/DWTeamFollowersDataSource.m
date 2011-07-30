//
//  DWTeamFollowersDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamFollowersDataSource.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamFollowersDataSource

@synthesize teamID  = _teamID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self.usersController getFollowersOfTeam:self.teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersLoaded:(NSMutableArray *)users {
        
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:self.teamID];
    
    [self populateUsers:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSString *)error {
    NSLog(@"Team followers error - %@",error);
    [self.delegate displayError:error];    
}


@end
