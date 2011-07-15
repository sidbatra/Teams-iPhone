//
//  DWUserItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"
#import "DWUserItemsDataSource.h"

@class DWUser;

/**
 * Table view for the items created by a user
 */
@interface DWUserItemsViewController : DWItemsViewController {
    DWUserItemsDataSource   *_userItemsDataSource;
}

/**
 * Datasource for the table view
 */
@property (nonatomic,retain) DWUserItemsDataSource *userItemsDataSource;


/**
 * Init with the user whose items are being displayed
 */ 
- (id)initWithUser:(DWUser*)user
         andIgnore:(BOOL)ignore;

@end
