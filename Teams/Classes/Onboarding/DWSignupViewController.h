//
//  DWSignupViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavRightBarButtonView.h"
#import "DWNavTitleView.h"
#import "DWUsersController.h"
#import "DWTeamsController.h"

@class DWTeam;
@class DWUser;
@protocol DWSignupViewControllerDelegate;


/*
 * Signup view controller to begin the step by step onboarding process
 */
@interface DWSignupViewController : UIViewController<UITextFieldDelegate,DWUsersControllerDelegate,DWTeamsControllerDelegate> {
    UITextField                 *_emailTextField;
    
	NSString                    *_password;    
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWUsersController           *_usersController;
    DWTeamsController           *_teamsController;
    
    id <DWSignupViewControllerDelegate>     _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;

/**
 * Encrypted user password
 */
@property (nonatomic,copy) NSString *password;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Model Controllers
 */
@property (nonatomic,retain) DWUsersController *usersController;
@property (nonatomic,retain) DWTeamsController *teamsController;


/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the signup step lifecycle
 */
@protocol DWSignupViewControllerDelegate

/*
 * Fired when a user is created
 */
- (void)userCreated:(DWUser*)created;

/*
 * Fired when information about a team is fetched
 * from the server
 */
- (void)teamLoaded:(DWTeam*)team;

@end