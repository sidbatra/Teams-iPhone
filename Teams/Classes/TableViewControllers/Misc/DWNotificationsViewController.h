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
    
    id<DWNotificationsViewControllerDelegate>   __unsafe_unretained _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic) DWNotificationsDataSource *notificationsDataSource;

/**
 * Delegates receives events based on the DWNotificationsViewControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWNotificationsViewControllerDelegate> delegate;


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

/**
 * Fired when a team view is to be displayed
 */
- (void)notificationsTeamSelected:(NSInteger)teamID;

/**
 * Fired when a request to display create view is fired
 */
- (void)notificationsCreateSelectedWithText:(NSString*)text;

@end
