//
//  DWTouchesController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTouchesController.h"
#import "DWTouch.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"


static NSString* const kCreateTouchURI       = @"/touches/items/%d.json?";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTouchesController

@synthesize delegate = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(touchCreated:) 
													 name:kNNewTouchCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(touchCreationError:) 
													 name:kNNewTouchError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Items controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)postWithItemID:(NSInteger)itemID {

    NSString *localURL = [NSString stringWithFormat:kCreateTouchURI,
                          itemID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewTouchCreated
                                                   errorNotification:kNNewTouchError
                                                       requestMethod:kPost];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)touchCreated:(NSNotification*)notification {
	
    SEL sel = @selector(touchCreated:);
    
	if(![self.delegate respondsToSelector:sel])
		return;
	
    
    NSDictionary *data      = [[notification userInfo] objectForKey:kKeyData];
    DWTouch *touch          = [DWTouch create:data];
    
    [self.delegate performSelector:sel 
                        withObject:touch];
}

//----------------------------------------------------------------------------------------------------
- (void)touchCreationError:(NSNotification*)notification {
	
    SEL sel = @selector(touchCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
		return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end
