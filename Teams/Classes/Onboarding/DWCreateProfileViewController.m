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
#import "DWGUIManager.h"

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

@synthesize navTitleView                    = _navTitleView;
@synthesize navRightBarButtonView           = _navRightBarButtonView;

@synthesize delegate                        = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {        
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreated:) 
													 name:kNNewUserCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userError:) 
													 name:kNNewUserError
												   object:nil];
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
    
    self.navTitleView                   = nil;
	self.navRightBarButtonView          = nil;
	
    [super dealloc];
}

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
    
    [self.navTitleView displayTitle:kCreateProfileText 
                        andSubTitle:[NSString stringWithFormat:kCreateProfileSubText,@"Twitter"]];
    
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
    //[super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {
	//[self.firstNameTextField resignFirstResponder];
    //[self.lastNameTextField resignFirstResponder];
	//[self.emailTextField resignFirstResponder];
	//[self.passwordTextField resignFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
	[self.firstNameTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)createNewUser {
	
	if (self.byLineTextField.text.length == 0 || 
        self.firstNameTextField.text.length == 0 ||
        self.lastNameTextField.text.length == 0 ||
        self.passwordTextField.text.length == 0) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else {			
		if(!_signupInitiated)
			[self freezeUI];
		
		if(!_isUploading) {
			
			_signupInitiated    = NO;
			self.password       = [[self.passwordTextField.text encrypt] stringByEncodingHTMLCharacters];
			
            /*
			[[DWRequestsManager sharedDWRequestsManager] createUserWithFirstName:self.firstNameTextField.text 
                                                                    withLastName:self.lastNameTextField.text
                                                                       withEmail:self.emailTextField.text
                                                                    withPassword:self.password
                                                               withPhotoFilename:kEmptyString];*/
             
		}
		else
			_signupInitiated    = YES;
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBAction methods
//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
    [self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self.delegate profileCreated];
	//[self createNewUser];
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
		[self createNewUser];
	}
	
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications
//----------------------------------------------------------------------------------------------------
- (void)userCreated:(NSNotification*)notification {
	/*
	NSDictionary *info = [notification userInfo];
	NSDictionary *body = [info objectForKey:kKeyBody];
	
	if([[info objectForKey:kKeyStatus] isEqualToString:kKeySuccess]) {
		
        DWUser *user            = (DWUser*)[[DWMemoryPool sharedDWMemoryPool] getOrSetObject:[body objectForKey:kKeyUser]
                                                                                       atRow:kMPUsersIndex];        
        user.encryptedPassword  = self.password;

		
		[[DWSession sharedDWSession] create:user];
        
		[[NSNotificationCenter defaultCenter] postNotificationName:kNUserLogsIn 
                                                            object:user];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
														message:[[body objectForKey:kKeyUser] objectForKey:kKeyErrorMessages]
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self unfreezeUI];
	}
	*/
}

//----------------------------------------------------------------------------------------------------
- (void)userError:(NSNotification*)notification {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:kMsgErrorNetwork
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
