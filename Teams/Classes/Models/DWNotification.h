//
//  DWNotification.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 * System generated messages relaying app activity to the user
 */
@interface DWNotification : DWPoolObject {
    NSInteger       _resourceID;
    
    NSString        *_entityData;
    NSString        *_eventData;
    NSString        *_resourceType;
    NSString        *_imageURL;
    
    UIImage         *_image;
    
    BOOL            _isImageDownloading;
    
    NSTimeInterval	_createdAtTimestamp;
}

/**
 * Text about the entity featured in the notification
 */
@property (nonatomic,copy) NSString* entityData;

/**
 * Text about the event in the notification
 */
@property (nonatomic,copy) NSString* eventData;

/**
 * The type of resource the notification leads to
 */
@property (nonatomic,copy) NSString* resourceType;

/**
 * Optional URL of the attached image
 */
@property (nonatomic,copy) NSString* imageURL;

/**
 * Image location at imageURL
 */
@property (nonatomic,retain) UIImage* image;

/**
 * Timestamp of the date of creation of the notification
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;


/**
 * Start downloading the image with the notification
 */
- (void)startImageDownload;

@end
