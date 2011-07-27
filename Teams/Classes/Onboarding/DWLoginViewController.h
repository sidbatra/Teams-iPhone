//
//  DWLoginViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWSessionController.h"

@class DWUser;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWLoginViewControllerDelegate;


/**
 * Login view controller for giving access to existing users
 */
@interface DWLoginViewController : UIViewController<UITextFieldDelegate,DWSessionControllerDelegate> {
	UITextField                 *_emailTextField;
	UITextField                 *_passwordTextField;
	UIView                      *_spinnerContainerView;    
    
	NSString                    *_password;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
    
    DWSessionController         *_sessionController;
    
    id <DWLoginViewControllerDelegate>      _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * Encrypted user password
 */
@property (nonatomic,copy) NSString *password;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic,retain) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controller for handling session requests
 */
@property (nonatomic,retain) DWSessionController *sessionController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWLoginViewControllerDelegate> delegate;


@end


/**
 * Delegate protocol to receive events during 
 * the login step lifecycle
 */
@protocol DWLoginViewControllerDelegate

/*
 * Fired when the user logs in.
 */
- (void)userLoggedIn:(DWUser*)user;

@end



