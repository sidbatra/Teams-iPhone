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


static NSString* const kCreateItemURI       = @"/items.json?item[data]=%@&item[lat]=%f&item[lon]=%f&item[filename]=%@";
static NSString* const kFollowedItemsURI    = @"/followed/items.json?before=%d";
static NSString* const kUserItemsURI        = @"/users/%d/items.json?before=%d";
static NSString* const kTeamItemsURI        = @"/teams/%d/items.json?before=%d";
static NSString* const kItemURI             = @"/items/%d.json?";
static NSString* const kItemDeleteURI       = @"/items/%d.json?";


/**
 * Private method and property declarations
 */
@interface DWItemsController()

/**
 * Populate a mutable items array from the given items JSON array
 */
- (NSMutableArray*)populateItemsArrayFromJSON:(NSArray*)data;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsController

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userItemsLoaded:) 
                                                     name:kNUserItemsLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(userItemsError:) 
                                                     name:kNUserItemsError
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(teamItemsLoaded:) 
                                                     name:kNTeamItemsLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(teamItemsError:) 
                                                     name:kNTeamItemsError
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemLoaded:) 
                                                     name:kNItemLoaded
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemError:) 
                                                     name:kNItemError
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemDeleted:) 
                                                     name:kNItemDeleted
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemDeleteError:) 
                                                     name:kNItemDeleteError
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
- (NSInteger)postWithData:(NSString *)data
               atLocation:(CLLocation *)location
             withFilename:(NSString*)filename
          andPreviewImage:(UIImage*)image {
    
    NSString *localURL = [NSString stringWithFormat:kCreateItemURI,
                          [data stringByEncodingHTMLCharacters],
                          location.coordinate.latitude,
                          location.coordinate.longitude,
                          filename];
    
    NSInteger resourceID = [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                                        successNotification:kNNewItemCreated
                                                                          errorNotification:kNNewItemError
                                                                              requestMethod:kPost];
    
    if(image) {
        [[DWMemoryPool sharedDWMemoryPool] setObject:image
                                              withID:[NSString stringWithFormat:@"%d",resourceID]
                                            forClass:[UIImage className]];
    }
    
    return resourceID;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)populateItemsArrayFromJSON:(NSArray*)data {
    
    NSMutableArray *items   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *item in data) {
        [items addObject:[DWItem create:item]];
    }
    
    return items;
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowedItemsBefore:(NSInteger)before {
    
    NSString *localURL = [NSString stringWithFormat:kFollowedItemsURI,before];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNFollowedItemsLoaded
                                                   errorNotification:kNFollowedItemsError
                                                       requestMethod:kGet];
}

//----------------------------------------------------------------------------------------------------
- (void)getUserItemsForUserID:(NSInteger)userID
                       before:(NSInteger)before {
    
    NSString *localURL = [NSString stringWithFormat:kUserItemsURI,
                          userID,
                          before];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserItemsLoaded
                                                   errorNotification:kNUserItemsError
                                                       requestMethod:kGet
                                                          resourceID:userID];
}

//----------------------------------------------------------------------------------------------------
- (void)getTeamItemsForTeamID:(NSInteger)teamID
                       before:(NSInteger)before {
    
    NSString *localURL = [NSString stringWithFormat:kTeamItemsURI,
                          teamID,
                          before];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamItemsLoaded
                                                   errorNotification:kNTeamItemsError
                                                       requestMethod:kGet
                                                          resourceID:teamID
                                                              caller:self];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show

//----------------------------------------------------------------------------------------------------
- (void)getItemWithID:(NSInteger)itemID {
    
    NSString *localURL = [NSString stringWithFormat:kItemURI,
                          itemID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNItemLoaded
                                                   errorNotification:kNItemError
                                                       requestMethod:kGet
                                                          resourceID:itemID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Destroy

//----------------------------------------------------------------------------------------------------
- (void)deleteItemWithID:(NSInteger)itemID {
    
    NSString *localURL = [NSString stringWithFormat:kItemDeleteURI,
                          itemID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNItemDeleted
                                                   errorNotification:kNItemDeleteError
                                                       requestMethod:kDelete
                                                          resourceID:itemID];
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
- (void)followedItemsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(followedItemsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
        
    
    NSArray *data           = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *items   = [self populateItemsArrayFromJSON:data];
    
    [self.delegate performSelector:sel 
                        withObject:items];
}

//----------------------------------------------------------------------------------------------------
- (void)followedItemsError:(NSNotification*)notification {
    
    SEL sel = @selector(followedItemsError:);

    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(itemsResourceID);
    SEL itemsSel = @selector(userItemsLoaded:);
    
    if(![self.delegate respondsToSelector:itemsSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
        
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *items   = [self populateItemsArrayFromJSON:data];
    
    [self.delegate performSelector:itemsSel
                        withObject:items];
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsError:(NSNotification*)notification {
    
    SEL idSel    = @selector(itemsResourceID);
    SEL errorSel = @selector(userItemsError:);
    
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

//----------------------------------------------------------------------------------------------------
- (void)teamItemsLoaded:(NSNotification*)notification {
    
    if(notification.object != self)
        return;
    
    
    SEL idSel    = @selector(itemsResourceID);
    SEL itemsSel = @selector(teamItemsLoaded:);
    
    if(![self.delegate respondsToSelector:itemsSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *items   = [self populateItemsArrayFromJSON:data];
    
    [self.delegate performSelector:itemsSel
                        withObject:items];
}

//----------------------------------------------------------------------------------------------------
- (void)teamItemsError:(NSNotification*)notification {
    
    if(notification.object != self)
        return;
    
    
    SEL idSel    = @selector(itemsResourceID);
    SEL errorSel = @selector(teamItemsError:);
    
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

//----------------------------------------------------------------------------------------------------
- (void)itemLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(itemsResourceID);
    SEL itemsSel = @selector(itemLoaded:);
    
    if(![self.delegate respondsToSelector:itemsSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSDictionary *data      = [userInfo objectForKey:kKeyData];
    DWItem *item            = [DWItem create:data];
    
    [self.delegate performSelector:itemsSel
                        withObject:item];
}

//----------------------------------------------------------------------------------------------------
- (void)itemError:(NSNotification*)notification {
    
    SEL idSel    = @selector(itemsResourceID);
    SEL errorSel = @selector(itemError:);
    
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

//----------------------------------------------------------------------------------------------------
- (void)itemDeleted:(NSNotification*)notification {
    
    SEL itemsSel = @selector(itemDeleted:);
    
    if(![self.delegate respondsToSelector:itemsSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];    
    NSDictionary *data      = [userInfo objectForKey:kKeyData];
    
    DWItem *item            = [DWItem create:data];
    
    [self.delegate performSelector:itemsSel
                        withObject:item];
}

//----------------------------------------------------------------------------------------------------
- (void)itemDeleteError:(NSNotification*)notification {
    
    SEL errorSel = @selector(itemDeleteError:);
    
    if(![self.delegate respondsToSelector:errorSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel
                        withObject:[error localizedDescription]];
}

@end
