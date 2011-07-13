//
//  DWSessionController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;
@protocol DWSessionControllerDelegate;


/**
 * Handles requests for the session lifecycle
 */
@interface DWSessionController : NSObject {
    
    id<DWSessionControllerDelegate,NSObject>     _delegate;
}


/**
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

/**
 * Create a new session
 */
- (void)createSessionWithEmail:(NSString*)email
				  withPassword:(NSString*)password;

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

