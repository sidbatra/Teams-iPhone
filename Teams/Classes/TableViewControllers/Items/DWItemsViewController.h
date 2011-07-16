//
//  DWItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWTouchesController.h"

@class DWItem;
@class DWTeam;
@class DWUser;
@class DWTouchesController;
@class DWTableViewController;
@protocol DWItemsViewControllerDelegate;

/**
 * Base class for table views that display a list of items
 */
@interface DWItemsViewController : NSObject<DWTouchesControllerDelegate> {
    DWTouchesController     *_touchesController;
    DWTableViewController   *_tableViewController;

    
    id<DWItemsViewControllerDelegate,NSObject> _delegate;
}

/**
 * The table view controller which contains the items view controller object
 */
@property (nonatomic,assign) DWTableViewController *tableViewController;

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
