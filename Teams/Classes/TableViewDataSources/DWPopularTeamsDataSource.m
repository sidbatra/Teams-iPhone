//
//  DWPopularTeamsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPopularTeamsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPopularTeamsDataSource

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
    [self.teamsController getPopularTeams];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)popularTeamsLoaded:(NSMutableArray *)teams {
    [self populateTeams:teams];
}

//----------------------------------------------------------------------------------------------------
- (void)popularTeamsError:(NSString *)message {
    NSLog(@"Popular teams error - %@",message);
    [self.delegate displayError:message];    
}


@end
