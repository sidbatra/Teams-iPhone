//
//  DWItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWItemsDataSource.h"

/**
 * Base class for all table views that display a list of items
 */
@interface DWItemsViewController : DWTableViewController {
    DWItemsDataSource   *_itemsDataSource;
}

/**
 * Data source for populating items into the table view
 */
@property (nonatomic,retain) DWItemsDataSource *itemsDataSource;

@end
