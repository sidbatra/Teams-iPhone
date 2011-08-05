//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWContactsViewController.h"

@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWInvitePeopleViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInvitePeopleViewController : UIViewController<DWContactsViewControllerDelegate> {
    UITextField                 *_searchContactsTextField;
    UIImageView                 *_topShadowView;
    
    NSString                    *_navBarTitle;
    NSString                    *_navBarSubTitle;    
    NSString                    *_inviteAlertText;  
    BOOL                        _enforceInvite;
    BOOL                        _teamSpecificInvite;      
    BOOL                        _showTopShadow;
    BOOL                        _showBackButton;
    BOOL                        _showCancelButton;
        
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWContactsViewController    *_queryContactsViewController;
    DWContactsViewController    *_addedContactsViewController;    
        
    id <DWInvitePeopleViewControllerDelegate>  _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic, retain) IBOutlet UIImageView *topShadowView;

/**
 * Titles for navigation bar
 */
@property (nonatomic,copy) NSString *navBarTitle;
@property (nonatomic,copy) NSString *navBarSubTitle;

/**
 * Text to show in the invite alert message
 */
@property (nonatomic,copy) NSString *inviteAlertText;

/**
 * Property to enforce invite. YES by default.
 */
@property (nonatomic,assign) BOOL enforceInvite;

/**
 * Property that checks whether the invites are for a 
 * specific team. YES by default.
 */
@property (nonatomic,assign) BOOL teamSpecificInvite;

/**
 * Property to show its own nav bar shadow. NO by default.
 */
@property (nonatomic,assign) BOOL showTopShadow;

/**
 * Property to show nav bar back button. NO by default.
 */
@property (nonatomic,assign) BOOL showBackButton;

/**
 * Property to show nav bar close button. NO by default.
 */
@property (nonatomic,assign) BOOL showCancelButton;

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
 * Controllers for quering and added contacts from the address book
 */
@property (nonatomic,retain) DWContactsViewController *queryContactsViewController;
@property (nonatomic,retain) DWContactsViewController *addedContactsViewController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWInvitePeopleViewControllerDelegate> delegate;


/**
 * IBActions
 */
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender;

@end


/**
 * Delegate protocol to receive events during 
 * the add people view lifecycle
 */
@protocol DWInvitePeopleViewControllerDelegate

@optional

/*
 * Fired when the user decides to skip invite
 */
- (void)inviteSkipped;

/*
 * Fired when people are invited to use the app.
 */
- (void)peopleInvited;

/*
 * Fired when people are invited to join a team.
 */
- (void)peopleInvitedToATeam;

@end