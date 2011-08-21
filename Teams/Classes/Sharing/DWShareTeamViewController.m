//
//  DWShareTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWShareTeamViewController.h"

#import "DWTeam.h"
#import "DWTeamsHelper.h"
#import "DWGUIManager.h"
#import "DWConstants.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWSession.h"


static NSInteger const kMaxTwitterDataLength        = 104;
static NSString* const kMsgIncompleteTitle          = @"Incomplete";
static NSString* const kMsgIncomplete               = @"Please choose a network";
static NSString* const kMsgErrorAlertTitle          = @"Low connectivity";
static NSString* const kMsgTwitterError             = @"Can't connect to Twitter";
static NSString* const kMsgCancelTitle              = @"OK";
static NSString* const kMsgDefault                  = @"Sharing...";
static NSString* const kMsgLoggingIn                = @"Logging in...";
static NSString* const kNavBarRightButtonText       = @"Share";
static NSString* const kTitle                       = @"Share this Team";
static NSString* const kMsgShareTeam                = @"Check out the %@ Team: %@";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWShareTeamViewController

@synthesize facebookConnect             = _facebookConnect;
@synthesize twitterConnect              = _twitterConnect;

@synthesize team                        = _team;
@synthesize usersController             = _usersController;

@synthesize dataTextView                = _dataTextView;
@synthesize facebookSwitch              = _facebookSwitch;
@synthesize twitterSwitch               = _twitterSwitch;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize navBarRightButtonView       = _navBarRightButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;



//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.facebookConnect                = [[[DWFacebookConnect alloc] init] autorelease];
        self.facebookConnect.delegate       = self;
        self.facebookConnect.accessToken    = [DWSession sharedDWSession].currentUser.facebookAccessToken;
        
        self.twitterConnect                 = [[[DWTwitterConnect alloc] init] autorelease];
        self.twitterConnect.delegate        = self;        
        self.twitterConnect.xAuthToken      = [DWSession sharedDWSession].currentUser.twitterXAuthToken;
        
        self.usersController                = [[[DWUsersController alloc] init] autorelease];    
        self.usersController.delegate       = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	    
    self.facebookConnect        = nil;
    self.twitterConnect         = nil;
    
    self.team                   = nil;
    self.usersController        = nil;
    
    self.dataTextView           = nil;
    self.facebookSwitch         = nil;
    self.twitterSwitch          = nil;
    self.spinnerContainerView   = nil;
    
    self.navBarRightButtonView  = nil;
    self.spinnerOverlayView     = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:kTitle];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                       title:kNavBarRightButtonText 
                                       andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(112,134)
                                                                        andMessageText:kMsgDefault] autorelease];
    
    self.dataTextView.text = [NSString stringWithFormat:kMsgShareTeam,
                                                        self.team.name,
                                                        [DWTeamsHelper webURIForTeam:self.team]];
        
    self.facebookSwitch.on  = self.facebookConnect.accessToken ? YES : NO;
    self.twitterSwitch.on   = self.twitterConnect.xAuthToken   ? YES : NO;    
    
    [self.dataTextView becomeFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Functions

//----------------------------------------------------------------------------------------------------
- (void)freezeUIWithMessage:(NSString*)message {
    
    self.spinnerContainerView.hidden = NO;
    
    [self.spinnerOverlayView setMessageText:message];
    [self.spinnerOverlayView enable];
}

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {
    [self freezeUIWithMessage:kMsgDefault];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
    self.spinnerContainerView.hidden = YES;
    [self.spinnerOverlayView disable];
}

//----------------------------------------------------------------------------------------------------
- (void)createFacebookPost {    
    [self freezeUI];
    [self.facebookConnect createWallPostWithMessage:self.dataTextView.text
                                               name:@"Teams"
                                        description:@" " 
                                            caption:self.team.name
                                               link:[DWTeamsHelper webURIForTeam:self.team]
                                         pictureURL:kEmptyString];
}

//----------------------------------------------------------------------------------------------------
- (void)createTweet {
    [self freezeUI];
    [self.twitterConnect createTweetWithText:self.dataTextView.text];    
}

//----------------------------------------------------------------------------------------------------
- (void)share {
    
    if (!self.facebookSwitch.on && !self.twitterSwitch.on) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
                                                        message:kMsgIncomplete
                                                       delegate:nil 
                                              cancelButtonTitle:kMsgCancelTitle
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if (self.facebookSwitch.on && self.facebookSwitch.enabled && [self.facebookConnect authenticate]) 
        [self createFacebookPost];
    
    if (self.twitterSwitch.on && self.twitterSwitch.enabled && [self.twitterConnect authenticate]) 
        [self createTweet];     
}

//----------------------------------------------------------------------------------------------------
- (void)finishedSharing {
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextViewDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	NSUInteger newLength = [self.dataTextView.text length] + [text length] - range.length;
    
    if([text isEqualToString:@"\n"]) {
        [self share];
        return NO;
    }
    
    return (newLength > kMaxTwitterDataLength) ? NO : YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)facebookSwitchToggled:(id)sender {
    
    if (self.facebookSwitch.on && ![self.facebookConnect authenticate]) 
        [self.dataTextView resignFirstResponder];

}

//----------------------------------------------------------------------------------------------------
- (IBAction)twitterSwitchToggled:(id)sender {
    
    if (self.twitterSwitch.on)
        [self.twitterConnect authenticate];

}

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self share];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWFacebookConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticated {
    
    [self.dataTextView becomeFirstResponder];    

    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                           withFacebookToken:self.facebookConnect.accessToken];
}

//----------------------------------------------------------------------------------------------------
- (void)fbAuthenticationFailed {
    self.facebookSwitch.on = NO;    
    [self.dataTextView becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)fbRequestLoaded:(id)result {
    
    _sharedToFacebook               = YES;
    self.facebookSwitch.enabled     = NO;
    
    if (!self.twitterSwitch.on || _sharedToTwitter) 
        [self finishedSharing];
}

//----------------------------------------------------------------------------------------------------
- (void)fbRequestFailed:(NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorAlertTitle
													message:[error localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
    if (_sharedToTwitter) 
        self.twitterSwitch.enabled = NO;
    
    [self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTwitterConnectDelegate

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticatedWithToken:(NSString*)token andSecret:(NSString*)secret {    
    self.twitterSwitch.on = YES;    
    [self unfreezeUI];
    
    [self.usersController updateUserHavingID:[DWSession sharedDWSession].currentUser.databaseID 
                            withTwitterToken:token 
                            andTwitterSecret:secret];
}

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticating {
    [self freezeUIWithMessage:kMsgLoggingIn];
}

//----------------------------------------------------------------------------------------------------
- (void)twAuthenticationFailed {
    self.twitterSwitch.on = NO;
    [self unfreezeUI];
}

//----------------------------------------------------------------------------------------------------
- (void)twSharingDone {
    
    _sharedToTwitter            = YES;
    self.twitterSwitch.enabled  = NO;
    
    if (!self.facebookSwitch.on || _sharedToFacebook) 
        [self finishedSharing];
}

//----------------------------------------------------------------------------------------------------
- (void)twSharingFailed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorAlertTitle
													message:kMsgTwitterError
												   delegate:nil 
										  cancelButtonTitle:kMsgCancelTitle
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
    if (_sharedToFacebook) 
        self.facebookSwitch.enabled = NO;

	[self unfreezeUI];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UsersController Delegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    [user destroy];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {
    //Analytics
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
