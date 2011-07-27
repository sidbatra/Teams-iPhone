//
//  DWCreateProfileViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateProfileViewController.h"

#import "NSString+Helpers.h"
#import "DWConstants.h"
#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"


static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter first name, last name, email and password";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgCancelTitle          = @"OK";
static NSString* const kCreateProfileText       = @"Add Yourself";
static NSString* const kCreateProfileSubText    = @"to the %@ Team";
static NSString* const kNavBarRightButtonText   = @"Next";
static NSString* const kMsgProcesssing          = @"Creating your profile...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateProfileViewController

@synthesize firstNameTextField              = _firstNameTextField;
@synthesize lastNameTextField               = _lastNameTextField;
@synthesize byLineTextField                 = _byLineTextField;
@synthesize passwordTextField               = _passwordTextField;
@synthesize spinnerContainerView            = _spinnerContainerView;

@synthesize password                        = _password;
@synthesize teamName                        = _teamName;
@synthesize userID                          = _userID;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize usersController                 = _usersController;

@synthesize delegate                        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.usersController            = [[[DWUsersController alloc] init] autorelease];        
        self.usersController.delegate   = self;
        
        _hasPasswordChanged             = NO;
	}
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	
	self.firstNameTextField             = nil;
    self.lastNameTextField              = nil;
	self.byLineTextField                = nil;
	self.passwordTextField              = nil;
    self.spinnerContainerView           = nil;
    
    self.password                       = nil;    
    self.teamName                       = nil;
    
    self.navTitleView                   = nil;
	self.navBarRightButtonView          = nil;
    self.spinnerOverlayView             = nil;
    
    self.usersController                = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kCreateProfileText 
                        andSubTitle:[NSString stringWithFormat:kCreateProfileSubText,self.teamName]];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(50,120)
                                                                        andMessageText:kMsgProcesssing] autorelease];
    
    
	[self.firstNameTextField becomeFirstResponder];
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
- (void)prePopulateViewWithFirstName:(NSString*)firstName lastName:(NSString*)lastName 
                              byLine:(NSString*)byLine andPassword:(NSString*)password {
    
    self.firstNameTextField.text        = firstName;
    self.lastNameTextField.text         = lastName;
    self.byLineTextField.text           = byLine;
    self.passwordTextField.text         = @"random";
    self.password                       = password;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {	
    self.spinnerContainerView.hidden = NO;
    [self.spinnerOverlayView enable];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
    self.spinnerContainerView.hidden = YES;
    [self.spinnerOverlayView disable];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUser {

	if (self.byLineTextField.text.length == 0 || 
        self.firstNameTextField.text.length == 0 ||
        self.lastNameTextField.text.length == 0 ||
        self.passwordTextField.text.length == 0) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {			
        [self freezeUI];
        
        if(_hasPasswordChanged)
            self.password = [self.passwordTextField.text encrypt];

        [self.usersController updateUserHavingID:self.userID 
                                   withFirstName:self.firstNameTextField.text 
                                        lastName:self.lastNameTextField.text 
                                          byline:self.byLineTextField.text 
                                     andPassword:self.password];                                  
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction methods

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
	[self updateUser];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	
	if(textField == self.firstNameTextField) {
		[self.firstNameTextField resignFirstResponder];
		[self.lastNameTextField becomeFirstResponder];
	}
    else if(textField == self.lastNameTextField) {
        [self.lastNameTextField resignFirstResponder];
        [self.byLineTextField becomeFirstResponder];
    }
	else if(textField == self.byLineTextField) {
		[self.byLineTextField resignFirstResponder];
		[self.passwordTextField becomeFirstResponder];
	}
	else if(textField == self.passwordTextField) {
		[self updateUser];
	}
	
	return YES;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    
    if (textField == self.passwordTextField) {
        self.passwordTextField.text = kEmptyString;
        _hasPasswordChanged         = YES;
    }
    return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersController Delegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    if ([NSStringFromClass([self.navigationController.topViewController class]) isEqualToString:@"DWCreateProfileViewController"]) {
        user.encryptedPassword = self.password;
    
        [self.delegate userDetailsUpdated];
        [self unfreezeUI];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
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
    [self.firstNameTextField becomeFirstResponder];    
    
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];
}


@end
