//
//  DWContactsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWContactsController.h"

@class DWContact;

/**
 * Data source for the contacts table view controller
 */
@interface DWContactsDataSource : DWTableViewDataSource<DWContactsControllerDelegate> {
    
    DWContactsController        *_contactsController;
}

/**
 * Controller for address book contacts requests
 */
@property (nonatomic,retain) DWContactsController *contactsController;

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

@end
