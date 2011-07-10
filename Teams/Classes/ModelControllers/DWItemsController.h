//
//  DWItemsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWItemsControllerDelegate;

/**
 * Interface to the Items service on the app server
 */
@interface DWItemsController : NSObject {
    id<DWItemsControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWItemsControllerDelegate,NSObject> delegate;


/**
 * Fetch and parse items in the feed of the current user
 */
- (void)getFollowedItems;


@end


/**
 * Protocol for the ItemsController delegate. Fires messages
 * about the success and failure of requests
 */
@protocol DWItemsControllerDelegate

@optional

/**
 * Array of parsed DWItem objects
 */
- (void)followedItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered
 */
- (void)followedItemsError:(NSString*)message;
@end
