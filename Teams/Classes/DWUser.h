//
//  DWUser.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 * User model represnts a user entity as defined in the database
 */
@interface DWUser : DWPoolObject<NSCoding> {
	NSString	*_firstName;
	NSString	*_lastName;
    NSString    *_byline;
	NSString	*_email;
	NSString	*_encryptedPassword;
	NSString	*_smallURL;
    NSString	*_largeURL;
	NSData      *_twitterXAuthToken;
	NSString	*_facebookAccessToken;
	
	UIImage		*_smallImage;
    
    NSInteger   _followingCount;
	
	BOOL		_isSmallDownloading;
	BOOL		_isProcessed;
	BOOL		_hasPhoto;
    BOOL        _isCurrentUser;
}

/**
 * First name of the user
 */
@property (nonatomic,copy) NSString *firstName;

/**
 * Last name of the user
 */
@property (nonatomic,copy) NSString *lastName;

/**
 * Byline for the user's team
 */
@property (nonatomic,retain) NSString *byline;

/**
 * Email used to register the account with
 */
@property (nonatomic,copy) NSString *email;

/**
 * Only used by the current user to sign requests
 */
@property (nonatomic,copy) NSString *encryptedPassword;

/**
 * URL of the small sized profile image
 */
@property (nonatomic,copy) NSString *smallURL;

/**
 * URL of the large sized profile image
 */
@property (nonatomic,copy) NSString *largeURL;

/**
 * Twitter XAuth token obtained after twitter connect.
 * Its saved using NSUserDefaults and read in every session
 * for future usage
 */
@property (nonatomic,retain) NSData *twitterXAuthToken;

/**
 * Facebook access token obtained after facebook connect.
 * Its saved on disk using NSUserDefaults and read in every
 * session for future usage
 */
@property (nonatomic,copy) NSString *facebookAccessToken;

/**
 * Image obtained from smallURL
 */
@property (nonatomic,retain) UIImage *smallImage;

/**
 * Whether the user has uploaded a photo or not
 */
@property (nonatomic,assign) BOOL hasPhoto;

/**
 * Number of places followed by the user
 */
@property (nonatomic,assign) NSInteger followingCount;

/**
 * If the user object is the object of the currently signed in user
 */
@property (nonatomic,assign) BOOL isCurrentUser;


/**
 * Update both all the preview images
 */
- (void)updateImages:(UIImage*)image;

/**
 * Start downloading the small image or provide a suitable
 * placeholder. Image downloads are alerted via notifications
 */
- (void)startSmallImageDownload;

@end

