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


static NSString* const kFollowedItemsURI    = @"/followed/items.json?before=%d&after=%d";
static NSString* const kCreateItemURI       = @"/items.json?item[data]=%@&item[lat]=%f&item[lon]=%f&item[filename]=%@";


/**
 * Private method and property declarations
 */
@interface DWItemsController()
    - (void)getFollowedItems;
@end



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
        _role = kItemsControllerRoleFollowed;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)initWithRole:(DWItemsControllerRole)role {
    self = [super init];
    
    if(self) {
        
        _role = role;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemCreated:) 
													 name:kNNewItemCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemCreationError:) 
													 name:kNNewItemError
												   object:nil];
        
        switch(_role) {
            case kItemsControllerRoleFollowed:
                
                [[NSNotificationCenter defaultCenter] addObserver:self 
                                                         selector:@selector(itemsLoaded:) 
                                                             name:kNFollowedItemsLoaded
                                                           object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self 
                                                         selector:@selector(itemsError:) 
                                                             name:kNFollowedItemsError
                                                           object:nil];	
                break;
            default:
                break;
        }
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
- (void)queueWithData:(NSString*)data
           atLocation:(CLLocation*)location
         withVideoURL:(NSURL*)videoURL
  andVideoOrientation:(NSString*)videoOrientation
     withPreviewImage:(UIImage*)image {
    
    DWNewPostQueueItem *queueItem = [[[DWNewPostQueueItem alloc] init] autorelease];
    
    [queueItem postWithItemWithData:data
                         atLocation:location
                       withVideoURL:videoURL
               withVideoOrientation:videoOrientation
                   withPreviewImage:image];
    
    [[DWCreationQueue sharedDWCreationQueue] addQueueItem:queueItem];
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowedItems {
    
    NSTimeInterval before   = 0;
    NSTimeInterval after    = 0;
    
    switch(_paginationType) {
        case kPaginationTypeOlder:
            before = _oldestTimestamp;
            break;
        default:
            break;
    }
    
    NSString *localURL = [NSString stringWithFormat:kFollowedItemsURI,(NSInteger)before,(NSInteger)after];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNFollowedItemsLoaded
                                                   errorNotification:kNFollowedItemsError
                                                       requestMethod:kGet];
}

//----------------------------------------------------------------------------------------------------
- (void)getItems {
    
    _paginationType = kPaginationTypeNone;
    
    switch(_role) {
        case kItemsControllerRoleFollowed:
            [self getFollowedItems];
        default:
            break;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)getMoreItems {
    
    _paginationType = kPaginationTypeOlder;
    
    switch(_role) {
        case kItemsControllerRoleFollowed:
            [self getFollowedItems];
        default:
            break;
    }
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
- (void)itemsLoaded:(NSNotification*)notification {
    
    if(![self.delegate respondsToSelector:@selector(itemsLoaded:)])
        return;
        
    
    NSArray *data           = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *items   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *item in data) {
        [items addObject:[DWItem create:item]];
    }
    
    _oldestTimestamp = ((DWItem*)[items lastObject]).createdAtTimestamp;
    
    switch (_paginationType) {
        case kPaginationTypeNone:
            [self.delegate itemsLoaded:items];
            break;
        case kPaginationTypeOlder:
            if([self.delegate respondsToSelector:@selector(moreItemsLoaded:)])
                [self.delegate moreItemsLoaded:items];
        default:
            break;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)itemsError:(NSNotification*)notification {
    
    if(![self.delegate respondsToSelector:@selector(itemsError:)])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate itemsError:[error localizedDescription]];
}

@end
