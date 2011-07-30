//
//  DWPushNotificationsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPushNotificationsManager.h"
#import "DWRequestsManager.h"
#import "DWNotification.h"
#import "DWSession.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"

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

/**
 * Broadcast's the _unreadNotificationsCount as the new badge number
 */
- (void)broadcastNewBadgeNumber;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPushNotificationsManager

@synthesize backgroundNotificationInfo      = _backgroundNotificationInfo;
@synthesize usersController                 = _usersController;
@synthesize unreadNotificationsCount        = _unreadNotificationsCount;
@synthesize showNotifications               = _showNotifications;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWPushNotificationsManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.usersController                    = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate           = self;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.backgroundNotificationInfo     = nil;
    self.usersController                = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)handleLiveNotificationWithInfo:(NSDictionary*)info {
    
	NSDictionary *aps		= (NSDictionary*)[info objectForKey:kKeyAPS];
	NSDictionary *alert     = [aps objectForKey:kKeyAlert];
    NSString *badge         = [aps objectForKey:kKeyBadge];


    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {

        if(alert) {
            
            NSString *message = [alert objectForKey:kKeyBody];
            
            if(message && [message length]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                                                    message:message
                                                                   delegate:self 
                                                          cancelButtonTitle:kCancelTitle
                                                          otherButtonTitles:kActionTitle,nil];
                [alertView show];
                [alertView release];
            }
        }
        
        if(badge) {
            _unreadNotificationsCount = [badge integerValue];
            [UIApplication sharedApplication].applicationIconBadgeNumber = _unreadNotificationsCount;
        }
        
	}
    else {
        _unreadNotificationsCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
        
        [self displayNotifications];
    }
    
    
    [self broadcastNewBadgeNumber];
}

//----------------------------------------------------------------------------------------------------
- (void)handleBackgroundNotification {
    
    _unreadNotificationsCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    [self broadcastNewBadgeNumber];
    
    
    if(self.backgroundNotificationInfo) {
        [self displayNotifications];
        self.backgroundNotificationInfo = nil;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)setDeviceToken:(NSData*)deviceToken 
             forUserID:(NSInteger)userID {
    
    [self.usersController updateUserHavingID:userID 
                          withiPhoneDeviceID:[NSString stringWithFormat:@"%@",deviceToken]];
}

//----------------------------------------------------------------------------------------------------
- (void)resetNotifications {
    
    _showNotifications          = NO;
    _unreadNotificationsCount   = 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self broadcastNewBadgeNumber];
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID
                      withNotificationsCount:0];
}

//----------------------------------------------------------------------------------------------------
- (void)displayNotifications {
    
    _showNotifications = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNRequestTabBarIndexChange
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:kTabBarFeedIndex],kKeyTabIndex,
                                                                [NSNumber numberWithInteger:kResetNone],kKeyResetType,
                                                                nil]];
}

//----------------------------------------------------------------------------------------------------
- (void)broadcastNewBadgeNumber {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNNewApplicationBadge
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInteger:_unreadNotificationsCount],kKeyBadge,
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {
}

@end
