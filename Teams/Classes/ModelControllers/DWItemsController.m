//
//  DWItemsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsController.h"
#import "DWItem.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"

static NSString* const kFollowedItemsURI    = @"/followed/items.json?";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsController

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followedItemsLoaded:) 
													 name:kNFollowedItemsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followedItemsError:) 
													 name:kNFollowedItemsError
												   object:nil];	
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowedItems {
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:kFollowedItemsURI
                                                 successNotification:kNFollowedItemsLoaded
                                                   errorNotification:kNFollowedItemsError
                                                       requestMethod:kGet];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)followedItemsLoaded:(NSNotification*)notification {
    
    if(![self.delegate respondsToSelector:@selector(followedItemsLoaded:)])
        return;
        
    
    NSArray *data           = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *items   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *item in data) {
        [items addObject:[DWItem create:item]];
    }
    
    [self.delegate followedItemsLoaded:items];
}

//----------------------------------------------------------------------------------------------------
- (void)followedItemsError:(NSNotification*)notification {
    
    if(![self.delegate respondsToSelector:@selector(followedItemsError:)])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate followedItemsError:[error localizedDescription]];
}

@end
