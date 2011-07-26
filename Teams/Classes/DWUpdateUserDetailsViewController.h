//
//  DWUpdateUserDetailsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWUsersController.h"
#import "DWMediaPickerController.h"

@class DWUser;
@class DWNavTitleView;
@class DWNavRightBarButtonView;
@class DWSpinnerOverlayView;

/*
 * Provides an interface for editing user details
 */
@interface DWUpdateUserDetailsViewController : UIViewController<UITextFieldDelegate,DWUsersControllerDelegate,
DWMediaPickerControllerDelegate> {
    
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
    UIImageView                 *_userImageView;
    UIButton                    *_changeUserImageButton;
    UIView                      *_spinnerContainerView;
    
    NSInteger                   _userID;
    NSString                    *_firstName;
    NSString                    *_lastName;    
    NSString                    *_byline;    
    UIImage                     *_userImage;
    
    UIViewController            *_displayMediaPickerController;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWUsersController           *_usersController;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *byLineTextField;
@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
@property (nonatomic, retain) IBOutlet UIButton *changeUserImageButton;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * IBActions
 */
- (IBAction)changeUserImageButtonTapped:(id)sender;

/**
 * User attributes
 */
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *byline;
@property (nonatomic,retain) UIImage *userImage;

/**
 * Controller for presenting the media picker
 */ 
@property (nonatomic,retain) UIViewController *displayMediaPickerController;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic,retain) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controller for handling user requests
 */
@property (nonatomic,retain) DWUsersController *usersController;


/**
 * Custom init with user
 */
- (id)initWithUserToEdit:(DWUser*)user;


@end
