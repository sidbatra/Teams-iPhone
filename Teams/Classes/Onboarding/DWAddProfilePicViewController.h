//
//  DWAddProfilePicViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWUsersController.h"
#import "DWMediaController.h"
#import "DWMediaPickerController.h"
#import "DWMembershipsController.h"
#import "DWFacebookConnect.h"

@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWAddProfilePicViewControllerDelegate;


/**
 * Provides an interface for adding profile picture.
 */
@interface DWAddProfilePicViewController : UIViewController<UIActionSheetDelegate,DWUsersControllerDelegate,DWMediaControllerDelegate,DWMediaPickerControllerDelegate,DWMembershipsControllerDelegate,DWFacebookConnectDelegate> {
    
    UIButton                    *_addProfilePicButton;
    UIImageView                 *_underlayImageView;
    UIButton                    *_useFacebookPhotoButton;
	UIView                      *_spinnerContainerView;                
    
    UIImage                     *_userImage;
    NSString                    *_userFBToken;    
    NSInteger                   _userID;    
    NSInteger                   _teamID;
    NSInteger                   _mediaResourceID;  
    BOOL                        _hasChangedImage;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
    
    DWUsersController           *_usersController;
    DWMediaController           *_mediaController;
    DWMembershipsController     *_membershipsController;    
    
    DWFacebookConnect           *_facebookConnect;
    
    id <DWAddProfilePicViewControllerDelegate>  __unsafe_unretained _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UIButton *addProfilePicButton;
@property (nonatomic) IBOutlet UIImageView *underlayImageView;
@property (nonatomic) IBOutlet UIButton *useFacebookPhotoButton;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;

/**
 * IBActions
 */
- (IBAction)addProfilePicButtonTapped:(id)sender;
- (IBAction)useFacebookPhotoButtonTapped:(id)sender;

/**
 * User's Facebook Access Token
 */
@property (nonatomic,copy) NSString *userFBToken;

/**
 * User image
 */
@property (nonatomic) UIImage *userImage;

/**
 * Database ID for the user
 */
@property (nonatomic,assign) NSInteger userID;

/**
 * Database ID for the user's team
 */
@property (nonatomic,assign) NSInteger teamID;

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
 * Controller for handling memberships requests
 */
@property (nonatomic) DWMembershipsController *membershipsController;

/**
 * Instance of the facebook connect wrapper
 */
@property (nonatomic) DWFacebookConnect *facebookConnect;

/**
 * Delegate to send updates to
 */
@property (nonatomic,unsafe_unretained) id<DWAddProfilePicViewControllerDelegate> delegate;

@end


/**
 * Delegate protocol to receive events during 
 * the add profile picture lifecycle
 */
@protocol DWAddProfilePicViewControllerDelegate

/*
 * Fired when user photo is added and the
 * user model is updated.
 */
- (void)userPhotoUpdated;

/*
 * Fired when the membership is created
 */
- (void)membershipCreated;

@end



