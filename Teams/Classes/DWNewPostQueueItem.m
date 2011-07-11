//
//  DWNewPostQueueItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNewPostQueueItem.h"
#import "DWRequestsManager.h"
#import "DWItem.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNewPostQueueItem

@synthesize data                = _data;
@synthesize videoURL            = _videoURL;
@synthesize location            = _location;
@synthesize image               = _image;
@synthesize previewImage        = _previewImage;
@synthesize itemsController     = _itemsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.itemsController            = [[[DWItemsController alloc] init] autorelease];
        self.itemsController.delegate   = self;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.data               = nil;
    self.videoURL           = nil;
    self.location           = nil;
    self.image              = nil;
    self.previewImage       = nil;
    self.itemsController    = nil;
        
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)postWithItemWithData:(NSString*)data
                  atLocation:(CLLocation*)location; {
	
    self.data       = data;
    self.location   = location;
}

//----------------------------------------------------------------------------------------------------
- (void)startMediaUpload {
	[super startMediaUpload];
	
	if(self.image) {
		
		_mediaUploadID = [[DWRequestsManager sharedDWRequestsManager] createImageWithData:self.image
																				 toFolder:kS3ItemsFolder
																	   withUploadDelegate:self];
	}
	else {
        /*
		_mediaUploadID = [[DWRequestsManager sharedDWRequestsManager] createVideoUsingURL:self.
																			atOrientation:self.item.attachment.orientation
																				 toFolder:kS3ItemsFolder
																	   withUploadDelegate:self];
         */
	}
}

//----------------------------------------------------------------------------------------------------
- (void)startPrimaryUpload {
	[super startPrimaryUpload];
    
    [self.itemsController postWithData:self.data
                            atLocation:self.location
                               onQueue:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)start {
	[super start];
	
	if(self.image || self.videoURL)
		[self startMediaUpload];
	else
		[self startPrimaryUpload];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadFinished:(NSString*)theFilename {
	[super mediaUploadFinished:theFilename];
		
	self.image      = nil;
    self.videoURL   = nil;
		
	[self startPrimaryUpload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)itemCreated:(DWItem*)item 
     fromResourceID:(NSInteger)resourceID {
    
    if(resourceID != self.itemsController.createResourceID)
        return;
    
    NSLog(@"new item with id - %d",item.databaseID);
    
    [self primaryUploadFinished];
}

//----------------------------------------------------------------------------------------------------
- (void)itemCreationError:(NSString *)error 
           fromResourceID:(NSInteger)resourceID {
    if(resourceID != self.itemsController.createResourceID)
        return;
    
    NSLog(@"ERROR - %@",error);
	
    [self primaryUploadError];
}

@end
