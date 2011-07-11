//
//  DWItemsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DWItemsControllerDelegate;
@class DWItem;

/**
 * Interface to the Items service on the app server
 */
@interface DWItemsController : NSObject {
    NSInteger   _createResourceID;
    
    id<DWItemsControllerDelegate,NSObject> _delegate;
}

/**
 * resourceID used for the last create item request
 */
@property (nonatomic,readonly) NSInteger createResourceID;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWItemsControllerDelegate,NSObject> delegate;


/**
 * Create a new item posted by the current user.
 * queue indicates whether the request should be posted directly
 * or via the global content creation queue
 */
- (void)postWithData:(NSString*)data
          atLocation:(CLLocation*)location
             onQueue:(BOOL)queue;

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
 * Fired when a new item is created
 */
- (void)itemCreated:(DWItem*)item 
     fromResourceID:(NSInteger)resourceID;

/**
 * Error message while creating an item
 */
- (void)itemCreationError:(NSString*)error 
           fromResourceID:(NSInteger)resourceID;

/**
 * Array of parsed DWItem objects
 */
- (void)followedItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered
 */
- (void)followedItemsError:(NSString*)message;
@end
