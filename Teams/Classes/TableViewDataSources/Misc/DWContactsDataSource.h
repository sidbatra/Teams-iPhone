//
//  DWContactsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWContactsController.h"
#import "DWInvitesController.h"

@class DWContact;
@protocol DWContactsDataSourceDelegate;

/**
 * Data source for the contacts table view controller
 */
@interface DWContactsDataSource : DWTableViewDataSource<DWContactsControllerDelegate,DWInvitesControllerDelegate> {
    
    NSArray                     *_allContacts;
    
    DWContactsController        *_contactsController;
    DWInvitesController         *_invitesController;    
}

/**
 * Redefined delegate object
 */
@property (nonatomic,assign) id<DWContactsDataSourceDelegate> delegate;


/**
 * All Address Book Contacts
 */
@property (nonatomic,retain) DWContactsController *contactsController;

/**
 * Controller for address book contacts requests
 */
@property (nonatomic,retain) NSArray *allContacts;

/**
 * Interface to invite service
 */
@property (nonatomic,retain) DWInvitesController *invitesController;


/*
 * Load all contacts from the address book
 */
- (void)loadAllContacts;

/*
 * Load contacts whose properties contain a 
 * given string
 */
- (void)loadContactsMatching:(NSString*)string;

/*
 * Add the given contact at the end of objects array
 */
- (void)addContact:(DWContact*)contact;

/*
 * Remove the given contact from the objects array
 */
- (void)removeContact:(DWContact*)contact;

/**
 * Send invite information to server
 */
- (void)triggerInvites;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWContactsDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Provide the fetched user object to the table view to update the UI
 */
- (void)invitesCreated;

@end






