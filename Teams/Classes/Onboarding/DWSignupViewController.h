//
//  DWSignupViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavRightBarButtonView.h"
#import "DWNavTitleView.h"


@protocol DWSignupViewControllerDelegate;


/*
 * Signup view controller to begin the step by step onboarding process
 */
@interface DWSignupViewController : UIViewController {
    UITextField                 *_emailTextField;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    id <DWSignupViewControllerDelegate>     _delegate;
}

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;

/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the signup step lifecycle
 */
@protocol DWSignupViewControllerDelegate

/*
 * Fired when the information about a team is retrieved 
 * from the work email.
 */
- (void)teamInfoRetrieved;

@end