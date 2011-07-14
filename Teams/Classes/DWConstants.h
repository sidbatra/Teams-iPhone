//
//  DWConstants.h
//  Copyright 2011 Denwen. All rights reserved.
//	

#import <Foundation/Foundation.h>

extern NSString* const kVersion;
extern NSString* const kDenwenProtocol;
extern NSString* const kGet;
extern NSString* const kPost;
extern NSString* const kPut;
extern NSString* const kDelete;
extern NSString* const kDenwenServer;


/**
 * Configuration for uploading to Amazon S3
 */
extern NSString* const kS3Policy;
extern NSString* const kS3Signature;
extern NSString* const kS3AccessID;
extern NSString* const kS3ACL;
extern NSString* const kS3Server;
extern NSString* const kS3UsersFolder;
extern NSString* const kS3ItemsFolder;

/**
 * Atachment types
 */

typedef enum {
    kAttachmentNone     = -1,
    kAttachmentImage    = 0,
    kAttachmentVideo    = 1
} kAttacmentType;


/**
 * Presentation styles for different models
 */
extern NSInteger const kDefaultStyle;


/**
 * Types of resources flowing through the application
 */
typedef enum {
    kResoureTypeLargeAttachmentImage = 0
} DWResourceType;


/**
 * Reset types
 */
extern NSInteger const kResetNone;
extern NSInteger const kResetHard;
extern NSInteger const kResetSoft;

/**
 * Tab bar
 */ 
extern NSInteger const kTabBarPlacesIndex;
extern NSInteger const kTabBarCreateIndex;
extern NSInteger const kTabBarFeedIndex;
extern NSInteger const kTabBarNormalTag;
extern NSInteger const kTabBarSpecialTag;

/**
 * Nav bar
 */
extern NSInteger const kNavBarHeight;

/**
 * Keys used for objects in JSON and custom dictionaties
 */
extern NSString* const kKeyStatus;
extern NSString* const kKeyMessage;
extern NSString* const kKeyBody;
extern NSString* const kKeySuccess;
extern NSString* const kKeyErrors;
extern NSString* const kKeyError;
extern NSString* const kKeyErrorMessage;
extern NSString* const kKeyErrorMessages;
extern NSString* const kKeyImage;
extern NSString* const kKeyResourceID;
extern NSString* const kKeyPlaces;
extern NSString* const kKeyPlace;
extern NSString* const kKeyNewPlace;
extern NSString* const kKeyItems;
extern NSString* const kKeyItem;
extern NSString* const kKeyUsers;
extern NSString* const kKeyUser;
extern NSString* const kKeyTeam;
extern NSString* const kKeyID;
extern NSString* const kKeyFilename;
extern NSString* const kKeyNotificationType;
extern NSString* const kKeyHasPhoto;
extern NSString* const kKeyFirstName;
extern NSString* const kKeyLastName;
extern NSString* const kKeyByLine;
extern NSString* const kKeyEmail;
extern NSString* const kKeyPhoto;
extern NSString* const kKeySmallURL;
extern NSString* const kKeyMediumURL;
extern NSString* const kKeyLargeURL;
extern NSString* const kKeySliceURL;
extern NSString* const kKeyIsProcessed;
extern NSString* const kKeyName;
extern NSString* const kKeyHashedID;
extern NSString* const kKeyFollowingsCount;
extern NSString* const kKeyMembershipsCount;
extern NSString* const kKeyTimestamp;
extern NSString* const kKeyLatitude;
extern NSString* const kKeyLongitude;
extern NSString* const kKeyLocation;
extern NSString* const kKeyAddress;
extern NSString* const kKeyAddresses;
extern NSString* const kKeyShortTown;
extern NSString* const kKeyShortState;
extern NSString* const kKeyShortCountry;
extern NSString* const kKeyFileType;
extern NSString* const kKeyActualURL;
extern NSString* const kKeyCreatedAt;
extern NSString* const kKeyCondensedData;
extern NSString* const kKeyTouches;
extern NSString* const kKeyTouchesCount;
extern NSString* const kKeyTouchID;
extern NSString* const kKeyData;
extern NSString* const kKeyAttachment;
extern NSString* const kKeyURLs;
extern NSString* const kKeyFollowing;
extern NSString* const kKeyTabIndex;
extern NSString* const kKeyWidth;
extern NSString* const kKeyIsSelected;
extern NSString* const kKeySelectedImageName;
extern NSString* const kKeyHighlightedImageName;
extern NSString* const kKeyNormalImageName;
extern NSString* const kKeyTag;
extern NSString* const kKeySelectedIndex;
extern NSString* const kKeyOldSelectedIndex;
extern NSString* const kKeyTotalActive;
extern NSString* const kKeyTotalFailed;
extern NSString* const kKeyTotalProgress;
extern NSString* const kKeyResetType;
extern NSString* const kKeyType;
extern NSString* const kKeyUserImage;

