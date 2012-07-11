//
//  DWShareTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWFacebookConnect.h"
#import "DWTwitterConnect.h"
#import "DWUsersController.h"

@class DWTeam;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

/**
 * View for sharing items to Facebook and Twitter
 */
@interface DWShareTeamViewController : UIViewController<DWFacebookConnectDelegate,DWTwitterConnectDelegate,DWUsersControllerDelegate> {
    
    DWFacebookConnect           *_facebookConnect;
    DWTwitterConnect            *_twitterConnect;
    
    DWTeam                      *_team;
    DWUsersController           *_usersController;
    
    BOOL                        _sharedToFacebook;
    BOOL                        _sharedToTwitter;
    
    UITextView                  *_dataTextView;
    UISwitch                    *_facebookSwitch;
    UISwitch                    *_twitterSwitch;
	UIView                      *_spinnerContainerView;                
    
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
}

/**
 * Instance of the facebook connect wrapper
 */
@property (nonatomic) DWFacebookConnect *facebookConnect;

/**
 * Instance of the twitter connect wrapper
 */
@property (nonatomic) DWTwitterConnect *twitterConnect;

/**
 * The team being shared
 */
@property (nonatomic) DWTeam *team;

/**
 * Controller for handling user requests
 */
@property (nonatomic) DWUsersController *usersController;

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UITextView *dataTextView;
@property (nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic) DWSpinnerOverlayView *spinnerOverlayView; 


/**
 * IBAction methods
 */
- (IBAction)facebookSwitchToggled:(id)sender;
- (IBAction)twitterSwitchToggled:(id)sender;

@end



