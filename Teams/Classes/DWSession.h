//
//  DWSession.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "DWUser.h"

/**
 * Manages the current user's session
 */
@interface DWSession : NSObject {
	DWUser			*_currentUser;
	CLLocation		*_location;
    NSURL           *_launchURL;
    
	BOOL			_firstVisitRecorded;
    BOOL            _firstTimeUser;
    
    NSInteger       _lastReadItemID;
    NSInteger       _selectedTabIndex;
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
 * Current location of the user
 */
@property (nonatomic,retain) CLLocation *location;

/**
 * Holds a launch URL if the was loaded via a url
 */
@property (nonatomic,retain) NSURL *launchURL;

/**
 * Indicates whether its the user's first session 
 */
@property (nonatomic,readonly) BOOL firstTimeUser;

/**
 * Database ID of the last item read by the user in the feed
 * that was not the user's own item
 */
@property (nonatomic,readonly) NSInteger lastReadItemID;

/**
 * Index of the currently selected tab
 */
@property (nonatomic,readonly) NSInteger selectedTabIndex;


/**
 * Read the user session from disk using NSUserDefaults
 */
- (void)read;

/**
 * Creae the user session with the given user object
 */
- (void)create:(DWUser*)newUser;

/**
 * Destroy the user session
 */
- (void)destroy;

/**
 * Populate the _lastReadItemID from disk
 */
- (void)readLastReadItemID;

/**
 * Reads whether this is a first session or not
 */
- (void)readFirstTimeUser;

/**
 * Updates the firstTimeUser flag on disk
 */
- (void)updateFirstTimeUser;

/**
 * Test whether a user is currently signed in
 */
- (BOOL)isActive;

/**
 * Tests the given userID with the current user' ID
 */
- (BOOL)doesCurrentUserHaveID:(NSInteger)userID;

/**
 * Transitions the app to a mode where there are unread feed items
 */
- (void)gotoUnreadItemsMode:(NSInteger)newItemID;

/**
 * Transitions the app to a mode where the feed items are read
 */
- (void)gotoReadItemsMode;

@end
