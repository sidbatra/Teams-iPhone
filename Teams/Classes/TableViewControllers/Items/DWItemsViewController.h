//
//  DWItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWItemsDataSource.h"
#import "DWTouchesController.h"

@class DWTouchesController;
@class DWItem;
@class DWTeam;
@class DWUser;
@protocol DWItemsViewControllerDelegate;

/**
 * Base class for table views that display a list of items
 */
@interface DWItemsViewController : DWTableViewController<DWTouchesControllerDelegate> {
    DWTouchesController     *_touchesController;
    
    id<DWItemsViewControllerDelegate,NSObject> _delegate;
}

/**
 * Record the touches made on items by the current user
 */
@property (nonatomic,retain) DWTouchesController *touchesController;

/**
 * Delegate fires events about the ItemsViewController lifecycle
 */
@property (nonatomic,assign) id<DWItemsViewControllerDelegate,NSObject> delegate;

@end


/**
 * Delegate protocol to receive events about the ItemsViewController lifecycle
 */
@protocol DWItemsViewControllerDelegate

@optional

/**
 * Fired when a team is selected
 */
- (void)teamSelected:(DWTeam*)team;

/**
 * Fired when a user is selected
 */
- (void)userSelected:(DWUser*)user;

/**
 * Fired when the share button or an item is selected
 */
- (void)shareSelectedForItem:(DWItem*)item;

@end
