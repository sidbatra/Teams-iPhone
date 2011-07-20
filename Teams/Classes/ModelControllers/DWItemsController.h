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
    id<DWItemsControllerDelegate,NSObject> _delegate;
}

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
- (NSInteger)postWithData:(NSString *)data
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
 * Get items followed by the current user. Use before for pagination.
 */
- (void)getFollowedItemsBefore:(NSInteger)before;

/**
 * Get items created by the given userID. Use before for pagination.
 */
- (void)getUserItemsForUserID:(NSInteger)userID
                       before:(NSInteger)before;

/**
 * Get items created by the given teamID. Use before for pagination.
 */
- (void)getTeamItemsForTeamID:(NSInteger)teamID
                       before:(NSInteger)before;

/**
 * Get an individual item
 */
- (void)getItemWithID:(NSInteger)itemID;

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
 * Used for pinging delegates of the objects waiting for the right resourceID
 */
- (NSInteger)itemsResourceID;

/**
 * Array of parsed DWItem objects followed by the current user
 */
- (void)followedItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered while loading followed items
 */
- (void)followedItemsError:(NSString*)message;

/**
 * Array of parsed DWItem objects created by a specific user
 */
- (void)userItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered while loading a user's items
 */
- (void)userItemsError:(NSString*)message;

/**
 * Array of parsed DWItem objects created by a specific team
 */
- (void)teamItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered while loading a teams's items
 */
- (void)teamItemsError:(NSString*)message;

/**
 * Parsed DWItem
 */
- (void)itemLoaded:(DWItem*)item;

/**
 * Error message encourntered while fetching an individual item
 */
- (void)itemError:(NSString*)error;

@end
