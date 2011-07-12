//
//  DWCreateUserViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWMediaPickerController.h"
#import "MBProgressHUD.h"
#import "DWNavigationBar.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"

@protocol DWCreateUserProfileViewControllerDelegate;


/**
 * Provides an interface for creating user profiles.
 */
@interface DWCreateUserViewController : UIViewController<UITextFieldDelegate> {
	
	UIView                      *_profileDetailsContainerView;
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
	UITextField                 *_passwordTextField;
			  	
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
																				
	NSString                    *_password;
	
	BOOL                        _isUploading;
	BOOL                        _signupInitiated;
    
	NSInteger                   _uploadID;
    
    id <DWCreateUserProfileViewControllerDelegate>  _delegate;
}

/**
 * Encrypted password for the current user
 */
@property (nonatomic,copy) NSString *password;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;


/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UIView *profileDetailsContainerView;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *byLineTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;


/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the create user profile lifecycle
 */
@protocol DWCreateUserProfileViewControllerDelegate

/*
 * Fired when a user profile is created.
 */
- (void)userProfileCreated;

@end



