//
//  DWTeamItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"
#import "DWTableViewController.h"

@class DWTeam;
@class DWTeamItemsDataSource;

/**
 * Table view for the items crated by a team
 */
@interface DWTeamItemsViewController : DWTableViewController {
    DWTeamItemsDataSource       *_teamItemsDataSource;
    DWItemsViewController       *_itemsViewController;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamItemsDataSource *teamItemsDataSource;


/**
 * Items view controller encapsulates all the functionality neede by a table
 * view to display a list of items
 */
@property (nonatomic,retain) DWItemsViewController *itemsViewController;


/**
 * Init with the team whose items are being displayed
 */ 
- (id)initWithTeam:(DWTeam*)team;

/**
 * Set a items view controller delegate
 */
- (void)setItemsDelegate:(id<DWItemsViewControllerDelegate>)delegate;

@end
