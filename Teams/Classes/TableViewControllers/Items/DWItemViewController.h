//
//  DWItemViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWItem;
@class DWItemViewDataSource;
@class DWItemsLogicController;
@class DWUsersLogicController;
@protocol DWItemsLogicControllerDelegate;
@protocol DWUsersLogicControllerDelegate;


/**
 * Displays an item and the users who've touched it
 */
@interface DWItemViewController : DWTableViewController {
    DWItemsLogicController  *_itemsLogicController;
    DWUsersLogicController  *_usersLogicController;
    DWItemViewDataSource    *_itemViewDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic) DWItemViewDataSource *itemViewDataSource;


/**
 * Items logic controller encapsulates all the functionality for display and interaction
 * of a list of items
 */
@property (nonatomic) DWItemsLogicController *itemsLogicController;

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic) DWUsersLogicController *usersLogicController;


/**
 * Init with the itemID being displayed
 */
- (id)initWithItemID:(NSInteger)itemID;
    
/**
 * Set a items logic controller delegate
 */
- (void)setItemsDelegate:(id<DWItemsLogicControllerDelegate>)delegate;

/**
 * Set a users logic controller delegate
 */
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate;


@end
