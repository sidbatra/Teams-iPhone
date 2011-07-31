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
#import "DWAnalyticsManager.h"

static NSString* const kImgInvite		= @"button_invite.png";



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

/**
 * Add a members resource into self.objects based on the given team
 */
- (void)addMembersResourceUsingTeam:(DWTeam*)team;

/**
 * Add a followers resource into self.objects based on the given team
 */
- (void)addFollowersResourceUsingTeam:(DWTeam*)team;

/**
 * Add an invite resource into self.objects
 */
- (void)addInviteResource;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewDataSource

@synthesize teamsController     = _teamsController;
@synthesize usersController     = _usersController;
@synthesize followers           = _followers;
@synthesize members             = _members;
@synthesize invite              = _invite;
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
    self.invite             = nil;
    
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
- (void)addMembersResourceUsingTeam:(DWTeam*)team {
    
    if(!self.members)
        self.members                = [[[DWResource alloc] init] autorelease];
    
    self.members.text               = [DWTeamsHelper totalMembersLineForTeam:team];
    [self.objects addObject:self.members];
}

//----------------------------------------------------------------------------------------------------
- (void)addFollowersResourceUsingTeam:(DWTeam*)team {
    
    if(!self.followers)
        self.followers              = [[[DWResource alloc] init] autorelease];
    
    self.followers.text             = [DWTeamsHelper totalWatchersLineForTeam:team];
    [self.objects addObject:self.followers];
}

//----------------------------------------------------------------------------------------------------
- (void)addInviteResource {

    if(!self.invite)
        self.invite                 = [[[DWResource alloc] init] autorelease];
    
    self.invite.text                = @"Add People";
    self.invite.image               = [UIImage imageNamed:kImgInvite];
    
    [self.objects addObject:self.invite];
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
    
    
    [self addMembersResourceUsingTeam:team];
    [self addFollowersResourceUsingTeam:team];
    [self addInviteResource];
    
       
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:team];
    [self.objects addObject:message];
    
    
    [self.delegate reloadTableView];

    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:_teamID];

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
- (void)teamFollowersLoaded:(NSMutableArray*)users {
    DWUser *user = [users objectAtIndex:0];
    
    [self setupMemberResource:self.followers
                     withUser:user];
    
    [user destroy];
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
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members load error - %@",error);
    [self.delegate displayError:error];
}


@end
