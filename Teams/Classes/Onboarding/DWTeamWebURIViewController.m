//
//  DWTeamWebURIViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamWebURIViewController.h"

#import "DWConstants.h"
#import "DWTeam.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"


static NSString* const kTeamOnWebText                   = @"On the Web";
static NSString* const kNavBarRightButtonText           = @"Next";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Your address should be at least one character long";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMsgProcesssing                  = @"Creating Team page...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamWebURIViewController

@synthesize teamHandleTextField         = _teamHandleTextField;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize team                        = _team;

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
    
    self.teamHandleTextField        = nil;
    self.spinnerContainerView       = nil;
    
    self.team                       = nil;
    
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
    
    self.navigationItem.hidesBackButton = YES;
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kTeamOnWebText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                       title:kNavBarRightButtonText 
                                       andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(67,134)
                                                                        andMessageText:kMsgProcesssing] autorelease];
    
    
    self.teamHandleTextField.text = self.team.handle;
    [self.teamHandleTextField becomeFirstResponder];
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
- (void)updateTeamHandle {    
    if (self.teamHandleTextField.text.length == 0) {
        [self displayEmptyFieldsError];
	}
	else {
        [self freezeUI];
        [self.teamsController updateTeamHavingID:self.team.databaseID 
                                      withHandle:self.teamHandleTextField.text];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self updateTeamHandle];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.teamHandleTextField)
        [self updateTeamHandle];
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam*)team { 
    [self unfreezeUI];
    [team destroy];
    
	[self.delegate teamHandleSelected];    
}

//----------------------------------------------------------------------------------------------------
- (void)teamUpdateError:(NSString*)error {
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
