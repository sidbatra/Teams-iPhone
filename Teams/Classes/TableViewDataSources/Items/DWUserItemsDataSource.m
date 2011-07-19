//
//  DWUserItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsDataSource

@synthesize userID = _userID;

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getUserItemsForUserID:_userID
                                         before:_oldestTimestamp];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return _userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsLoaded:(NSMutableArray *)items {  
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsError:(NSString *)message {
    NSLog(@"User items error - %@",message);
    [self.delegate displayError:message];
}


@end
