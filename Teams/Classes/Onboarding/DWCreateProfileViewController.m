//
//  DWCreateProfileViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateProfileViewController.h"
#import "DWUser.h"
#import "DWRequestsManager.h"
#import "NSString+Helpers.h"
#import "DWSession.h"
#import "DWMemoryPool.h"
#import "DWConstants.h"

static NSString* const kMsgProgressIndicator    = @"Signing Up";
static NSString* const kMsgIncompleteTitle      = @"Incomplete";
static NSString* const kMsgIncomplete           = @"Enter first name, last name, email and password";
static NSString* const kMsgErrorTitle           = @"Error";
static NSString* const kMsgErrorNetwork         = @"Please make sure you have network connectivity and try again";
static NSString* const kMsgCancelTitle          = @"OK";
static NSInteger const kPreviewSize             = 75;
static NSString* const kCreateProfileText       = @"Add Yourself";
static NSString* const kCreateProfileSubText    = @"to the %@ Team";
static NSString* const kRightNavBarButtonText   = @"Next";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateProfileViewController

@synthesize profileDetailsContainerView     = _profileDetailsContainerView;
@synthesize firstNameTextField              = _firstNameTextField;
@synthesize lastNameTextField               = _lastNameTextField;
@synthesize byLineTextField                 = _byLineTextField;
@synthesize passwordTextField               = _passwordTextField;

@synthesize password                        = _password;
@synthesize teamName                        = _teamName;
@synthesize userID                          = _userID;

@synthesize navTitleView                    = _navTitleView;
@synthesize navRightBarButtonView           = _navRightBarButtonView;

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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    self.profileDetailsContainerView    = nil;
	self.firstNameTextField             = nil;
    self.lastNameTextField              = nil;
	self.byLineTextField                = nil;
	self.passwordTextField              = nil;
    
    self.password                       = nil;    
    self.teamName                           = nil;
    
    self.navTitleView                   = nil;
	self.navRightBarButtonView          = nil;
    
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
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
    
	[[self.profileDetailsContainerView layer] setCornerRadius:2.5f];	
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
- (void)didTapDoneButton:(id)sender event:(id)event {
	[self updateUser];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if(textField == self.firstNameTextField) {
		[self.firstNameTextField resignFirstResponder];
		[self.lastNameTextField becomeFirstResponder];
	}
    else if(textField == self.lastNameTextField) {
        [self.lastNameTextField resignFirstResponder];
        [self.byLineTextField becomeFirstResponder];
    }
	if(textField == self.byLineTextField) {
		[self.byLineTextField resignFirstResponder];
		[self.passwordTextField becomeFirstResponder];
	}
	else if(textField == self.passwordTextField) {
		[self updateUser];
	}
	
	return YES;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
- (void)userUpdated:(DWUser *)user {
    user.encryptedPassword  = self.password;
    [self.delegate userDetailsUpdated:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString *)error {

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
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.firstNameTextField becomeFirstResponder];    
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
}


@end
