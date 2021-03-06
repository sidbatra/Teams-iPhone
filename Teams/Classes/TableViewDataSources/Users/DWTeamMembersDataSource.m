//
//  DWTeamMembersDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamMembersDataSource.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamMembersDataSource

@synthesize teamID  = _teamID;

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
    [self.usersController getMembersOfTeam:self.teamID];
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
- (void)teamMembersLoaded:(NSMutableArray *)users {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:self.teamID];
    
    [self populateUsers:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members error - %@",error);
    [self.delegate displayError:error];    
}


@end
