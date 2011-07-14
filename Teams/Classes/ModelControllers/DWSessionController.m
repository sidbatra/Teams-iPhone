//
//  DWSessionController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSessionController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWUser.h"


static NSString* const kNewSessionURI			= @"/session.json?email=%@&password=%@";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSessionController

@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sessionCreated:) 
													 name:kNNewSessionCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sessionCreationError:) 
													 name:kNNewSessionError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createSessionWithEmail:(NSString*)email andPassword:(NSString*)password {
    
    NSString *localURL = [NSString stringWithFormat:kNewSessionURI,
                            [email stringByEncodingHTMLCharacters],
                            [password stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewSessionCreated
                                                   errorNotification:kNNewSessionError
                                                       requestMethod:kPost 
                                                        authenticate:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Session controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sessionCreated:(NSNotification*)notification {

    SEL sel = @selector(sessionCreatedForUser:);
    
    if(![self.delegate respondsToSelector:sel])
        return;

    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    DWUser *user        = [DWUser create:data];
    
    [self.delegate performSelector:sel 
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionCreationError:(NSNotification*)notification {
	
    SEL sel = @selector(sessionCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
        
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end