/**
 * Notification names
 */
extern NSString* const kNPopularPlacesLoaded;
extern NSString* const kNPopularPlacesError;
extern NSString* const kNNearbyPlacesLoaded;
extern NSString* const kNNearbyPlacesError;
extern NSString* const kNUserPlacesLoaded;
extern NSString* const kNUserPlacesError;
extern NSString* const kNSearchPlacesLoaded;
extern NSString* const kNSearchPlacesError;
extern NSString* const kNPlaceLoaded;
extern NSString* const kNPlaceError;
extern NSString* const kNPlaceUpdated;
extern NSString* const kNPlaceUpdateError;
extern NSString* const kNNewPlaceCreated;
extern NSString* const kNNewPlaceError;
extern NSString* const kNNewPlaceParsed;
extern NSString* const kNNewFollowingCreated;
extern NSString* const kNNewFollowingError;
extern NSString* const kNFollowingDestroyed;
extern NSString* const kNFollowingDestroyError;
extern NSString* const kNUserLoaded;
extern NSString* const kNUserError;
extern NSString* const kNUserUpdated;
extern NSString* const kNUserUpdateError;
extern NSString* const kNUserLogsIn;
extern NSString* const kNFollowedItemsLoaded;
extern NSString* const kNFollowedItemsError;
extern NSString* const kNNewTouchCreated;
extern NSString* const kNNewTouchError;
extern NSString* const kNTouchesLoaded;
extern NSString* const kNTouchesError;
extern NSString* const kNAddressLoaded;
extern NSString* const kNAddressError;
extern NSString* const kNNewItemCreated;
extern NSString* const kNNewItemError;
extern NSString* const kNNewItemParsed;
extern NSString* const kNNewUserCreated;
extern NSString* const kNNewUserError;
extern NSString* const kNNewSessionCreated;
extern NSString* const kNNewSessionError;
extern NSString* const kNS3UploadDone;
extern NSString* const kNS3UploadError;
extern NSString* const kNImgSmallUserLoaded;
extern NSString* const kNImgSmallUserError;
extern NSString* const kNImgMediumUserLoaded;
extern NSString* const kNImgMediumUserError;
extern NSString* const kNImgLargeUserLoaded;
extern NSString* const kNImgLargeUserError;
extern NSString* const kNImgSmallPlaceLoaded;
extern NSString* const kNImgSmallPlaceError;
extern NSString* const kNImgMediumPlaceLoaded;
extern NSString* const kNImgMediumPlaceError;
extern NSString* const kNImgLargePlaceLoaded;
extern NSString* const kNImgLargePlaceError;
extern NSString* const kNImgMediumAttachmentLoaded;
extern NSString* const kNImgMediumAttachmentError;
extern NSString* const kNImgLargeAttachmentLoaded;
extern NSString* const kNImgLargeAttachmentError;
extern NSString* const kNImgActualUserImageLoaded;
extern NSString* const kNImgActualUserImageError;
extern NSString* const kNImgSliceAttachmentLoaded;
extern NSString* const kNImgSliceAttachmentFinalized;
extern NSString* const kNImgSliceAttachmentError;
extern NSString* const kNNewApplicationBadge;
extern NSString* const kNTabSelectionChanged;
extern NSString* const kNNewLocationAvailable;
extern NSString* const kNUserRejectedLocation;
extern NSString* const kNFacebookURLOpened;
extern NSString* const kNDenwenURLOpened ;
extern NSString* const kNRequestTabBarIndexChange;
extern NSString* const kNNearbyPlacesCacheUpdated;
extern NSString* const kNFollowedPlacesCacheUpdated;
extern NSString* const kNCreationQueueItemProcessed;
extern NSString* const kNQueueItemProgressUpdated;
extern NSString* const kNCreationQueueUpdated;
extern NSString* const kNUserFollowingCountUpdated;
extern NSString* const kNPlaceFollowersUpdated;
extern NSString* const kNItemDeleted;
extern NSString* const kNNewFeedItemsLoaded;
extern NSString* const kNNewFeedItemsRead;
extern NSString* const kNUserProfilePicUpdated;
extern NSString* const kNPaginationCellReached;

