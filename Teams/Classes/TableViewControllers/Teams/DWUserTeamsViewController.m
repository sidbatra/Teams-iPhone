//
//  DWUserTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserTeamsViewController.h"
#import "DWUserTeamsDataSource.h"
#import "DWUser.h"
#import "DWGUIManager.h"
#import "DWUsersHelper.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserTeamsViewController

@synthesize userTeamsDataSource = _userTeamsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user 
         andIgnore:(BOOL)ignore {
    
    self = [super init];
    
    if(self) {        
        self.userTeamsDataSource            = [[DWUserTeamsDataSource alloc] init];
        self.userTeamsDataSource.userID     = user.databaseID;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.userTeamsDataSource            = [[DWUserTeamsDataSource alloc] init];
    }
    
    return self;
}


//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userTeamsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    DWUser *user = [DWUser fetch:self.userTeamsDataSource.userID];
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:[DWUsersHelper userTeamsTitle:user]];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.userTeamsDataSource loadTeams];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
