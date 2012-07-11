//
//  DWItemsLogicController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsLogicController.h"
#import "DWTableViewController.h"
#import "DWTouchesController.h"
#import "DWItem.h"
#import "DWTeam.h"
#import "DWUser.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsLogicController

@synthesize touchesController       = _touchesController;
@synthesize usersController         = _usersController;
@synthesize teamsController         = _teamsController;
@synthesize tableViewController     = _tableViewController;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.touchesController          = [[DWTouchesController alloc] init];
        
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
        
        self.teamsController            = [[DWTeamsController alloc] init];
        self.teamsController.delegate   = self;
        
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
        
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)largeAttachmentLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
        
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeLargeAttachmentImage
                                                   resource:resource
                                                 resourceID:resourceID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemFeedCellDelegate (Implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (BOOL)shouldTouchItemWithID:(NSInteger)itemID {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"touch"
                                                               andExtraInfo:[NSString stringWithFormat:@"item_id=%d",itemID]];
    
    DWItem *item = [DWItem fetch:itemID];
    return !item.isTouched && ![item.user isCurrentUser];
}

//----------------------------------------------------------------------------------------------------
- (void)cellTouched:(NSInteger)itemID {
    
    DWItem *item    = [DWItem fetch:itemID];
    [item touched];
    
    [self.touchesController postWithItemID:item.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)getVideoAttachmentURLForItemID:(NSInteger)itemID {
	DWItem *item = [DWItem fetch:itemID];
    return item.attachment.actualURL;
}

//----------------------------------------------------------------------------------------------------
- (void)teamSelectedForItemID:(NSInteger)itemID {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"team_selected"
                                                               andExtraInfo:[NSString stringWithFormat:@"item_id=%d",itemID]];
    
    
    SEL sel = @selector(itemsLogicTeamSelected:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
        
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item.team];
}

//----------------------------------------------------------------------------------------------------
- (void)userSelectedForItemID:(NSInteger)itemID {
	
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"user_selected"
                                                               andExtraInfo:[NSString stringWithFormat:@"item_id=%d",itemID]];
    
    
    SEL sel = @selector(itemsLogicUserSelected:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item.user];
}

/*
//----------------------------------------------------------------------------------------------------
- (void)shareSelectedForItemID:(NSInteger)itemID {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"share_selected"
                                                               andExtraInfo:[NSString stringWithFormat:@"item_id=%d",itemID]];
    
    
    SEL sel = @selector(itemsLogicShareSelectedForItem:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item];
}*/


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersController

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeUser
                                                   resource:user
                                                 resourceID:user.databaseID];
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam *)team {
    
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeTeam
                                                   resource:team
                                                 resourceID:team.databaseID];
    
    [team destroy];
}



@end

