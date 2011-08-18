//
//  DWShareTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWFacebookConnect.h"
#import "DWTwitterConnect.h"

@class DWTeam;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

/**
 * View for sharing items to Facebook and Twitter
 */
@interface DWShareTeamViewController : UIViewController<DWFacebookConnectDelegate,DWTwitterConnectDelegate> {
    
    DWFacebookConnect           *_facebookConnect;
    DWTwitterConnect            *_twitterConnect;
    
    DWTeam                      *_team;
    
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
@property (nonatomic,retain) DWFacebookConnect *facebookConnect;

/**
 * Instance of the twitter connect wrapper
 */
@property (nonatomic,retain) DWTwitterConnect *twitterConnect;

/**
 * The team being shared
 */
@property (nonatomic,retain) DWTeam *team;

/**
 * IBOutlet properties
 */
@property (nonatomic,retain) IBOutlet UITextView *dataTextView;
@property (nonatomic,retain) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic,retain) IBOutlet UISwitch *twitterSwitch;
@property (nonatomic,retain) IBOutlet UIView *spinnerContainerView;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic,retain) DWSpinnerOverlayView *spinnerOverlayView; 


/**
 * IBAction methods
 */
- (IBAction)facebookSwitchToggled:(id)sender;
- (IBAction)twitterSwitchToggled:(id)sender;

@end



