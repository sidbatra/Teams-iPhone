//
//  DWInteractionsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInteractionsController.h"
#import "DWRequestsManager.h"
#import "NSString+Helpers.h"
#import "DWConstants.h"

static NSString* const kCreateInteractionsURI   = @"/interactions.json?data=%@";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInteractionsController

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(interactionsCreated:) 
													 name:kNInteractionsCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(interactionsError:) 
													 name:kNInteractionsError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"interactions controller released");
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)postInteractions:(NSString*)interactionsJSON {
    
    NSString *localURL = [NSString stringWithFormat:kCreateInteractionsURI,
                          [interactionsJSON stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNInteractionsCreated
                                                   errorNotification:kNInteractionsError
                                                       requestMethod:kPost];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)interactionsCreated:(NSNotification*)notification {
    
    SEL sel = @selector(interactionsCreated);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    [self.delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void)interactionsError:(NSNotification*)notification {
    
    SEL sel = @selector(interactionsCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end


