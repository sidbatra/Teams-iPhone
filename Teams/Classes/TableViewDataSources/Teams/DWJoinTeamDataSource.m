//
//  DWJoinTeamDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWJoinTeamDataSource.h"
#import "DWTeam.h"
#import "DWMessage.h"
#import "DWTeamsHelper.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWJoinTeamDataSource

@synthesize usersController     = _usersController;

@synthesize teamID              = _teamID;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.usersController    = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
    [self.usersController getMembersOfTeam:self.teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return _teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSMutableArray*)users {

    [self.objects addObject:[DWTeam fetch:self.teamID]];  
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,[users count])];
    [self.objects insertObjects:users atIndexes:indexSet];          
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:[DWTeam fetch:_teamID]];
    [self.objects addObject:message];

    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString*)error {
    NSLog(@"Team Members error - %@",error);
    [self.delegate displayError:error];    
}


@end
