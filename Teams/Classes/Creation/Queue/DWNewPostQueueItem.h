//
//  DWNewPostQueueItem.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "DWItemsController.h"
#import "DWCreationQueueItem.h"


/**
 * Queue item for creating a new post
 */
@interface DWNewPostQueueItem : DWCreationQueueItem<DWItemsControllerDelegate> {
    NSString            *_data;
    NSURL               *_videoURL;
    NSString            *_videoOrientation;
    CLLocation          *_location;
    
    UIImage             *_image;
    UIImage             *_previewImage;
    
    NSTimeInterval      _createdAt;
    
    DWItemsController   *_itemsController;
}

/**
 * The text being posted
 */
@property (nonatomic,copy) NSString *data;

/**
 * URL on disk of the video attachment
 */
@property (nonatomic,retain) NSURL *videoURL;

/**
 * Orientation at which the video was recorded
 */
@property (nonatomic,copy) NSString *videoOrietation;

/**
 * Geo location from which the item is being posted
 */
@property (nonatomic,retain) CLLocation *location;

/**
 * UIImage for an image attachment
 */
@property (nonatomic,retain) UIImage *image;

/**
 * Preview image to be hooked to the attachment of
 * the final parsed DWItem object
 */
@property (nonatomic,retain) UIImage *previewImage;

/**
 * Interface to the items service on the app server
 */
@property (nonatomic,retain) DWItemsController *itemsController;


/**
 * Post item without an attachment
 */
- (void)postWithItemWithData:(NSString*)data
                  atLocation:(CLLocation*)location;

/**
 * Post item with an image attachment
 */
- (void)postWithItemWithData:(NSString*)data
                  atLocation:(CLLocation*)location
                   withImage:(UIImage*)image;

/**
 * Post item with a video attachment
 */
- (void)postWithItemWithData:(NSString*)data
                  atLocation:(CLLocation*)location
                withVideoURL:(NSURL*)videoURL
        withVideoOrientation:(NSString*)videoOrientation
            withPreviewImage:(UIImage*)image;

@end

