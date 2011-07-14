//
//  DWSessionController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSessionController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "DWSession.h"
#import "DWUser.h"


static NSString* const kNewSessionURI			= @"/session.json?email=%@&password=%@";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSessionController

//----------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    
    if(self) {
        _delegate   = theDelegate;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sessionCreated:) 
													 name:kNNewSessionCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sessionError:) 
													 name:kNNewSessionError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createSessionWithEmail:(NSString*)email withPassword:(NSString*)password {
    
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sessionCreated:(NSNotification*)notification {

	if(![_delegate respondsToSelector:@selector(sessionCreatedForUser:)])
		return;

    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    DWUser *user        = [DWUser create:data];
    
    [_delegate sessionCreatedForUser:user];
}

//----------------------------------------------------------------------------------------------------
- (void)sessionError:(NSNotification*)notification {
	
    if(![_delegate respondsToSelector:@selector(sessionCreationError:)])
		return;
        
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [_delegate sessionCreationError:[error localizedDescription]];
}


@end
