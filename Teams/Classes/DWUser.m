//
//  DWUser.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUser.h"
#import "DWSession.h"
#import "DWRequestsManager.h"
#import "UIImage+ImageProcessing.h"
#import "NSString+Helpers.h"
#import "DWConstants.h"

static NSString* const kImgProfilePicPlaceHolder		= @"profile_pic_placeholder.png";
static NSString* const kImgAddProfilePicPlaceHolder		= @"add_profile_pic_placeholder.png";
static NSString* const kImgMediumPlaceHolder			= @"user_medium_placeholder.png";
static NSString* const kImgSignedInMediumPlaceHolder	= @"profile_button.png";
static NSString* const kDiskKeySignedInUser				= @"signedin_user_";
static NSString* const kDiskKeyID						= @"signedin_user__id";
static NSString* const kDiskKeyEmail					= @"signedin_user__email";
static NSString* const kDiskKeyPassword					= @"signedin_user__password";
static NSString* const kDiskKeyHasPhoto					= @"signedin_user__hasPhoto";
static NSString* const kDiskKeySmallUrl					= @"signedin_user__smallurl";
static NSString* const kDiskKeylargeURL                 = @"signedin_user__largeURL";
static NSString* const kDiskKeyTwitterData				= @"signedin_user__twitterXAuthData";
static NSString* const kDiskKeyFacebookData				= @"signedin_user__facebookAuthToken";
static NSString* const kDiskKeyFirstName				= @"signedin_user__firstName";
static NSString* const kDiskKeyLastName                 = @"signedin_user__lastName";
static NSString* const kDiskKeyByline                   = @"signedin_user__byline";
static NSString* const kDiskKeyFollowingCount           = @"signedin_user__followingCount";
static NSString* const kDiskKeyIsCurrentUser            = @"signedin_user__isCurrentUser";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUser

@synthesize firstName			= _firstName;
@synthesize lastName			= _lastName;
@synthesize byline              = _byline;
@synthesize email				= _email;
@synthesize encryptedPassword	= _encryptedPassword;
@synthesize smallURL			= _smallURL;
@synthesize largeURL			= _largeURL;
@synthesize smallImage          = _smallImage;
@synthesize	hasPhoto			= _hasPhoto;
@synthesize twitterXAuthToken	= _twitterXAuthToken;
@synthesize	facebookAccessToken = _facebookAccessToken;
@synthesize followingCount      = _followingCount;
@synthesize isCurrentUser       = _isCurrentUser;


