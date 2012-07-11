//
//  DWResource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A generic model object to hold text and media
 */
@interface DWResource : NSObject {
    UIImage     *_image;
    NSString    *_text;
    NSString    *_subText;
    NSString    *_statText;
    
    NSInteger   _ownerID;
    NSInteger   _imageResourceType;
    NSInteger   _imageResourceID;
}

/**
 * Image of the resource
 */
@property (nonatomic) UIImage *image;

/**
 * Text of the resource
 */
@property (nonatomic,copy) NSString *text;

/**
 * Optional secondary text - blank by default
 */
@property (nonatomic,copy) NSString *subText;

/**
 * Optional stat text.
 */
@property (nonatomic,copy) NSString *statText;

/**
 * Resoure type for the image of the resource
 */
@property (nonatomic,assign) NSInteger imageResourceType;

/**
 * Unique id identifying the image resource
 */
@property (nonatomic,assign) NSInteger imageResourceID;

/**
 * ID for the owner of the resource
 */
@property (nonatomic,assign) NSInteger ownerID;


/**
 * Check if the resource object has an image
 */
- (BOOL)hasImage;


@end
