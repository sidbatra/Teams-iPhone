//
//  DWJoinTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWJoinTeamViewController.h"

#import "DWConstants.h"
#import "DWTeam.h"
#import "DWUser.h"
#import "DWJoinTeamDataSource.h"
#import "DWUsersLogicController.h"
#import "NSObject+Helpers.h"
#import "DWApplicationHelper.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"

static NSString* const kImgTopShadow                    = @"shadow_top.png";
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

@synthesize topShadowView               = _topShadowView;
@synthesize navTitleView                = _navTitleView;
@synthesize navBarRightButtonView       = _navBarRightButtonView;

@synthesize joinTeamDataSource          = _joinTeamDataSource;
@synthesize usersLogicController        = _usersLogicController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.joinTeamDataSource                         = [[DWJoinTeamDataSource alloc] init];

        self.usersLogicController                       = [[DWUsersLogicController alloc] init];
        self.usersLogicController.tableViewController   = self;
                
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kUserPresenterStyleNavigationDisabled]
                                        forKey:[[DWUser class] className]];   
    }
    return self;
}

//----------------------------------------------------------------------------------------------------

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
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    self.tableView.backgroundView           = [DWGUIManager backgroundImageViewWithFrame:self.view.frame];
    
    [self disablePullToRefresh];
    
    if(!self.topShadowView)
        self.topShadowView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgTopShadow]];
    
    self.topShadowView.frame    = CGRectMake(0,0,320,5);
    [self.view addSubview:self.topShadowView];
    
    if (!self.navTitleView)
        self.navTitleView = [[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self];
    
    [self.navTitleView displayTitle:[NSString stringWithFormat:kJoinTeamText,self.team.name] 
                        andSubTitle:[NSString stringWithFormat:kJoinTeamSubText,
                                     [DWApplicationHelper generateOrdinalFrom:(self.team.membersCount+1)]]];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self];
    
    self.joinTeamDataSource.teamID  = self.team.databaseID;
    [self.joinTeamDataSource loadData];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad];
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
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate {
    self.usersLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWUser class] className]])
        delegate = self.usersLogicController;
    
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"join_selected"];
    
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
