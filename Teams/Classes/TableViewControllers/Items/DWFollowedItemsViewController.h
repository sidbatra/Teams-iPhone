//
//  DWFollowedItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWItemsViewController.h"

@class DWFollowedItemsDataSource;

/**
 * Tabe view for the items followed by the current user
 */
@interface DWFollowedItemsViewController : DWTableViewController {
    DWFollowedItemsDataSource   *_itemsDataSource;
    DWItemsViewController       *_itemsViewController;
}

/**
 * Data source for populating items into the table view
 */
@property (nonatomic,retain) DWFollowedItemsDataSource *itemsDataSource;

/**
 * Items view controller encapsulates all the functionality neede by a table
 * view to display a list of items
 */
@property (nonatomic,retain) DWItemsViewController *itemsViewController;


/**
 * Set a items view controller delegate
 */
- (void)setDelegate:(id<DWItemsViewControllerDelegate>)delegate;

@end
