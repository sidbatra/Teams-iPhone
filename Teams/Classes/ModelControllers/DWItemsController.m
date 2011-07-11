//
//  DWItemsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsController.h"
#import "DWItem.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "DWCreationQueue.h"
#import "DWNewPostQueueItem.h"
#import "NSString+Helpers.h"
#import "NSObject+Helpers.h"
#import "DWConstants.h"

static NSString* const kFollowedItemsURI    = @"/followed/items.json?";
static NSString* const kCreateItemURI       = @"/items.json?item[data]=%@&item[lat]=%f&item[lon]=%f&item[filename]=%@";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsController

@synthesize createResourceID    = _createResourceID;
@synthesize delegate            = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemCreated:) 
													 name:kNNewItemCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemCreationError:) 
													 name:kNNewItemError
												   object:nil];
        
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
    
    NSLog(@"Items controller released %d",_createResourceID);

    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)postWithData:(NSString *)data
          atLocation:(CLLocation *)location
        withFilename:(NSString*)filename
     andPreviewImage:(UIImage*)image {
    
    NSString *localURL = [NSString stringWithFormat:kCreateItemURI,
                          [data stringByEncodingHTMLCharacters],
                          location.coordinate.latitude,
                          location.coordinate.longitude,
                          filename];
    
    _createResourceID = [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                                     successNotification:kNNewItemCreated
                                                                       errorNotification:kNNewItemError
                                                                           requestMethod:kPost];
    
    if(image) {
        [[DWMemoryPool sharedDWMemoryPool] setObject:image
                                              withID:[NSString stringWithFormat:@"%d",_createResourceID]
                                            forClass:[UIImage className]];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)queueWithData:(NSString*)data
          atLocation:(CLLocation*)location {
    
    DWNewPostQueueItem *queueItem = [[[DWNewPostQueueItem alloc] init] autorelease];
    
    [queueItem postWithItemWithData:data
                         atLocation:location];
    
    [[DWCreationQueue sharedDWCreationQueue] addQueueItem:queueItem];
}

//----------------------------------------------------------------------------------------------------
- (void)queueWithData:(NSString*)data
          atLocation:(CLLocation*)location
           withImage:(UIImage*)image {    
    
    DWNewPostQueueItem *queueItem = [[[DWNewPostQueueItem alloc] init] autorelease];
    
    [queueItem postWithItemWithData:data
                         atLocation:location
                          withImage:image];
    
    [[DWCreationQueue sharedDWCreationQueue] addQueueItem:queueItem];
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
- (void)itemCreated:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(![self.delegate respondsToSelector:@selector(itemCreated:fromResourceID:)])
		return;
	
    
    NSDictionary *data  = [info objectForKey:kKeyData];
    DWItem *item        = [DWItem create:data];
    
    if(item.attachment) {    
        UIImage *preview = [[DWMemoryPool sharedDWMemoryPool] getObjectWithID:[NSString stringWithFormat:@"%d",resourceID]
                                                                     forClass:[UIImage className]];
        item.attachment.largeImage  = preview;
        
        if(preview)
            NSLog(@"preview set!!");
    }
    
    [_delegate itemCreated:item
            fromResourceID:resourceID];
}

//----------------------------------------------------------------------------------------------------
- (void)itemCreationError:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
    if(![self.delegate respondsToSelector:@selector(itemCreationError:fromResourceID:)])
		return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate itemCreationError:[error localizedDescription] 
                      fromResourceID:resourceID];
}

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
