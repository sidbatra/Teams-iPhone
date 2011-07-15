//
//  DWUserItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"

/**
 * Data source for the user items view controller
 */
@interface DWUserItemsDataSource : DWItemsDataSource {
    NSInteger   _userID;
}

/**
 * The userID whose items are being displayed
 */
@property (nonatomic,assign) NSInteger userID;

@end
