//
//  DWItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWItemsController.h"

/**
 * Datasource for table views that contain a list of items
 */
@interface DWItemsDataSource : DWTableViewDataSource<DWItemsControllerDelegate> {
    DWItemsController   *_itemsController;
    
    NSTimeInterval      _oldestTimestamp;
}

/**
 * Interface to the items service on the app server
 */
@property (nonatomic) DWItemsController *itemsController;


/**
 * Populate items into in the objects array and handle pagination
 */
- (void)populateItems:(NSMutableArray*)items;

/**
 * Get the item object at the given index path
 */
- (DWItem*)getItemAtIndexPath:(NSIndexPath*)indexPath;

/**
 * Delete item with the given databaseID from the table view and 
 * initiate request to delete it on the server.
 */
- (void)deleteItemWithDatabaseID:(NSInteger)databaseID;

/**
 * Stub method overriden by base class to start the loading of items into the table view
 */
- (void)loadItems;

@end
