//
//  DWJoinTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWJoinTeamViewController.h"

#import "DWConstants.h"
#import "DWMembership.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWGUIManager.h"


static NSString* const kJoinTeamText                    = @"Join %@";
static NSString* const kJoinTeamSubText                 = @"as the %d member";
static NSString* const kRightNavBarButtonText           = @"Join";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWJoinTeamViewController

@synthesize team                        = _team;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;

@synthesize membershipsController       = _membershipsController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.membershipsController          = [[[DWMembershipsController alloc] init] autorelease];
        self.membershipsController.delegate = self;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.team                   = nil;
    
    self.navTitleView           = nil;
    self.navRightBarButtonView  = nil;
    
    self.membershipsController  = nil;
    
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
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:[NSString stringWithFormat:kJoinTeamText,self.team.name] 
                        andSubTitle:[NSString stringWithFormat:kJoinTeamSubText,self.team.membersCount+1]];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                       title:kRightNavBarButtonText 
                                       andTarget:self] autorelease];    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)joinTeam {  
    [self.membershipsController createMembershipForTeamID:self.team.databaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWMembershipsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)membershipCreated:(DWMembership *)membership {
    [self.delegate teamJoined:membership.team];
}

//----------------------------------------------------------------------------------------------------
- (void)membershipCreationError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self joinTeam];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
}

@end
