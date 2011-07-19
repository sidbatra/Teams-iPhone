//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWContactsController.h"

@protocol DWInvitePeopleViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInvitePeopleViewController : UIViewController <DWContactsControllerDelegate> {
    UITextField                 *_searchContactsTextField;
    UILabel                     *_resultsLabel;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWContactsController        *_contactsController;
    
    id <DWInvitePeopleViewControllerDelegate>  _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic, retain) IBOutlet UILabel *resultsLabel;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Controller for address book contacts requests
 */
@property (nonatomic,retain) DWContactsController *contactsController;

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

/*
 * Fired when people are invited.
 */
- (void)peopleInvited;

@end