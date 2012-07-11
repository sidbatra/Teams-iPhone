//
//  DWPushNotificationsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersController.h"
#import "DWNotificationsController.h"

/**
 * Handle the notifications flow of the app
 */
@interface DWPushNotificationsManager : NSObject<DWUsersControllerDelegate,DWNotificationsControllerDelegate> {
    
    NSDictionary                *_backgroundNotificationInfo;
    
    DWUsersController           *_usersController;
    DWNotificationsController   *_notificationsController;
    
    NSInteger                   _unreadNotificationsCount;
    BOOL                        _showNotifications;
}

/**
 * The sole shared instance of the class
 */
+ (DWPushNotificationsManager *)sharedDWPushNotificationsManager;

/**
 * Dictionary with the remote notification info obtained while the
 * app was closed
 */
@property (nonatomic) NSDictionary *backgroundNotificationInfo;

/**
 * Interface to the users service
 */
@property (nonatomic) DWUsersController *usersController;

/**
 * Interface to the notifications service
 */
@property (nonatomic) DWNotificationsController *notificationsController;

/**
 * Flag for unread notifications
 */
@property (nonatomic,readonly) NSInteger unreadNotificationsCount;

/**
 * Flag is set when the user has shown explicit intent to view notifications
 */
@property (nonatomic,readonly) BOOL showNotifications;


/**
 * Handle push notifications while the app is open
 */
- (void)handleLiveNotificationWithInfo:(NSDictionary*)info;

/**
 * Handle push notifications received while the app wass in the background
 */
- (void)handleBackgroundNotification;

/**
 * Apply the given iphone device token for the given userID
 */
- (void)setDeviceToken:(NSData*)deviceToken 
             forUserID:(NSInteger)userID;

/**
 * Reset all states after notifications are viewed 
 */
- (void)resetNotifications;

/**
 * Mark the given notification as read
 */
- (void)updateNotificationWithID:(NSInteger)notificationID;

@end

