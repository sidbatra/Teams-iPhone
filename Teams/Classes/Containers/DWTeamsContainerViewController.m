//
//  DWTeamsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsContainerViewController.h"
#import "DWPopularTeamsViewController.h"
#import "DWSearchViewController.h"
#import "DWNavTitleView.h"
#import "DWGUIManager.h"
#import "DWConstants.h"
#import "DWAnalyticsManager.h"

static NSString* const kImgInvite                   = @"button_invite.png";
static NSString* const kImgSearch                   = @"button_search.png";
static NSString* const kMsgUnload					= @"Unload called on teams container";
static NSString* const kMsgTitle                    = @"Teams";
static NSString* const kSearchBarText				= @"Search teams and people";
static NSString* const kSearchBarBackgroundClass	= @"UISearchBarBackground";
static NSInteger const kMinimumQueryLength			= 1;

/**
 * Private method and property declarations
 */
@interface DWTeamsContainerViewController()

/**
 * Compliment of the loadSideButtons method
 */
- (void)removeSideButtons;

/**
 * View creation methods
 */
- (void)loadPopularTeamsViewController;
- (void)loadSearchViewController;
- (void)loadSideButtons;
- (void)loadTitleView;
- (void)loadSearchBar;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsContainerViewController

@synthesize popularTeamsViewController  = _popularTeamsViewController;
@synthesize searchViewController        = _searchViewController;
@synthesize navTitleView                = _navTitleView;
@synthesize searchBar                   = _searchBar;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.popularTeamsViewController = nil;
    self.searchViewController       = nil;
    self.navTitleView               = nil;
    self.searchBar                  = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)loadPopularTeamsViewController {
    
    if(!self.popularTeamsViewController) {
        self.popularTeamsViewController = [[[DWPopularTeamsViewController alloc] init] autorelease];
        [self.popularTeamsViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.popularTeamsViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadSearchBar {
    
    if(!self.searchBar) {
        self.searchBar                      = [[[DWSearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)] autorelease];
        self.searchBar.minimumQueryLength   = 1;
        self.searchBar.delegate             = self;
        self.searchBar.hidden               = YES;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)loadSearchViewController {
    
    if(!self.searchViewController) {
        self.searchViewController = [[[DWSearchViewController alloc] init] autorelease];
        [self.searchViewController setUsersDelegate:self];
        [self.searchViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.searchViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadSideButtons {
    
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarButtonWithImageName:kImgSearch
                                                                               target:self
                                                                          andSelector:@selector(didTapSearchButton:)];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarButtonWithImageName:kImgInvite
                                                                               target:self
                                                                          andSelector:@selector(didTapInviteButton:)];
}

//----------------------------------------------------------------------------------------------------
- (void)removeSideButtons {
    self.navigationItem.leftBarButtonItem   = nil;
    self.navigationItem.rightBarButtonItem  = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)loadTitleView {
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kMsgTitle];       
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPopularTeamsViewController];
    [self loadSearchViewController];
    [self loadSideButtons];
    [self loadTitleView];
    [self loadSearchBar];
    

	self.navigationItem.titleView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@",kMsgUnload);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchCancelled {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"search_cancelled"];
    
    
    self.searchViewController.view.hidden   = YES;
    self.searchBar.hidden                   = YES;
    
    [self.searchViewController resetWithSpinnerHidden:YES];
    [self.searchBar resignActive];
    
    self.navTitleView.hidden                = NO;
    [self loadSideButtons];
}

//----------------------------------------------------------------------------------------------------
- (void)searchWithQuery:(NSString*)query {
    [self.searchViewController search:query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITouchEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapSearchButton:(UIButton*)button {  
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"search_selected"];
    
    
    self.searchViewController.view.hidden = NO;
    self.searchBar.hidden                 = NO;
    
    [self.searchBar becomeActive];
    
    self.navTitleView.hidden              = YES;
    [self removeSideButtons];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapInviteButton:(UIButton*)button { 
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"invite_selected"];
    
    NSLog(@"invite");
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    self.searchBar.hidden = viewController != self || self.searchViewController.view.hidden;
    
    [super navigationController:navigationController 
         willShowViewController:viewController 
                       animated:animated];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.searchBar];
}


@end
