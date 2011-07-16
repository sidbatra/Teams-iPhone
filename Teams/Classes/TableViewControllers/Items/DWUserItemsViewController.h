//
//  DWUserItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWItemsViewController.h"


@class DWUser;
@class DWUserItemsDataSource;

/**
 * Table view for the items created by a user
 */
@interface DWUserItemsViewController : DWTableViewController {
    DWUserItemsDataSource       *_userItemsDataSource;
    DWItemsViewController       *_itemsViewController;
}

/**
 * Datasource for the table view
 */
@property (nonatomic,retain) DWUserItemsDataSource *userItemsDataSource;

/**
 * Items view controller encapsulates all the functionality neede by a table
 * view to display a list of items
 */
@property (nonatomic,retain) DWItemsViewController *itemsViewController;



/**
 * Init with the user whose items are being displayed
 */ 
- (id)initWithUser:(DWUser*)user
         andIgnore:(BOOL)ignore;

/**
 * Set a items view controller delegate
 */
- (void)setDelegate:(id<DWItemsViewControllerDelegate>)delegate;

@end
