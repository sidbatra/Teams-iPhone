//
//  DWUserItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsViewController.h"
#import "DWUserItemsDataSource.h"  
#import "DWItem.h"
#import "DWUser.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"
#import "DWUsersHelper.h"
#import "DWNavTitleView.h"


/**
 * Private method and property declarations
 */
@interface DWUserItemsViewController()

/**
 * Add the title view to the navigatio bar
 */
- (void)loadNavTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsViewController

@synthesize userItemsDataSource     = _userItemsDataSource;
@synthesize navTitleView            = _navTitleView;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user 
         andIgnore:(BOOL)ignore {
    
    self = [super init];
    
    if(self) {
        self.userItemsDataSource        = [[[DWUserItemsDataSource alloc] init] autorelease];
        self.userItemsDataSource.userID = user.databaseID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleUserItems]
                                                                forKey:[[DWItem class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userItemsDataSource  = [[[DWUserItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.userItemsDataSource    = nil;
    self.navTitleView           = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
        
    self.navigationItem.leftBarButtonItem = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self loadNavTitleView];
       
    [self.userItemsDataSource loadItems];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:nil];
    }
    
    DWUser *user = [DWUser fetch:self.userItemsDataSource.userID];
    
    [self.navTitleView displayPassiveButtonWithTitle:[DWUsersHelper displayName:user]
                                         andSubTitle:user.byline];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end
