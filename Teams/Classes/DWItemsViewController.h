//
//  DWItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWItemsDataSource.h"
#import "DWTouchesController.h"

@class DWTouchesController;

/**
 * Base class for all table views that display a list of items
 */
@interface DWItemsViewController : DWTableViewController<DWTouchesControllerDelegate> {
    DWTouchesController     *_touchesController;
}

/**
 * Record the touches made on items by the current user
 */
@property (nonatomic,retain) DWTouchesController *touchesController;

@end
