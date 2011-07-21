//
//  DWUserViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"

@class DWUser;
@protocol DWUserViewDataSourceDelegate;

/**
 * Data source for the user table view
 */
@interface DWUserViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate> {
    
    DWUsersController   *_usersController;
    
    NSInteger           _userID;
}

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * ID of the user being displayed
 */
@property (nonatomic,assign) NSInteger userID;

/**
 * Overriding the base class delegate
 */
@property (nonatomic,assign) id<DWUserViewDataSourceDelegate,NSObject> delegate;


/**
 * Start fetching the user from the server
 */
- (void)loadUser;

@end


/**
 * Additional delegate methods for the data source
 */
@protocol DWUserViewDataSourceDelegate<DWTableViewDataSourceDelegate>

/**
 * Provide the fetched user object to the table view to update the UI
 */
- (void)userLoaded:(DWUser*)user;
@end
