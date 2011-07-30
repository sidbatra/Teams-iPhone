//
//  DWUserViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewController.h"
#import "DWUser.h"
#import "DWResource.h"
#import "DWGUIManager.h"
#import "NSObject+Helpers.h"
#import "DWNavTitleView.h"
#import "DWUsersHelper.h"
#import "DWSession.h"
#import "DWNavBarRightButtonView.h"
#import "DWNavBarFillerView.h"
#import "DWUpdateUserDetailsViewController.h"
#import "DWAnalyticsManager.h"


/**
 * Private method and property declarations
 */
@interface DWUserViewController()

/**
 * Create a nav title view
 */
- (void)loadNavTitleView;

/**
 * Create a nav right bar button
 */
- (void)loadNavBarRightButtonView;

@end


static NSString* const kNavBarRightButtonText   = @"Edit";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewController

@synthesize userViewDataSource      = _userViewDataSource;

@synthesize navTitleView            = _navTitleView;
@synthesize navBarRightButtonView   = _navBarRightButtonView;

@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithUserID:(NSInteger)userID {
    self = [super init];
    
    if(self) {
        _isCurrentUser                  = [DWSession sharedDWSession].currentUser.databaseID == userID;
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
        self.userViewDataSource.userID  = userID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kResourcePresenterStyleFat]
                                        forKey:[[DWResource class] className]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(largeImageLoaded:) 
                                                     name:kNImgLargeUserLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.userViewDataSource     = nil;
    
    self.navTitleView           = nil;
    self.navBarRightButtonView  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self loadNavTitleView];
    
    [self.userViewDataSource loadUser];
    
    if (_isCurrentUser && !self.navBarRightButtonView)
        [self loadNavBarRightButtonView];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:nil];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavBarRightButtonView {
    self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                   initWithFrame:CGRectMake(260,0,
                                                            kNavRightButtonWidth,
                                                            kNavRightButtonHeight)
                                           title:kNavBarRightButtonText 
                                       andTarget:self] autorelease];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction methods

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    
    DWUser *user = [DWUser fetch:self.userViewDataSource.userID];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"edit_selected"
                                                                 withViewID:user.databaseID];
    
    [self.delegate showEditUserDetailsView:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
    [self.navTitleView displayPassiveButtonWithTitle:[DWUsersHelper displayName:user]
                                         andSubTitle:user.team.name 
                                    withEnabledState:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWResourcePresenterDelegate (via selectors)

//----------------------------------------------------------------------------------------------------
- (void)messageClicked:(id)message {
    
    DWUser *user = [DWUser fetch:self.userViewDataSource.userID];
    
    if(message == self.userViewDataSource.teamMessage) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"team_selected"
                                                                     withViewID:user.databaseID];
        
        [self.delegate userViewShowTeam:user.team];
    }
    else if(message == self.userViewDataSource.watchingMessage) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"following_selected"
                                                                     withViewID:user.databaseID];
        
        [self.delegate userViewShowTeamsWatchedBy:user];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)largeImageLoaded:(NSNotification*)notification {
    
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self provideResourceToVisibleCells:kResourceTypeLargeUserImage
                               resource:resource
                             resourceID:resourceID];
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
    
    if(_isCurrentUser)
        [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
}



@end
