//
//  DWCreateProfileViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"

@class DWUser;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWCreateProfileViewControllerDelegate;


/**
 * Provides an interface for creating user profiles.
 */
@interface DWCreateProfileViewController : UIViewController<UITextFieldDelegate,DWUsersControllerDelegate> {
	
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
	UITextField                 *_passwordTextField;
	UIView                      *_spinnerContainerView;            
    
	NSString                    *_password; 
    NSString                    *_teamName;
	NSInteger                   _userID;    
    BOOL                        _hasPasswordChanged;
			  	
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
    
    DWUsersController           *_usersController;
																				    
    id <DWCreateProfileViewControllerDelegate>  _delegate;
}


/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *byLineTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * Encrypted password for the current user
 */
@property (nonatomic,copy) NSString *password;

/**
 * Team which the user belongs to
 */
@property (nonatomic,copy) NSString *teamName;

/**
 * Database ID for the user
 */
@property (nonatomic,assign) NSInteger userID;

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
 * Controller for handling user requests
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWCreateProfileViewControllerDelegate> delegate;


/**
 * Prepopulate the user details
 */
- (void)prePopulateViewWithFirstName:(NSString*)firstName 
                            lastName:(NSString*)lastName 
                              byLine:(NSString*)byLine 
                         andPassword:(NSString*)password;

@end


/**
 * Delegate protocol to receive events during 
 * the create user profile lifecycle
 */
@protocol DWCreateProfileViewControllerDelegate

/*
 * Fired when user details are updated.
 */
- (void)userDetailsUpdated:(DWUser*)user;

@end



