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

static NSString* const kImgNotificationsButton      = @"button_more.png";
static NSString* const kMsgFollowAction             = @"Tap to follow this Team";
static NSString* const kMsgActionSheetUnfollow      = @"Unfollow";
static NSInteger const kTagUnfollowActionSheet      = -1;


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
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarButtonWithImageName:kImgNotificationsButton
                                                                               target:self
                                                                          andSelector:@selector(didTapDetailsButton:)];
    
    [self loadNavTitleView];
    
    [self.teamItemsDataSource loadItems];
    [self.teamItemsDataSource loadTeam];
    [self.teamItemsDataSource loadFollowing];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:self] autorelease];       
        
        //[self.navTitleView displaySpinnerWithUnderlay:NO];
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
        if ([DWSession sharedDWSession].currentUser.team != team) {
            [self.navTitleView displayPassiveButtonWithTitle:team.name
                                                 andSubTitle:team.byline
                                            withEnabledState:YES];
        }
        else {
            [self.navTitleView displayTitle:team.name
                                andSubTitle:team.byline];
        }
    }
    else {
        [self.navTitleView displayActiveButtonWithTitle:team.name
                                            andSubTitle:kMsgFollowAction
                                       withEnabledState:YES];
    }
    
    if([DWSession sharedDWSession].currentUser.team == team)
        [[DWSession sharedDWSession] update];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)invertFollowingState {
    [self.navTitleView displaySpinnerWithUnderlay:YES];
    [self.teamItemsDataSource invertFollowingState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNavTitleViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleView {
    
    if (self.teamItemsDataSource.following) {
        UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                                  delegate:self 
                                                         cancelButtonTitle:kMsgActionSheetCancel
                                                    destructiveButtonTitle:kMsgActionSheetUnfollow
                                                         otherButtonTitles:nil];
        actionSheet.tag             = kTagUnfollowActionSheet;
    
        [actionSheet showInView:self.view];
        [actionSheet release];  
    }
    else
        [self invertFollowingState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheetDelegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (buttonIndex == 0) {
        
        if (actionSheet.tag == kTagUnfollowActionSheet) 
            [self invertFollowingState];        
        else
            [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        
    }
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
