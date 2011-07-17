//
//  DWTeamViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewDataSource.h"
#import "DWTeamsHelper.h"
#import "DWResource.h"
#import "DWMessage.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewDataSource

@synthesize teamsController     = _teamsController;
@synthesize usersController     = _usersController;
@synthesize teamID              = _teamID;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];
        self.teamsController.delegate   = self;
        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.teamsController    = nil;
    self.usersController    = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
    [self clean];
    self.objects = [NSMutableArray array];
    
    [self.teamsController getTeamWithID:self.teamID];
    [self.usersController getLastFollowerOfTeam:self.teamID];
    [self.usersController getLastMemberOfTeam:self.teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadData];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)teamResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam *)team {
            
    [self.objects addObject:team];
    
    DWResource *resource    = [[[DWResource alloc] init] autorelease];
    resource.text           = [DWTeamsHelper totalMembersLineForTeam:team];
    [self.objects addObject:resource];
    
    resource                = [[[DWResource alloc] init] autorelease];
    resource.text           = [DWTeamsHelper totalWatchersLineForTeam:team];
    [self.objects addObject:resource];
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:team];
    [self.objects addObject:message];

    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString *)error {
    NSLog(@"Team load error - %@",error);
    [self.delegate displayError:error];        
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
    NSLog(@"team followers loaded %d",[users count]);
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSString *)error {
    NSLog(@"Team followers load error - %@",error);
    [self.delegate displayError:error];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSMutableArray *)users {
    NSLog(@"team member loaded %d",[users count]);
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team memb ers load error - %@",error);
    [self.delegate displayError:error];
}

@end
