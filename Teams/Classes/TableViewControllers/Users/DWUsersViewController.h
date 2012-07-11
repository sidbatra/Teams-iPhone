//
//  DWUsersViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWUsersLogicController;
@protocol DWUsersLogicControllerDelegate;

/**
 * Base class for table views with a list of users
 */
@interface DWUsersViewController : DWTableViewController {
    DWUsersLogicController       *_usersLogicController;
}

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic) DWUsersLogicController *usersLogicController;


/**
 * Set a users logic controller delegate
 */
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate;

@end
