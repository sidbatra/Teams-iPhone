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
@interface DWTeamViewDataSource()

/**
 * Sets up either members or followers resource with the corresponding
 * user object
 */
- (void)setupMemberResource:(DWResource*)resource 
                   withUser:(DWUser*)user;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewDataSource

@synthesize teamsController     = _teamsController;
@synthesize usersController     = _usersController;
@synthesize followers           = _followers;
@synthesize members             = _members;
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
    self.followers          = nil;
    self.members            = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setupMemberResource:(DWResource*)resource 
                   withUser:(DWUser*)user {
    
    resource.imageResourceType    = kResourceTypeSmallUserImage;
    resource.imageResourceID      = user.databaseID;
    
    [user startSmallImageDownload];
    
    if(user.smallImage) {
        resource.image = user.smallImage;
        [self.delegate reloadRowAtIndex:[self indexForObject:resource]];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
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
            
    [self clean];
    self.objects = [NSMutableArray array];
    
    [self.objects addObject:team];
    
    
    if(!self.members)
        self.members                = [[[DWResource alloc] init] autorelease];
    
    self.members.text               = [DWTeamsHelper totalMembersLineForTeam:team];
    [self.objects addObject:self.members];
    
    
    if(!self.followers)
        self.followers              = [[[DWResource alloc] init] autorelease];
    
    self.followers.text             = [DWTeamsHelper totalWatchersLineForTeam:team];
    [self.objects addObject:self.followers];
    
    
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
    
    [self setupMemberResource:self.followers
                     withUser:user];
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSString *)error {
    NSLog(@"Team followers load error - %@",error);
    [self.delegate displayError:error];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSMutableArray *)users {
    DWUser *user = [users objectAtIndex:0];
    
    [self setupMemberResource:self.members
                     withUser:user];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members load error - %@",error);
    [self.delegate displayError:error];
}


@end
