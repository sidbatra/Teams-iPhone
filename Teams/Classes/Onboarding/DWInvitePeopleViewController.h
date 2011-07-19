//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWContactsViewController.h"

@protocol DWInvitePeopleViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInvitePeopleViewController : UIViewController {
    UITextField                 *_searchContactsTextField;
    UILabel                     *_resultsLabel;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWContactsViewController    *_contactsViewController;
        
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
 * Show contacts from the address book
 */
@property (nonatomic,retain) DWContactsViewController *contactsViewController;

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