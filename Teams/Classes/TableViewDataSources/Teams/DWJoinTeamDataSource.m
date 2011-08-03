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
- (void)addTeam:(DWTeam*)team {   
    _teamID = team.databaseID;     
    [self.objects addObject:team];
}

//----------------------------------------------------------------------------------------------------
- (void)loadMembers {
    [self.usersController getMembersOfTeam:_teamID];
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

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,[users count])];
    [self.objects insertObjects:users atIndexes:indexSet];          
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:[self.objects objectAtIndex:0]];
    [self.objects addObject:message];

    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString*)error {
    NSLog(@"Team Members error - %@",error);
    [self.delegate displayError:error];    
}


@end
