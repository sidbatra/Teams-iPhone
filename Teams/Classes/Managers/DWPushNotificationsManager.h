//
//  DWPushNotificationsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Handle the notifications flow of the app
 */
@interface DWPushNotificationsManager : NSObject {
    NSDictionary    *_backgroundNotificationInfo;
    
    BOOL            _hasUnreadNotifications;
}

/**
 * The sole shared instance of the class
 */
+ (DWPushNotificationsManager *)sharedDWPushNotificationsManager;

/**
 * Dictionary with the remote notification info obtained while the
 * app was closed
 */
@property (nonatomic,retain) NSDictionary *backgroundNotificationInfo;

/**
 * Flag for unread notifications
 */
@property (nonatomic,readonly) BOOL hasUnreadNotifications;


/**
 * Handle push notifications while the app is open
 */
- (void)handleLiveNotificationWithInfo:(NSDictionary*)info;

/**
 * Handle push notifications received while the app wass in the background
 */
- (void)handleBackgroundNotification;

@end

