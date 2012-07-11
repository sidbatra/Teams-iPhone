//
//  DWUserItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"


@class DWUser;
@class DWUserItemsDataSource;
@class DWNavTitleView;
@class DWSmallProfilePicView;

/**
 * Table view for the items created by a user
 */
@interface DWUserItemsViewController : DWItemsViewController {
    DWUserItemsDataSource       *_userItemsDataSource;
    
    DWNavTitleView              *_navTitleView;
    DWSmallProfilePicView       *_smallProfilePicView;
}

/**
 * Datasource for the table view
 */
@property (nonatomic) DWUserItemsDataSource *userItemsDataSource;

/**
 * Title view for the controller
 */
@property (nonatomic) DWNavTitleView *navTitleView;

/**
 * View to display the user's profile picture on the nav bar
 */
@property (nonatomic) DWSmallProfilePicView *smallProfilePicView;


/**
 * Init with the userID whose items are being displayed
 */ 
- (id)initWithUserID:(NSInteger)userID;

@end
