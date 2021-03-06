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
    
    DWTableViewController   *_tableViewController;
    DWUsersController       *_usersController;

    BOOL                    _navigationEnabled;

    id <DWUsersLogicControllerDelegate> _delegate;

}

/**
 * The table view controller which contains the teams view controller object
 */
@property (nonatomic,assign) DWTableViewController *tableViewController;

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;


/**
 * Controls the navigation from user cells
 */
@property (nonatomic,assign) BOOL navigationEnabled;

/**
 * Delegate receives events based on the DWTeamsLogicControllerDelegate
 */
@property (nonatomic,assign) id<DWUsersLogicControllerDelegate> delegate;

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

