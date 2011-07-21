//
//  DWTeamItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsDataSource

@synthesize teamsController     = _teamsController;
@synthesize teamID              = _teamID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];
        self.teamsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.teamsController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getTeamItemsForTeamID:self.teamID
                                         before:_oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowing {
    
}

//----------------------------------------------------------------------------------------------------
- (void)loadTeam {
    [self.teamsController getTeamWithID:self.teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [super refreshInitiated];
    
    [self loadTeam];
    [self loadFollowing];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsLoaded:(NSMutableArray *)items {  
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsError:(NSString *)message {
    NSLog(@"Team items error - %@",message);
    [self.delegate displayError:message];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)teamResourceID {
    return self.teamID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam *)team {
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString *)error {
    NSLog(@"Team load error - %@",error);
    [self.delegate displayError:error];        
}



@end
