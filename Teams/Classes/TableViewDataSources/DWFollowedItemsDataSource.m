//
//  DWFollowedItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowedItemsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowedItemsDataSource

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getFollowedItemsBefore:_oldestTimestamp];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)itemCreated:(DWItem *)item 
     fromResourceID:(NSInteger)resourceID {
    
    [self addObject:item
            atIndex:0];
}

//----------------------------------------------------------------------------------------------------
- (void)followedItemsLoaded:(NSMutableArray *)items { 
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)followedItemsError:(NSString *)message {
    NSLog(@"Followed items error - %@",message);
    [self.delegate displayError:message];
}


@end
