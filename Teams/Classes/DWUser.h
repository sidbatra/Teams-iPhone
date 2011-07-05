//
//  DWUser.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

/**
 * User model represnts a user entity as defined in the database
 */
@interface DWUser : DWPoolObject {
	NSString	*_firstName;
	NSString	*_lastName;
    NSString    *_byline;
	NSString	*_email;
	NSString	*_encryptedPassword;
	NSString	*_smallURL;
    NSString	*_largeURL;
	NSData      *_twitterXAuthToken;
	NSString	*_facebookAccessToken;
	
	UIImage		*_smallPreviewImage;
    
    NSInteger   _followingCount;
	
	BOOL		_isSmallDownloading;
	BOOL		_isProcessed;
	BOOL		_hasPhoto;
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
@property (nonatomic,retain) UIImage *smallPreviewImage;

/**
 * Whether the user has uploaded a photo or not
 */
@property (nonatomic,readonly) BOOL hasPhoto;

/**
 * Number of places followed by the user
 */
@property (nonatomic,readonly) NSInteger followingCount;

/**
 * Update both the small and medium preview images
 */
- (void)updatePreviewImages:(UIImage*)image;

/**
 * Start downloading the small image or provide a suitable
 * placeholder. Image downloads are alerted via notifications
 */
- (void)startSmallPreviewDownload;

/**
 * Update user following count
 */
- (void)updateFollowingCount:(NSInteger)delta;

/**
 * Store twitter oauth data obtained after twitter connect
 * using NSUserDefaults
 */
- (void)storeTwitterData:(NSData*)data;

/**
 * Store facebook access token obtained after facebook connect
 * using NSUserDefaults
 */
- (void)storeFacebookToken:(NSString*)token;

/**
 * Save vital information about the user to disk - only used
 * maintaining a session for the current user
 */
- (void)saveToDisk;

/**
 * Save picture information about the user to disk - used
 * for updating the images when the user changes his profile pic
 */
- (void)savePicturesToDisk;

/**
 * Save following count for the users places to disk -used
 * for showing the follow places count in feed view
 */
- (void)saveFollowingCountToDisk;

/**
 * Read current user information from the disk in a cookie-esque 
 * fashion to maintain the session
 */
- (BOOL)readFromDisk;

/**
 * Clean user information from the disk
 */
- (void)removeFromDisk;

/**
 * Returns true if it represents the current user
 */
- (BOOL)isCurrentUser;

/**
 * Returns the full name of the user
 */
- (NSString*)fullName;

@end

