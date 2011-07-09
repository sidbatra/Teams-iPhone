//
//  DWDenwenRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWDenwenRequest.h"

#import "JSON.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDenwenRequest

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {
    
    NSDictionary *response      = [responseString JSONValue];
    NSDictionary *errorInfo     = [response objectForKey:kKeyError];
    
    if(errorInfo) {
        [self processError:[NSError errorWithDomain:[errorInfo objectForKey:kKeyMessage]
                                               code:-1
                                           userInfo:nil]];
    }
    else {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
                              response                                  ,kKeyBody,
                              nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.successNotification 
                                                            object:nil
                                                          userInfo:info];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)processError:(NSError*)theError {
	
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
								theError									,kKeyError,
								nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:self.errorNotification
														object:nil
													  userInfo:info];
}

/*
 [request setDownloadCache:[ASIDownloadCache sharedCache]];
 [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
 [request setSecondsToCache:1000000];
 */

@end
