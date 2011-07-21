//
//  DWNotificationsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWNotificationsController.h"

/**
 * Datasource for the notifications view controller
 */
@interface DWNotificationsDataSource : DWTableViewDataSource<DWNotificationsControllerDelegate> {
    DWNotificationsController   *_notificationsController;
    
    NSTimeInterval              _oldestTimestamp;

}

/**
 * Interface to the notifications service
 */
@property (nonatomic,retain) DWNotificationsController *notificationsController;


/**
 * Start fetching notifications from the server
 */
- (void)loadNotifications;

@end
