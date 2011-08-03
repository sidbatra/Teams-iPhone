//
//  DWTeamsLogicController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsLogicController.h"
#import "DWTableViewController.h"
#import "DWConstants.h"
#import "DWTeam.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsLogicController

@synthesize tableViewController     = _tableViewController;
@synthesize navigationEnabled       = _navigationEnabled;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        _navigationEnabled  = YES;
                
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sliceAttachmentLoaded:) 
													 name:kNImgSliceAttachmentFinalized
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(largeAttachmentLoaded:) 
													 name:kNImgLargeAttachmentLoaded
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tableViewController    = nil;
    self.delegate               = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamPresenterDelegate (implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)teamSelected:(DWTeam*)team {
    
    if(!self.navigationEnabled)
        return;
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"team_selected"
                                                               andExtraInfo:[NSString stringWithFormat:@"team_id=%d",
                                                                             team.databaseID]];
    
    [self.delegate teamsLogicTeamSelected:team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sliceAttachmentLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeSliceAttachmentImage
                                                   resource:resource
                                                 resourceID:resourceID];
}

//----------------------------------------------------------------------------------------------------
- (void)largeAttachmentLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeLargeAttachmentImage
                                                   resource:resource
                                                 resourceID:resourceID];
}

@end