//----------------------------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID             = [[coder decodeObjectForKey:kDiskKeyID] integerValue];
        self.firstName              = [coder decodeObjectForKey:kDiskKeyFirstName];
        self.lastName               = [coder decodeObjectForKey:kDiskKeyLastName];
        self.email                  = [coder decodeObjectForKey:kDiskKeyEmail];
        self.encryptedPassword      = [coder decodeObjectForKey:kDiskKeyPassword];
        self.byline                 = [coder decodeObjectForKey:kDiskKeyByline];
        self.followingCount         = [[coder decodeObjectForKey:kDiskKeyFollowingCount] integerValue];
        self.twitterXAuthToken      = [coder decodeObjectForKey:kDiskKeyTwitterData];
        self.facebookAccessToken    = [coder decodeObjectForKey:kDiskKeyFacebookData];
        self.hasPhoto               = [[coder decodeObjectForKey:kDiskKeyHasPhoto] boolValue];
        self.smallURL               = [coder decodeObjectForKey:kDiskKeySmallUrl];
        self.largeURL               = [coder decodeObjectForKey:kDiskKeylargeURL];
        self.isCurrentUser          = [[coder decodeObjectForKey:kDiskKeyIsCurrentUser] boolValue];
    }
    
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder*)coder {
    
    [coder encodeObject:[NSNumber numberWithInt:self.databaseID]    	forKey:kDiskKeyID];
    [coder encodeObject:self.firstName                                  forKey:kDiskKeyFirstName];
    [coder encodeObject:self.lastName                                   forKey:kDiskKeyLastName];
    [coder encodeObject:self.email                                      forKey:kDiskKeyEmail];
    [coder encodeObject:self.encryptedPassword                          forKey:kDiskKeyPassword];
    [coder encodeObject:self.byline                                     forKey:kDiskKeyByline];
    [coder encodeObject:[NSNumber numberWithInt:self.followingCount]    forKey:kDiskKeyFollowingCount];
    [coder encodeObject:self.twitterXAuthToken                          forKey:kDiskKeyTwitterData];
    [coder encodeObject:self.facebookAccessToken                        forKey:kDiskKeyFacebookData];
    [coder encodeObject:[NSNumber numberWithBool:self.hasPhoto]         forKey:kDiskKeyHasPhoto];
    [coder encodeObject:self.smallURL                                   forKey:kDiskKeySmallUrl];
    [coder encodeObject:self.largeURL                                   forKey:kDiskKeylargeURL];
    [coder encodeObject:[NSNumber numberWithBool:self.isCurrentUser]    forKey:kDiskKeyIsCurrentUser];
}

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(smallImageLoaded:) 
													 name:kNImgSmallUserLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(smallImageError:) 
													 name:kNImgSmallUserError
												   object:nil];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    self.smallImage = nil;
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSLog(@"user released %d",_databaseID);
		
	self.firstName				= nil;
	self.lastName				= nil;
    self.byline                 = nil;
	self.email					= nil;
	self.encryptedPassword		= nil;
	self.twitterXAuthToken		= nil;
	self.facebookAccessToken	= nil;
    
    self.smallURL               = nil;
    self.largeURL              = nil;
    self.smallImage             = nil;
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)user {
    [super update:user];
	
	NSString *email             = [user objectForKey:kKeyEmail];
    NSString *firstName         = [user objectForKey:kKeyFirstName];
    NSString *lastName          = [user objectForKey:kKeyLastName];
    NSString *byline            = [user objectForKey:kKeyByLine];
    NSString *followingsCount   = [user objectForKey:kKeyFollowingsCount];
    
    if(email && ![self.email isEqualToString:email])
        self.email = email;
    
    if(firstName && ![self.firstName isEqualToString:firstName])
        self.firstName = firstName;
    
    if(lastName && ![self.lastName isEqualToString:lastName])
        self.lastName = lastName;
    
    if(byline && ![self.byline isEqualToString:byline])
        self.byline = [user objectForKey:kKeyByLine];
    
    if(followingsCount)
        self.followingCount = [followingsCount integerValue];
    
    
    if([user objectForKey:kKeyPhoto]) {
        NSDictionary *photo		= [user objectForKey:kKeyPhoto];
        NSString *smallURL      = [photo objectForKey:kKeySmallURL]; 
        
       _hasPhoto                = YES;
        
        if(![self.smallURL isEqualToString:smallURL]) {
            self.smallURL           = smallURL;
            self.largeURL          = [photo objectForKey:kKeyLargeURL];
            
            _isProcessed            = [[photo objectForKey:kKeyIsProcessed] boolValue];
            
            self.smallImage         = nil;
        }
    } 
}

//----------------------------------------------------------------------------------------------------
- (void)applyNewSmallImage:(UIImage*)image {
    
    
    self.smallImage         = image;
    
	NSDictionary *info      = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:self.databaseID]		,kKeyResourceID,
                               image										,kKeyImage,
                               nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImgSmallUserLoaded
														object:nil
													  userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)updateImages:(UIImage*)image {
	[self applyNewSmallImage:image];
}

//----------------------------------------------------------------------------------------------------
- (void)startSmallImageDownload {
    
	if(_hasPhoto && !_isSmallDownloading && !self.smallImage) {
		_isSmallDownloading = YES;
		
		[[DWRequestsManager sharedDWRequestsManager] getImageAt:self.smallURL
												 withResourceID:self.databaseID
											successNotification:kNImgSmallUserLoaded
											  errorNotification:kNImgSmallUserError];
	}
	else if(!_hasPhoto && !self.smallImage){ 
        
        [self applyNewSmallImage:[UIImage imageNamed:[self isCurrentUser] ? 
                                                     kImgAddProfilePicPlaceHolder : 
                                                     kImgProfilePicPlaceHolder]];
         
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)smallImageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	self.smallImage         = [info objectForKey:kKeyImage];		
	_isSmallDownloading     = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)smallImageError:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isSmallDownloading = NO;
}

@end
