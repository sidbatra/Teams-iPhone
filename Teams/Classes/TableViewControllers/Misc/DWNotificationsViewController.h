//
//  DWNotificationsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWNotificationsDataSource;
@protocol DWNotificationsViewControllerDelegate;

/**
 * Display notifications for the current user
 */
@interface DWNotificationsViewController : DWTableViewController {
    DWNotificationsDataSource   *_notificationsDataSource;
    
    id<DWNotificationsViewControllerDelegate>   _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWNotificationsDataSource *notificationsDataSource;

/**
 * Delegates receives events based on the DWNotificationsViewControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWNotificationsViewControllerDelegate> delegate;


/**
 * Silently reload notifications
 */ 
- (void)softRefresh;

@end


/**
 * Protocol for delegates of DWNotificationViewController instances
 */
@protocol DWNotificationsViewControllerDelegate

/**
 * Fired when a user view is to be displayed
 */
- (void)notificationsUserSelected:(NSInteger)userID;

/**
 * Fired when an item view is to be displayed
 */
- (void)notificationsItemSelected:(NSInteger)itemID;

@end
