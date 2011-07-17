//
//  DWTeamViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewDataSource.h"
#import "DWTeamsHelper.h"
#import "DWMessage.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewDataSource

@synthesize teamsController     = _teamsController;
@synthesize teamID              = _teamID;

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadData {
    [self clean];
    self.objects = [NSMutableArray array];
    
    [self.teamsController getTeamWithID:self.teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadData];
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
            
    [self.objects addObject:team];
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.content     = [DWTeamsHelper createdAtLineForTeam:team];
    [self.objects addObject:message];
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString *)error {
    NSLog(@"Team load error - %@",error);
    [self.delegate displayError:error];        
}

@end
