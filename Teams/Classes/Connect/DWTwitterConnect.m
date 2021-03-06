//
//  DWTwitterConnect.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTwitterConnect.h"
#import "DWSession.h"
#import "DWRequestsManager.h"
#import "TwitterConsumer.h"
#import "TwitterToken.h"
#import "TwitterTweetPoster.h"
#import "DWConstants.h"


static NSUInteger const kTagTwitterUsername     = 19875;
static NSUInteger const kTagTwitterPassword     = 19455;
static NSUInteger const kTwitterAlertOKIndex    = 1;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTwitterConnect

@synthesize consumer        = _consumer;
@synthesize authenticator   = _authenticator;
@synthesize poster          = _poster;
@synthesize xAuthToken      = _xAuthToken;
@synthesize xAuthAlertView  = _xAuthAlertView;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.consumer = [[[TwitterConsumer alloc] initWithKey:kTwitterOAuthConsumerKey 
                                                       secret:kTwitterOAuthConsumerSecret] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.consumer           = nil;
    self.authenticator      = nil;
    self.poster             = nil;
    self.xAuthToken         = nil;
    self.xAuthAlertView     = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)displayAuthenticationUI {
    
    self.xAuthAlertView               = [[[UIAlertView alloc] init] autorelease];
    self.xAuthAlertView.delegate      = self;
    self.xAuthAlertView.title         = @"Log in to Twitter";
    self.xAuthAlertView.message       = @"\n\n\n";
    
    [self.xAuthAlertView addButtonWithTitle:@"Cancel"];
    [self.xAuthAlertView addButtonWithTitle:@"Log In"];
    
    
    
    UITextField *userNameField              = [[[UITextField alloc] initWithFrame:CGRectMake(11,
                                                                                             43.0,
                                                                                             262,
                                                                                             32)] autorelease];
    userNameField.placeholder               = @"Twitter username";
    userNameField.delegate                  = self;
    userNameField.returnKeyType             = UIReturnKeyNext;
    userNameField.borderStyle               = UITextBorderStyleRoundedRect;
    userNameField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;;
    userNameField.tag                       = kTagTwitterUsername;
    userNameField.backgroundColor           = [UIColor clearColor];
    userNameField.autocorrectionType        = UITextAutocorrectionTypeNo;
    userNameField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    
    [self.xAuthAlertView addSubview:userNameField];    
    
    
    UITextField *passwordField              = [[[UITextField alloc] initWithFrame:CGRectMake(11,
                                                                                             81,
                                                                                             262,
                                                                                             32)] autorelease];
    passwordField.placeholder               = @"Twitter password";
    passwordField.delegate                  = self;
    passwordField.returnKeyType             = UIReturnKeyDone;
    passwordField.borderStyle               = UITextBorderStyleRoundedRect;
    passwordField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
    passwordField.tag                       = kTagTwitterPassword;
    passwordField.backgroundColor           = [UIColor clearColor];
    passwordField.autocorrectionType        = UITextAutocorrectionTypeNo;
    passwordField.secureTextEntry           = YES;
    
    [self.xAuthAlertView addSubview:passwordField];    
    
    
    
    [self.xAuthAlertView show];
    
    [userNameField performSelector:@selector(becomeFirstResponder) 
                        withObject:nil
                        afterDelay:0.35];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)authenticate {
    
    BOOL isAuthenticated = NO;
    
    if(self.xAuthToken) 
        isAuthenticated = YES;
    else 
        [self displayAuthenticationUI];
    
    return isAuthenticated;
}

//----------------------------------------------------------------------------------------------------
- (void)createTweetWithText:(NSString*)text {
    
    self.poster             = [TwitterTweetPoster new];
    
    self.poster.consumer    = self.consumer;
    self.poster.token       = (TwitterToken*)[NSKeyedUnarchiver unarchiveObjectWithData:[DWSession sharedDWSession].currentUser.twitterXAuthToken];
    self.poster.delegate    = self;
    self.poster.message     = text;
    
    [self.poster execute];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == kTwitterAlertOKIndex) {
        
        NSString *username = nil;
        NSString *password = nil;

        for(UIView *subview in alertView.subviews) {
            if(subview.tag == kTagTwitterUsername)
                username    = ((UITextField*)subview).text;
            else if(subview.tag == kTagTwitterPassword)
                password    = ((UITextField*)subview).text;
        }
        
        self.authenticator              = [TwitterAuthenticator new];
        
        self.authenticator.consumer     = self.consumer;
        self.authenticator.username     = username;
        self.authenticator.password     = password;
        self.authenticator.delegate     = self;
        
        [_authenticator authenticate];

        SEL sel = @selector(twAuthenticating);
        
        if([_delegate respondsToSelector:sel])
            [_delegate performSelector:sel];
    }
    else {
        SEL sel = @selector(twAuthenticationFailed);
        
        if([_delegate respondsToSelector:sel])
            [_delegate performSelector:sel];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if(textField.tag == kTagTwitterUsername) {
        
        for(UIView *subview in self.xAuthAlertView.subviews)
            if(subview.tag == kTagTwitterPassword)
                [((UITextField*)subview) becomeFirstResponder];
	}
	else if(textField.tag == kTagTwitterPassword) {
        [self.xAuthAlertView dismissWithClickedButtonIndex:kTwitterAlertOKIndex 
                                                  animated:YES];
		[self alertView:self.xAuthAlertView clickedButtonAtIndex:kTwitterAlertOKIndex];
	}
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TwitterAuthenticatorDelegate

//----------------------------------------------------------------------------------------------------
- (void) twitterAuthenticator:(TwitterAuthenticator*)twitterAuthenticator
             didFailWithError:(NSError*)error {
    
    [self displayAuthenticationUI];
    
    SEL sel = @selector(twAuthenticationFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void) twitterAuthenticator:(TwitterAuthenticator*)twitterAuthenticator
          didSucceedWithToken:(TwitterToken*)token {
    
    self.xAuthToken                                             = [NSKeyedArchiver archivedDataWithRootObject:token]; 
    [DWSession sharedDWSession].currentUser.twitterXAuthToken   = self.xAuthToken;
    [[DWSession sharedDWSession] update];
        
    SEL sel = @selector(twAuthenticatedWithToken:andSecret:);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel 
                        withObject:token.token 
                        withObject:token.secret];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TwitterTweetPosterDelegate

//----------------------------------------------------------------------------------------------------
- (void)twitterTweetPosterDidSucceed:(TwitterTweetPoster*)twitterTweetPoster {
    
    SEL sel = @selector(twSharingDone);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void)twitterTweetPoster:(TwitterTweetPoster*)twitterTweetPoster 
          didFailWithError:(NSError*)error {
    
    SEL sel = @selector(twSharingFailed);
    
    if([_delegate respondsToSelector:sel])
        [_delegate performSelector:sel];
}

@end
