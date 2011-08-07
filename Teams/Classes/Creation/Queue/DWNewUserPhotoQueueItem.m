//
//  DWNewUserPhotoQueueItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNewUserPhotoQueueItem.h"
#import "DWRequestsManager.h"
#import "DWUser.h"
#import "DWConstants.h"

static NSString* const kQueueErrorDomain		= @"DWQueueError";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNewUserPhotoQueueItem

@synthesize image               = _image;
@synthesize imageClone          = _imageClone;
@synthesize usersController     = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        
        _isSilent = YES;
        
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdated:) 
													 name:kNUserUpdated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdateError:) 
													 name:kNUserUpdateError
												   object:nil];		
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.image              = nil;
    self.imageClone         = nil;
    self.usersController    = nil;
        
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)fireFailureNotification {
    
    NSError *error = [NSError errorWithDomain:kQueueErrorDomain
                                         code:-1
                                     userInfo:[NSDictionary dictionaryWithObject:@""
                                                                          forKey:NSLocalizedDescriptionKey]];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          error, kKeyError,
                          nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserUpdateError
                                                        object:nil
                                                      userInfo:info];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Profile Pic Upload/Update Methods

//----------------------------------------------------------------------------------------------------
- (void)updatePhotoForUserWithID:(NSInteger)userID
                         toImage:(UIImage*)theImage {
    
    self.image          = theImage;
    self.imageClone     = theImage;
    
    _userID             = userID;
    
    [self start];
}

//----------------------------------------------------------------------------------------------------
- (void)startMediaUpload {
	[super startMediaUpload];
    
    //_mediaUploadID = [[DWRequestsManager sharedDWRequestsManager] createImageWithData:self.image
     //                                                                        toFolder:kS3UsersFolder
      //                                                             withUploadDelegate:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)startPrimaryUpload {
	[super startPrimaryUpload];

	//_primaryUploadID = [[DWRequestsManager sharedDWRequestsManager] updatePhotoForUserWithID:_userID
     //                                                                      withPhotoFilename:self.filename];
}

//----------------------------------------------------------------------------------------------------
- (void)start {
	[super start];
	
	if(self.image)
		[self startMediaUpload];
	else
		[self startPrimaryUpload];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadFinished:(NSString*)theFilename {
	[super mediaUploadFinished:theFilename];
    
    self.image  = nil;
        
	[self startPrimaryUpload];
}

//----------------------------------------------------------------------------------------------------
- (void)mediaUploadError {
	[super mediaUploadError];
    
    if ([self isFailed])
        [self fireFailureNotification];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(DWUser*)user {
    [user updateImages:self.imageClone];
    
    [self primaryUploadFinished];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSString*)error {
    [self primaryUploadError];    
}


@end
