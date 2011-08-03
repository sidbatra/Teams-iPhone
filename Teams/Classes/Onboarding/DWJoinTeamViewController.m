//
//  DWJoinTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWJoinTeamViewController.h"

#import "DWConstants.h"
#import "DWTeam.h"
#import "DWUser.h"
#import "DWJoinTeamDataSource.h"
#import "DWTeamsLogicController.h"
#import "DWUsersLogicController.h"
#import "NSObject+Helpers.h"
#import "DWApplicationHelper.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWGUIManager.h"


static NSString* const kJoinTeamText                    = @"Join %@";
static NSString* const kJoinTeamSubText                 = @"as the %@ member";
static NSString* const kNavBarRightButtonText           = @"Join";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWJoinTeamViewController

@synthesize team                        = _team;

@synthesize navTitleView                = _navTitleView;
@synthesize navBarRightButtonView       = _navBarRightButtonView;

@synthesize joinTeamDataSource          = _joinTeamDataSource;
@synthesize teamsLogicController        = _teamsLogicController;
@synthesize usersLogicController        = _usersLogicController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.joinTeamDataSource                         = [[[DWJoinTeamDataSource alloc] init] autorelease];
        
        self.teamsLogicController                       = [[[DWTeamsLogicController alloc] init] autorelease];
        self.teamsLogicController.tableViewController   = self;
        
        self.usersLogicController                       = [[[DWUsersLogicController alloc] init] autorelease];
        self.usersLogicController.tableViewController   = self;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kTeamPresenterStyleFat]
                                        forKey:[[DWTeam class] className]];   
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kUserPresenterStyleNavigationDisabled]
                                        forKey:[[DWUser class] className]];   
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    NSLog(@"join team view controller freed");
    self.team                   = nil;
    
    self.navTitleView           = nil;
    self.navBarRightButtonView  = nil;
    
    self.joinTeamDataSource     = nil;
    self.teamsLogicController   = nil;
    self.usersLogicController   = nil;
        
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager customBackButton:self.delegate];
    
    [self disablePullToRefresh];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:[NSString stringWithFormat:kJoinTeamText,self.team.name] 
                        andSubTitle:[NSString stringWithFormat:kJoinTeamSubText,
                                     [DWApplicationHelper generateOrdinalFrom:(self.team.membersCount+1)]]];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    
    self.joinTeamDataSource.teamID  = self.team.databaseID;
    [self.joinTeamDataSource loadData];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.joinTeamDataSource;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self.delegate teamJoined:self.team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
}

@end
