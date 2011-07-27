//
//  DWCreateTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateTeamViewController.h"

#import "DWConstants.h"
#import "DWTeam.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"

static NSString* const kCreateTeamText                  = @"Create New Team";
static NSString* const kRightNavBarButtonText           = @"Next";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter team name and byline";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMessageLabelText                = @"Open to friends and colleagues with a @%@ address:";
static NSString* const kMsgProcesssing                  = @"Creating new Team ...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateTeamViewController

@synthesize teamNameTextField           = _teamNameTextField;
@synthesize teamBylineTextField         = _teamBylineTextField;
@synthesize messageLabel                = _messageLabel;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize domain                      = _domain;

@synthesize navTitleView                = _navTitleView;
@synthesize navBarRightButtonView       = _navBarRightButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;

@synthesize teamsController             = _teamsController;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if (self) {
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];        
        self.teamsController.delegate   = self;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.teamNameTextField          = nil;
    self.teamBylineTextField        = nil;
    self.messageLabel               = nil;
    self.spinnerContainerView       = nil;
    
    self.domain                     = nil;
    
    self.navTitleView               = nil;
    self.navBarRightButtonView      = nil;
    self.spinnerOverlayView         = nil;
    
    self.teamsController            = nil;
    
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
    
    [self.navTitleView displayTitle:kCreateTeamText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(50,170)
                                                                        andMessageText:kMsgProcesssing] autorelease];

    
    self.messageLabel.text = [NSString stringWithFormat:kMessageLabelText,self.domain];
    [self.teamNameTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
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
- (void)createTeam {
    if (self.teamNameTextField.text.length == 0 || self.teamBylineTextField.text.length == 0) {
        [self displayEmptyFieldsError];
	}
	else {
        [self freezeUI];
        [self.teamsController createTeamWithName:self.teamNameTextField.text 
                                          byline:self.teamBylineTextField.text 
                                       andDomain:self.domain];        
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self createTeam];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	
	if(textField == self.teamNameTextField) {
		[self.teamNameTextField resignFirstResponder];
		[self.teamBylineTextField becomeFirstResponder];
	}
	else if(textField == self.teamBylineTextField) {
		[self createTeam];
	}
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)teamCreated:(DWTeam*)team {
    [self.delegate teamCreated:team];
    [self unfreezeUI];    
}

//----------------------------------------------------------------------------------------------------
- (void)teamCreationError:(NSString*)error {
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
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];            
}

@end
