//
//  DWRequest.h
//  Copyright 2011 Denwen. All rights reserved.
//	

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"

/**
 * Provides a base class for all requests
 */
@interface DWRequest : ASIFormDataRequest {
	NSInteger		_resourceID;
    
	NSString		*_successNotification;
	NSString		*_errorNotification;
    
    NSUInteger      _callerID;
}


/**
 * Optinal unique identifier for the resource being requested (default -1)
 */
@property (nonatomic,assign) NSInteger resourceID;

/**
 * Name of the notification to be fired when the request finished 
 * successfully
 */
@property (nonatomic,copy) NSString* successNotification;

/**
 * Name of the notification to be fired when the request fails
 * with an error
 */
@property (nonatomic,copy) NSString* errorNotification;

/**
 * Optional unique identifier for the calling object, 0 by default
 */
@property (nonatomic,assign) NSUInteger callerID;


/**
 * Static method to return an autoreleased object
 * created using initWithRequestURL
 */
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification;

/**
 * Static method to return an autoreleased object
 * created using requestWthRequestURL with additional resource ID
 */
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification
				 resourceID:(NSInteger)theResourceID;

/**
 * Overloaded version of requestWithRequestURL that sets the caller
 * object that initiated the request
 */
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification
                   callerID:(NSUInteger)callerID;
/**
 * Overloaded version of requestWithRequestURL that sets the caller
 * object that initiated the request and a request resource id
 */
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification
				 resourceID:(NSInteger)theResourceID 
                   callerID:(NSUInteger)callerID;


/**
 * Init with request url and notification names to be invoked
 * after request execution
 */
- (id)initWithRequestURL:(NSString*)requestURL 
	 successNotification:(NSString*)theSuccessNotification
	   errorNotification:(NSString*)theErrorNotification;

/*
 * Stub method overriden by each child class to process the response
 * of a successful request
 */
- (void)processResponse:(NSString*)responseString 
        andResponseData:(NSData*)responseData;

/**
 * Stub method overriden by each child class to process an error
 * in finishing the request
 */
- (void)processError:(NSError*)error;


@end
