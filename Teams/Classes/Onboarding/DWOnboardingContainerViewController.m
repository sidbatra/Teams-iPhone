//
//  DWOnboardingContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWOnboardingContainerViewController.h"
#import "DWGUIManager.h"


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
    
    self.navigationController.navigationBarHidden = YES;
    
    self.splashScreenViewController = [[[DWSplashScreenViewController alloc] initWithDelegate:self] autorelease];
    [self.view addSubview:self.splashScreenViewController.view];
}
    
//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions
//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
    [self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSplashScreenViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)loginInitiated {
    DWLoginViewController *loginViewController = [[[DWLoginViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)signupInitiated {
    DWSignupViewController *signupViewController = [[[DWSignupViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:signupViewController animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSignupViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamInfoRetrieved {
    DWCreateTeamViewController *createNewTeamController = [[[DWCreateTeamViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:createNewTeamController animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWLoginViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoggedIn {
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateNewTeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)newTeamCreated {
    DWCreateUserViewController *createUserProfileController = [[[DWCreateUserViewController alloc] 
                                                                       initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:createUserProfileController animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateUserProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userProfileCreated {
    DWInvitePeopleViewController *addPeopleViewController = [[DWInvitePeopleViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:addPeopleViewController animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWCreateUserProfileViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)peopleAdded {
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
