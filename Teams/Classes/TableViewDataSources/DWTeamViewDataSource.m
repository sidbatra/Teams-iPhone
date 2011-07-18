//
//  DWTeamViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewDataSource.h"
#import "DWTeamsHelper.h"
#import "DWResource.h"
#import "DWMessage.h"
#import "DWUser.h"
#import "DWConstants.h"



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
    
    _members                = [[[DWResource alloc] init] autorelease];
    _members.text           = [DWTeamsHelper totalMembersLineForTeam:team];
    [self.objects addObject:_members];
    
    _followers              = [[[DWResource alloc] init] autorelease];
    _followers.text         = [DWTeamsHelper totalWatchersLineForTeam:team];
    [self.objects addObject:_followers];
    
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
    DWUser *user = [users objectAtIndex:0];
    
    _followers.imageResourceType    = kResourceTypeSmallUserImage;
    _followers.imageResourceID      = user.databaseID;
    
    [user startSmallImageDownload];
    
    if(user.smallImage) {
        _followers.image = user.smallImage;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSString *)error {
    NSLog(@"Team followers load error - %@",error);
    [self.delegate displayError:error];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSMutableArray *)users {
    DWUser *user = [users objectAtIndex:0];
    
    _members.imageResourceType    = kResourceTypeSmallUserImage;
    _members.imageResourceID      = user.databaseID;
    
    [user startSmallImageDownload];
    
    if(user.smallImage) {
        _members.image = user.smallImage;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members load error - %@",error);
    [self.delegate displayError:error];
}

@end
