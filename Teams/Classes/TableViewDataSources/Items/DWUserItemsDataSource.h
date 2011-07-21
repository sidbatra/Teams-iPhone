//
//  DWUserItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWUsersController.h"

/**
 * Data source for the user items view controller
 */
@interface DWUserItemsDataSource : DWItemsDataSource<DWUsersControllerDelegate> {
    DWUsersController   *_usersController;
    
    NSInteger           _userID;
}

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * The userID whose items are being displayed
 */
@property (nonatomic,assign) NSInteger userID;


/**
 * Fetch user information 
 */
- (void)loadUser;

@end
