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
#import "DWJoinTeamViewController.h"
#import "DWCreateProfileViewController.h"
#import "DWTeamWebURIViewController.h"
#import "DWAddProfilePicViewController.h"
#import "DWInvitePeopleViewController.h"


/**
 * Container for handling all events and logic for onboarding
 */
@interface DWOnboardingContainerViewController : DWContainerViewController<DWSplashScreenViewControllerDelegate,DWSignupViewControllerDelegate,DWLoginViewControllerDelegate,DWCreateTeamViewControllerDelegate,DWJoinTeamViewControllerDelegate, DWCreateProfileViewControllerDelegate,DWTeamWebURIViewControllerDelegate,DWAddProfilePicViewControllerDelegate,DWInvitePeopleViewControllerDelegate> {
    
    DWSplashScreenViewController    *_splashScreenViewController;
}

/**
 * SplashScreenViewController object to retain the splash screen
 */
@property (nonatomic) DWSplashScreenViewController *splashScreenViewController;

@end
