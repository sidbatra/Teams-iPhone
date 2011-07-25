//
//  DWItemViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemViewDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemViewDataSource

@synthesize itemsController     = _itemsController;
@synthesize usersController     = _usersController;
@synthesize itemID              = _itemID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsController            = [[[DWItemsController alloc] init] autorelease];
        self.itemsController.delegate   = self;
        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.itemsController    = nil;
    self.usersController    = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
    _itemLoaded     = NO;
    _usersLoaded    = NO;

    [self.itemsController getItemWithID:self.itemID];
    [self.usersController getTouchersOfItem:self.itemID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadData];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return self.itemID;
}

//----------------------------------------------------------------------------------------------------
- (void)itemLoaded:(DWItem*)item {

    if(!_usersLoaded) {
        [self clean];
        self.objects = [NSMutableArray array];
        [self.objects addObject:item];
    }
    else {
        [self.objects insertObject:item
                           atIndex:0];
    }
    
    [self.delegate reloadTableView];
    [self.delegate itemLoaded:item];
        
    _itemLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)itemError:(NSString *)message {
    NSLog(@"Item error - %@",message);
    [self.delegate displayError:message];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return self.itemID;
}

//----------------------------------------------------------------------------------------------------
- (void)itemTouchersLoaded:(NSMutableArray*)users {
    
    if(!_itemLoaded) {
        [self clean];
        self.objects = users;
    }
    else {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,[users count])];
        [self.objects insertObjects:users atIndexes:indexSet];          
    }
    
    [self.delegate reloadTableView];
    
    _usersLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)itemTouchersError:(NSString *)error {
    NSLog(@"Item touchers error - %@",error);
    [self.delegate displayError:error];    
}


@end
