//
//  DWOnboardingViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * Primary class for onboarding that behaves in the same way 
 * as the app delegate and implements its own navigation controller
 */
@interface DWOnboardingViewController : UIViewController {
    
    UINavigationController	*_onboardingNavController;
}

/**
 * IBOutlet properties
 */
@property (nonatomic,retain) IBOutlet UINavigationController *onboardingNavController;

@end
