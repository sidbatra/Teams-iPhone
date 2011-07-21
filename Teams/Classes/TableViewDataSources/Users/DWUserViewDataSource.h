//
//  DWUserViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"

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
 * Start fetching the user from the server
 */
- (void)loadUser;

@end
