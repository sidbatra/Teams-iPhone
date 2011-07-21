//
//  DWContactsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWContactsDataSource;
@class DWContact;
@protocol DWContactsViewControllerDelegate;


/**
 * Table view displaying search results
 */
@interface DWContactsViewController : DWTableViewController<UIActionSheetDelegate> {
    
    DWContact                       *_contactToRemove;
    DWContactsDataSource            *_contactsDataSource;
    
    id<DWContactsViewControllerDelegate>    _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWContactsDataSource *contactsDataSource;

/**
 * Delegate based on the DWContactsViewControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWContactsViewControllerDelegate> delegate;

/**
 * Custom init with style
 */
- (id)initWithPresentationStyle:(NSInteger)style;

/**
 * Load contacts whose properties contain a 
 * given string
 */
- (void)loadContactsMatching:(NSString*)string;

/**
 * Add the given contact to the datasource and the tableview
 */
- (void)addContact:(DWContact*)contact;

/**
 * Show the action sheet to confirm removing a contact from 
 * the table view
 */
- (void)showActionSheetInView:(UIView*)view
                  forRemoving:(DWContact*)contact;

@end


/**
 * Protocol for delegates of DWContactsViewController
 */
@protocol DWContactsViewControllerDelegate

/**
 * Fired when a contact is selected along with 
 * object for the contactsviewcontroller
 */
- (void)contactSelected:(DWContact*)contact 
             fromObject:(id)object;

@end