/**
 * Nav bar title view dimensions
 */
extern NSInteger const kNavTitleViewX;
extern NSInteger const kNavTitleViewWidth;
extern NSInteger const kNavTitleViewHeight;


/**
 * Nav bar title button images
 */
extern NSString* const kImgStaticButton;
extern NSString* const kImgStaticButtonActive;
extern NSString* const kImgDynamicButton;
extern NSString* const kImgDynamicButtonActive;


/**
 * Nav bar button types
 */
extern NSInteger const kDWButtonTypeStatic;
extern NSInteger const kDWButtonTypeDynamic;

/**
 * Nav bar titleview types
 */
extern NSInteger const kNavStandaloneTitleMode;
extern NSInteger const kNavTitleAndSubtitleMode;

/**
 * Push notifcation types
 */
extern NSInteger const kPNLive;
extern NSInteger const kPNBackground;

/**
 * Different use cases for UITableVIiew
 */
extern NSInteger const kTableViewAsData;
extern NSInteger const kTableViewAsSpinner;
extern NSInteger const kTableViewAsMessage;
extern NSInteger const kTableViewAsProfileMessage;

/**
 * Table view UI
 */
extern NSInteger const kTVLoadingCellCount;
extern NSInteger const kTVLoadingCellHeight;
extern NSString* const kTVPaginationCellIdentifier;
extern NSString* const kTVMessageCellIdentifier;
extern NSString* const kTVLoadingCellIdentifier;
extern NSString* const kTVDefaultCellIdentifier;

/**
 * Media picker modes
 */
extern NSInteger const kMediaPickerCaptureMode;
extern NSInteger const kMediaPickerLibraryMode;

/**
 * Camera flash modes
 */
extern NSInteger const kCameraFlashModeOn;
extern NSInteger const kCameraFlashModeOff;

/**
 * Camera capture modes
 */
NSInteger const kCameraCaptureModeVideo;
NSInteger const kCameraCaptureModePhoto;

/**
 * Camera devices
 */
NSInteger const kCameraDeviceRear;
NSInteger const kCameraDeviceFront;

/**
 * Camera video settings
 */
NSInteger const kMaxVideoDuration;

/**
 * Location
 */
extern NSInteger const kLocNearbyRadius;

/**
 * Pagination
 */
extern NSInteger const kPagInitialPage;

/**
 * Memory Pool
 */
extern NSInteger const kMPDefaultDatabaseID;


/**
 * Messages
 */
extern NSString* const kMsgNoPlacesNearby;
extern NSString* const kMsgNoFollowPlacesCurrentUser;
extern NSString* const kMsgNoFollowPlacesNormalUser;
extern NSString* const kMsgTakeFirstPhoto;
extern NSString* const kMsgChooseFirstPhoto;
extern NSString* const kMsgTakeBetterPhoto;
extern NSString* const kMsgChooseBetterPhoto;
extern NSString* const kMsgTakeMedia;
extern NSString* const kMsgChooseMedia;
extern NSString* const kMsgCancelPhoto;
extern NSString* const kMsgCancelMedia;

/**
 * Images
 */
extern NSString* const kImgGenericPlaceHolder;


/**
 * Third party service tokens
 */
extern NSString* const kTwitterOAuthConsumerKey;
extern NSString* const kTwitterOAuthConsumerSecret;
extern NSString* const kFacebookAppID;


/**
 * Misc App UI
 */
extern NSString* const kPlaceListViewControllerNib;
extern NSString* const kGenericBackButtonTitle;
extern NSInteger const kStatusBarStyle;
extern NSInteger const kAttachmentHeight;
extern NSInteger const kAttachmentYPadding;
extern NSInteger const kURLTagMultipler;
extern NSInteger const kPaginationCellHeight;
extern NSInteger const kUserViewCellHeight;
extern NSInteger const kPlaceViewCellHeight;
extern NSString* const kEmptyString;




@interface DWConstants : NSObject {

}

@end
