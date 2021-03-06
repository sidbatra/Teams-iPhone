//
//  DWOnboardingContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWOnboardingContainerViewController.h"
#import "DWGUIManager.h"
#import "DWSession.h"
#import "DWConstants.h"


static NSString* const kMsgInviteAlertText      = @"There is no I in Team";
static NSString* const kMsgInviteMessageText    = @"Grow your Team.";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWOnboardingContainerViewController

@synthesize splashScreenViewController      = _splashScreenViewController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.splashScreenViewController = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)displayCreateProfileView:(DWTeam*)team {
    
    DWCreateProfileViewController *createProfileViewController  = [[[DWCreateProfileViewController alloc] init] autorelease];
    createProfileViewController.delegate                        = self;
    createProfileViewController.userID                          = [DWSession sharedDWSession].currentUser.databaseID;
    createProfileViewController.teamName                        = [DWSession sharedDWSession].currentUser.team.name;
    
    [self.navigationController pushViewController:createProfileViewController 
                                         animated:YES];
    
    if ([[DWSession sharedDWSession] state] >= kSessionStateTillUserDetails) 
        [createProfileViewController prePopulateViewWithFirstName:[DWSession sharedDWSession].currentUser.firstName 
                                                         lastName:[DWSession sharedDWSession].currentUser.lastName  
                                                           byLine:[DWSession sharedDWSession].currentUser.byline  
                                                      andPassword:[DWSession sharedDWSession].currentUser.encryptedPassword]; 
}

//----------------------------------------------------------------------------------------------------
- (void)dismissInviteController {
    [DWSession sharedDWSession].currentUser.hasInvitedPeople = YES;
    [[DWSession sharedDWSession] update]; 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLogsIn 
                                                        object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.parentViewController dismissModalViewControllerAnimated:NO]; 
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
        
    self.navigationController.navigationBarHidden           = YES;
    self.navigationController.navigationBar.clipsToBounds   = NO;
        
    self.splashScreenViewController                         = [[[DWSplashScreenViewController alloc] init] autorelease];
    self.splashScreenViewController.delegate                = self;
    
    [self.view addSubview:self.splashScreenViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSplashScreenViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)loginInitiated {
    
    DWLoginViewController *loginViewController  = [[[DWLoginViewController alloc] init] autorelease];
    loginViewController.delegate                = self;
    
    [self.navigationController pushViewController:loginViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)signupInitiated {
    
    DWSignupViewController *signupViewController    = [[[DWSignupViewController alloc] init] autorelease];
    signupViewController.delegate                   = self;
    
    [self.navigationController pushViewController:signupViewController 
                                         animated:YES];
    
    if ([[DWSession sharedDWSession] state] >= kSessionStateTillUserEmail) 
        [signupViewController prePopulateViewWithEmail:[DWSession sharedDWSession].currentUser.email 
                                             andUserID:[DWSession sharedDWSession].currentUser.databaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWLoginViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoggedIn:(DWUser*)user {
    
    [[DWSession sharedDWSession] create:user];
    
    [DWSession sharedDWSession].currentUser.hasInvitedPeople = YES;
    [[DWSession sharedDWSession] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserLogsIn 
                                                        object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:NO];    
    [self.parentViewController dismissModalViewControllerAnimated:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSignupViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(DWUser*)user {
    [[DWSession sharedDWSession] create:user];     
}

//----------------------------------------------------------------------------------------------------
- (void)userEmailUpdated {
    [[DWSession sharedDWSession] update];     
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam*)team {
    
    if (team) {        
        DWJoinTeamViewController *joinTeamViewController        = [[[DWJoinTeamViewController alloc] init] autorelease];
        joinTeamViewController.delegate                         = self;
        joinTeamViewController.team                             = team;
        
        [joinTeamViewController setUsersDelegate:self];
        
        [self.navigationController pushViewController:joinTeamViewController 
                                             animated:YES];
    }
    else {
        DWCreateTeamViewController *createTeamViewController    = [[[DWCreateTeamViewController alloc] init] autorelease];
        createTeamViewController.delegate                       = self;
        createTeamViewController.domain                         = [[DWSession sharedDWSession].currentUser getDomainFromEmail];
        
        [self.navigationController pushViewController:createTeamViewController 
                                             animated:YES];        
    }    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateTeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamCreated:(DWTeam*)team {
    team.membersCount = 1;
    
    [DWSession sharedDWSession].currentUser.team = team;
    [[DWSession sharedDWSession] update];
    
    [self displayCreateProfileView:team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWJoinTeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamJoined:(DWTeam*)team {
    team.membersCount = team.membersCount + 1;
    
    [DWSession sharedDWSession].currentUser.team = team;
    [[DWSession sharedDWSession] update];    
    
    [self displayCreateProfileView:team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userDetailsUpdated {
    [[DWSession sharedDWSession] update];     
    
    DWAddProfilePicViewController *addProfilePicViewController  = [[[DWAddProfilePicViewController alloc] init] autorelease];
    addProfilePicViewController.delegate                        = self;
    addProfilePicViewController.userID                          = [DWSession sharedDWSession].currentUser.databaseID; 
    addProfilePicViewController.userFBToken                     = [DWSession sharedDWSession].currentUser.facebookAccessToken;    
    addProfilePicViewController.teamID                          = [DWSession sharedDWSession].currentUser.team.databaseID;  
    
    [self.navigationController pushViewController:addProfilePicViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWAddProfilePicViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userPhotoUpdated {
    [[DWSession sharedDWSession] update];     
}

//----------------------------------------------------------------------------------------------------
- (void)membershipCreated {
    [[DWSession sharedDWSession] update]; 
    
    DWInvitePeopleViewController *invitePeopleViewController    = [[[DWInvitePeopleViewController alloc] init] autorelease];
    invitePeopleViewController.delegate                         = self;
    
    invitePeopleViewController.showTopShadow                    = YES;
    invitePeopleViewController.addBackgroundView                = YES;
        
    invitePeopleViewController.navBarTitle                      = kAddPeopleText;
    invitePeopleViewController.navBarSubTitle                   = [NSString 
                                                                   stringWithFormat:kAddPeopleSubText,
                                                                                    [DWSession sharedDWSession].currentUser.team.name];
    
    invitePeopleViewController.messageLabelText                 = kMsgInviteMessageText;
    
    
    if ([DWSession sharedDWSession].currentUser.team.membersCount == 1) 
        invitePeopleViewController.inviteAlertText = kMsgInviteAlertText; 
    else
        invitePeopleViewController.enforceInvite = NO;
    
    
    [self.navigationController pushViewController:invitePeopleViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWInvitePeopleViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)peopleInvitedToATeam {
    [self dismissInviteController];
}

//----------------------------------------------------------------------------------------------------
- (void)inviteSkipped {
    [self dismissInviteController];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController setNavigationBarHidden:YES 
                                             animated:YES];
}

@end
