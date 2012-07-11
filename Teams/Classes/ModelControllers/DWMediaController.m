//
//  DWMediaController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMediaController.h"

#import "DWConstants.h"
#import "DWRequestsManager.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMediaController

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(mediaUploadDone:) 
													 name:kNS3UploadDone
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(mediaUploadError:) 
													 name:kNS3UploadError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Media controller released");    
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Creation

//----------------------------------------------------------------------------------------------------
- (NSInteger)postImage:(UIImage*)image 
            withPrefix:(NSString*)prefix {
    
    return [[DWRequestsManager sharedDWRequestsManager] createImageWithData:image
                                                                 withPrefix:prefix
                                                         withUploadDelegate:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadDone:(NSNotification*)notification {
    
    SEL idSel           = @selector(mediaResourceID);
    SEL mediaSel        = @selector(mediaUploaded:);
    
    if(![self.delegate respondsToSelector:mediaSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo      = [notification userInfo];
    NSInteger resourceID        = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    [self.delegate performSelector:mediaSel
                        withObject:[userInfo objectForKey:kKeyFilename]];

}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadError:(NSNotification*)notification {
    
    SEL idSel           = @selector(mediaResourceID);
    SEL errorSel        = @selector(mediaUploadError:);
	
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
