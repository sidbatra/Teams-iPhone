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
    BOOL            _firstTimeUser;
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
 * Indicates whether its the user's first session 
 */
@property (nonatomic,readonly) BOOL firstTimeUser;


/**
 * Test whether a user is currently signed in
 */
- (BOOL)isActive;

@end


/**
 * Private method declarations
 */
@interface DWSession(Private)

/**
 * Read the user session from disk using NSUserDefaults
 */
- (void)read;

/**
 * Reads whether this is a first session or not
 */
- (void)readFirstTimeUser;

/**
 * Creae the user session with the given user object
 */
- (void)create:(DWUser*)newUser;

/**
 * Updates the firstTimeUser flag on disk
 */
- (void)updateFirstTimeUser;

/**
 * Destroy the user session
 */
- (void)destroy;

@end



