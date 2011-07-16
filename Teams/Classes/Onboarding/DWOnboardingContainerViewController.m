//
//  DWOnboardingContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWOnboardingContainerViewController.h"
#import "DWGUIManager.h"
#import "DWSession.h"
#import "DWConstants.h"


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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationController.navigationBarHidden   = YES;
    
    self.splashScreenViewController                 = [[[DWSplashScreenViewController alloc] init] autorelease];
    self.splashScreenViewController.delegate    	= self;
    
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
    [self.parentViewController dismissModalViewControllerAnimated:YES];
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
- (void)userUpdated:(DWUser*)user {
    [[DWSession sharedDWSession] create:user];     
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(DWTeam*)team {
    
    if (team) {
        NSLog(@"team already exist");
    }
    else {
        DWCreateTeamViewController *createTeamViewController    = [[[DWCreateTeamViewController alloc] init] autorelease];
        createTeamViewController.delegate                       = self;
        createTeamViewController.domain                         = [[DWSession sharedDWSession].currentUser getDomainFromEmail];
        
        [self.navigationController pushViewController:createTeamViewController 
                                             animated:YES];        
        
        if ([[DWSession sharedDWSession] state] >= kSessionStateTillTeamDetails) 
            [createTeamViewController prePopulateViewWithName:[DWSession sharedDWSession].currentUser.team.name
                                                       byline:[DWSession sharedDWSession].currentUser.team.byline
                                                    andTeamID:[DWSession sharedDWSession].currentUser.team.databaseID];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateNewTeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamCreated:(DWTeam*)team {
    
    [DWSession sharedDWSession].currentUser.team = team;
    [[DWSession sharedDWSession] update];
    
    DWCreateProfileViewController *createProfileViewController  = [[[DWCreateProfileViewController alloc] init] autorelease];
    createProfileViewController.delegate                        = self;
    
    [self.navigationController pushViewController:createProfileViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateUserProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)profileCreated {
    
    DWInvitePeopleViewController *invitePeopleViewController    = [[[DWInvitePeopleViewController alloc] init] autorelease];
    invitePeopleViewController.delegate                         = self;
    
    [self.navigationController pushViewController:invitePeopleViewController 
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateUserProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)peopleInvited {
    //TODO
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
