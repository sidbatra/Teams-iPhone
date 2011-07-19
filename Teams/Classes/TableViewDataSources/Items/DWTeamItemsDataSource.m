//
//  DWTeamItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsDataSource

@synthesize teamID  = _teamID;

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getTeamItemsForTeamID:_teamID
                                         before:_oldestTimestamp];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return _teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsLoaded:(NSMutableArray *)items {  
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsError:(NSString *)message {
    NSLog(@"Team items error - %@",message);
    [self.delegate displayError:message];
}



@end
