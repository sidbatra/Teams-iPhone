//
//  DWTwitterConnect.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwitterAuthenticator.h"
#import "TwitterTweetPoster.h"

@class TwitterConsumer;
@protocol DWTwitterConnectDelegate;

/**
 * Wrapper over the Twitter XAuth Libs
 */
@interface DWTwitterConnect : NSObject<TwitterAuthenticatorDelegate,TwitterTweetPosterDelegate,UITextFieldDelegate> {
    TwitterConsumer         *_consumer;
    TwitterAuthenticator    *_authenticator;
    TwitterTweetPoster      *_poster;
    
    NSData                  *_xAuthToken;
    UIAlertView             *_xAuthAlertView;

    id<DWTwitterConnectDelegate,NSObject>   _delegate;
}

/**
 * Represents the API client
 */
@property (nonatomic,retain) TwitterConsumer *consumer;

/**
 * Performs authentications of behalf of the user
 */
@property (nonatomic,retain) TwitterAuthenticator *authenticator;

/**
 * Tweet posting wrapper
 */
@property (nonatomic,retain) TwitterTweetPoster *poster;

/**
 * Access token to make requests on behalf of the user
 */
@property (nonatomic,retain) NSData *xAuthToken;

/**
 * Customized alert view for getting the user's xauth info
 */
@property (nonatomic,retain) UIAlertView *xAuthAlertView;

/**
 * DWTwitterConnectDelegate
 */
@property (nonatomic,assign) id<DWTwitterConnectDelegate,NSObject> delegate;


/**
 * Test authentication status and authenticate if needed. Returns YES if authenticated
 */
- (BOOL)authenticate;

/**
 * Send tweet on behalf of the user
 */
- (void)createTweetWithText:(NSString*)text;

@end


/**
 * Delegate protocol to fire events about the Twitter authentication
 * and sharing lifecycle
 */
@protocol DWTwitterConnectDelegate
- (void)twAuthenticating;
- (void)twAuthenticationFailed;
- (void)twSharingDone;
- (void)twSharingFailed;
- (void)twAuthenticatedWithToken:(NSString*)token 
                       andSecret:(NSString*)secret;
@end
