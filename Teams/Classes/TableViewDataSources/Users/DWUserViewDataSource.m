//
//  DWUserViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewDataSource.h"
#import "DWUser.h"
#import "DWResource.h"
#import "DWProfileImage.h"
#import "DWUsersHelper.h"
#import "DWAnalyticsManager.h"
#import "DWMessage.h"
#import "DWConstants.h"

static NSString* const kImgUsersTeam		= @"slice_button_user_white.png";



/**
 * Private method and property declarations
 */
@interface DWUserViewDataSource()

/**
 * Add a profile image object to display the user's image
 */
- (void)addProfileImage:(DWUser*)user;

/**
 * Adds a resource object to display the user's team
 */
- (void)addCurrentTeamResource:(DWUser*)user;

/**
 * Adds a resource object to display the number of teams
 * the user is following
 */
- (void)addFollowingTeamsResource:(DWUser*)user;


@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewDataSource

@synthesize usersController     = _usersController;
@synthesize teamsController     = _teamsController;
@synthesize teamResource        = _teamResource;
@synthesize followingResource   = _followingResource;
@synthesize profileImage        = _profileImage;
@synthesize userID              = _userID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
        
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];
        self.teamsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.usersController    = nil;
    self.teamsController    = nil;
    self.teamResource       = nil;
    self.followingResource  = nil;
    self.profileImage       = nil;
    
    DWUser *user = [DWUser fetch:_userID];
    [user destroy];
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)addProfileImage:(DWUser*)user {
    
    self.profileImage                   = [[[DWProfileImage alloc] init] autorelease];
    self.profileImage.image             = user.largeImage;
    self.profileImage.imageID           = user.databaseID;
    
    [self.objects addObject:self.profileImage];
}

//----------------------------------------------------------------------------------------------------
- (void)addCurrentTeamResource:(DWUser*)user {
    
    self.teamResource                   = [[[DWResource alloc] init] autorelease];
    self.teamResource.text              = [DWUsersHelper currentTeamLine:user];
    self.teamResource.subText           = user.team.byline;
    self.teamResource.image             = [UIImage imageNamed:kImgUsersTeam];    
    
    [self.objects addObject:self.teamResource];
}

//----------------------------------------------------------------------------------------------------
- (void)addFollowingTeamsResource:(DWUser*)user {
    
    if (user.followingCount < 2)
        return;
        
    
    self.followingResource              = [[[DWResource alloc] init] autorelease];
    self.followingResource.text         = [DWUsersHelper watchingTeamsLine:user];
    self.followingResource.subText      = @"across the network";
    self.followingResource.statText     = [NSString stringWithFormat:@"%d",user.followingCount-1];
    
    [self.objects addObject:self.followingResource];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self.usersController getUserWithID:self.userID];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:self.userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return self.userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
    
    [self clean];
    self.objects = [NSMutableArray array];
    
    [user startLargeImageDownload];
    
    [self addProfileImage:user];
    [self addCurrentTeamResource:user];
    [self addFollowingTeamsResource:user];
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWUsersHelper createdAtLine:[DWUser fetch:self.userID]];
    [self.objects addObject:message];
      
    [self.delegate userLoaded:user];
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString*)error {
    NSLog(@"User load error - %@",error);
    [self.delegate displayError:error];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    
    if(user.databaseID == _userID) {
        
        [user startLargeImageDownload];
        
        self.profileImage.image = user.largeImage;
        
        [self.delegate userLoaded:user];
        [self.delegate reloadTableView];
    }
    
    [user destroy];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam*)team {
    
    DWUser *user = [DWUser fetch:_userID];
    
    if(user.team.databaseID == team.databaseID) {
        
        [user startLargeImageDownload];
        
        self.profileImage.image     = user.largeImage;
        
        self.teamResource.text      = [DWUsersHelper currentTeamLine:user];
        self.teamResource.subText   = user.team.byline;
        
        [self.delegate userLoaded:user];
        [self.delegate reloadTableView];
    }
    
    [team destroy];
}

@end
