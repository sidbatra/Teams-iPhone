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
    
    NSInteger   _imageResourceType;
    NSInteger   _imageResourceID;
}

/**
 * Image of the resource
 */
@property (nonatomic,retain) UIImage *image;

/**
 * Text of the resource
 */
@property (nonatomic,copy) NSString *text;

/**
 * Resoure type for the image of the resource
 */
@property (nonatomic,assign) NSInteger imageResourceType;

/**
 * Unique id identifying the image resource
 */
@property (nonatomic,assign) NSInteger imageResourceID;

@end
