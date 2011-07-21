//
//  DWTeamItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsViewController.h"
#import "DWTeamViewController.h"
#import "DWTeamItemsDataSource.h"
#import "DWItem.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsViewController

@synthesize teamItemsDataSource     = _teamItemsDataSource;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    self =  [super init];
    
    if(self) {
        self.teamItemsDataSource        = [[[DWTeamItemsDataSource alloc] init] autorelease];
        self.teamItemsDataSource.teamID = team.databaseID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleTeamItems]
                                        forKey:[[DWItem class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamItemsDataSource = [[[DWTeamItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamItemsDataSource    = nil;
    self.delegate               = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarDetailsButtonWithTarget:self
                                                                              andSelector:@selector(didTapDetailsButton:)];
    
    [self.teamItemsDataSource loadItems];
    [self.teamItemsDataSource loadTeam];
    [self.teamItemsDataSource loadFollowing];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITouchEvents
//----------------------------------------------------------------------------------------------------
- (void)didTapDetailsButton:(UIButton*)button {  
    DWTeam *team = [DWTeam fetch:self.teamItemsDataSource.teamID];
    [self.delegate teamDetailsSelected:team];
}

@end
