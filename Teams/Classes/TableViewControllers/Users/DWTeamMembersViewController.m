//
//  DWTeamMembersViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamMembersViewController.h"
#import "DWTeamMembersDataSource.h"
#import "DWUser.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamMembersViewController

@synthesize teamMembersDataSource   = _teamMembersDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    self =  [super init];
    
    if(self) {
        self.teamMembersDataSource              = [[[DWTeamMembersDataSource alloc] init] autorelease];
        self.teamMembersDataSource.teamID       = team.databaseID;
        
        //[self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleTeamItems]
        //                                forKey:[[DWUser class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamMembersDataSource              = [[[DWTeamMembersDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamMembersDataSource    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamMembersDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.teamMembersDataSource loadUsers];
}

@end
