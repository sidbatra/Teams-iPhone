//
//  DWUsersLogicController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersController.h"

@class DWUser;
@class DWTableViewController;
@protocol DWUsersLogicControllerDelegate;

/**
 * Encapsulates logic for handling display and interactions
 * of a list of users
 */
@interface DWUsersLogicController : NSObject<DWUsersControllerDelegate> {
    
    DWTableViewController   *__unsafe_unretained _tableViewController;
    DWUsersController       *_usersController;

    BOOL                    _navigationEnabled;

    id <DWUsersLogicControllerDelegate> __unsafe_unretained _delegate;

}

/**
 * The table view controller which contains the teams view controller object
 */
@property (nonatomic,unsafe_unretained) DWTableViewController *tableViewController;

/**
 * Interface to the users service
 */
@property (nonatomic) DWUsersController *usersController;


/**
 * Controls the navigation from user cells
 */
@property (nonatomic,assign) BOOL navigationEnabled;

/**
 * Delegate receives events based on the DWTeamsLogicControllerDelegate
 */
@property (nonatomic,unsafe_unretained) id<DWUsersLogicControllerDelegate> delegate;

@end


/**
 * Delegate protocol for the DWUsersLogicController
 */
@protocol DWUsersLogicControllerDelegate

/**
 * Fired when the user selects a user
 */
- (void)usersLogicUserSelected:(DWUser*)user;

@end

