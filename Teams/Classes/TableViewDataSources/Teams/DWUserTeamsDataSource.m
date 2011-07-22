//
//  DWUserTeamsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserTeamsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserTeamsDataSource

@synthesize userID  = _userID;

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
    [self.teamsController getTeamsFollowedBy:self.userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)teamResourceID {
    return self.userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userTeamsLoaded:(NSMutableArray *)teams {
    [self populateTeams:teams];
}

//----------------------------------------------------------------------------------------------------
- (void)userTeamsError:(NSString *)message {
    NSLog(@"User teams error - %@",message);
    [self.delegate displayError:message];    
}

@end
