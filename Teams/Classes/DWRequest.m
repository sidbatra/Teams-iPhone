//
//  DWRequest.m
//  Copyright 2011 Denwen. All rights reserved.
//	

#import "DWRequest.h"

#import "JSON.h"
#import "DWConstants.h"

static NSInteger const kPersistenceTimeout	= 120;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequest

@synthesize resourceID				= _resourceID;
@synthesize successNotification		= _successNotification;
@synthesize errorNotification		= _errorNotification;


//----------------------------------------------------------------------------------------------------
- (id)initWithRequestURL:(NSString*)requestURL 
	 successNotification:(NSString*)theSuccessNotification
	   errorNotification:(NSString*)theErrorNotification {
	
	NSURL *tempURL = [NSURL URLWithString:requestURL];
	
	self = [super initWithURL:tempURL];
	
	if(self != nil) {
		self.successNotification	= theSuccessNotification;
		self.errorNotification		= theErrorNotification;
		
		//[self setShouldAttemptPersistentConnection:NO];
		//[self setPersistentConnectionTimeoutSeconds:kPersistenceTimeout];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	self.successNotification	= nil;
	self.errorNotification		= nil;
	
	[super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Stubs

//----------------------------------------------------------------------------------------------------
- (void)processResponse:(NSString*)responseString andResponseData:(NSData*)responseData {}

//----------------------------------------------------------------------------------------------------
- (void)processError:(NSError*)error {}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Static

//----------------------------------------------------------------------------------------------------
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification {
	
	return [[[self alloc] initWithRequestURL:requestURL
						 successNotification:theSuccessNotification
						   errorNotification:theErrorNotification] 
			autorelease];
}

//----------------------------------------------------------------------------------------------------
+ (id)requestWithRequestURL:(NSString*)requestURL
		successNotification:(NSString*)theSuccessNotification
		  errorNotification:(NSString*)theErrorNotification
				 resourceID:(NSInteger)theResourceID {
	
	DWRequest *request	= [self requestWithRequestURL:requestURL 
								successNotification:theSuccessNotification 
								  errorNotification:theErrorNotification];
	request.resourceID	= theResourceID;
	
	return request;
}

@end
