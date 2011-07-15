//
//  DWLoginViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MBProgressHUD.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWSessionController.h"

@class DWUser;
@protocol DWLoginViewControllerDelegate;

/**
 * Login view controller for giving access to existing users
 */
@interface DWLoginViewController : UIViewController<UITextFieldDelegate,DWSessionControllerDelegate> {
	UIView                      *_loginFieldsContainerView;
	UITextField                 *_emailTextField;
	UITextField                 *_passwordTextField;
    
	NSString                    *_password;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
	MBProgressHUD               *mbProgressIndicator;
    
    DWSessionController         *_sessionController;
    
    id <DWLoginViewControllerDelegate>      _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UIView *loginFieldsContainerView;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

/**
 * Encrypted user password
 */
@property (nonatomic,copy) NSString *password;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

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



