//
//  DWUserItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsViewController.h"
#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsViewController

@synthesize userItemsDataSource = _userItemsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user 
         andIgnore:(BOOL)ignore {
    
    self = [super init];
    
    if(self) {
        self.userItemsDataSource        = [[[DWUserItemsDataSource alloc] init] autorelease];
        self.userItemsDataSource.userID = user.databaseID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userItemsDataSource        = [[[DWUserItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.userItemsDataSource  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.userItemsDataSource loadItems];
}

@end
