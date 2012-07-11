//
//  DWUsersDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"

/**
 * Base data source for table views containing a list of users
 */
@interface DWUsersDataSource : DWTableViewDataSource<DWUsersControllerDelegate> {
    DWUsersController   *_usersController;
}

/**
 * Interface to the users service on the app server
 */
@property (nonatomic) DWUsersController *usersController;


/**
 * Populate users into the objects array
 */
- (void)populateUsers:(NSMutableArray*)users;

/**
 * Stub method overriden by base class to start the loading of users into the table view
 */
- (void)loadUsers;

@end
