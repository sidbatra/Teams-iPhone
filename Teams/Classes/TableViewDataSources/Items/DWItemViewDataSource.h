//
//  DWItemViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWItemsController.h"
#import "DWUsersController.h"

/**
 * Data source for the item view controller
 */
@interface DWItemViewDataSource : DWTableViewDataSource<DWItemsControllerDelegate,DWUsersControllerDelegate> {
    DWItemsController   *_itemsController;
    DWUsersController   *_usersController;
    
    BOOL                _itemLoaded;
    BOOL                _usersLoaded;
    
    NSInteger           _itemID;
}

/**
 * Interface to the items service
 */
@property (nonatomic,retain) DWItemsController *itemsController;

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * ItemID for the item whose touchers are being displayed
 */
@property (nonatomic,assign) NSInteger itemID;


/**
 * Start fetching data needed to populate the table view
 */
- (void)loadData;

@end
