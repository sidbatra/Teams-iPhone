//
//  DWTeamMembersDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamMembersDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamMembersDataSource

@synthesize teamID  = _teamID;

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
    [self.usersController getMembersOfTeam:self.teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSMutableArray *)users {
    [self populateUsers:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members error - %@",error);
    [self.delegate displayError:error];    
}


@end
