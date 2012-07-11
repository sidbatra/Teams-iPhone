//
//  DWUpdateTeamDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateTeamDetailsViewController.h"

#import "DWConstants.h"
#import "DWSession.h"
#import "DWTeam.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWGUIManager.h"
#import "DWAnalyticsManager.h"


static NSString* const kUpdateTeamDetailsText           = @"Edit Team";
static NSString* const kNavBarRightButtonText           = @"Save";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter team name and byline";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";
static NSString* const kMessageLabelText                = @"@%@";
static NSString* const kMsgProcesssing                  = @"Updating team details...";


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
@synthesize navBarRightButtonView       = _navBarRightButtonView;
@synthesize spinnerOverlayView          = _spinnerOverlayView;

@synthesize teamsController             = _teamsController;


//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    
    self = [super init];
    
    if (self) {
        self.teamsController                = [[DWTeamsController alloc] init];        
        self.teamsController.delegate       = self;    
        self.team                           = team;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------

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
    
    self.navigationItem.leftBarButtonItem                   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    self.navigationController.navigationBar.clipsToBounds   = NO;
    
    if (!self.navTitleView)
        self.navTitleView = [[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self];
    
    [self.navTitleView displayTitle:kUpdateTeamDetailsText];
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView  = [[DWNavBarRightButtonView alloc]
                                        initWithFrame:CGRectMake(260,0,
                                                                 kNavRightButtonWidth,
                                                                 kNavRightButtonHeight) 
                                                title:kNavBarRightButtonText 
                                            andTarget:self];
    
    self.teamNameTextField.text     = self.team.name;
    self.teamBylineTextField.text   = self.team.byline;
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView     = [[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(67,178)
                                                                            andMessageText:kMsgProcesssing];
    
    
    self.messageLabel.text          = [NSString stringWithFormat:kMessageLabelText,
                                       [[DWSession sharedDWSession].currentUser getDomainFromEmail]];
    
    [self.teamBylineTextField becomeFirstResponder];
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad
                                                                 withViewID:self.team.databaseID];
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
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"team_updated"
                                                                 withViewID:self.team.databaseID
                                                               andExtraInfo:[NSString stringWithFormat:@"name=%@&byline=%@",
                                                                             self.teamNameTextField.text,
                                                                             self.teamBylineTextField.text]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self updateTeam];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	
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
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == self.teamNameTextField) 
        return (newLength > kMaxTeamNameLength) ? NO : YES;
    
    else if (textField == self.teamBylineTextField) 
        return (newLength > kMaxTeamBylineLength) ? NO : YES;        
    
    else
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

    [team destroy];
    
    [self unfreezeUI];
	[self.navigationController popViewControllerAnimated:YES];    
}

//----------------------------------------------------------------------------------------------------
- (void)teamUpdateError:(NSString*)error {
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
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];                
}


@end
