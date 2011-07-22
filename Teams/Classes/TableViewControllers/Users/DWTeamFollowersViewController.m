//
//  DWTeamFollowersViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamFollowersViewController.h"
#import "DWTeamFollowersDataSource.h"
#import "DWUser.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"
#import "DWTeamsHelper.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamFollowersViewController

@synthesize teamFollowersDataSource = _teamFollowersDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    self =  [super init];
    
    if(self) {
        self.teamFollowersDataSource            = [[[DWTeamFollowersDataSource alloc] init] autorelease];
        self.teamFollowersDataSource.teamID     = team.databaseID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:KUserPresenterStyleFullSignature]
                                        forKey:[[DWUser class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamFollowersDataSource            = [[[DWTeamFollowersDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamFollowersDataSource    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamFollowersDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    DWTeam *team = [DWTeam fetch:self.teamFollowersDataSource.teamID];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:[DWTeamsHelper watchersOfTeam:team]];
    
    [self.teamFollowersDataSource loadUsers];
}

@end
