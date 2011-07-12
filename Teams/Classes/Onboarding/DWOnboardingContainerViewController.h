//
//  DWOnboardingContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWContainerViewController.h"
#import "DWSplashScreenViewController.h"
#import "DWSignupViewController.h"
#import "DWLoginViewController.h"
#import "DWCreateTeamViewController.h"
#import "DWCreateUserViewController.h"
#import "DWInvitePeopleViewController.h"

/**
 * Primary view and container for handling all the 
 * events and logic for onboarding
 */
@interface DWOnboardingContainerViewController : DWContainerViewController<DWSplashScreenViewControllerDelegate,DWSignupViewControllerDelegate,DWLoginViewControllerDelegate,DWCreateNewTeamViewControllerDelegate,DWCreateUserProfileViewControllerDelegate, DWAddPeopleViewControllerDelegate> {
    
    DWSplashScreenViewController    *_splashScreenViewController;
}

/**
 * SplashScreenViewController object to retain the splash screen
 */
@property (nonatomic,retain) DWSplashScreenViewController *splashScreenViewController;

@end
