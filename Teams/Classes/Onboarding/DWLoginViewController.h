//
//  DWLoginViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MBProgressHUD.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWUserProfileView.h"

@protocol DWLoginViewControllerDelegate;

/**
 * Login view controller for giving access to existing users
 */
@interface DWLoginViewController : UIViewController<UITextFieldDelegate> {
	UIView                      *_loginFieldsContainerView;
	UITextField                 *_emailTextField;
	UITextField                 *_passwordTextField;
    
	NSString                    *_password;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
	MBProgressHUD               *mbProgressIndicator;
    
    id <DWLoginViewControllerDelegate>      _delegate;
}

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
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UIView *loginFieldsContainerView;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the login step lifecycle
 */
@protocol DWLoginViewControllerDelegate

/*
 * Fired when the user logs in.
 */
- (void)userLoggedIn;

@end



