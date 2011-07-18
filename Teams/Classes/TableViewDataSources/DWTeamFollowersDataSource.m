//
//  DWTeamFollowersDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamFollowersDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamFollowersDataSource

@synthesize teamID  = _teamID;

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
    [self.usersController getFollowersOfTeam:self.teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersLoaded:(NSMutableArray *)users {
    [self populateUsers:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSString *)error {
    NSLog(@"Team followers error - %@",error);
    [self.delegate displayError:error];    
}


@end
