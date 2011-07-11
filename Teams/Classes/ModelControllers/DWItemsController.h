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
 * Post a new item created at the given location
 * with a attachment filename. Blank represents no attachment
 * previewImage is the video thumbnail or image preview cached
 * for instant display
 */
- (void)postWithData:(NSString *)data
          atLocation:(CLLocation *)location
        withFilename:(NSString*)filename
     andPreviewImage:(UIImage*)image;

/**
 * Add creation of item without an attachment
 * to the content creation queue
 */
- (void)queueWithData:(NSString*)data
           atLocation:(CLLocation*)location;

/**
 * Add creation of item with an image attachment 
 * to the content creation queue
 */
- (void)queueWithData:(NSString *)data
           atLocation:(CLLocation *)location
            withImage:(UIImage*)image;

/**
 * Add creation of item with a video attachment
 * to the content creation queue
 */
- (void)queueWithData:(NSString*)data
           atLocation:(CLLocation*)location
         withVideoURL:(NSURL*)videoURL
  andVideoOrientation:(NSString*)videoOrientation
     withPreviewImage:(UIImage*)image;

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
