//
//  DWUserItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"


@class DWUser;
@class DWUserItemsDataSource;
@class DWNavTitleView;

/**
 * Table view for the items created by a user
 */
@interface DWUserItemsViewController : DWItemsViewController {
    DWUserItemsDataSource       *_userItemsDataSource;
    DWNavTitleView              *_navTitleView;
}

/**
 * Datasource for the table view
 */
@property (nonatomic,retain) DWUserItemsDataSource *userItemsDataSource;

/**
 * Title view for the controller
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;


/**
 * Init with the user whose items are being displayed
 */ 
- (id)initWithUser:(DWUser*)user
         andIgnore:(BOOL)ignore;

@end
