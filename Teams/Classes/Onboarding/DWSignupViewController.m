//
//  DWSignupViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSignupViewController.h"

#import "NSString+Helpers.h"
#import "DWConstants.h"
#import "DWTeam.h"
#import "DWUser.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"


static NSString* const kSignupText                      = @"Sign Up";
static NSString* const kRightNavBarButtonText           = @"Next";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter your work email";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMsgProcesssing                  = @"Searching existing teams ...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSignupViewController

@synthesize emailTextField              = _emailTextField;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize password                    = _password;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;

@synthesize usersController             = _usersController;
@synthesize teamsController             = _teamsController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController            = [[[DWUsersController alloc] init] autorelease];    
        self.usersController.delegate   = self;
        
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];        
        self.teamsController.delegate   = self;
        
        _hasCreatedUser                 = NO;
        _teamResourceID                 = [[NSDate date] timeIntervalSince1970];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.emailTextField             = nil;
    self.spinnerContainerView       = nil;
    
    self.password                   = nil;
    
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;
    self.spinnerOverlayView         = nil;
    
    self.usersController            = nil;
    self.teamsController            = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem   =   [DWGUIManager customBackButton:self.delegate];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kSignupText];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(90,170)
                                                                        andMessageText:kMsgProcesssing] autorelease];
    
    [self.emailTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)prePopulateViewWithEmail:(NSString*)email andUserID:(NSInteger)userID {
    self.emailTextField.text    = email;
    
    _hasCreatedUser             = YES;
    _userID                     = userID;
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
- (void)displayEmptyFieldsError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
                                                    message:kMsgIncomplete
                                                   delegate:nil 
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

//----------------------------------------------------------------------------------------------------
- (void)createUser {	
	if (self.emailTextField.text.length == 0) {        
        [self displayEmptyFieldsError];
	}
	else {			
        [self freezeUI];
        self.password = [@"password" encrypt];        
        
        [self.usersController createUserWithEmail:self.emailTextField.text 
                                      andPassword:self.password];	
    }
}

//----------------------------------------------------------------------------------------------------
- (void)updateUser {
	if (self.emailTextField.text.length == 0) {        
        [self displayEmptyFieldsError];
	}
	else {		
        [self freezeUI];
        [self.usersController updateUserHavingID:_userID 
                                       withEmail:self.emailTextField.text];
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)createOrUdateUser {
    if (!_hasCreatedUser)
        [self createUser];
    else
        [self updateUser];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self createOrUdateUser];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	if(textField == self.emailTextField)
		[self createOrUdateUser];

	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersController Delegate

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(DWUser*)user {    
    
    user.encryptedPassword  = self.password;                
    _hasCreatedUser         = YES;
    _userID                 = user.databaseID;
    
    [self.delegate userCreated:user];
   
    NSString *domain = [user getDomainFromEmail];
    [self.teamsController getTeamFromDomain:domain andResourceID:_teamResourceID];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSString*)error {

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
- (void)userUpdated:(DWUser*)user {    
        
    if ([NSStringFromClass([self.navigationController.topViewController class]) isEqualToString:@"DWSignupViewController"]) {

        [self.delegate userEmailUpdated:user];
    
        NSString *domain = [user getDomainFromEmail];        
        [self.teamsController getTeamFromDomain:domain andResourceID:_teamResourceID];
    }
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
    
    [self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)teamResourceID {
    return _teamResourceID;
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam*)team {
    [self.delegate teamLoaded:team];
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString*)error {
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
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];        
}

@end
