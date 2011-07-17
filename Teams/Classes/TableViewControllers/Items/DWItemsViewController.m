//
//  DWItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsViewController.h"
#import "DWItemsLogicController.h"
#import "DWItem.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsViewController

@synthesize itemsLogicController     = _itemsLogicController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.itemsLogicController    = [[[DWItemsLogicController alloc] init] autorelease];
        self.itemsLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.itemsLogicController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setItemsDelegate:(id<DWItemsLogicControllerDelegate,NSObject>)delegate {
    self.itemsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWItem class] className]])
        delegate = self.itemsLogicController;
    
    return delegate;
}

@end
