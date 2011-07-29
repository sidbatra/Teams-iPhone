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
#import "DWNavTitleView.h"
#import "DWSession.h"
#import "DWAnalyticsManager.h"


static NSString* const kMsgFollowAction = @"Tap to start watching this Team";


/**
 * Private method and property declarations
 */
@interface DWTeamItemsViewController()


/**
 * Add the title view to the navigation bar
 */
- (void)loadNavTitleView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsViewController

@synthesize teamItemsDataSource     = _teamItemsDataSource;
@synthesize navTitleView            = _navTitleView;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeamID:(NSInteger)teamID {
    self =  [super init];
    
    if(self) {
        self.teamItemsDataSource        = [[[DWTeamItemsDataSource alloc] init] autorelease];
        self.teamItemsDataSource.teamID = teamID;
        
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
    self.navTitleView           = nil;
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
    
    [self loadNavTitleView];
    
    [self.teamItemsDataSource loadItems];
    [self.teamItemsDataSource loadTeam];
    [self.teamItemsDataSource loadFollowing];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:self];       
        
        [self.navTitleView displaySpinnerWithUnderlay:YES];
    }
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamItemsDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam*)team 
     withFollowing:(DWFollowing*)following {
    
    if(following) {
        [self.navTitleView displayPassiveButtonWithTitle:team.name
                                             andSubTitle:team.byline
                                        withEnabledState:[DWSession sharedDWSession].currentUser.team != team];
    }
    else {
        [self.navTitleView displayActiveButtonWithTitle:team.name
                                            andSubTitle:kMsgFollowAction
                                       withEnabledState:YES];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNavTitleViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleView {
        
    [self.navTitleView displaySpinnerWithUnderlay:YES];
    [self.teamItemsDataSource invertFollowingState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITouchEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapDetailsButton:(UIButton*)button {  
    
    DWTeam *team = [DWTeam fetch:self.teamItemsDataSource.teamID];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"details_selected"
                                                                 withViewID:team.databaseID];
    
    
    [self.delegate teamDetailsSelected:team];
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
