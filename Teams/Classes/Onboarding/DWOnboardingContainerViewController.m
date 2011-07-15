//
//  DWOnboardingContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWOnboardingContainerViewController.h"
#import "DWGUIManager.h"
#import "DWSession.h"


/**
 * Private methods
 */
@interface DWOnboardingContainerViewController()

- (void) displaySplashScreen;
- (void) displayLoginView;
- (void) displaySignUpView;
- (void) displayCreateTeamView;
- (void) displayCreateProfileView;
- (void) displayInvitePeopleView;
    
@end

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWOnboardingContainerViewController


//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];	
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
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
- (void) displaySplashScreen {
    NSLog(@"splash screen");
    self.navigationController.navigationBarHidden = YES;
    
    DWSplashScreenViewController *splashScreen = [[[DWSplashScreenViewController alloc] initWithDelegate:self] autorelease];
    [self.view addSubview:splashScreen.view];
}

//----------------------------------------------------------------------------------------------------
- (void) displayLoginView {
    DWLoginViewController *loginViewController = [[[DWLoginViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:loginViewController animated:YES];    
}

//----------------------------------------------------------------------------------------------------
- (void) displaySignUpView {
    DWSignupViewController *signupViewController = [[[DWSignupViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:signupViewController animated:YES];    
}

//----------------------------------------------------------------------------------------------------
- (void) displayCreateTeamView {
    DWCreateTeamViewController *createTeamViewController = [[[DWCreateTeamViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:createTeamViewController animated:YES];      
}

//----------------------------------------------------------------------------------------------------
- (void) displayCreateProfileView {
    DWCreateProfileViewController *createProfileViewController = [[[DWCreateProfileViewController alloc] 
                                                                   initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:createProfileViewController animated:YES];    
}

//----------------------------------------------------------------------------------------------------
- (void) displayInvitePeopleView {
    DWInvitePeopleViewController *invitePeopleViewController = [[DWInvitePeopleViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:invitePeopleViewController animated:YES];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    /*
    switch ([[DWSession sharedDWSession] state])
	{
		case kSessionStateEmpty: 
            [self displaySplashScreen];
            break;
            
		case kSessionStateTillUserEmail: 
            [self displaySignUpView];
            break;
            
		case kSessionStateTillTeamDetails: 
            [self displayCreateProfileView];
            break; 
            
		case kSessionStateTillUserDetails: 
            [self displayInvitePeopleView];
            break;             
            
		default: 
            break;
	}*/
    [self displaySplashScreen];
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
    [self displayLoginView];
}

//----------------------------------------------------------------------------------------------------
- (void)signupInitiated {
    [self displaySignUpView];
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
- (void)teamLoaded:(DWTeam*)team {
    if (team) {
        NSLog(@"team already exist");
        //[self displayJoinTeamView];
    }
    else {
        [self displayCreateTeamView];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateTeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamCreated {
    [self displayCreateProfileView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)profileCreated {
    [self displayInvitePeopleView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWInvitePeopleViewControllerDelegate

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
