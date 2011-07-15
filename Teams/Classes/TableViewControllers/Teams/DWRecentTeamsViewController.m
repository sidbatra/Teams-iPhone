//
//  DWRecentTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRecentTeamsViewController.h"
#import "DWRecentTeamsDataSource.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRecentTeamsViewController

@synthesize recentTeamsDataSource   = _recentTeamsDataSource;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.recentTeamsDataSource = [[[DWRecentTeamsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.recentTeamsDataSource  = nil;
    
    [super dealloc];
}

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
