//
//  DWTouchesController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTouchesController.h"
#import "DWTouch.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"


static NSString* const kCreateTouchURI       = @"/touches/items/%d.json?";
static NSString* const kItemTouchesURI       = @"/items/%d/touches.json?";



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
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(touchesLoaded:) 
													 name:kNTouchesLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(touchesError:) 
													 name:kNTouchesError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Touches controller released");
    
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
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)populateTouchesArrayFromJSON:(NSArray*)data {
    
    NSMutableArray *touches   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *touch in data) {
        [touches addObject:[DWTouch create:touch]];
    }
    
    return touches;
}

//----------------------------------------------------------------------------------------------------
- (void)getTouchesOnItem:(NSInteger)itemID {
    
    NSString *localURL = [NSString stringWithFormat:kItemTouchesURI,itemID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTouchesLoaded
                                                   errorNotification:kNTouchesError
                                                       requestMethod:kGet
                                                          resourceID:itemID];
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

//----------------------------------------------------------------------------------------------------
- (void)touchesLoaded:(NSNotification*)notification {
    
    SEL idSel       = @selector(touchesResourceID);
    SEL touchesSel  = @selector(touchesLoaded:);
    
    if(![self.delegate respondsToSelector:touchesSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *items   = [self populateTouchesArrayFromJSON:data];
    
    [self.delegate performSelector:touchesSel
                        withObject:items];
}

//----------------------------------------------------------------------------------------------------
- (void)touchesError:(NSNotification*)notification {
    
    SEL idSel    = @selector(touchesResourceID);
    SEL errorSel = @selector(touchesError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel
                        withObject:[error localizedDescription]];
}



@end
