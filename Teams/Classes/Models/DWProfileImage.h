//
//  DWProfileImage.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Profile image model used to inject profile 
 * (large size) images into table views
 */
@interface DWProfileImage : NSObject {
    UIImage     *_image;
    NSInteger   _imageID;
}

/**
 * Image
 */
@property (nonatomic) UIImage *image;


/**
 * Unique id identifying the image
 */
@property (nonatomic,assign) NSInteger imageID;

@end
