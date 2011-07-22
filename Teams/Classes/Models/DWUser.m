//
//  DWUser.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUser.h"
#import "DWSession.h"
#import "DWRequestsManager.h"
#import "UIImage+ImageProcessing.h"
#import "DWConstants.h"

static NSString* const kImgProfilePicPlaceHolder		= @"profile_pic_placeholder.png";
static NSString* const kImgAddProfilePicPlaceHolder		= @"add_profile_pic_placeholder.png";
static NSString* const kImgMediumPlaceHolder			= @"user_medium_placeholder.png";
static NSString* const kImgSignedInMediumPlaceHolder	= @"profile_button.png";
static NSString* const kDiskKeyID						= @"DWUser_id";
static NSString* const kDiskKeyEmail					= @"DWUser_email";
static NSString* const kDiskKeyPassword					= @"DWUser_password";
static NSString* const kDiskKeyHasPhoto					= @"DWUser_hasPhoto";
static NSString* const kDiskKeySmallUrl					= @"DWUser_smallurl";
static NSString* const kDiskKeylargeURL                 = @"DWUser_largeURL";
static NSString* const kDiskKeyTwitterData				= @"DWUser_twitterXAuthData";
static NSString* const kDiskKeyFacebookData				= @"DWUser_facebookAuthToken";
static NSString* const kDiskKeyFirstName				= @"DWUser_firstName";
static NSString* const kDiskKeyLastName                 = @"DWUser_lastName";
static NSString* const kDiskKeyByline                   = @"DWUser_byline";
static NSString* const kDiskKeyFollowingCount           = @"DWUser_followingCount";
static NSString* const kDiskKeyIsCurrentUser            = @"DWUser_isCurrentUser";
static NSString* const kDiskKeyIsNewUser                = @"DWUser_isNewUser";
static NSString* const kDiskKeyHasInvitedPeople         = @"DWUser_hasInvitedPeople";
static NSString* const kDiskKeyTeam                     = @"DWUser_Team";


/**
 * Private method and property declarations
 */
@interface DWUser()

/**
 * Attach observers to receive notifications
 */
- (void)attachObservers;

@end



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
@synthesize largeImage          = _largeImage;
@synthesize	hasPhoto			= _hasPhoto;
@synthesize twitterXAuthToken	= _twitterXAuthToken;
@synthesize	facebookAccessToken = _facebookAccessToken;
@synthesize followingCount      = _followingCount;
@synthesize createdAtTimestamp  = _createdAtTimestamp;
@synthesize isCurrentUser       = _isCurrentUser;
@synthesize isNewUser           = _isNewUser;
@synthesize hasInvitedPeople    = _hasInvitedPeople;
@synthesize team                = _team;

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
        self.isNewUser              = [[coder decodeObjectForKey:kDiskKeyIsNewUser] boolValue];
        self.hasInvitedPeople       = [[coder decodeObjectForKey:kDiskKeyHasInvitedPeople] boolValue];        
        self.team                   = [coder decodeObjectForKey:kDiskKeyTeam];
    }
    
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
    
    [self attachObservers];
    
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
    [coder encodeObject:[NSNumber numberWithBool:self.isNewUser]        forKey:kDiskKeyIsNewUser];
    [coder encodeObject:[NSNumber numberWithBool:self.hasInvitedPeople] forKey:kDiskKeyHasInvitedPeople];    
    [coder encodeObject:self.team                                       forKey:kDiskKeyTeam];

}

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
        [self attachObservers];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)attachObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallImageLoaded:) 
                                                 name:kNImgSmallUserLoaded
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallImageError:) 
                                                 name:kNImgSmallUserError
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(largeImageLoaded:) 
                                                 name:kNImgLargeUserLoaded
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(largeImageError:) 
                                                 name:kNImgLargeUserError
                                               object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    self.smallImage = nil;
    self.largeImage = nil;
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
    self.largeURL               = nil;
    self.smallImage             = nil;
    self.largeImage             = nil;
    
    [self.team destroy];
    self.team                   = nil;
	
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
    NSString *timestamp         = [user objectForKey:kKeyTimestamp];
    NSDictionary *photo         = [user objectForKey:kKeyPhoto];
    NSDictionary *team          = [user objectForKey:kKeyTeam];

    
    if(email && ![self.email isEqualToString:email])
        self.email = email;
    
    if(firstName && ![firstName isKindOfClass:[NSNull class]] && ![self.firstName isEqualToString:firstName])
        self.firstName = firstName;
    
    if(lastName && ![lastName isKindOfClass:[NSNull class]] && ![self.lastName isEqualToString:lastName])
        self.lastName = lastName;
    
    if(byline && ![byline isKindOfClass:[NSNull class]] && ![self.byline isEqualToString:byline])
        self.byline = [user objectForKey:kKeyByLine];
    
    if(followingsCount)
        self.followingCount = [followingsCount integerValue];
    
    if(timestamp)
        _createdAtTimestamp = [timestamp integerValue];
    
    
    if(photo) {
        NSString *smallURL      = [photo objectForKey:kKeySmallURL]; 
        NSString *largeURL      = [photo objectForKey:kKeyLargeURL];
        
       _hasPhoto = YES;
        
        if(smallURL && ![self.smallURL isEqualToString:smallURL]) {
            self.smallURL       = smallURL;
            self.smallImage     = nil;
        }
        
        if(largeURL && ![self.largeURL isEqualToString:largeURL]) {
            self.largeURL       = [photo objectForKey:kKeyLargeURL];
            self.largeImage     = nil;
        }
    } 
    
    
    if(team) {
        if(self.team)
            [self.team update:team];
        else
            self.team = [DWTeam create:team];
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
- (void)applyNewLargeImage:(UIImage*)image {
    
    
    self.largeImage         = image;
    
	NSDictionary *info      = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:self.databaseID]		,kKeyResourceID,
                               image										,kKeyImage,
                               nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNImgLargeUserLoaded
														object:nil
													  userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)updateImages:(UIImage*)image {
	[self applyNewSmallImage:image];
    [self applyNewLargeImage:image];
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
- (NSString*)getDomainFromEmail {
   return [self.email substringFromIndex:[self.email rangeOfString:@"@"].location + 1];
}

//----------------------------------------------------------------------------------------------------
- (void)startLargeImageDownload {
    
	if(_hasPhoto && !_isLargeDownloading && !self.largeImage) {
		_isLargeDownloading = YES;
		
		[[DWRequestsManager sharedDWRequestsManager] getImageAt:self.largeURL
												 withResourceID:self.databaseID
											successNotification:kNImgLargeUserLoaded
											  errorNotification:kNImgLargeUserError];
	}
	else if(!_hasPhoto && !self.largeImage){ 
        
        [self applyNewLargeImage:[UIImage imageNamed:self.isCurrentUser ? 
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

//----------------------------------------------------------------------------------------------------
- (void)largeImageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	self.largeImage         = [info objectForKey:kKeyImage];		
	_isLargeDownloading     = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)largeImageError:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
	
	if(resourceID != self.databaseID)
		return;
	
	_isLargeDownloading = NO;
}


@end
