//
//  DWUserViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewDataSource.h"
#import "DWUser.h"
#import "DWResource.h"
#import "DWMessage.h"
#import "DWUsersHelper.h"
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

/**
 * Adds an object with the date of joining displayed
 */
- (void)addJoiningMessage:(DWUser*)user;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewDataSource

@synthesize usersController = _usersController;
@synthesize userID          = _userID;

@dynamic delegate;

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
- (void)addImageResource:(DWUser*)user {
    
    DWResource *resource            = [[[DWResource alloc] init] autorelease];
    resource.text                   = user.byline;
    resource.image                  = user.largeImage;
    resource.imageResourceType      = kResourceTypeLargeUserImage;
    resource.imageResourceID        = user.databaseID;
    
    [self.objects addObject:resource];
}

//----------------------------------------------------------------------------------------------------
- (void)addCurrentTeamMessage:(DWUser*)user {
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.interactive = YES;
    message.content     = [DWUsersHelper currentTeamLine:user];
    
    [self.objects addObject:message];
}

//----------------------------------------------------------------------------------------------------
- (void)addWatchingTeamsMessage:(DWUser*)user {
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.interactive = YES;
    message.content     = [DWUsersHelper watchingTeamsLine:user];
    
    [self.objects addObject:message];
}

//----------------------------------------------------------------------------------------------------
- (void)addJoiningMessage:(DWUser*)user {
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWUsersHelper createdAtLine:user];
    
    [self.objects addObject:message];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self.usersController getUserWithID:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUser];
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
    [self addJoiningMessage:user];
      
    [self.delegate userLoaded:user];
    [self.delegate reloadTableView];
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString*)error {
    NSLog(@"User load error - %@",error);
    [self.delegate displayError:error];
}

@end


