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
                                             andSubTitle:team.byline];
    }
    else {
        [self.navTitleView displayActiveButtonWithTitle:team.name
                                            andSubTitle:kMsgFollowAction];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNavTitleViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleView {
    
    DWTeam *team = [DWTeam fetch:self.teamItemsDataSource.teamID];
    
    if(team != [DWSession sharedDWSession].currentUser.team)
        [self.teamItemsDataSource invertFollowingState];
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
}


@end
