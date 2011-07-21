//
//  DWTeamItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsDataSource.h"
#import "DWSession.h"

/**
 * Private method and property declarations
 */
@interface DWTeamItemsDataSource()

/**
 * Fire delegate if both team and following have been loaded. 
 */
- (void)fireTeamAndFollowingDelegate;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsDataSource

@synthesize teamsController         = _teamsController;
@synthesize followingsController    = _followingsController;
@synthesize team                    = _team;
@synthesize following               = _following;
@synthesize teamID                  = _teamID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamsController                = [[[DWTeamsController alloc] init] autorelease];
        self.teamsController.delegate       = self;
        
        self.followingsController           = [[[DWFollowingsController alloc] init] autorelease];
        self.followingsController.delegate  = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    [self.following destroy];
    [self.team destroy];
    
    self.teamsController        = nil;
    self.followingsController   = nil;
    self.team                   = nil;
    self.following              = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getTeamItemsForTeamID:self.teamID
                                         before:_oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowing {
    
    [self.following destroy];
    self.following      = nil;
    
    _followingLoaded    = NO;
    
    [self.followingsController getFollowingForTeamID:self.teamID
                                           andUserID:[DWSession sharedDWSession].currentUser.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)loadTeam {
    
    [self.team destroy];
    self.team = nil;
    
    [self.teamsController getTeamWithID:self.teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [super refreshInitiated];
    
    [self loadTeam];
    [self loadFollowing];
}

//----------------------------------------------------------------------------------------------------
- (void)fireTeamAndFollowingDelegate {
    
    if(!self.team || !_followingLoaded)
        return;
    
    [self.delegate teamLoaded:self.team
                withFollowing:self.following];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsLoaded:(NSMutableArray *)items {  
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsError:(NSString *)message {
    NSLog(@"Team items error - %@",message);
    [self.delegate displayError:message];
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
    self.team = team;
    
    [self fireTeamAndFollowingDelegate];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString *)error {
    NSLog(@"Team load error - %@",error);
    [self.delegate displayError:error];        
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFollowingsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)followingResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoaded:(DWFollowing*)following {
    self.following      = following;
    _followingLoaded    = YES;
    
    [self fireTeamAndFollowingDelegate];
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoadError:(NSString *)error {
    NSLog(@"Following load error - %@",error);
    [self.delegate displayError:error];    
}

@end
