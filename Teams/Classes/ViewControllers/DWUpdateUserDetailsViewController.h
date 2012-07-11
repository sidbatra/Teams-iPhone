//
//  DWUpdateUserDetailsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWUsersController.h"
#import "DWMediaController.h"
#import "DWMediaPickerController.h"

@class DWUser;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

/*
 * Provides an interface for editing user details
 */
@interface DWUpdateUserDetailsViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,DWUsersControllerDelegate,DWMediaControllerDelegate,DWMediaPickerControllerDelegate> {
    
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
    UIImageView                 *_userImageView;
    UIButton                    *_changeUserImageButton;
    UIView                      *_spinnerContainerView;
    
    BOOL                        _hasChangedImage;
    NSInteger                   _mediaResourceID;
    NSInteger                   _userID;
    NSString                    *_firstName;
    NSString                    *_lastName;    
    NSString                    *_byline;    
    UIImage                     *_userImage;
    
    UIViewController            *_displayMediaPickerController;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWUsersController           *_usersController;
    DWMediaController           *_mediaController;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextField *firstNameTextField;
@property (nonatomic) IBOutlet UITextField *lastNameTextField;
@property (nonatomic) IBOutlet UITextField *byLineTextField;
@property (nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic) IBOutlet UIButton *changeUserImageButton;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;

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
@property (nonatomic) UIImage *userImage;

/**
 * Controller for presenting the media picker
 */ 
@property (nonatomic) UIViewController *displayMediaPickerController;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic) DWNavTitleView *navTitleView;
@property (nonatomic) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controller for handling user requests
 */
@property (nonatomic) DWUsersController *usersController;

/**
 * Controller for handling media uploading request
 */
@property (nonatomic) DWMediaController *mediaController;

/**
 * Custom init with user
 */
- (id)initWithUserToEdit:(DWUser*)user;


@end
