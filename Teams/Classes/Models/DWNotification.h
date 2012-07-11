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
    NSString        *_details;
    
    BOOL            _unread;
    
    UIImage         *_image;
    
    BOOL            _isImageDownloading;
    
    NSTimeInterval	_createdAtTimestamp;
}

/**
 * Resource ID of the notification
 */
@property (nonatomic,readonly) NSInteger resourceID;

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
 * Optional details associated with the notification
 */
@property (nonatomic,copy) NSString* details;

/**
 * Checks whether the Notification has been read by 
 * the current user or not
 */
@property (nonatomic,assign) BOOL unread;

/**
 * Image location at imageURL
 */
@property (nonatomic) UIImage* image;

/**
 * Timestamp of the date of creation of the notification
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;


/**
 * Start downloading the image with the notification
 */
- (void)startImageDownload;

@end
