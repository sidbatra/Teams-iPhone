//
//  DWFacebookConnect.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@protocol DWFacebookConnectDelegate;

/**
 * Wrapper over the Facebook iOS SDK
 */
@interface DWFacebookConnect : NSObject<FBSessionDelegate,FBRequestDelegate> {
    Facebook    *_facebook;
    NSString    *_accessToken;
    
    id<DWFacebookConnectDelegate,NSObject> _delegate;
}

/**
 * Facebook iOS SDK interface instance
 */
@property (nonatomic,retain) Facebook *facebook;

/**
 * Access token to make requests on behalf of the user
 */
@property (nonatomic,copy) NSString *accessToken;

/**
 * DWFacebookConnectDelegate
 */
@property (nonatomic,assign) id<DWFacebookConnectDelegate,NSObject> delegate;


/**
 * Test authentication status and authenticate if needed. Returns YES if authenticated
 */
- (BOOL)authenticate;

/**
 * Get the largest copy of the user's profile picture
 */
- (void)getProfilePicture;

/**
 * Post a message to the wall
 */
- (void)createWallPostWithMessage:(NSString*)message 
                             name:(NSString*)name 
                      description:(NSString*)description 
                          caption:(NSString*)caption
                             link:(NSString*)link
                       pictureURL:(NSString*)pictureURL;

@end


/**
 * Protocol to fire events about the fbSharing lifecycle
 */
@protocol DWFacebookConnectDelegate 

@optional

- (void)fbAuthenticated;
- (void)fbAuthenticationFailed;
- (void)fbRequestLoaded:(id)result;
- (void)fbRequestFailed:(NSError*)error;
@end