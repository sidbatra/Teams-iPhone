//
//  DWUpdateUserDetailsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWUsersController.h"

@class DWUser;
@class DWNavTitleView;
@class DWNavRightBarButtonView;

/*
 * Provides an interface for editing user details
 */
@interface DWUpdateUserDetailsViewController : UIViewController<DWUsersControllerDelegate> {
    
	UITextField                 *_firstNameTextField;
    UITextField                 *_lastNameTextField;
	UITextField                 *_byLineTextField;
    
    DWUser                      *_user;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWUsersController           *_usersController;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *byLineTextField;

/**
 * Current user
 */
@property (nonatomic,retain) DWUser *user;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Controller for handling user requests
 */
@property (nonatomic,retain) DWUsersController *usersController;


/**
 * Custom init with user
 */
- (id)initWithUser:(DWUser*)user;


@end
