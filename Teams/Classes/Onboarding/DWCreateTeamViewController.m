//
//  DWCreateTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateTeamViewController.h"
#import "DWGUIManager.h"


static NSString* const kCreateTeamText          = @"Create New Team";
static NSString* const kRightNavBarButtonText   = @"Next";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateTeamViewController

@synthesize teamNameTextField           = _teamNameTextField;
@synthesize teamBylineTextField         = _teamBylineTextField;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;

//----------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)theDelegate {
    
    self = [super init];
    
    if (self) {
        _delegate   = theDelegate;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.teamNameTextField          = nil;
    self.teamBylineTextField        = nil;
    
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;
    
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
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager customBackButton:_delegate];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kCreateTeamText];
    
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
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [_delegate newTeamCreated];
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
