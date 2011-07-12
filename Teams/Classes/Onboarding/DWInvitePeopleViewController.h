//
//  DWInvitePeopleViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"

@protocol DWAddPeopleViewControllerDelegate;

/**
 * View for adding people throughout the app.
 */
@interface DWInvitePeopleViewController : UIViewController {
    UITextField                 *_searchContactsTextField;
    UILabel                     *_resultsLabel;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    id <DWAddPeopleViewControllerDelegate>  _delegate;
}

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UITextField *searchContactsTextField;
@property (nonatomic, retain) IBOutlet UILabel *resultsLabel;

/**
 * IBActions
 */
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the add people view lifecycle
 */
@protocol DWAddPeopleViewControllerDelegate

/*
 * Fired when people are added.
 */
- (void)peopleAdded;

@end