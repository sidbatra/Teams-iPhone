//
//  DWRecentTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRecentTeamsViewController.h"
#import "DWRecentTeamsDataSource.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRecentTeamsViewController

@synthesize recentTeamsDataSource   = _recentTeamsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.recentTeamsDataSource = [[DWRecentTeamsDataSource alloc] init];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.recentTeamsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.recentTeamsDataSource loadTeams];
}

@end
