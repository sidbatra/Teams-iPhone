//
//  DWMediaController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWMediaControllerDelegate;

/**
 * Interface to the media service on app server and S3
 */
@interface DWMediaController : NSObject {
    
    id <DWMediaControllerDelegate,NSObject>  _delegate;    
}

/**
 * Delegate recieves events based on the DWInvitesControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWMediaControllerDelegate,NSObject> delegate;


/**
 * Post image to the specified folder
 */
- (NSInteger)postImage:(UIImage*)image
              toFolder:(NSString*)folder;

@end


/**
 * Protocol for the MediaController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWMediaControllerDelegate

@optional

/**
 * Used for pinging delegates of the object waiting for the right resourceID
 */
- (NSInteger)mediaResourceID;

/**
 * Fired when the media is uploaded the server
 */
- (void)mediaUploaded:(NSString*)filename;

/**
 * Error message while uploading the media
 */
- (void)mediaUploadError:(NSString*)error;


@end