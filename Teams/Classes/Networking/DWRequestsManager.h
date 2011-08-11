//
//  DWRequestsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//	

#import <Foundation/Foundation.h>

/**
 * DWRequestsManager enables absracted access to all network operations
 * via a simple interface
 */
@interface DWRequestsManager : NSObject {

}

/**
 * Shared sole instance of the class
 */
+ (DWRequestsManager *)sharedDWRequestsManager;


/**
 * Create a post request to be sent to the app server. The post params are sent
 * via the request body and not the URL to accomodate large params.
 */
- (NSInteger)createPostBodyBasedDenwenRequest:(NSString*)localRequestURL
                                   withParams:(NSDictionary*)params
                          successNotification:(NSString*)successNotification
                            errorNotification:(NSString*)errorNotification;

/**
 * Create a request to be sent to the app server.
 * resourceID is bundled with the success/error notification for identification
 * authentcate indicates the need to append the current user's email password
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                      resourceID:(NSInteger)resourceID
                    authenticate:(NSInteger)authenticate
                        callerID:(NSUInteger)callerID;

/**
 * Overloaded method for createDenwenRequest. Generates a unique
 * resourceID.
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                    authenticate:(BOOL)authenticate;

/**
 * Overloaded method for createDenwenRequest. Authentication defaults
 * to YES
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                      resourceID:(NSInteger)resourceID;

/**
 * Overloaded method for createDenwenRequest. Authentication defaults
 * to YES and a caller object is specified
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                      resourceID:(NSInteger)resourceID 
                        callerID:(NSUInteger)callerID;

/**
 * Overloaded method for createDenwenRequest. Generates a unique
 * resourceID and authentication is on by default
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod;

/**
 * Overloaded method for createDenwenRequest. Generates a unique
 * resourceID and authentication is on by default and 
 * a caller object is specified
 */
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                        callerID:(NSUInteger)callerID;
/**
 * Download the image from the given URL and fire the given
 * notifications
 */
- (NSInteger)getImageAt:(NSString*)url 
         withResourceID:(NSInteger)resourceID
    successNotification:(NSString*)theSuccessNotification
      errorNotification:(NSString*)theErrorNotification;


/**
 * Upload an image to a S3 folder. Method returns
 * the resource ID to uniquely identify the image upload
 * uploadDelegate receive events about the upload progress
 */
- (NSInteger)createImageWithData:(UIImage*)image 
                      withPrefix:(NSString*)prefix
			  withUploadDelegate:(id)uploadDelegate;

/**
 * Upload video located at the URL to the S3 folder. Method returns
 * the resource ID to unique identify the video upload
 * uploadDelegate receive events about the upload progress
 */
- (NSInteger)createVideoUsingURL:(NSURL*)theURL
				   atOrientation:(NSString*)orientation 
                      withPrefix:(NSString*)prefix
			  withUploadDelegate:(id)uploadDelegate;

@end

