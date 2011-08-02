//
//  DWFacebookConnect.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFacebookConnect.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFacebookConnect

@synthesize facebook    	= _facebook;
@synthesize accessToken     = _accessToken;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    
    self = [super init];
    
    if(self) {
        self.facebook	= [[[Facebook alloc] initWithAppId:kFacebookAppID] autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(facebookURLOpened:) 
													 name:kNFacebookURLOpened
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.facebook       = nil;
    self.accessToken    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)authenticate {
    
    BOOL isAuthenticated = NO;
    
    if(self.accessToken) {
		self.facebook.accessToken		= self.accessToken;
		self.facebook.expirationDate	= [NSDate distantFuture];
        
        isAuthenticated                 = YES;
	}
    else {
        [self.facebook authorize:[NSArray arrayWithObjects:
                                  @"offline_access", 
                                  @"publish_stream",
                                  @"user_education_history",
                                  @"user_groups",
                                  @"user_likes",
                                  @"user_location",
                                  @"user_work_history",
                                  @"user_events",
                                  @"friends_education_history",
                                  @"friends_work_history",
                                  @"friends_likes",
                                  nil] 
                        delegate:self];
    }
    
    return isAuthenticated;
}

//----------------------------------------------------------------------------------------------------
- (void)getProfilePicture {
    [self.facebook requestWithGraphPath:@"/me/picture?type=large" 
                            andDelegate:self];
}

//----------------------------------------------------------------------------------------------------
- (void)createWallPostWithMessage:(NSString*)message 
                             name:(NSString*)name 
                      description:(NSString*)description 
                          caption:(NSString*)caption
                             link:(NSString*)link
                       pictureURL:(NSString*)pictureURL {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message				,@"message",
                                   name                 ,@"name",
                                   description			,@"description",
                                   caption              ,@"caption",
                                   link                 ,@"link",
                                   pictureURL			,@"picture",
                                   nil];
    
    [self.facebook requestWithGraphPath:@"/me/feed"   
							  andParams:params
						  andHttpMethod:@"POST"
							andDelegate:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)facebookURLOpened:(NSNotification*)notification {
	[self.facebook handleOpenURL:(NSURL*)[notification object]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FBSessionDelegate

//----------------------------------------------------------------------------------------------------
- (void)fbDidLogin {
    
    self.accessToken = self.facebook.accessToken;
    
    SEL sel = @selector(fbAuthenticated);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
-(void)fbDidNotLogin:(BOOL)cancelled {
    
    SEL sel = @selector(fbAuthenticationFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FBReqestDelegate

//----------------------------------------------------------------------------------------------------
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	/**
	 * Called when the Facebook API request has returned a response. This callback
	 * gives you access to the raw response. It's called before
	 * (void)request:(FBRequest *)request didLoad:(id)result,
	 * which is passed the parsed response object.
	 */
}

//----------------------------------------------------------------------------------------------------
- (void)request:(FBRequest *)request didLoad:(id)result {
	/** 
	 * Called when a request returns and its response has been parsed into
	 * an object. The resulting object may be a dictionary, an array, a string,
	 * or a number, depending on the format of the API response. If you need access
	 * to the raw response, use:
	 *
	 * (void)request:(FBRequest *)request
	 *      didReceiveResponse:(NSURLResponse *)response
	 */
	
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
    
    
    SEL sel = @selector(fbRequestLoaded:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:result];
}

//----------------------------------------------------------------------------------------------------
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {

    SEL sel = @selector(fbRequestFailed:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:error];
}



@end
