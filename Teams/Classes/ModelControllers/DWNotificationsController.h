//
//  DWNotificationsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWNotificationsControllerDelegate;

/**
 * Interface to the notifications service on the app server
 */
@interface DWNotificationsController : NSObject {
    
    id<DWNotificationsControllerDelegate,NSObject>   _delegate;
}

/**
 * Delegate receives events based on the DWNotificationsControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWNotificationsControllerDelegate,NSObject> delegate;


/**
 * Get notifications for the current user. Use before for pagination.
 */
- (void)getNotificationsForCurrentUserBefore:(NSInteger)before;

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

@end
