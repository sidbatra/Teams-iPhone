//
//  DWNotificationsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsViewController.h"
#import "DWNotificationsDataSource.h"
#import "DWPushNotificationsManager.h"
#import "DWNotification.h"
#import "DWUser.h"
#import "DWItem.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"
#import "NSObject+Helpers.h"


static NSString* const kTitle               = @"Notifications";
static NSString* const kModelNamePrefix     = @"DW";
static NSString* const kImgClose            = @"button_close_left.png";
static NSString* const kNewItemName         = @"DWNewItem";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsViewController

@synthesize notificationsDataSource = _notificationsDataSource;
@synthesize delegate                = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.notificationsDataSource    = [[DWNotificationsDataSource alloc] init];

        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageLoaded:) 
													 name:kNImgSmallNotificationLoaded
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.notificationsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];

    self.navigationItem.hidesBackButton     = YES;
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:kTitle];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarButtonWithImageName:kImgClose
                                                                               target:self
                                                                          andSelector:@selector(didTapDoneButton:)];

    [self.notificationsDataSource loadNotifications];
    
    [[DWPushNotificationsManager sharedDWPushNotificationsManager] resetNotifications];
}

//----------------------------------------------------------------------------------------------------
- (void)softRefresh {
    [self.notificationsDataSource refreshInitiated];
    
    [[DWPushNotificationsManager sharedDWPushNotificationsManager] resetNotifications];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationPresenterDelegate - (implmented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)notificationClicked:(DWNotification*)notification {
    
    NSString *clientClassName = [NSString stringWithFormat:@"%@%@",kModelNamePrefix,notification.resourceType];

    if([clientClassName isEqualToString:[DWUser className]]) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"user_selected"
                                                                   andExtraInfo:[NSString stringWithFormat:@"notification_id=%d&user_id=%d",
                                                                                 notification.databaseID,
                                                                                 notification.resourceID]];
        
        [self.delegate notificationsUserSelected:notification.resourceID];
    }
    else if([clientClassName isEqualToString:[DWItem className]]) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"item_selected"
                                                                   andExtraInfo:[NSString stringWithFormat:@"notification_id=%d&item_id=%d",
                                                                                 notification.databaseID,
                                                                                 notification.resourceID]];
        
        [self.delegate notificationsItemSelected:notification.resourceID];
    }
    else if([clientClassName isEqualToString:[DWTeam className]]) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"team_selected"
                                                                   andExtraInfo:[NSString stringWithFormat:@"notification_id=%d&team_id=%d",
                                                                                 notification.databaseID,
                                                                                 notification.resourceID]];
        
        [self.delegate notificationsTeamSelected:notification.resourceID];
    }
    else if([clientClassName isEqualToString:kNewItemName])  {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"create_item_selected"
                                                                   andExtraInfo:[NSString stringWithFormat:@"notification_id=%d&message=%@",
                                                                                 notification.databaseID,
                                                                                 notification.eventData]];
        
        [self.delegate notificationsCreateSelectedWithText:notification.details];
    }
    
    if(notification.unread) {
        notification.unread = NO;
        [[DWPushNotificationsManager sharedDWPushNotificationsManager] updateNotificationWithID:notification.databaseID];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITouchEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(UIButton*)button {  
    [self.navigationController popViewControllerAnimated:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)imageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self provideResourceToVisibleCells:kResourceTypeSmallNotificationImage
                               resource:resource
                             resourceID:resourceID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    //Ensure nav bar is always displayed
    if(self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO 
                                                 animated:YES];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
