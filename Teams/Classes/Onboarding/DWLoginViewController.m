//
//  DWLoginViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWLoginViewController.h"
#import "DWUser.h"
#import "DWGUIManager.h"
#import "NSString+Helpers.h"
#import "DWConstants.h"

static NSString* const kMsgProgressIndicator    = @"Logging In";
static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter email and password";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kLoginText               = @"Log In";
static NSString* const kRightNavBarButtonText   = @"Done";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLoginViewController

@synthesize loginFieldsContainerView    = _loginFieldsContainerView;
@synthesize emailTextField              = _emailTextField;
@synthesize passwordTextField           = _passwordTextField;

@synthesize password                    = _password;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;

@synthesize sessionController           = _sessionController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.sessionController          = [[[DWSessionController alloc] init] autorelease];
        self.sessionController.delegate = self;
	}
    
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    self.loginFieldsContainerView   = nil;
	self.emailTextField             = nil;
	self.passwordTextField          = nil;
    
	self.password                   = nil;
    
    self.navTitleView               = nil;
	self.navRightBarButtonView      = nil;
    
    self.sessionController          = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager customBackButton:self.delegate];

    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kLoginText];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
    
	
	[[self.loginFieldsContainerView layer] setCornerRadius:2.5f];
	[self.emailTextField becomeFirstResponder];
	
    mbProgressIndicator         = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    mbProgressIndicator.yOffset = -87;
	[self.view addSubview:mbProgressIndicator];
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
- (void)freezeUI {	
	mbProgressIndicator.labelText = kMsgProgressIndicator;
	[mbProgressIndicator show:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
	[mbProgressIndicator hide:YES];
	[self.emailTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)authenticateCredentials {
	if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else {
		[self freezeUI];
		
		self.password = [self.passwordTextField.text encrypt];                
        [self.sessionController createSessionWithEmail:self.emailTextField.text
                                           andPassword:self.password];
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
	[self authenticateCredentials];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if(textField == self.emailTextField) {
		[self.emailTextField resignFirstResponder];
		[self.passwordTextField becomeFirstResponder];
	}
	else if(textField == self.passwordTextField) {
		[self authenticateCredentials];
	}

	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSessionController Delegate

//----------------------------------------------------------------------------------------------------
- (void)sessionCreatedForUser:(DWUser*)user {    
    user.encryptedPassword  = self.password;    
    [self.delegate userLoggedIn:user];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionCreationError:(NSString*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
	[self unfreezeUI];
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
