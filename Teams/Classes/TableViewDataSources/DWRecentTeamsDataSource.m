//
//  DWRecentTeamsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRecentTeamsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRecentTeamsDataSource

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
    [self.teamsController getRecentTeams];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)recentTeamsLoaded:(NSMutableArray *)teams {
    [self populateTeams:teams];
}

//----------------------------------------------------------------------------------------------------
- (void)recentTeamsError:(NSString *)message {
    NSLog(@"Recent teams error - %@",message);
    [self.delegate displayError:message];    
}

@end
