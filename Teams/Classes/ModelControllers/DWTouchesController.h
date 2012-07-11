//
//  DWTouchesController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTouch;
@protocol DWTouchesControllerDelegate;

/**
 * Interface to the touches service on the app server
 */
@interface DWTouchesController : NSObject {
    id<DWTouchesControllerDelegate,NSObject> __unsafe_unretained _delegate;
}

/**
 * Delegate to receive updates about requested operations
 */
@property (nonatomic,unsafe_unretained) id<DWTouchesControllerDelegate,NSObject> delegate;


/**
 * Create a new touch on itemID
 */
- (void)postWithItemID:(NSInteger)itemID;

/**
 * Get touches on the given itemID
 */
- (void)getTouchesOnItem:(NSInteger)itemID;

@end


/**
 * Protocol for the TouchesController delegate. Fires messages
 * about the success and failure of requests
 */
@protocol DWTouchesControllerDelegate

@optional

/**
 * Fired when a touch is successfully created and parsed
 */
- (void)touchCreated:(DWTouch*)touch;

/**
 * Fired when an error occurs during the creation of a touch
 */
- (void)touchCreationError:(NSString*)error;

/**
 * Used for pinging delegates of the objects waiting for the right resourceID
 */
- (NSInteger)touchesResourceID;

/**
 * Array of parsed DWTouch objects
 */
- (void)touchesLoaded:(NSMutableArray*)touches;

/**
 * Error message encountered while loading touches
 */
- (void)touchesError:(NSString*)message;

@end
