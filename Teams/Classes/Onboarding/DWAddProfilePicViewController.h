//
//  DWAddProfilePicViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"
#import "DWMediaController.h"
#import "DWMediaPickerController.h"
#import "DWMembershipsController.h"
#import "DWFacebookConnect.h"

@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWNavBarFillerView;
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
    DWNavBarFillerView          *_navBarFillerView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
    
    DWUsersController           *_usersController;
    DWMediaController           *_mediaController;
    DWMembershipsController     *_membershipsController;    
    
    DWFacebookConnect           *_facebookConnect;
    
    id <DWAddProfilePicViewControllerDelegate>  _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UIButton *addProfilePicButton;
@property (nonatomic, retain) IBOutlet UIImageView *underlayImageView;
@property (nonatomic, retain) IBOutlet UIButton *useFacebookPhotoButton;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

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
@property (nonatomic,retain) UIImage *userImage;

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
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;
@property (nonatomic,retain) DWNavBarFillerView *navBarFillerView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic,retain) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controller for handling user requests
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * Controller for handling media uploading request
 */
@property (nonatomic,retain) DWMediaController *mediaController;

/**
 * Controller for handling memberships requests
 */
@property (nonatomic,retain) DWMembershipsController *membershipsController;

/**
 * Instance of the facebook connect wrapper
 */
@property (nonatomic,retain) DWFacebookConnect *facebookConnect;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWAddProfilePicViewControllerDelegate> delegate;

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



