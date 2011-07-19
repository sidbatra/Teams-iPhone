//
//  DWCreateTeamViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWCreateTeamViewController.h"
#import "DWGUIManager.h"
#import "DWConstants.h"
#import "DWTeam.h"

static NSString* const kCreateTeamText                  = @"Create New Team";
static NSString* const kRightNavBarButtonText           = @"Next";
static NSString* const kMsgIncompleteTitle              = @"Incomplete";
static NSString* const kMsgIncomplete                   = @"Enter team name and byline";
static NSString* const kMsgErrorTitle                   = @"Error";
static NSString* const kMsgCancelTitle                  = @"OK";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreateTeamViewController

@synthesize teamNameTextField           = _teamNameTextField;
@synthesize teamBylineTextField         = _teamBylineTextField;

@synthesize domain                      = _domain;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;

@synthesize teamsController             = _teamsController;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)theDelegate {
    
    self = [super init];
    
    if (self) {
        
        self.teamsController            = [[[DWTeamsController alloc] init] autorelease];        
        self.teamsController.delegate   = self;
        _hasCreatedTeam                 = NO;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.teamNameTextField          = nil;
    self.teamBylineTextField        = nil;
    
    self.domain                     = nil;
    
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
- (void)prePopulateViewWithName:(NSString*)name byline:(NSString*)byline andTeamID:(NSInteger)teamID {
    self.teamNameTextField.text         = name;
    self.teamBylineTextField.text       = byline;
    
    _teamID                             = teamID;
    _hasCreatedTeam                     = YES;
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
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
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
- (void)createTeam {
    if (self.teamNameTextField.text.length == 0 || self.teamBylineTextField.text.length == 0) {
        [self displayEmptyFieldsError];
	}
	else {
        [self.teamsController createTeamWithName:self.teamNameTextField.text 
                                          byline:self.teamBylineTextField.text 
                                       andDomain:self.domain];        
    }
}

//----------------------------------------------------------------------------------------------------
- (void)updateTeam {
    if (self.teamNameTextField.text.length == 0 ||  self.teamBylineTextField.text.length == 0) {
        [self displayEmptyFieldsError];
	}
	else {
     [self.teamsController updateTeamHavingID:_teamID 
                                        withName:self.teamNameTextField.text 
                                          byline:self.teamBylineTextField.text 
                                       andDomain:self.domain];        
    }
}

//----------------------------------------------------------------------------------------------------
-(void)createOrUpdateTeam {
    if (!_hasCreatedTeam)
        [self createTeam];
    else
        [self updateTeam];       
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self createOrUpdateTeam];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)teamCreated:(DWTeam*)team {     
    _hasCreatedTeam = YES;
    _teamID         = team.databaseID;
    
    [self.delegate teamCreated:team];
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
}

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(DWTeam*)team { 
    _hasCreatedTeam = YES;    
    [self.delegate teamCreated:team];
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
