//
//  DWItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsDataSource.h"
#import "DWItem.h"
#import "DWPagination.h"



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
- (void)populateItems:(NSMutableArray*)items {
    
    id lastObject   = [self.objects lastObject];
    BOOL paginate   = NO;
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = YES;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = items;
    }
    else {
        [self.objects removeLastObject];
        [self.objects addObjectsFromArray:items];
    }
    
    if([items count]) {
        
        _oldestTimestamp            = ((DWItem*)[items lastObject]).createdAtTimestamp;
        
        DWPagination *pagination    = [[[DWPagination alloc] init] autorelease];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (DWItem*)getItemAtIndexPath:(NSIndexPath*)indexPath {
    return [self.objects objectAtIndex:indexPath.row];
}

//----------------------------------------------------------------------------------------------------
- (void)deleteItemWithDatabaseID:(NSInteger)databaseID {
    
    DWItem *item = [DWItem fetch:databaseID];
    
    if(!item)
        return;
    
    [self.itemsController deleteItemWithID:item.databaseID];
    
    [self removeObject:item 
         withAnimation:UITableViewScrollPositionBottom];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    _oldestTimestamp = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        [self.objects removeLastObject];
    }
    
    [self loadItems];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadItems];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)itemDeleted:(DWItem*)item {
    
    [self removeObject:item 
         withAnimation:UITableViewRowAnimationBottom];
    
    [item destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)itemDeleteError:(NSString *)error {
}


@end

