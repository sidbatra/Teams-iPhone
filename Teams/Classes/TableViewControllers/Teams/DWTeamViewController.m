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
#import "DWNavRightBarButtonView.h"
#import "DWUpdateTeamDetailsViewController.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"


static NSString* const kRightNavBarButtonText   = @"Edit";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamViewController

@synthesize teamViewDataSource      = _teamViewDataSource;
@synthesize teamsLogicController    = _teamsLogicController;

@synthesize navRightBarButtonView   = _navRightBarButtonView;

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
    
    self.navRightBarButtonView      = nil;
    
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
    
    DWTeam *team = [DWTeam fetch:self.teamViewDataSource.teamID];
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:team.name];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.teamViewDataSource loadData];
    
    if (_isUsersTeam && !self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                       title:kRightNavBarButtonText 
                                       andTarget:self] autorelease];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction methods

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    DWUpdateTeamDetailsViewController *updateTeamDetailsViewController  = [[[DWUpdateTeamDetailsViewController alloc] 
                                                                            initWithTeam:[DWTeam fetch:self.teamViewDataSource.teamID]] 
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
    
    if(resource == self.teamViewDataSource.members)
        [self.delegate showMembersOfTeam:team];
    else if(resource == self.teamViewDataSource.followers)
        [self.delegate showFollowersOfTeam:team];
    else if(resource == self.teamViewDataSource.invite)
        [self.delegate showInvitePeople];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    if (_isUsersTeam) 
        [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
}

@end

