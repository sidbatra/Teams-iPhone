//
//  DWItemsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DWItemsControllerDelegate;
@class DWItem;

/**
 * Enumeration for the types of roles under
 * which multiple items can be fetched from the
 * items service
 */
typedef enum {
    kItemsControllerRoleFollowed  = 0,
    kItemsControllerRoleUser      = 1,
    kItemsControllerRoleTeam      = 2,
    kItemsControllerRoleNone      = 3 
} DWItemsControllerRole;

/**
 * Different pagination options for requests
 */
typedef enum {
    kPaginationTypeNone     = 0,
    kPaginationTypeOlder    = 1
} DWPaginationType;


/**
 * Interface to the Items service on the app server
 */
@interface DWItemsController : NSObject {
    NSInteger               _createResourceID;
    
    NSTimeInterval          _oldestTimestamp;
    
    DWItemsControllerRole   _role;
    DWPaginationType        _paginationType;
    
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
 * Init with a specific role if using it for loading a list of items
 */
- (id)initWithRole:(DWItemsControllerRole)role;

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
 * Load the first page of items based on the specified role
 */
- (void)getItems;

/**
 * Load the next page of items
 */
- (void)getMoreItems;

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
 * Array of parsed DWItem objects prepared based on the role specified
 */
- (void)itemsLoaded:(NSMutableArray*)items;

/**
 * Next page of parsed DWItem objects based on the role specified
 */
- (void)moreItemsLoaded:(NSMutableArray*)items;

/**
 * Error message encountered while loading items
 */
- (void)itemsError:(NSString*)message;
@end
