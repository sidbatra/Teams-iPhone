//
//  DWTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewController.h"
#import "DWTeamsLogicController.h"
#import "DWTeamViewDataSource.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewController

@synthesize teamViewDataSource      = _teamViewDataSource;
@synthesize teamsLogicController    = _teamsLogicController;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    
    self = [super init];
    
    if(self) {
        self.teamViewDataSource             = [[[DWTeamViewDataSource alloc] init] autorelease];
        self.teamViewDataSource.teamID      = team.databaseID;
        
        self.teamsLogicController           = [[[DWTeamsLogicController alloc] init] autorelease];
        self.teamsLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamViewDataSource        = [[[DWTeamViewDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamViewDataSource         = nil;
    self.teamsLogicController       = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate {
    self.teamsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWTeam class] className]])
        delegate = self.teamsLogicController;
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.teamViewDataSource loadData];
}


@end
