//
//  DWPopularTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPopularTeamsViewController.h"
#import "DWPopularTeamsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPopularTeamsViewController

@synthesize popularTeamsDataSource  = _popularTeamsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.popularTeamsDataSource = [[[DWPopularTeamsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.popularTeamsDataSource     = nil;

    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.popularTeamsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.popularTeamsDataSource loadTeams];
}


@end
