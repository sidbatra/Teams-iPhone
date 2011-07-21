//
//  DWUserViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewController.h"
#import "DWUser.h"
#import "DWGUIManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewController

@synthesize userViewDataSource  = _userViewDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithUserID:(NSInteger)userID {
    self = [super init];
    
    if(self) {
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
        self.userViewDataSource.userID  = userID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.userViewDataSource = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.userViewDataSource loadUser];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
}

@end
