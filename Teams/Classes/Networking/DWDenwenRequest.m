//
//  DWDenwenRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWDenwenRequest.h"

#import "JSON.h"
#import "DWConstants.h"


static NSString* const kDWErrorDomain		= @"DWError";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDenwenRequest

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {
    
    NSDictionary *response      = [responseString JSONValue];
    NSDictionary *errorInfo     = [response objectForKey:kKeyError];
    
    if(errorInfo) {
        [self processError:[NSError errorWithDomain:kDWErrorDomain
                                               code:-1
                                           userInfo:[NSDictionary dictionaryWithObject:[errorInfo objectForKey:kKeyMessage] 
                                                                                forKey:NSLocalizedDescriptionKey]]];
    }
    else {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.resourceID]	,kKeyResourceID,
                              [response objectForKey:kKeyData]          ,kKeyData,
                              nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.successNotification 
                                                            object:self.caller
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
														object:self.caller
													  userInfo:info];
}

/*
 [request setDownloadCache:[ASIDownloadCache sharedCache]];
 [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
 [request setSecondsToCache:1000000];
 */

@end
