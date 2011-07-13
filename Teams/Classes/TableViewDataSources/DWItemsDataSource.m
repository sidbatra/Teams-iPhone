//
//  DWItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsDataSource.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsDataSource

@synthesize itemsController = _itemsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(paginationCellReached:) 
													 name:kNPaginationCellReached
												   object:nil];
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
    self.itemsController            = [[DWItemsController alloc] initWithRole:kItemsControllerRoleFollowed];
    self.itemsController.delegate   = self;
    
    [self.itemsController getItems];
    
    
    //[self.itemsController performSelector:@selector(getMoreItems) withObject:nil afterDelay:2.0];
    /*[self.itemsController performSelector:@selector(getMoreItems) withObject:nil afterDelay:5.0];
    [self.itemsController performSelector:@selector(getMoreItems) withObject:nil afterDelay:8.0];
    [self.itemsController performSelector:@selector(getItems) withObject:nil afterDelay:10.0];
     */
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)itemsLoaded:(NSMutableArray *)items {
    [self clean];
    self.objects = items;
    
    if([items count]) {
        DWPagination *pagination = [[[DWPagination alloc] init] autorelease];
        pagination.owner = self;
        [self.objects addObject:pagination];
    }
        
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)moreItemsLoaded:(NSMutableArray *)items {
    [self.objects removeLastObject];
    [self.objects addObjectsFromArray:items];
    
    if([items count]) {
        DWPagination *pagination = [[[DWPagination alloc] init] autorelease];
        pagination.owner = self;
        [self.objects addObject:pagination];
    }
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)itemsError:(NSString *)message {
    NSLog(@"ERROR - %@",message);
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)paginationCellReached:(NSNotification*)notification {
    if([notification object] == self) {
        NSLog(@"pagination cell reached");
        [self.itemsController getMoreItems];
    }
}

@end
