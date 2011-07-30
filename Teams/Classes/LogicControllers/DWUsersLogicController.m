//
//  DWUsersLogicController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersLogicController.h"
#import "DWTableViewController.h"
#import "DWConstants.h"
#import "DWUser.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersLogicController

@synthesize tableViewController     = _tableViewController;
@synthesize navigationEnabled       = _navigationEnabled;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        _navigationEnabled  = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userSmallImageLoaded:) 
													 name:kNImgSmallUserLoaded
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
#pragma mark DWUserPresenterDelegate (implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)userSelected:(DWUser*)user {
    
    if(!self.navigationEnabled)
        return;
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tableViewController
                                                             withActionName:@"user_selected"
                                                               andExtraInfo:[NSString stringWithFormat:@"user_id=%d",
                                                                             user.databaseID]];
    
    
    [self.delegate usersLogicUserSelected:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userSmallImageLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self.tableViewController provideResourceToVisibleCells:kResourceTypeSmallUserImage
                                                   resource:resource
                                                 resourceID:resourceID];
}


@end
