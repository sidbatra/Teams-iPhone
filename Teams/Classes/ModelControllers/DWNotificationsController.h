//
//  DWNotificationsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWNotification;
@protocol DWNotificationsControllerDelegate;

/**
 * Interface to the notifications service on the app server
 */
@interface DWNotificationsController : NSObject {
    
    id<DWNotificationsControllerDelegate,NSObject>   __unsafe_unretained _delegate;
}

/**
 * Delegate receives events based on the DWNotificationsControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWNotificationsControllerDelegate,NSObject> delegate;


/**
 * Get notifications for the current user. Use before for pagination.
 */
- (void)getNotificationsForCurrentUserBefore:(NSInteger)before;

/**
 * Mark the notification with the given ID as read.
 */
- (void)markNotificationAsRead:(NSInteger)notificationID;

@end


/**
 * Protocol for delegates of DWNotificationsController instances
 */
@protocol DWNotificationsControllerDelegate

@optional

/**
 * Fired when notifications have been loaded
 */
- (void)notificationsLoaded:(NSMutableArray*)notifications;

/**
 * Fired when there is an error loading notifications
 */
- (void)notificationsError:(NSString*)error;

/**
 * Fired when the notification is read
 */
- (void)notificationRead:(DWNotification*)notification;

/**
 * Fired when there is an error in reading a notification
 */
- (void)notificationReadError:(NSString*)error 
            forNotificationID:(NSNumber*)notificationID;

@end
