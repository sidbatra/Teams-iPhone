//
//  DWItemsLogicController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"
#import "DWUsersController.h"
#import "DWTeamsController.h"
#import "DWTouchesController.h"

@class DWItem;
@class DWTeam;
@class DWUser;
@class DWTouchesController;
@class DWTableViewController;
@protocol DWItemsLogicControllerDelegate;

/**
 * Base class for table views that display a list of items
 */
@interface DWItemsLogicController : NSObject<DWTouchesControllerDelegate,DWUsersControllerDelegate,DWTeamsControllerDelegate> {

    DWTouchesController     *_touchesController;
    DWUsersController       *_usersController;
    DWTeamsController       *_teamsController;
    
    DWTableViewController   *_tableViewController;
    

    
    id<DWItemsLogicControllerDelegate,NSObject> _delegate;
}

/**
 * The table view controller which contains the items view controller object
 */
@property (nonatomic,assign) DWTableViewController *tableViewController;

/**
 * Record the touches made on items by the current user
 */
@property (nonatomic,retain) DWTouchesController *touchesController;

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * Interface to the teams service
 */
@property (nonatomic,retain) DWTeamsController *teamsController;


/**
 * Delegate fires events about the ItemsLogicController lifecycle
 */
@property (nonatomic,assign) id<DWItemsLogicControllerDelegate,NSObject> delegate;

@end


/**
 * Delegate protocol to receive events about the ItemsLogicController lifecycle
 */
@protocol DWItemsLogicControllerDelegate

@optional

/**
 * Fired when a team is selected
 */
- (void)itemsLogicTeamSelected:(DWTeam*)team;

/**
 * Fired when a user is selected
 */
- (void)itemsLogicUserSelected:(DWUser*)user;

/**
 * Fired when the share button or an item is selected
 */
- (void)itemsLogicShareSelectedForItem:(DWItem*)item;

@end
