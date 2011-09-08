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
@class DWProfileImage;
@protocol DWUserViewDataSourceDelegate;

/**
 * Data source for the user table view
 */
@interface DWUserViewDataSource : DWTableViewDataSource<DWUsersControllerDelegate,DWTeamsControllerDelegate> {
    
    DWUsersController   *_usersController;
    DWTeamsController   *_teamsController;
    
    DWResource          *_teamResource;
    DWResource          *_followingResource;
    
    DWProfileImage      *_profileImage;
    DWUser              *_user;
    
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
 * Resource displaying the current team
 */
@property (nonatomic,retain) DWResource *teamResource;

/**
 * Resource displaying the total teams being followed
 */
@property (nonatomic,retain) DWResource *followingResource;

/**
 * Image for the profile pic cell
 */
@property (nonatomic,retain) DWProfileImage *profileImage;

/**
 * User being displayed
 */
@property (nonatomic,retain) DWUser *user;


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
