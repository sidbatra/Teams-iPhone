//
//  DWFollowedItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"
#import "DWFollowedItemsDataSource.h"

/**
 * Tabe view for the items followed by the current user
 */
@interface DWFollowedItemsViewController : DWItemsViewController {
    DWFollowedItemsDataSource   *_itemsDataSource;
}

/**
 * Data source for populating items into the table view
 */
@property (nonatomic,retain) DWFollowedItemsDataSource *itemsDataSource;

@end
