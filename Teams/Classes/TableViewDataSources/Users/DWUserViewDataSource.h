//
//  DWUserViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWUsersController.h"
#import "DWTeamsController.h"

@class DWUser;
@class DWResource;
@class DWMessage;
@protocol DWUserViewDataSourceDelegate;

/**
 * Data source for the user table view
 */
@interface DWUserViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate,DWTeamsControllerDelegate> {
    
    DWUsersController   *_usersController;
    DWTeamsController   *_teamsController;
    
    DWMessage           *_teamMessage;
    DWMessage           *_watchingMessage;
    
    DWResource          *_imageResource;
    
    NSInteger           _userID;
}

/**
 * Interface to the users service
 */
@property (nonatomic,retain) DWUsersController *usersController;

/**
 * Interface to the teams service
 */
@property (nonatomic,retain) DWTeamsController *teamsController;

/**
 * Message displaying the current team
 */
@property (nonatomic,retain) DWMessage *teamMessage;

/**
 * Message displaying the total teams being watched
 */
@property (nonatomic,retain) DWMessage *watchingMessage;

/**
 * Image + byline for the profile pic cell
 */
@property (nonatomic,retain) DWResource *imageResource;


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
