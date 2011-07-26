//
//  DWUpdateTeamDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateTeamDetailsViewController.h"

#import "DWConstants.h"
#import "DWSession.h"
#import "DWTeam.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"


static NSString* const kUpdateTeamDetailsText           = @"Edit Team";
static NSString* const kRightNavBarButtonText           = @"Save";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter team name and byline";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMessageLabelText                = @"Open to friends and colleagues with a @%@ address:";
static NSString* const kMsgProcesssing                  = @"Editing Team Details ...";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUpdateTeamDetailsViewController

@synthesize teamNameTextField           = _teamNameTextField;
@synthesize teamBylineTextField         = _teamBylineTextField;
@synthesize messageLabel                = _messageLabel;
@synthesize spinnerContainerView        = _spinnerContainerView;

@synthesize team                        = _team;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;

@synthesize teamsController             = _teamsController;


//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    
    self = [super init];
    
    if (self) {
        self.teamsController                = [[[DWTeamsController alloc] init] autorelease];        
        self.teamsController.delegate       = self;    
        self.team                           = team;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.teamNameTextField          = nil;
    self.teamBylineTextField        = nil;
    self.messageLabel               = nil;
    self.spinnerContainerView       = nil;
    
    self.team                       = nil;
        
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;
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
    
    self.navigationItem.leftBarButtonItem                   = [DWGUIManager customBackButton:self];
    self.navigationController.navigationBar.clipsToBounds   = NO;
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kUpdateTeamDetailsText];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView  = [[[DWNavRightBarButtonView alloc]
                                        initWithFrame:CGRectMake(260,0,
                                                                 kNavTitleViewWidth,
                                                                 kNavTitleViewHeight) 
                                                title:kRightNavBarButtonText 
                                            andTarget:self] autorelease];
    
    self.teamNameTextField.text     = self.team.name;
    self.teamBylineTextField.text   = self.team.byline;
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView     = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(50,170)
                                                                            andMessageText:kMsgProcesssing] autorelease];
    
    
    self.messageLabel.text          = [NSString stringWithFormat:kMessageLabelText,
                                       [[DWSession sharedDWSession].currentUser getDomainFromEmail]];
    
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
- (void)updateTeam {
    if (self.teamNameTextField.text.length == 0 ||  self.teamBylineTextField.text.length == 0) {
        [self displayEmptyFieldsError];
	}
	else {
        [self freezeUI];
        
        [self.teamsController updateTeamHavingID:self.team.databaseID 
                                        withName:self.teamNameTextField.text 
                                       andByline:self.teamBylineTextField.text];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self updateTeam];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if(textField == self.teamNameTextField) {
		[self.teamNameTextField resignFirstResponder];
		[self.teamBylineTextField becomeFirstResponder];
	}
	else if(textField == self.teamBylineTextField) {
		[self updateTeam];
	}
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam*)team { 
    [DWSession sharedDWSession].currentUser.team = team;
    [[DWSession sharedDWSession] update];

    [self unfreezeUI];
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
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
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
