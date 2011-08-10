//
//  DWUserViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewDataSource.h"
#import "DWUser.h"
#import "DWResource.h"
#import "DWMessage.h"
#import "DWUsersHelper.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

/**
 * Private method and property declarations
 */
@interface DWUserViewDataSource()

/**
 * Add a resource object to display the user image
 */
- (void)addImageResource:(DWUser*)user;

/**
 * Adds an object with a line about the user's current team
 */
- (void)addCurrentTeamMessage:(DWUser*)user;

/**
 * Adds an object with a line about the teams the user is watching
 */
- (void)addWatchingTeamsMessage:(DWUser*)user;


@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewDataSource

@synthesize usersController     = _usersController;
@synthesize teamsController     = _teamsController;
@synthesize teamMessage         = _teamMessage;
@synthesize watchingMessage     = _watchingMessage;
@synthesize imageResource       = _imageResource;
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
    self.teamMessage        = nil;
    self.watchingMessage    = nil;
    self.imageResource      = nil;
    
    DWUser *user = [DWUser fetch:_userID];
    [user destroy];
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)addImageResource:(DWUser*)user {
    
    self.imageResource                        = [[[DWResource alloc] init] autorelease];
    self.imageResource.text                   = user.byline;
    self.imageResource.image                  = user.largeImage;
    self.imageResource.imageResourceType      = kResourceTypeLargeUserImage;
    self.imageResource.imageResourceID        = user.databaseID;
    
    [self.objects addObject:self.imageResource];
}

//----------------------------------------------------------------------------------------------------
- (void)addCurrentTeamMessage:(DWUser*)user {
    
    self.teamMessage                = [[[DWMessage alloc] init] autorelease];
    self.teamMessage.interactive    = YES;
    self.teamMessage.content        = [DWUsersHelper currentTeamLine:user];
    
    [self.objects addObject:self.teamMessage];
}

//----------------------------------------------------------------------------------------------------
- (void)addWatchingTeamsMessage:(DWUser*)user {
    
    self.watchingMessage                = [[[DWMessage alloc] init] autorelease];
    self.watchingMessage.interactive    = YES;
    self.watchingMessage.content        = [DWUsersHelper watchingTeamsLine:user];
    
    [self.objects addObject:self.watchingMessage];
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
    
    [self addImageResource:user];
    [self addCurrentTeamMessage:user];
    [self addWatchingTeamsMessage:user];
      
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
        
        self.imageResource.text     = user.byline;
        self.imageResource.image    = user.largeImage;
        
        
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
        
        self.imageResource.text     = user.byline;
        self.imageResource.image    = user.largeImage;
        
        self.teamMessage.content  = [DWUsersHelper currentTeamLine:user];
        
        [self.delegate userLoaded:user];
        [self.delegate reloadTableView];
    }
    
    [team destroy];
}

@end


