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
    id<DWTouchesControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate to receive updates about requested operations
 */
@property (nonatomic,assign) id<DWTouchesControllerDelegate,NSObject> delegate;


/**
 * Create a new touch on itemID
 */
- (void)postWithItemID:(NSInteger)itemID;

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

@end
