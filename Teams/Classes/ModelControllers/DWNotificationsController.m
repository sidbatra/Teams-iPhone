//
//  DWNotificationsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsController.h"
#import "DWNotification.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"

static NSString* const kCurrentUserNotificationsURI           = @"/notifications.json?before=%d";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
             
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(notificationsLoaded:) 
													 name:kNNotificationsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(notificationsError:) 
													 name:kNNotificationsError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"notifications controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)populateNotificationsArrayFromJSON:(NSArray*)data {
    
    NSMutableArray *notifications   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *notification in data) {
        [notifications addObject:[DWNotification create:notification]];
    }
    
    return notifications;
}

//----------------------------------------------------------------------------------------------------
- (void)getNotificationsForCurrentUserBefore:(NSInteger)before {
    
    NSString *localURL  = [NSString stringWithFormat:kCurrentUserNotificationsURI,before];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNotificationsLoaded
                                                   errorNotification:kNNotificationsError
                                                       requestMethod:kGet];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(notificationsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSArray *data                   = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *notifications   = [self populateNotificationsArrayFromJSON:data];
    
    [self.delegate performSelector:sel 
                        withObject:notifications];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsError:(NSNotification*)notification {
    
    SEL sel = @selector(notificationsError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end