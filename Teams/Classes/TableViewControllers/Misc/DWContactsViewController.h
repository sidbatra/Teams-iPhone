//
//  DWContactsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWContactsDataSource;

/**
 * Table view displaying search results
 */
@interface DWContactsViewController : DWTableViewController {

    DWContactsDataSource          *_contactsDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWContactsDataSource *contactsDataSource;

/**
 * Load contacts whose properties contain a 
 * given string
 */
- (void)loadContactsMatching:(NSString*)string;

@end
