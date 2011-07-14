//
//  DWUsersController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;
@protocol DWUserControllerDelegate;


/**
 * Interface to Users Service on the app server
 */
@interface DWUsersController : NSObject {
    
    id<DWUserControllerDelegate,NSObject>     _delegate;
}

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWUserControllerDelegate,NSObject> delegate;

/**
 * Create a new user
 */
- (void)createUserWithEmail:(NSString*)email
                andPassword:(NSString*)password;

@end


/**
 * Protocol for the UserController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWUserControllerDelegate

@optional

/**
 * Fired when a user is created
 */
- (void)userCreated:(DWUser*)user;

/**
 * Error message while creating a user
 */
- (void)userCreationError:(NSString*)error;

@end