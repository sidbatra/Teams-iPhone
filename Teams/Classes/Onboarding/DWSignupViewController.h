//
//  DWSignupViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWUsersController.h"
#import "DWTeamsController.h"

@class DWTeam;
@class DWUser;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWSignupViewControllerDelegate;


/*
 * Signup view controller to begin the step by step onboarding process
 */
@interface DWSignupViewController : UIViewController<UITextFieldDelegate,DWUsersControllerDelegate,DWTeamsControllerDelegate> {
    UITextField                 *_emailTextField;
	UIView                      *_spinnerContainerView;        
    
	NSString                    *_password;    
    NSInteger                   _userID;
    NSInteger                   _teamResourceID;
    BOOL                        _hasCreatedUser;    
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;
    
    DWUsersController           *_usersController;
    DWTeamsController           *_teamsController;
    
    id <DWSignupViewControllerDelegate>     _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * Encrypted user password
 */
@property (nonatomic,copy) NSString *password;

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
 * Model Controllers
 */
@property (nonatomic,retain) DWUsersController *usersController;
@property (nonatomic,retain) DWTeamsController *teamsController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWSignupViewControllerDelegate> delegate;


/**
 * Prepopulate the signup view from session data to 
 * keep state persistence.
 */
- (void)prePopulateViewWithEmail:(NSString*)email 
                       andUserID:(NSInteger)userID;


@end


/**
 * Delegate protocol to receive events during 
 * the signup step lifecycle
 */
@protocol DWSignupViewControllerDelegate

/*
 * Fired when a user is created
 */
- (void)userCreated:(DWUser*)user;

/*
 * Fired when a user is updated
 */
- (void)userEmailUpdated;

/*
 * Fired when information about a team is fetched
 * from the server
 */
- (void)teamLoaded:(DWTeam*)team;

@end