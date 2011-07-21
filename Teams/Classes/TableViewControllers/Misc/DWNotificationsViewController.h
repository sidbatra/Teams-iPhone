//
//  DWNotificationsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWNotificationsDataSource;

/**
 * Display notifications for the current user
 */
@interface DWNotificationsViewController : DWTableViewController {
    DWNotificationsDataSource   *_notificationsDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWNotificationsDataSource *notificationsDataSource;

@end
