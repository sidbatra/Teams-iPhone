//
//  DWItemViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemViewDataSource.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemViewDataSource

@synthesize itemsController     = _itemsController;
@synthesize touchesController   = _touchesController;
@synthesize itemID              = _itemID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsController                = [[[DWItemsController alloc] init] autorelease];
        self.itemsController.delegate       = self;
        
        self.touchesController              = [[[DWTouchesController alloc] init] autorelease];
        self.touchesController.delegate     = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.itemsController        = nil;
    self.touchesController      = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:_itemID];
    
    
    _itemLoaded     = NO;
    _touchesLoaded  = NO;

    [self.itemsController getItemWithID:self.itemID];
    [self.touchesController getTouchesOnItem:self.itemID];
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

    if(!_touchesLoaded) {
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
#pragma mark DWTouchesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)touchesResourceID {
    return self.itemID;
}

//----------------------------------------------------------------------------------------------------
- (void)touchesLoaded:(NSMutableArray*)touches {

    if(!_itemLoaded) {
        [self clean];
        self.objects = touches;
    }
    else {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,[touches count])];
        [self.objects insertObjects:touches atIndexes:indexSet];          
    }
    
    [self.delegate reloadTableView];
    
    _touchesLoaded = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)touchesError:(NSString *)error {
    NSLog(@"Item touches error - %@",error);
    [self.delegate displayError:error];    
}


@end
