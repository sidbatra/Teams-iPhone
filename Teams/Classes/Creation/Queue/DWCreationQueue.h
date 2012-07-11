//
//  DWCreationQueue.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DWCreationQueueItem;

/**
 * Queue for managing asynchronous creation
 */
@interface DWCreationQueue : NSObject {
	
	NSMutableArray *_queue;
}

/**
 * The sole shared instance of the class
 */
+ (DWCreationQueue *)sharedDWCreationQueue;

/**
 * Queue of items being created simultaneously
 */
@property (nonatomic) NSMutableArray *queue;


/**
 * Add a new item onto the queue and start processing it
 */
- (void)addQueueItem:(DWCreationQueueItem*)queueItem;

/**
 * Delete all failed requests from the queue
 */
- (void)deleteRequests;

/**
 * Retry all failed requests
 */
- (void)retryRequests;

@end
