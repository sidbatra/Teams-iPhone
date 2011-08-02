//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWContactsViewController.h"

@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWNavBarFillerView;

@protocol DWInvitePeopleViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInvitePeopleViewController : UIViewController<DWContactsViewControllerDelegate> {
    UITextField                 *_searchContactsTextField;
    UILabel                     *_resultsLabel;
    
    NSString                    *_teamName;
        
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWNavBarFillerView          *_navBarFillerView;
    
    DWContactsViewController    *_queryContactsViewController;
    DWContactsViewController    *_addedContactsViewController;    
        
    id <DWInvitePeopleViewControllerDelegate>  _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic, retain) IBOutlet UILabel *resultsLabel;

/**
 * Team which the user belongs to
 */
@property (nonatomic,copy) NSString *teamName;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;
@property (nonatomic,retain) DWNavBarFillerView *navBarFillerView;

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

/*
 * Fired when people are invited.
 */
- (void)peopleInvited;

@end