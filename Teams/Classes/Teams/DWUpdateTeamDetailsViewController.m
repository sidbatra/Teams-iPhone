//
//  DWUpdateTeamDetailsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUpdateTeamDetailsViewController.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWGUIManager.h"
#import "DWConstants.h"
#import "DWTeam.h"

static NSString* const kUpdateTeamDetailsText           = @"Edit Team";
static NSString* const kRightNavBarButtonText           = @"Save";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter team name and byline";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUpdateTeamDetailsViewController

@synthesize teamNameTextField           = _teamNameTextField;
@synthesize teamBylineTextField         = _teamBylineTextField;

@synthesize team                        = _team;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;

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
    
    self.team                       = nil;
        
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;
    
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
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager customBackButton:self];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc]
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kUpdateTeamDetailsText];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                       title:kRightNavBarButtonText 
                                       andTarget:self] autorelease];
    
    self.teamNameTextField.text         = self.team.name;
    self.teamBylineTextField.text       = self.team.byline;
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
    NSLog(@"team update request sent");
    [self updateTeam];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam*)team { 
    NSLog(@"team updated");
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
