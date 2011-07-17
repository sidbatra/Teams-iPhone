//
//  DWTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewController.h"
#import "DWTeamsLogicController.h"

#import "DWTeamViewDataSource.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"



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
        self.teamsLogicController.tableViewController   = self;
        self.teamsLogicController.navigationEnabled     = NO;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kTeamPresenterStyleNavigationDisabled]
                                        forKey:[[DWTeam class] className]];
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
    
    DWTeam *team = [DWTeam fetch:self.teamViewDataSource.teamID];
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:team.name];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.teamViewDataSource loadData];
}


@end
