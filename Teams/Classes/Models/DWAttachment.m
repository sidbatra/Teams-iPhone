//
//  DWAttachment.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAttachment.h"
#import "DWRequestsManager.h"
#import "UIImage+ImageProcessing.h"
#import "DWConstants.h"

static NSString* const kImgVideolargePlaceholder		= @"video_placeholder.png";
static NSInteger const kSliceX							= 0;
static NSInteger const kSliceY							= 114;
static NSInteger const kSliceWidth						= 320;
static float	 const kSliceHeight						= 92;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAttachment

@synthesize fileType		= _fileType;
@synthesize actualURL		= _actualURL;
@synthesize largeURL		= _largeURL;
@synthesize sliceURL		= _sliceURL;
@synthesize largeImage      = _largeImage;
@synthesize sliceImage		= _sliceImage;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(largeImageLoaded:) 
													 name:kNImgLargeAttachmentLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(largeImageError:) 
													 name:kNImgLargeAttachmentError
													object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sliceImageLoaded:) 
													 name:kNImgSliceAttachmentLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sliceImageError:) 
													 name:kNImgSliceAttachmentError
												   object:nil];
	}
	
	return self; 
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
	self.largeImage	= nil;
	self.sliceImage	= nil;
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
        
    
    NSLog(@"attachment released - %d",self.databaseID);
	
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)attachment {
    [super update:attachment];
    
    NSString *filetype      = [attachment objectForKey:kKeyFileType];
    NSString *isProcessed   = [attachment objectForKey:kKeyIsProcessed];
    NSString *actualURL     = [attachment objectForKey:kKeyActualURL];
	NSString *largeURL      = [attachment objectForKey:kKeyLargeURL];
	NSString *sliceURL      = [attachment objectForKey:kKeySliceURL];

    
    if(filetype)
        _fileType			= [filetype integerValue];
    
    if(isProcessed)
        _isProcessed		= [isProcessed boolValue];
	
    if(actualURL && ![self.actualURL isEqualToString:actualURL])
        self.actualURL		= [attachment objectForKey:kKeyActualURL];
    
    if(largeURL && ![self.largeURL isEqualToString:largeURL]) {
        self.largeURL		= [attachment objectForKey:kKeyLargeURL];
        self.largeImage     = nil;
    }
    
    if(sliceURL && ![self.sliceURL isEqualToString:sliceURL]) {
        self.sliceURL		= [attachment objectForKey:kKeySliceURL];
        self.sliceImage     = nil;
    }
}

//----------------------------------------------------------------------------------------------------							  
- (BOOL)isVideo {
	return _fileType == kAttachmentVideo;
}

//----------------------------------------------------------------------------------------------------							  
- (BOOL)isImage {
	return _fileType == kAttachmentImage;
}

//----------------------------------------------------------------------------------------------------
- (void)appplyNewlargeImage:(UIImage*)image {
	
	NSDictionary *info	= [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithInt:self.databaseID]		,kKeyResourceID,
						   image										,kKeyImage,
						   nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImgLargeAttachmentLoaded
														object:nil
													  userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)appplyNewSliceImage:(UIImage*)image {
	
	NSDictionary *info	= [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithInt:self.databaseID]		,kKeyResourceID,
						   image										,kKeyImage,
						   nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImgSliceAttachmentFinalized
														object:nil
													  userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)startLargeDownload {
	if(!_isLargeDownloading && !self.largeImage) {
		
		if(_isProcessed || [self isImage]) {
			 _isLargeDownloading = YES;
			
			[[DWRequestsManager sharedDWRequestsManager] getImageAt:self.largeURL
													 withResourceID:self.databaseID
												successNotification:kNImgLargeAttachmentLoaded
												  errorNotification:kNImgLargeAttachmentError];
			
		}
		else {
			//[self appplyNewlargeImage:[UIImage imageNamed:kImgVideolargePlaceholder]];
		}
	}
}

//----------------------------------------------------------------------------------------------------
- (void)startSliceDownload {
	if(!_isSliceDownloading && !self.sliceImage) {
		
		if(_isProcessed || [self isImage]) {
			_isSliceDownloading = YES;
			
			[[DWRequestsManager sharedDWRequestsManager] getImageAt:self.sliceURL
													 withResourceID:self.databaseID
												successNotification:kNImgSliceAttachmentLoaded
												  errorNotification:kNImgSliceAttachmentError];
		}
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)largeImageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	self.largeImage	= [info objectForKey:kKeyImage];		
	_isLargeDownloading		= NO;
}

//----------------------------------------------------------------------------------------------------
- (void)largeImageError:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isLargeDownloading		= NO;
}

//----------------------------------------------------------------------------------------------------
- (void)sliceImageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isSliceDownloading	= NO;
	
	
	if(!_isProcessed) {
		
		self.sliceImage = [info objectForKey:kKeyImage];
		
		if(self.sliceImage.size.width != kSliceWidth) {
			self.sliceImage = [self.sliceImage resizeTo:CGSizeMake(kSliceWidth,kSliceWidth)];
		}
		
		self.sliceImage = [self.sliceImage cropToRect:CGRectMake(kSliceX,kSliceY,kSliceWidth,kSliceHeight)];
	}
	else {
		self.sliceImage	= [info objectForKey:kKeyImage];
	}
	
	
	NSDictionary *userInfo	= [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithInt:self.databaseID]		,kKeyResourceID,
							   self.sliceImage								,kKeyImage,
							   nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImgSliceAttachmentFinalized
														object:nil
													  userInfo:userInfo];
}

//----------------------------------------------------------------------------------------------------
- (void)sliceImageError:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isSliceDownloading		= NO;
}

@end
