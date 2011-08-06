//
//  DWNotification.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotification.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotification

@synthesize resourceID          = _resourceID;
@synthesize entityData          = _entityData;
@synthesize eventData           = _eventData;
@synthesize resourceType        = _resourceType;
@synthesize imageURL            = _imageURL;
@synthesize image               = _image;
@synthesize details             = _details;
@synthesize createdAtTimestamp  = _createdAtTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageLoaded:) 
													 name:kNImgSmallNotificationLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageError:) 
													 name:kNImgSmallNotificationError
                                                   object:nil];
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	NSLog(@"notification released - %d",self.databaseID);
    
    self.entityData     = nil;
    self.eventData      = nil;
    self.resourceType   = nil;
    self.imageURL       = nil;
    self.details        = nil;
    self.image          = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    self.image = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)notification {
    [super update:notification];
	
    NSString *resourceID        = [notification objectForKey:kKeyResourceID];
	NSString *entityData        = [notification objectForKey:kKeyEntityData];
    NSString *eventData         = [notification objectForKey:kKeyEventData];
    NSString *resourceType      = [notification objectForKey:kKeyResourceType];
    NSString *details           = [notification objectForKey:kKeyDetails];
    NSString *timestamp         = [notification objectForKey:kKeyTimestamp];
    NSDictionary *image         = [notification objectForKey:kKeyImage];
    
    
    if(resourceID)
        _resourceID = [resourceID integerValue];
    
    if(timestamp)
        _createdAtTimestamp = [timestamp integerValue];
    
    if(entityData && ![self.entityData isEqualToString:entityData])
        self.entityData = entityData;
    
    if(eventData && ![self.eventData isEqualToString:eventData])
        self.eventData = eventData;

    if(resourceType && ![self.resourceType isEqualToString:resourceType])
        self.resourceType = resourceType;
    
    if(details && ![self.details isEqualToString:details])
        self.details = details;

    
    if(image) {
        NSString *imageURL = [image objectForKey:kKeySmallURL];
        
        if(imageURL && ![self.imageURL isEqualToString:imageURL]) {
            self.imageURL = imageURL;
        }
    } 
}

//----------------------------------------------------------------------------------------------------
- (void)startImageDownload {
    
    if(!_isImageDownloading && !self.image) {
		_isImageDownloading = YES;
		
		[[DWRequestsManager sharedDWRequestsManager] getImageAt:self.imageURL
												 withResourceID:self.databaseID
											successNotification:kNImgSmallNotificationLoaded
											  errorNotification:kNImgSmallNotificationError];
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)imageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
    self.image              = [info objectForKey:kKeyImage];		
	_isImageDownloading     = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)imageError:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isImageDownloading     = NO;
}


@end
