//
//  DWItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsDataSource.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsDataSource

@synthesize itemsController = _itemsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsController            = [[[DWItemsController alloc] init] autorelease];
        self.itemsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.itemsController    = nil;
        
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadFollowedItems {
    [self.itemsController getFollowedItems];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)followedItemsLoaded:(NSMutableArray *)items {
    [self.objects addObjectsFromArray:items];
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)followedItemsError:(NSString *)message {
    NSLog(@"ERROR - %@",message);
}

@end
