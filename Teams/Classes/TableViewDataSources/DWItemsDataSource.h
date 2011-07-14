//
//  DWItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWItemsController.h"

/**
 * Datasource for table views that contain item model objects
 */
@interface DWItemsDataSource : DWTableViewDataSource<DWItemsControllerDelegate> {
    DWItemsController   *_itemsController;
    
    NSTimeInterval      _oldestTimestamp;
}

/**
 * Interface to the items service on the app server
 */
@property (nonatomic,retain) DWItemsController *itemsController;


/**
 * Populate items into in the objects array and handle pagination
 */
- (void)populateItems:(NSMutableArray*)items;

/**
 * Load followed items into the table view
 */
- (void)loadItems;

@end
