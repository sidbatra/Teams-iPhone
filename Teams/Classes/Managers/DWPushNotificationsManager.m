//
//  DWPushNotificationsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPushNotificationsManager.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"


static NSString* const kKeyAPS                  = @"aps";
static NSString* const kKeyBadge                = @"badge";
static NSString* const kKeyAlert                = @"alert";
static NSString* const kAlertTitle              = @"Denwen";
static NSString* const kCancelTitle             = @"OK";
static NSString* const kActionTitle             = @"View";
static NSInteger const kActionButtonIndex       = 1;
static NSInteger const kNotificationTypeTouch   = 1;
static NSInteger const kNotificationTypeItem    = 2;


/**
 * Private method and property declarations
 */
@interface DWPushNotificationsManager()

/**
 * Start chain of events to display the notifications to the user
 */
- (void)displayNotifications;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPushNotificationsManager

@synthesize backgroundNotificationInfo      = _backgroundNotificationInfo;
@synthesize hasUnreadNotifications          = _hasUnreadNotifications;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWPushNotificationsManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.backgroundNotificationInfo   = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)handleLiveNotificationWithInfo:(NSDictionary*)info {
	
	NSDictionary *aps		= (NSDictionary*)[info objectForKey:kKeyAPS];
	NSDictionary *alert     = [aps objectForKey:kKeyAlert];
    //NSDictionary *badge     = [aps objectForKey:kKeyBadge];
    
    
	if(alert) {

        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                                                 message:[alert objectForKey:kKeyBody] 
                                                                delegate:self 
                                                       cancelButtonTitle:kCancelTitle
                                                       otherButtonTitles:kActionTitle,nil];
             [alertView show];
             [alertView release];
        }
        else
            [self displayNotifications];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)handleBackgroundNotification {
    
    if(self.backgroundNotificationInfo) {
        [self displayNotifications];
        self.backgroundNotificationInfo = nil;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)resetUnreadCount {
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	//if(self.unreadItems)
	//	[[DWRequestsManager sharedDWRequestsManager] updateUnreadCountForCurrentUserBy:self.unreadItems];	
}

//----------------------------------------------------------------------------------------------------
- (void)displayNotifications {
    
    _hasUnreadNotifications    = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kTabBarFeedIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:kResetNone],kKeyResetType,
                                                                nil]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate
//----------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	    
	if (buttonIndex == kActionButtonIndex)
        [self displayNotifications];
}

@end
