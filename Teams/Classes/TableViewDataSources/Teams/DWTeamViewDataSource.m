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

static NSString* const kImgInvite		= @"slice_button_addpeople.png";
static NSString* const kImgShare		= @"slice_button_share.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@interface DWTeamViewDataSource()

/**
 * Add an invite resource into self.objects
 */
- (void)addInviteResource;

/**
 * Add an share resource into self.objects
 */
- (void)addShareResource;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewDataSource

@synthesize teamsController     = _teamsController;
@synthesize usersController     = _usersController;
@synthesize invite              = _invite;
@synthesize share               = _share;
@synthesize teamID              = _teamID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamsController            = [[DWTeamsController alloc] init];
        self.teamsController.delegate   = self;
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)addInviteResource {

    if(!self.invite)
        self.invite                 = [[DWResource alloc] init];
    
    self.invite.text                = @"Add People";
    self.invite.subText             = @"To this Team";
    self.invite.image               = [UIImage imageNamed:kImgInvite];
    
    [self.objects addObject:self.invite];
}

//----------------------------------------------------------------------------------------------------
- (void)addShareResource {
    
    if(!self.share)
        self.share                  = [[DWResource alloc] init];
    
    self.share.text                 = @"Share this Team";
    self.share.subText              = [DWTeamsHelper webURIForTeam:[DWTeam fetch:self.teamID]];
    self.share.image                = [UIImage imageNamed:kImgShare];
    
    [self.objects addObject:self.share];
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
- (void)teamUpdated:(DWTeam*)team {
    [self.delegate reloadTableView];
    [self.delegate teamUpdated];
    [team destroy];
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
- (void)teamMembersLoaded:(NSMutableArray *)users {
    
    [self clean];
    self.objects = [NSMutableArray array];
    
    [self.objects addObjectsFromArray:users];
    
    [self addInviteResource];
    [self addShareResource];
    
    /*
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:[DWTeam fetch:self.teamID]];
    [self.objects addObject:message];*/
    
    [self.delegate reloadTableView];
    [self.delegate teamMembersLoaded];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:_teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSString *)error {
    NSLog(@"Team members load error - %@",error);
    [self.delegate displayError:error];
}


@end
