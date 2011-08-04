//
//  DWFollowedItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowedItemsViewController.h"
#import "DWFollowedItemsDataSource.h"




//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowedItemsViewController

@synthesize itemsDataSource         = _itemsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsDataSource = [[[DWFollowedItemsDataSource alloc] init] autorelease];
        
        
        if(&UIApplicationWillEnterForegroundNotification != NULL) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(applicationEnteringForeground:) 
                                                         name:UIApplicationWillEnterForegroundNotification
                                                       object:nil];
        }

    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.itemsDataSource        = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.itemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.itemsDataSource loadItems];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)applicationEnteringForeground:(NSNotification*)notification {
    [self.itemsDataSource refreshInitiated];
}



@end
