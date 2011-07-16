//
//  DWTeamItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsViewController.h"
#import "DWTeamItemsDataSource.h"
#import "DWItem.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsViewController

@synthesize teamItemsDataSource     = _teamItemsDataSource;
@synthesize itemsViewController     = _itemsViewController;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    self =  [super init];
    
    if(self) {
        self.teamItemsDataSource        = [[[DWTeamItemsDataSource alloc] init] autorelease];
        self.teamItemsDataSource.teamID = team.databaseID;
        
        self.itemsViewController        = [[[DWItemsViewController alloc] init] autorelease];
        self.itemsViewController.tableViewController    = self;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleTeamItems]
                                        forKey:[[DWItem class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamItemsDataSource = [[[DWTeamItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamItemsDataSource    = nil;
    self.itemsViewController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamItemsDataSource;
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
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.teamItemsDataSource loadItems];
}

@end
