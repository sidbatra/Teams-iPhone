//
//  DWCreateProfileViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWNavigationBar.h"
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"

@protocol DWCreateProfileViewControllerDelegate;


/**
 * Provides an interface for creating user profiles.
 */
@interface DWCreateProfileViewController : UIViewController<UITextFieldDelegate> {
	
	UIView                      *_profileDetailsContainerView;
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
	UITextField                 *_passwordTextField;
    
	NSString                    *_password;    
	BOOL                        _isUploading;
	BOOL                        _signupInitiated;
	NSInteger                   _uploadID;    
			  	
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
																				    
    id <DWCreateProfileViewControllerDelegate>  _delegate;
}


/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UIView *profileDetailsContainerView;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *byLineTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

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
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWCreateProfileViewControllerDelegate> delegate;

@end


/**
 * Delegate protocol to receive events during 
 * the create user profile lifecycle
 */
@protocol DWCreateProfileViewControllerDelegate

/*
 * Fired when a user profile is created.
 */
- (void)profileCreated;

@end



