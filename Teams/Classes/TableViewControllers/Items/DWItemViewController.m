//
//  DWItemViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemViewController.h"
#import "DWItemsLogicController.h"
#import "DWUsersLogicController.h"
#import "DWItemViewDataSource.h"
#import "DWItem.h"
#import "DWUser.h"
#import "DWGUIManager.h"
#import "DWItemsHelper.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemViewController

@synthesize itemsLogicController    = _itemsLogicController;
@synthesize usersLogicController    = _usersLogicController;
@synthesize itemViewDataSource      = _itemViewDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithItemID:(NSInteger)itemID {
    
    self = [super init];
    
    if(self) {
        self.itemViewDataSource             = [[[DWItemViewDataSource alloc] init] autorelease];
        self.itemViewDataSource.itemID      = itemID;
        
        self.itemsLogicController           = [[[DWItemsLogicController alloc] init] autorelease];
        self.itemsLogicController.tableViewController = self;
        
        self.usersLogicController           = [[[DWUsersLogicController alloc] init] autorelease];
        self.usersLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemViewDataSource             = [[[DWItemViewDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.itemsLogicController       = nil;
    self.usersLogicController       = nil;
    self.itemViewDataSource         = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setItemsDelegate:(id<DWItemsLogicControllerDelegate,NSObject>)delegate {
    self.itemsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate {
    self.usersLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWItem class] className]])
        delegate = self.itemsLogicController;
    else  if([className isEqualToString:[[DWUser class] className]])
        delegate = self.usersLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.itemViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)itemLoaded:(DWItem*)item {
    self.navigationItem.titleView  = [DWGUIManager navBarTitleViewForText:[DWItemsHelper itemViewTitle:item
                                                                                  belongsToCurrentUser:item.user.isCurrentUser]];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.itemViewDataSource loadData];
}



@end
