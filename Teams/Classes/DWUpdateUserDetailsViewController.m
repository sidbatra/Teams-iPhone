//
//  DWUpdateUserDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateUserDetailsViewController.h"
#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWRequestsManager.h"
#import "NSString+Helpers.h"
#import "DWSession.h"
#import "DWConstants.h"
#import "DWGUIManager.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter first name, last name, email and password";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kUpdateUserDetailsText   = @"Edit Your Details";
static NSString* const kRightNavBarButtonText   = @"Save";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUpdateUserDetailsViewController

@synthesize firstNameTextField              = _firstNameTextField;
@synthesize lastNameTextField               = _lastNameTextField;
@synthesize byLineTextField                 = _byLineTextField;

@synthesize user                            = _user;

@synthesize navTitleView                    = _navTitleView;
@synthesize navRightBarButtonView           = _navRightBarButtonView;

@synthesize usersController                 = _usersController;


//----------------------------------------------------------------------------------------------------
- (id)initWithUser:(DWUser*)user {
	self = [super init];
	
	if(self) {        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate   = self;
        self.user                       = user;
	}
    
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.firstNameTextField             = nil;
    self.lastNameTextField              = nil;
	self.byLineTextField                = nil;
    
    self.user                           = nil;
    
    self.navTitleView                   = nil;
	self.navRightBarButtonView          = nil;
    
    self.usersController                = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem           = [DWGUIManager customBackButton:self];
    self.navigationItem.hidesBackButton             = YES;
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kUpdateUserDetailsText];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
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
