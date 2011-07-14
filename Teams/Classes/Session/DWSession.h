//
//  DWSession.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUser.h"

/**
 * Manages the current user's session
 */
@interface DWSession : NSObject {
	DWUser			*_currentUser;
}

/**
 * Shared sole instance of the class
 */
+ (DWSession *)sharedDWSession;

/**
 * User object representing the current user
 */
@property (nonatomic,retain) DWUser* currentUser;


/**
 * Create an in-memory session and store user archive on disk
 */
- (void)create:(DWUser*)user;

/**
 * Update the stored user archive on disk
 */
- (void)update;

/**
 * Destroy the in-memory session and remove user archive from disk
 */
- (void)destroy;

/**
 * Test whether a user is currently signed in
 */
- (BOOL)isActive;

@end



