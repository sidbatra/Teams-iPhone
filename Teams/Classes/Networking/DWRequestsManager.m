//
//  DWRequestsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWRequestsManager.h"
#import "DWSession.h"
#import "DWConstants.h"

#import "ASIDownloadCache.h"

// Requests
#import "DWDenwenRequest.h"
#import "DWImageRequest.h"
#import "DWS3Request.h"

#import "NSString+Helpers.h"
#import "SynthesizeSingleton.h"


static NSInteger const kDefaultResourceID		= -1;


/**
 * Private method and property declarations
 */
@interface DWRequestsManager()

/**
 * Form the complete URL with or without authentication to send
 * a request to the app server
 */
- (NSString*)createDenwenRequestURL:(NSString*)localRequestURL 
                       authenticate:(BOOL)authenticate;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequestsManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DWRequestsManager);

//----------------------------------------------------------------------------------------------------
- (NSString*)createDenwenRequestURL:(NSString*)localRequestURL 
                       authenticate:(BOOL)authenticate {
	
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@%@",
                            kDenwenProtocol,
                            kDenwenServer,
                            localRequestURL];
    
    [url appendFormat:@"&v=%@",kVersion];
    
    if(authenticate && [[DWSession sharedDWSession] isActive])
        [url appendFormat:@"&email=%@&password=%@",
         [[DWSession sharedDWSession].currentUser.email stringByEncodingHTMLCharacters],
         [[DWSession sharedDWSession].currentUser.encryptedPassword stringByEncodingHTMLCharacters]];
    
                            
	return	[NSString stringWithString:url];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Denwen Requests

//----------------------------------------------------------------------------------------------------
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                      resourceID:(NSInteger)resourceID
                    authenticate:(NSInteger)authenticate {
	
	
	NSString *requestURL = [self createDenwenRequestURL:localRequestURL
                                           authenticate:authenticate];
	
	DWDenwenRequest *request = nil;
    
    if(resourceID == kDefaultResourceID) {
        request = [DWDenwenRequest requestWithRequestURL:requestURL
                                     successNotification:successNotification
                                       errorNotification:errorNotification];
    }
    else {
        request = [DWDenwenRequest requestWithRequestURL:requestURL
                                     successNotification:successNotification
                                       errorNotification:errorNotification
                                              resourceID:resourceID];
    }
    
	[request setDelegate:self];
	[request setRequestMethod:requestMethod];
    
    if(requestMethod == kPost)
        [request setShouldContinueWhenAppEntersBackground:YES];

	[request startAsynchronous];
	
    return request.resourceID;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod {
    
    return [self createDenwenRequest:localRequestURL
                 successNotification:successNotification
                   errorNotification:errorNotification
                       requestMethod:requestMethod
                          resourceID:kDefaultResourceID
                        authenticate:YES];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createDenwenRequest:(NSString*)localRequestURL 
             successNotification:(NSString*)successNotification
               errorNotification:(NSString*)errorNotification
                   requestMethod:(NSString*)requestMethod
                    authenticate:(BOOL)authenticate {
    
    return [self createDenwenRequest:localRequestURL
                 successNotification:successNotification
                   errorNotification:errorNotification
                       requestMethod:requestMethod
                          resourceID:kDefaultResourceID
                        authenticate:authenticate];
}
			

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Image Requests

//----------------------------------------------------------------------------------------------------
- (NSInteger)getImageAt:(NSString*)url 
         withResourceID:(NSInteger)resourceID
    successNotification:(NSString*)theSuccessNotification
      errorNotification:(NSString*)theErrorNotification {
	
	DWImageRequest *request = [DWImageRequest requestWithRequestURL:url 
														 resourceID:resourceID
												successNotification:theSuccessNotification
												  errorNotification:theErrorNotification];
	[request setDelegate:self];
	[request setRequestMethod:kGet];
	[request startAsynchronous];
    
    return request.resourceID;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark S3 Requests

//----------------------------------------------------------------------------------------------------
- (NSInteger)createImageWithData:(UIImage*)image
						toFolder:(NSString*)folder
			  withUploadDelegate:(id)uploadDelegate {
	
	DWS3Request *request			= [DWS3Request requestNewImage:image
														  toFolder:folder];
	request.showAccurateProgress	= YES;
	[request setDelegate:self];
	[request setUploadProgressDelegate:uploadDelegate];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[request startAsynchronous];
	
	return request.resourceID;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createVideoUsingURL:(NSURL*)theURL
				   atOrientation:(NSString*)orientation 
						toFolder:(NSString*)folder
			  withUploadDelegate:(id)uploadDelegate {
	
	DWS3Request *request			= [DWS3Request requestNewVideo:theURL 
													 atOrientation:orientation
														  toFolder:folder];
	request.showAccurateProgress	= YES;
	[request setDelegate:self];
	[request setShouldContinueWhenAppEntersBackground:YES];
	[request setUploadProgressDelegate:uploadDelegate];
	[request startAsynchronous];
	
	return request.resourceID;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ASIHTTPRequestDelegate

//----------------------------------------------------------------------------------------------------
- (void)requestFinished:(DWRequest*)request {
	[request processResponse:[request responseString] andResponseData:[request responseData]];
}

//----------------------------------------------------------------------------------------------------
- (void)requestFailed:(DWRequest*)request {
	[request processError:[request error]];
}

/*
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes {
}


- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength {
}
*/

@end
