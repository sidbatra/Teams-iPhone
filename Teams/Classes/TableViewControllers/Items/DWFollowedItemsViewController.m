//
//  DWFollowedItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowedItemsViewController.h"
#import "DWFollowedItemsDataSource.h"
#import "DWItem.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowedItemsViewController

@synthesize itemsDataSource         = _itemsDataSource;
@synthesize itemsViewController     = _itemsViewController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsDataSource = [[[DWFollowedItemsDataSource alloc] init] autorelease];
        
        self.itemsViewController    = [[[DWItemsViewController alloc] init] autorelease];
        self.itemsViewController.tableViewController    = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.itemsDataSource        = nil;
    self.itemsViewController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.itemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)setDelegate:(id<DWItemsViewControllerDelegate,NSObject>)delegate {
    self.itemsViewController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWItem class] className]])
        delegate = self.itemsViewController;
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.itemsDataSource loadItems];
}


@end
