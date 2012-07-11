//
//  DWAttachment.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 * Attachment model represents media entities attached to
 * an item
 */
@interface DWAttachment : DWPoolObject {
	NSString		*_largeURL;
	NSString		*_sliceURL;
	NSString		*_actualURL;
	
	NSInteger		_fileType;
	
	BOOL			_isProcessed;
	BOOL			_isLargeDownloading;
	BOOL			_isSliceDownloading;
	
	UIImage			*_largeImage;
	UIImage			*_sliceImage;
}

/**
 * Filetype for the attachment - image or video
 */
@property (nonatomic,assign) NSInteger fileType;

/**
 * URL of the actual attachment
 */
@property (nonatomic,copy) NSString *actualURL;

/**
 * URL of the large image
 */
@property (nonatomic,copy) NSString *largeURL;

/**
 * URL of the slice image
 */
@property (nonatomic,copy) NSString *sliceURL;

/**
 * Image downloaded from largeURL
 */
@property (nonatomic) UIImage *largeImage;

/**
 * Image downloaded from sliceURL
 */
@property (nonatomic) UIImage *sliceImage;



/**
 * Start downloading the image at largeURL
 */
- (void)startLargeDownload;

/**
 * Start downloading the image at sliceURL
 */
- (void)startSliceDownload;

/**
 * Is the attachment a video
 */
- (BOOL)isVideo;

/**
 * Is the attachment an image
 */
- (BOOL)isImage;

@end

