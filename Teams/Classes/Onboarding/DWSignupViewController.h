//
//  DWSignupViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavRightBarButtonView.h"
#import "DWNavTitleView.h"
#import "DWUsersController.h"


@protocol DWSignupViewControllerDelegate;


/*
 * Signup view controller to begin the step by step onboarding process
 */
@interface DWSignupViewController : UIViewController <DWUserControllerDelegate> {
    UITextField                 *_emailTextField;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWUsersController           *_usersController;
    
    id <DWSignupViewControllerDelegate>     _delegate;
}

/**
 * Controller for handling user requests
 */
@property (nonatomic,retain) DWUsersController *usersController;

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