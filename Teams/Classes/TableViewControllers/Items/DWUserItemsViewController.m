//
//  DWUserItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsViewController.h"
#import "DWUserItemsDataSource.h"  
#import "DWItem.h"
#import "NSObject+Helpers.h"

#import "DWItem.h"
#import "DWUser.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsViewController

@synthesize userItemsDataSource     = _userItemsDataSource;
@synthesize itemsViewController     = _itemsViewController;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user 
         andIgnore:(BOOL)ignore {
    
    self = [super init];
    
    if(self) {
        self.userItemsDataSource        = [[[DWUserItemsDataSource alloc] init] autorelease];
        self.userItemsDataSource.userID = user.databaseID;
        
        self.itemsViewController        = [[[DWItemsViewController alloc] init] autorelease];
        self.itemsViewController.tableViewController = self;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleUserItems]
                                                                forKey:[[DWItem class] className]];
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
    self.userItemsDataSource    = nil;
    self.itemsViewController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)setItemsDelegate:(id<DWItemsViewControllerDelegate,NSObject>)delegate {
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
        
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.userItemsDataSource loadItems];
}

@end
