//
//  DWSessionController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;
@protocol DWSessionControllerDelegate;


/**
 * Interface to Session service on the app server
 */
@interface DWSessionController : NSObject {
    
    id<DWSessionControllerDelegate,NSObject>     _delegate;
}


/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWSessionControllerDelegate,NSObject> delegate;

/**
 * Create a new session
 */
- (void)createSessionWithEmail:(NSString*)email
                   andPassword:(NSString*)password;

@end



/**
 * Protocol for the SessionController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWSessionControllerDelegate

@optional

/**
 * Fired when a session is created
 */
- (void)sessionCreatedForUser:(DWUser*)user;

/**
 * Error message while creating a session
 */
- (void)sessionCreationError:(NSString*)error;

@end

