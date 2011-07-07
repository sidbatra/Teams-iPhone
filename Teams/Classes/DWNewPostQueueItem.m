//
//  DWNewPostQueueItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNewPostQueueItem.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "DWItem.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNewPostQueueItem

@synthesize item            = _item;
@synthesize previewImage    = _previewImage;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemCreated:) 
													 name:kNNewItemCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemError:) 
													 name:kNNewItemError
												   object:nil];		
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.item           = nil;
    self.previewImage   = nil;
        
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createItemWithData:(NSString*)data {
	self.item					= [[[DWItem alloc] init] autorelease];
	//self.item.usesMemoryPool	= NO;
	self.item.data				= data;	
}

//----------------------------------------------------------------------------------------------------
- (void)createPlaceWithID:(NSInteger)placeID {
    /*
	DWPlace *place			= [[[DWPlace alloc] init] autorelease];
	place.databaseID		= placeID;
	
	self.item.place			= place;
     */
}

//----------------------------------------------------------------------------------------------------
- (void)createPlaceWithName:(NSString*)name
				 atLocation:(CLLocation*)location {
	/*
	DWPlace *place			= [[[DWPlace alloc] init] autorelease];
	place.name				= name;
	place.location			= location;
	
	self.item.place			= place;
     */
}

//----------------------------------------------------------------------------------------------------
- (void)createAttachmentWithImage:(UIImage*)image {
	
	if(!image)
		return;
	/*
	DWAttachment *attachment	= [[[DWAttachment alloc] init] autorelease];
	attachment.fileType			= kAttachmentImage;
	attachment.largeImage		= image;
	
	self.item.attachment		= attachment;
    
    self.previewImage           = image;
     */
}

//----------------------------------------------------------------------------------------------------
- (void)createAttachmentWithVideoURL:(NSURL*)url 
                    withVideoPreview:(UIImage*)videoPreviewImage
					  andOrientation:(NSString*)orientation {
	
	if(!url)
		return;
	
	//DWAttachment *attachment	= [[[DWAttachment alloc] init] autorelease];
	//attachment.fileType			= kAttachmentVideo;
	//attachment.orientation		= orientation;
	//attachment.videoURL			= url;
	
	//self.item.attachment		= attachment;
    
    self.previewImage           = videoPreviewImage;
}

//----------------------------------------------------------------------------------------------------
- (void)postWithItemData:(NSString*)data
	 withAttachmentImage:(UIImage*)image
			   toPlaceID:(NSInteger)placeID {
	
	[self createItemWithData:data];
	[self createPlaceWithID:placeID];
	[self createAttachmentWithImage:image];
	
	[self start];
}

//----------------------------------------------------------------------------------------------------
- (void)postWithItemData:(NSString*)data
			withVideoURL:(NSURL*)url
        withVideoPreview:(UIImage*)videoPreviewImage
		  andOrientation:(NSString*)orientation 
			   toPlaceID:(NSInteger)placeID {
		
	[self createItemWithData:data];
	[self createPlaceWithID:placeID];
	[self createAttachmentWithVideoURL:url
                      withVideoPreview:videoPreviewImage
						andOrientation:orientation];
	
	[self start];
}

//----------------------------------------------------------------------------------------------------
- (void)postWithItemData:(NSString*)data
	 withAttachmentImage:(UIImage*)image
			 toPlaceName:(NSString*)name
			  atLocation:(CLLocation*)location {
	
	[self createItemWithData:data];
	[self createPlaceWithName:name
				   atLocation:location];
	[self createAttachmentWithImage:image];
	
	[self start];
}

//----------------------------------------------------------------------------------------------------
- (void)postWithItemData:(NSString*)data
			withVideoURL:(NSURL*)url
        withVideoPreview:(UIImage*)videoPreviewImage
		  andOrientation:(NSString*)orientation
			 toPlaceName:(NSString*)name
			  atLocation:(CLLocation*)location {
	
	[self createItemWithData:data];
	[self createPlaceWithName:name
				   atLocation:location];
	[self createAttachmentWithVideoURL:url
                      withVideoPreview:videoPreviewImage
						andOrientation:orientation];
	
	[self start];
}

//----------------------------------------------------------------------------------------------------
- (void)startMediaUpload {
	[super startMediaUpload];
	
	if(self.item.attachment.fileType == kAttachmentImage) {
		
		_mediaUploadID = [[DWRequestsManager sharedDWRequestsManager] createImageWithData:self.item.attachment.largeImage
																				 toFolder:kS3ItemsFolder
																	   withUploadDelegate:self];
	}
	else {
        /*
		_mediaUploadID = [[DWRequestsManager sharedDWRequestsManager] createVideoUsingURL:self.item.attachment.videoURL
																			atOrientation:self.item.attachment.orientation
																				 toFolder:kS3ItemsFolder
																	   withUploadDelegate:self];
         */
	}
}

//----------------------------------------------------------------------------------------------------
- (void)startPrimaryUpload {
	[super startPrimaryUpload];
	
	if(self.item.team.databaseID != kMPDefaultDatabaseID) {
		
		_primaryUploadID = [[DWRequestsManager sharedDWRequestsManager] createItemWithData:self.item.data
																	withAttachmentFilename:self.filename
																			 atPlaceWithID:self.item.team.databaseID];
	}
	else {
		/*
		_primaryUploadID = [[DWRequestsManager sharedDWRequestsManager] createItemWithData:self.item.data
																	withAttachmentFilename:self.filename
																		   atPlaceWithName:self.item.place.name
																				atLocation:self.item.place.location.coordinate];
         */
	}
}

//----------------------------------------------------------------------------------------------------
- (void)start {
	[super start];
	
	if(self.item.attachment)
		[self startMediaUpload];
	else
		[self startPrimaryUpload];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadFinished:(NSString*)theFilename {
	[super mediaUploadFinished:theFilename];
		
	self.item.attachment	= nil;
		
	[self startPrimaryUpload];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadError {
	[super mediaUploadError];
}

//----------------------------------------------------------------------------------------------------
- (void)primaryUploadFinished {
	[super primaryUploadFinished];
}

//----------------------------------------------------------------------------------------------------
- (void)primaryUploadError {
	[super primaryUploadError];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)itemCreated:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(_primaryUploadID != resourceID)
		return;
	
	NSDictionary *body = [info objectForKey:kKeyBody];
	
	if([[info objectForKey:kKeyStatus] isEqualToString:kKeySuccess]) {
		

		//DWItem *item = (DWItem*)[[DWMemoryPool sharedDWMemoryPool] getOrSetObject:[body objectForKey:kKeyItem]
		//																	atRow:kMPItemsIndex];
        DWItem *item = nil;
		//item.pointerCount--;
        
        
        if(item.attachment)
            item.attachment.largeImage = self.previewImage;
        
        
				
		[[NSNotificationCenter defaultCenter] postNotificationName:kNNewItemParsed 
															object:nil
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																	item,kKeyItem,
																	nil]];
		if([[body objectForKey:kKeyNewPlace] boolValue]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kNNewPlaceParsed 
																object:nil
															  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																		item.team,kKeyPlace,
																		nil]];
		}	
        
        [self primaryUploadFinished];
	}
	else {
		self.errorMessage = [[body objectForKey:kKeyItem] objectForKey:kKeyErrorMessages];
				
		[self primaryUploadError];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)itemError:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(_primaryUploadID != resourceID)
		return;
		
	[self primaryUploadError];
}

@end
