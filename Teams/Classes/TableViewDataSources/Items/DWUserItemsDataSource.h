//
//  DWUserItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWUsersController.h"

@protocol DWUserItemsDataSourceDelegate;

/**
 * Data source for the user items view controller
 */
@interface DWUserItemsDataSource : DWItemsDataSource<DWUsersControllerDelegate> {
    DWUsersController   *_usersController;
    DWUser              *_user;
    
    NSInteger           _userID;
}

/**
 * Interface to the users service
 */
@property (nonatomic) DWUsersController *usersController;

/**
 * User whose objects are being displayed
 */
@property (nonatomic) DWUser *user;

/**
 * The userID whose items are being displayed
 */
@property (nonatomic,assign) NSInteger userID;

/**
 * Redefined delegate object
 */
@property (nonatomic,unsafe_unretained) id<DWUserItemsDataSourceDelegate,NSObject> delegate;


/**
 * Fetch user information 
 */
- (void)loadUser;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWUserItemsDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Provide the fetched user object to the table view to update the UI
 */
- (void)userLoaded:(DWUser*)user;
@end
