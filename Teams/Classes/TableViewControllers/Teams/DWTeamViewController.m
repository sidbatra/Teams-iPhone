//
//  DWTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamViewController.h"

#import "DWConstants.h"
#import "DWTeamsLogicController.h"
#import "DWTeamViewDataSource.h"
#import "DWTeam.h"
#import "DWSession.h"
#import "DWUpdateTeamDetailsViewController.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"
#import "DWNavTitleView.h"
#import "DWAnalyticsManager.h"

/**
 * Private method and property declarations
 */
@interface DWTeamViewController()

/**
 * Update the title view with the name of the team being displayed
 */
- (void)setupTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewController

@synthesize teamViewDataSource      = _teamViewDataSource;
@synthesize teamsLogicController    = _teamsLogicController;

@synthesize navTitleView            = _navTitleView;

@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    
    self = [super init];
    
    if(self) {
        _isUsersTeam                        = [DWSession sharedDWSession].currentUser.team == team;
        
        self.teamViewDataSource             = [[[DWTeamViewDataSource alloc] init] autorelease];
        self.teamViewDataSource.teamID      = team.databaseID;
        
        self.teamsLogicController           = [[[DWTeamsLogicController alloc] init] autorelease];
        self.teamsLogicController.tableViewController   = self;
        self.teamsLogicController.navigationEnabled     = NO;
        
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kTeamPresenterStyleNavigationDisabled]
                                        forKey:[[DWTeam class] className]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(smallUserImageLoaded:) 
													 name:kNImgSmallUserLoaded
												   object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.teamViewDataSource         = nil;
    self.teamsLogicController       = nil;
    
    self.navTitleView               = nil;
        
    self.delegate                   = nil;
    
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
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self setupTitleView];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.teamViewDataSource loadData];
    
    if (_isUsersTeam)
        self.navigationItem.rightBarButtonItem   = [DWGUIManager navBarButtonWithImageName:@"button_edit.png" 
                                                                                    target:self 
                                                                               andSelector:@selector(didTapEditButton:)];        
}

//----------------------------------------------------------------------------------------------------
- (void)setupTitleView {
    DWTeam *team = [DWTeam fetch:self.teamViewDataSource.teamID];

    if(!self.navTitleView) 
        self.navTitleView = [[[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                              kNavTitleViewY,
                                                                              kNavTitleViewWidth,
                                                                              kNavTitleViewHeight) 
                                                       andDelegate:nil] autorelease];    
    
    [self.navTitleView displayTitle:team.name 
                        andSubTitle:team.byline];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction methods

//----------------------------------------------------------------------------------------------------
- (void)didTapEditButton:(UIButton*)button {
    
    DWTeam *team = [DWTeam fetch:self.teamViewDataSource.teamID];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"edit_selected"
                                                                 withViewID:team.databaseID];
    
    
    DWUpdateTeamDetailsViewController *updateTeamDetailsViewController  = [[[DWUpdateTeamDetailsViewController alloc] 
                                                                            initWithTeam:team] 
                                                                           autorelease];
    
    [self.navigationController pushViewController:updateTeamDetailsViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)smallUserImageLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
        
    [self provideResourceToVisibleCells:kResourceTypeSmallUserImage
                               resource:resource
                             resourceID:resourceID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWResourcePresenterDelegate (Implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)resourceClicked:(id)resource {
    
    DWTeam *team = [DWTeam fetch:self.teamViewDataSource.teamID];

    if(resource == self.teamViewDataSource.invite) {
        [self.delegate showInvitePeopleFor:team];
        
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"invite_selected"
                                                                     withViewID:team.databaseID];
    }
    else if(resource == self.teamViewDataSource.share) {
        [self.delegate shareTeam:team];
        
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"share_selected"
                                                                     withViewID:team.databaseID];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated {
    [self setupTitleView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}

@end

