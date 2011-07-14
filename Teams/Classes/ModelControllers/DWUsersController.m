//
//  DWUsersController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWUser.h"

static NSString* const kNewUserURI			= @"/users.json?user[email]=%@&user[password]=%@";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersController

@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreated:) 
													 name:kNNewUserCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreationError:) 
													 name:kNNewUserError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createUserWithEmail:(NSString*)email andPassword:(NSString*)password {
    
    NSString *localURL = [NSString stringWithFormat:kNewUserURI,
                          [email stringByEncodingHTMLCharacters],
                          [password stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewUserCreated
                                                   errorNotification:kNNewUserError
                                                       requestMethod:kPost 
                                                        authenticate:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Users controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(NSNotification*)notification {
    
    SEL sel = @selector(userCreated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    
    NSLog(@"%@",data);
    
    NSArray *errorInfo = [data objectForKey:kKeyErrors];
    
    if ([errorInfo count] ) {
        NSArray *errors     = [errorInfo objectAtIndex:0];
        NSString *errorMsg  = @"";
        
        for(id error in errors) {
            errorMsg = [errorMsg stringByAppendingFormat:@"%@ ",error];
        }
        
        [self.delegate userCreationError:[errorMsg stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                           withString:[[errorMsg substringToIndex:1] 
                                                                                       uppercaseString]]];
        return;
    }
    
    DWUser *user    = [DWUser create:data];    
    [self.delegate performSelector:sel 
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(userCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end
