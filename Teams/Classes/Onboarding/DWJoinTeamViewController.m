//
//  DWJoinTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWJoinTeamViewController.h"

#import "DWConstants.h"
#import "DWMembership.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWGUIManager.h"


static NSString* const kJoinTeamText                    = @"Join %@";
static NSString* const kJoinTeamSubText                 = @"as member number %d";
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

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        //Custom initialization
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.team                   = nil;
    
    self.navTitleView           = nil;
    self.navBarRightButtonView  = nil;
        
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
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];    
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
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
