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
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"


static NSString* const kRegexNonWorkEmails              = @"@(gmail|yahoo|aim|hotmail|aol|live|msn)\\.";
static NSString* const kSignupText                      = @"Sign Up";
static NSString* const kNavBarRightButtonText           = @"Next";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Please enter the email you use at your organization";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMsgProcesssing                  = @"Searching existing Teams...";
static NSString* const kMsgEmailError                   = @"Please enter the email you use at your organization";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSignupViewController

@synthesize emailTextField              = _emailTextField;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize password                    = _password;

@synthesize navTitleView                = _navTitleView;
@synthesize navBarRightButtonView       = _navBarRightButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;

@synthesize usersController             = _usersController;
@synthesize teamsController             = _teamsController;

@synthesize delegate                    = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.usersController            = [[DWUsersController alloc] init];    
        self.usersController.delegate   = self;
        
        self.teamsController            = [[DWTeamsController alloc] init];        
        self.teamsController.delegate   = self;
        
        _hasCreatedUser                 = NO;
        _teamResourceID                 = [[NSDate date] timeIntervalSince1970];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem  = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    if (!self.navTitleView)
        self.navTitleView = [[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self];
    
    [self.navTitleView displayTitle:kSignupText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(52,134)
                                                                        andMessageText:kMsgProcesssing];
    
    [self.emailTextField becomeFirstResponder];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad];
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
- (BOOL)isWorkEmail:(NSString*)email {
    
    NSError *error              = NULL;
    NSRegularExpression *regex  = [NSRegularExpression regularExpressionWithPattern:kRegexNonWorkEmails
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    NSUInteger numberOfMatches  = [regex numberOfMatchesInString:email
                                                         options:0
                                                           range:NSMakeRange(0, [email length])];
    
    return numberOfMatches == 0;
}

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
}

//----------------------------------------------------------------------------------------------------
- (void)displayIncorrectEmailError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:kMsgEmailError
                                                   delegate:nil 
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles: nil];
    [alert show];
}

//----------------------------------------------------------------------------------------------------
- (void)createUser {	
	if (self.emailTextField.text.length == 0) {        
        [self displayEmptyFieldsError];
	}
	else {			
        if ([self isWorkEmail:self.emailTextField.text]) {
            
            [self freezeUI];
            self.password = [[NSString randomString] encrypt];        
            
            [self.usersController createUserWithEmail:self.emailTextField.text 
                                          andPassword:self.password];	
        }
        else {
            [self displayIncorrectEmailError];
        }
    }
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"user_created"
                                                               andExtraInfo:[NSString stringWithFormat:@"email=%@",
                                                                             self.emailTextField.text]];

}

//----------------------------------------------------------------------------------------------------
- (void)updateUser {
	if (self.emailTextField.text.length == 0) {        
        [self displayEmptyFieldsError];
	}
	else {		
        if ([self isWorkEmail:self.emailTextField.text]) {
            
            [self freezeUI];
            [self.usersController updateUserHavingID:_userID 
                                           withEmail:self.emailTextField.text];
        }
        else {
            [self displayIncorrectEmailError];
        }
    }    
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"user_updated"
                                                               andExtraInfo:[NSString stringWithFormat:@"email=%@",
                                                                             self.emailTextField.text]];
}

//----------------------------------------------------------------------------------------------------
- (void)createOrUpdateUser {
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
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self createOrUpdateUser];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.emailTextField)
		[self createOrUpdateUser];

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
    [self.teamsController getTeamFromDomain:domain 
                              andResourceID:_teamResourceID];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSString*)error {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
    
    [self unfreezeUI];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"create_failed"];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {    

    [self.delegate userEmailUpdated];

    NSString *domain = [user getDomainFromEmail];        
    [self.teamsController getTeamFromDomain:domain 
                              andResourceID:_teamResourceID];
    
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
    
    [self unfreezeUI];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"update_failed"];
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
    [self unfreezeUI];
    [self.delegate teamLoaded:team];    
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSString*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
													message:error
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles:nil];
	[alert show];
    
    [self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];        
}

@end
