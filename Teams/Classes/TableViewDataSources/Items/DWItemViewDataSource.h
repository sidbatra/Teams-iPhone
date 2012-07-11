//
//  DWItemViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWItemsController.h"
#import "DWTouchesController.h"

@protocol DWItemViewDataSourceDelegate;

/**
 * Data source for the item view controller
 */
@interface DWItemViewDataSource : DWTableViewDataSource<DWItemsControllerDelegate,DWTouchesControllerDelegate> {
    DWItemsController       *_itemsController;
    DWTouchesController     *_touchesController;
    
    BOOL                    _itemLoaded;
    BOOL                    _touchesLoaded;
    
    NSInteger               _itemID;
}

/**
 * Interface to the items service
 */
@property (nonatomic) DWItemsController *itemsController;

/**
 * Interface to the touches service
 */
@property (nonatomic) DWTouchesController *touchesController;

/**
 * ItemID for the item whose touchers are being displayed
 */
@property (nonatomic,assign) NSInteger itemID;

/**
 * Extend the original delegate
 */
@property (nonatomic,unsafe_unretained) id<DWItemViewDataSourceDelegate,NSObject> delegate;


/**
 * Start fetching data needed to populate the table view
 */
- (void)loadData;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWItemViewDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Provide the fetched item object to the table view
 */
- (void)itemLoaded:(DWItem*)item;

@end

