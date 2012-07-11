//
//  DWTeamsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsDataSource

@synthesize teamsController = _teamsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamsController            = [[DWTeamsController alloc] init];
        self.teamsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)populateTeams:(NSMutableArray*)teams {
   
    [self clean];
    self.objects = teams;
    
    [self.delegate reloadTableView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadTeams {
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadTeams];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}

@end
