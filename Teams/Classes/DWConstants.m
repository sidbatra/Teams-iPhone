//
//  Constants.m
//  Copyright 2011 Denwen. All rights reserved.
//	

//#define PRODUCTION 1 


#import "DWConstants.h"

//----------------------------------------------------------------------------------------------------
NSString* const kVersion            = @"1.0";
NSString* const kDenwenProtocol     = @"http://";
NSString* const kGet				= @"GET";
NSString* const kPost               = @"POST";
NSString* const kPut				= @"PUT";
NSString* const kDelete				= @"DELETE";


#ifdef PRODUCTION
	NSString* const kDenwenServer	= @"teams.denwen.com";
	
	//----------------------------------------------------------------------------------------------------
	NSString* const kS3Policy		= @"eydleHBpcmF0aW9uJzogJzIwMTctMDItMDlUMDU6MDI6MzcuMDAwWicsCiAgICAgICAgJ2NvbmRpdGlvbnMnOiBbCiAgICAgICAgICB7J2J1Y2tldCc6ICdkZW53ZW4nfSwKICAgICAgICAgIHsnYWNsJzogJ3B1YmxpYy1yZWFkJ30sCiAgICAgICAgICBbJ2NvbnRlbnQtbGVuZ3RoLXJhbmdlJywgMCwgNTI0Mjg4MDBdLAogICAgICAgICAgWydzdGFydHMtd2l0aCcsICcka2V5JywgJyddLAogICAgICAgICAgWydzdGFydHMtd2l0aCcsICcnLCAnJ10KICAgICAgICBdCiAgICAgIH0=";
	NSString* const kS3Signature	= @"PG1k3sSsZe6FsxfcnqPobBWHKwc=";
	NSString* const kS3AccessID		= @"AKIAJWYCAWDPAAKLNKSQ";
	NSString* const kS3ACL			= @"public-read";
	NSString* const kS3Server		= @"http://denwen.s3.amazonaws.com/";
#else
    //NSString* const kDenwenServer	= @"ec2-50-19-68-158.compute-1.amazonaws.com";//@"sbat.denwen.com";
    NSString* const kDenwenServer	= @"teams.denwen.com";
	
	//----------------------------------------------------------------------------------------------------
	NSString* const kS3Policy		= @"eydleHBpcmF0aW9uJzogJzIwMTctMDEtMjRUMDQ6MjA6MjguMDAwWicsCiAgICAgICAgJ2NvbmRpdGlvbnMnOiBbCiAgICAgICAgICB7J2J1Y2tldCc6ICd0ZW53ZW4nfSwKICAgICAgICAgIHsnYWNsJzogJ3B1YmxpYy1yZWFkJ30sCiAgICAgICAgICBbJ2NvbnRlbnQtbGVuZ3RoLXJhbmdlJywgMCwgNTI0Mjg4MDBdLAogICAgICAgICAgWydzdGFydHMtd2l0aCcsICcka2V5JywgJyddLAogICAgICAgICAgWydzdGFydHMtd2l0aCcsICcnLCAnJ10KICAgICAgICBdCiAgICAgIH0=";
	NSString* const kS3Signature	= @"a5XAsCN6H/t4cv5MZ9/vuUOnc5s=";
	NSString* const kS3AccessID		= @"AKIAJWYCAWDPAAKLNKSQ";
	NSString* const kS3ACL			= @"public-read";
	NSString* const kS3Server		= @"http://tenwen.s3.amazonaws.com/";
#endif

NSString* const kS3UsersFolder	= @"user_photos";
NSString* const kS3ItemsFolder	= @"items";


//----------------------------------------------------------------------------------------------------
NSInteger const kResetNone              = -1;
NSInteger const kResetHard              = 0;
NSInteger const kResetSoft              = 1;


//----------------------------------------------------------------------------------------------------
NSInteger const kTabBarPlacesIndex		= 0;
NSInteger const kTabBarCreateIndex		= 1;
NSInteger const kTabBarFeedIndex		= 2;
NSInteger const kTabBarNormalTag		= 0;
NSInteger const kTabBarSpecialTag		= -1;

//----------------------------------------------------------------------------------------------------
NSInteger const kNavBarHeight	= 44;;

//----------------------------------------------------------------------------------------------------
NSString* const kKeyStatus					= @"status";
NSString* const kKeyMessage					= @"message";
NSString* const kKeyBody					= @"body";
NSString* const kKeySuccess					= @"success";
NSString* const kKeyError					= @"error";
NSString* const kKeyErrorMessage			= @"errorMessage";
NSString* const kKeyErrorMessages			= @"error_messages";
NSString* const kKeyImage					= @"image";
NSString* const kKeyResourceID				= @"resourceID";
NSString* const kKeyPlaces					= @"places";
NSString* const kKeyPlace					= @"place";
NSString* const kKeyNewPlace				= @"new_place";
NSString* const kKeyItems					= @"items";
NSString* const kKeyItem					= @"item";
NSString* const kKeyUsers					= @"users";
NSString* const kKeyUser					= @"user";
NSString* const kKeyTeam					= @"team";
NSString* const kKeyID						= @"id";
NSString* const kKeyFilename				= @"filename";
NSString* const kKeyNotificationType		= @"notificationType";
NSString* const kKeyHasPhoto				= @"has_photo";
NSString* const kKeyFirstName				= @"first_name";
NSString* const kKeyLastName				= @"last_name";
NSString* const kKeyByLine                  = @"byline";
NSString* const kKeyEmail					= @"email";
NSString* const kKeyPhoto					= @"photo";
NSString* const kKeySmallURL				= @"small_url";
NSString* const kKeyMediumURL				= @"medium_url";
NSString* const kKeyLargeURL				= @"large_url";
NSString* const kKeySliceURL				= @"slice_url";
NSString* const kKeyIsProcessed				= @"is_processed";
NSString* const kKeyName					= @"name";
NSString* const kKeyHashedID				= @"hashed_id";
NSString* const kKeyFollowingsCount			= @"followings_count";
NSString* const kKeyMembershipsCount        = @"memberships_count";
NSString* const kKeyTimestamp               = @"timestamp";
NSString* const kKeyLatitude				= @"latitude";
NSString* const kKeyLongitude				= @"longitude";
NSString* const kKeyLocation				= @"location";
NSString* const kKeyAddress					= @"address";
NSString* const kKeyAddresses				= @"addresses";
NSString* const kKeyShortTown				= @"short_town";
NSString* const kKeyShortState				= @"short_state";
NSString* const kKeyShortCountry			= @"short_country";
NSString* const kKeyFileType				= @"filetype";
NSString* const kKeyActualURL				= @"actual_url";
NSString* const kKeyCreatedAt				= @"created_at_timestamp";
NSString* const kKeyCondensedData			= @"condensed_data";
NSString* const kKeyTouches                 = @"touches";
NSString* const kKeyTouchesCount			= @"touches_count";
NSString* const kKeyTouchID					= @"touch_id";
NSString* const kKeyData					= @"data";
NSString* const kKeyAttachment				= @"attachment";
NSString* const kKeyURLs					= @"urls";
NSString* const kKeyFollowing				= @"following";
NSString* const kKeyTabIndex				= @"tabIndex";
NSString* const kKeyWidth					= @"width";
NSString* const kKeyIsSelected				= @"is_selected";
NSString* const kKeySelectedImageName		= @"selected_image";
NSString* const kKeyHighlightedImageName	= @"highlighted_image";
NSString* const kKeyNormalImageName			= @"normal_image";
NSString* const kKeyTag						= @"tag";
NSString* const kKeySelectedIndex			= @"selected_index";
NSString* const kKeyOldSelectedIndex		= @"old_selected_index";
NSString* const kKeyTotalActive				= @"total_active";
NSString* const kKeyTotalFailed				= @"total_failed";
NSString* const kKeyTotalProgress			= @"total_progress";
NSString* const kKeyResetType               = @"reset_type";
NSString* const kKeyType                    = @"type";
NSString* const kKeyUserImage               = @"user_image";


//----------------------------------------------------------------------------------------------------
NSString* const kNPopularPlacesLoaded			= @"NPopularPlacesLoaded";
NSString* const kNPopularPlacesError			= @"NPopularPlacesError";
NSString* const kNNearbyPlacesLoaded			= @"NNearbyPlacesLoaded";
NSString* const kNNearbyPlacesError				= @"NNearbyPlacesError";
NSString* const kNUserPlacesLoaded				= @"NUserPlacesLoaded";
NSString* const kNUserPlacesError				= @"NUserPlacesError";
NSString* const kNSearchPlacesLoaded			= @"NSearchPlacesLoaded";
NSString* const kNSearchPlacesError				= @"NSearchPlacesError";
NSString* const kNPlaceLoaded					= @"NPlaceLoaded";
NSString* const kNPlaceError					= @"NPlaceError";
NSString* const kNPlaceUpdated					= @"NPlaceUpdated";
NSString* const kNPlaceUpdateError				= @"NPlaceUpdateError";
NSString* const kNNewPlaceCreated				= @"NNewPlaceCreated";
NSString* const kNNewPlaceError					= @"NNewPlaceError";
NSString* const kNNewPlaceParsed				= @"NNewPlaceParsed";
NSString* const kNNewFollowingCreated			= @"NNewFollowingCreated";
NSString* const kNNewFollowingError				= @"NNewFollowingError";
NSString* const kNFollowingDestroyed			= @"NFollowingDestroyed";
NSString* const kNFollowingDestroyError			= @"NFollowingDestroyError";
NSString* const kNUserLoaded					= @"NUserLoaded";
NSString* const kNUserError						= @"NUserError";
NSString* const kNUserUpdated					= @"NUserUpdated";
NSString* const kNUserUpdateError				= @"NUserUpdateError";
NSString* const kNUserLogsIn					= @"NUserLogsIn";
NSString* const kNFollowedItemsLoaded			= @"NFollowedItemsLoaded";
NSString* const kNFollowedItemsError			= @"NFollowedItemsError";
NSString* const kNTouchesLoaded                 = @"NTouchesLoaded";
NSString* const kNTouchesError                  = @"NTouchesError";
NSString* const kNAddressLoaded                 = @"NAddressLoaded";
NSString* const kNAddressError                  = @"NAddressError";
NSString* const kNNewItemCreated				= @"NNewItemCreated";
NSString* const kNNewItemError					= @"NNewItemError";
NSString* const kNNewItemParsed					= @"NNewItemParsed";
NSString* const kNNewUserCreated				= @"NNewUserCreated";
NSString* const kNNewUserError					= @"NNewUserError";	
NSString* const kNNewSessionCreated				= @"NNewSessionCreated";
NSString* const kNNewSessionError				= @"NNewSessionError";
NSString* const kNS3UploadDone					= @"NS3UploadDone";
NSString* const kNS3UploadError					= @"NS3UploadError";
NSString* const kNImgSmallUserLoaded			= @"NImgSmallUserLoaded";
NSString* const kNImgSmallUserError				= @"NImgSmallUserError";
NSString* const kNImgMediumUserLoaded			= @"NImgMediumUserLoaded";
NSString* const kNImgMediumUserError			= @"NImgMediumUserError";
NSString* const kNImgLargeUserLoaded			= @"NImgLargeUserLoaded";
NSString* const kNImgLargeUserError				= @"NImgLargeUserError";
NSString* const kNImgSmallPlaceLoaded			= @"NImgSmallPlaceLoaded";
NSString* const kNImgSmallPlaceError			= @"NImgSmallPlaceError";
NSString* const kNImgMediumPlaceLoaded			= @"NImgMediumPlaceLoaded";
NSString* const kNImgMediumPlaceError			= @"NImgMediumPlaceError";
NSString* const kNImgLargePlaceLoaded			= @"NImgLargePlaceLoaded";
NSString* const kNImgLargePlaceError			= @"NImgLargePlaceError";
NSString* const kNImgMediumAttachmentLoaded		= @"NImgMediumAttachmentLoaded";
NSString* const kNImgMediumAttachmentError		= @"NImgMediumAttachmentError";
NSString* const kNImgLargeAttachmentLoaded		= @"NImgLargeAttachmentLoaded";
NSString* const kNImgLargeAttachmentError		= @"NImgLargeAttachmentError";
NSString* const kNImgActualUserImageLoaded		= @"NImgActualUserImageLoaded";
NSString* const kNImgActualUserImageError		= @"NImgActualUserImageError";
NSString* const kNImgSliceAttachmentLoaded		= @"NImgSliceAttachmentLoaded";
NSString* const kNImgSliceAttachmentFinalized	= @"NImgSliceAttachmentFinalized";
NSString* const kNImgSliceAttachmentError		= @"NImgSliceAttachmentError";
NSString* const kNNewApplicationBadge			= @"NNewApplicationBadge"; 
NSString* const kNTabSelectionChanged			= @"NTabSelectionChanged";
NSString* const kNNewLocationAvailable			= @"NNewLocationAvailable";
NSString* const kNUserRejectedLocation          = @"NUserRejectedLocation";
NSString* const kNFacebookURLOpened				= @"NFacebookURLOpened";
NSString* const kNDenwenURLOpened				= @"NDenwenURLOpened";
NSString* const kNRequestTabBarIndexChange		= @"NRequestTabBarIndexChange";
NSString* const kNNearbyPlacesCacheUpdated		= @"NNearbyPlacesCacheUpdated";
NSString* const kNFollowedPlacesCacheUpdated	= @"NFollowedPlacesCacheUpdated";
NSString* const kNCreationQueueItemProcessed	= @"NCreationQueueItemProcessed";
NSString* const kNQueueItemProgressUpdated		= @"NQueueItemProgressUpdated";
NSString* const kNCreationQueueUpdated			= @"NCreationQueueUpdated";
NSString* const kNUserFollowingCountUpdated     = @"NUserFollowingCountUpdated";
NSString* const kNPlaceFollowersUpdated         = @"NPlaceFollowersUpdated";
NSString* const kNItemDeleted                   = @"NItemDeleted";
NSString* const kNNewFeedItemsLoaded            = @"NNewFeedItemsLoaded";
NSString* const kNNewFeedItemsRead              = @"NNewFeedItemsRead";
NSString* const kNUserProfilePicUpdated         = @"NUserProfilePicUpdated";


//----------------------------------------------------------------------------------------------------
NSInteger const kNavTitleViewX                  = 60;
NSInteger const kNavTitleViewWidth              = 200;
NSInteger const kNavTitleViewHeight             = 44;

//----------------------------------------------------------------------------------------------------
NSInteger const kDWButtonTypeStatic             = 0;
NSInteger const kDWButtonTypeDynamic            = 1;

//----------------------------------------------------------------------------------------------------
NSString* const kImgStaticButton                 = @"loading_bar_fail.png";
NSString* const kImgStaticButtonActive           = @"static_button_active.png";
NSString* const kImgDynamicButton                = @"button_follow.png";
NSString* const kImgDynamicButtonActive          = @"button_follow_active.png";

//----------------------------------------------------------------------------------------------------
NSInteger const kNavStandaloneTitleMode            = 0;
NSInteger const kNavTitleAndSubtitleMode           = 1;

//----------------------------------------------------------------------------------------------------
NSInteger const kPNLive			= 0;
NSInteger const kPNBackground	= 1;

//----------------------------------------------------------------------------------------------------
NSInteger const kImgSmallUser			= 0;
NSInteger const kImgMediumUser			= 1;
NSInteger const kImgLargeUser			= 2;
NSInteger const kImgSmallPlace			= 3;
NSInteger const kImgMediumPlace			= 4;
NSInteger const kImgLargePlace			= 5;
NSInteger const kImgMediumAttachment	= 6;
NSInteger const kImgLargeAttachment		= 7;
NSInteger const kImgActualAttachment	= 8;

//----------------------------------------------------------------------------------------------------
NSInteger const kTableViewAsData			= 0;
NSInteger const kTableViewAsSpinner			= 1;
NSInteger const kTableViewAsMessage			= 2;
NSInteger const kTableViewAsProfileMessage	= 3;

//----------------------------------------------------------------------------------------------------
NSInteger const kTVLoadingCellCount			= 1;
NSInteger const kTVLoadingCellHeight		= 367;
NSString* const kTVPaginationCellIdentifier = @"PaginationCell";
NSString* const kTVMessageCellIdentifier	= @"MessageCell";
NSString* const kTVLoadingCellIdentifier	= @"LoadingCell";
NSString* const kTVDefaultCellIdentifier	= @"Cell";

//----------------------------------------------------------------------------------------------------
NSInteger const kMediaPickerCaptureMode		= UIImagePickerControllerSourceTypeCamera;
NSInteger const kMediaPickerLibraryMode		= UIImagePickerControllerSourceTypePhotoLibrary;

//----------------------------------------------------------------------------------------------------
NSInteger const kCameraFlashModeOn          = UIImagePickerControllerCameraFlashModeOn;
NSInteger const kCameraFlashModeOff         = UIImagePickerControllerCameraFlashModeOff;

//----------------------------------------------------------------------------------------------------
NSInteger const kCameraCaptureModeVideo     = UIImagePickerControllerCameraCaptureModeVideo;
NSInteger const kCameraCaptureModePhoto     = UIImagePickerControllerCameraCaptureModePhoto;

//----------------------------------------------------------------------------------------------------
NSInteger const kCameraDeviceRear           = UIImagePickerControllerCameraDeviceRear;
NSInteger const kCameraDeviceFront          = UIImagePickerControllerCameraDeviceFront;

//----------------------------------------------------------------------------------------------------
NSInteger const kMaxVideoDuration           = 45;

//----------------------------------------------------------------------------------------------------
NSInteger const kLocNearbyRadius			= 1200;

//----------------------------------------------------------------------------------------------------
NSInteger const kPagInitialPage		= 0;

//----------------------------------------------------------------------------------------------------
NSInteger const kMPTotalClasses             = 5;
//NSInteger const kMPItemsIndex               = 0;
//NSInteger const kMPPlacesIndex              = 1;
//NSInteger const kMPUsersIndex               = 2;
NSInteger const kMPAttachmentsIndex         = 3;
//NSInteger const kMPAttachmentSlicesIndex    = 4;
NSInteger const kMPDefaultDatabaseID        = -1;


//----------------------------------------------------------------------------------------------------
NSString* const kMsgNoPlacesNearby				= @"No places nearby";
NSString* const kMsgNoFollowPlacesCurrentUser	= @"You aren't following any places yet";
NSString* const kMsgNoFollowPlacesNormalUser	= @"This user isn't following any places yet";
NSString* const kMsgTakeFirstPhoto				= @"Take Photo";
NSString* const kMsgChooseFirstPhoto			= @"Choose Existing";
NSString* const kMsgTakeBetterPhoto				= @"Take Better Photo";
NSString* const kMsgChooseBetterPhoto			= @"Choose Better Photo";
NSString* const kMsgTakeMedia					= @"Take Photo or Video";
NSString* const kMsgChooseMedia					= @"Choose Existing";
NSString* const kMsgCancelPhoto					= @"Cancel";
NSString* const kMsgCancelMedia					= @"Cancel";

//----------------------------------------------------------------------------------------------------
NSString* const kImgGenericPlaceHolder			= @"generic_placeholder.png";

//----------------------------------------------------------------------------------------------------
#ifdef PRODUCTION

/**
 * Denwen Twitter and Facebook apps made by sbat
 */
NSString* const kTwitterOAuthConsumerKey		= @"Y8wcijb0orzZSbkd3fQ4g";
NSString* const kTwitterOAuthConsumerSecret		= @"i7Oqqpy1I1ZycqRpJOSsBMylURsFlC2Qo7pQc0YbUzk";
NSString* const kFacebookAppID					= @"127979053940843";

#else

NSString* const kTwitterOAuthConsumerKey		= @"Y8wcijb0orzZSbkd3fQ4g";
NSString* const kTwitterOAuthConsumerSecret		= @"i7Oqqpy1I1ZycqRpJOSsBMylURsFlC2Qo7pQc0YbUzk";
//NSString* const kFacebookAppID					= @"127979053940843";
NSString* const kFacebookAppID					= @"176869555684965";


/**
 * Tenwen Twitter and Facebook apps made by drao
 */
//NSString* const kTwitterOAuthConsumerKey		= @"kC2Kv9gsqYdZGwHHzx4bTQ";
//NSString* const kTwitterOAuthConsumerSecret		= @"CO7MYDyF2TyzBAVPzARIWt7GI6SLSb1fgAcMPhLgE";
//NSString* const kFacebookAppID					= @"176869555684965";

#endif


//----------------------------------------------------------------------------------------------------
NSString* const kPlaceListViewControllerNib		= @"DWPlaceListViewController";
NSString* const kGenericBackButtonTitle			= @"Back";
NSInteger const kStatusBarStyle					= UIStatusBarStyleBlackOpaque;
NSInteger const kAttachmentHeight				= 196;
NSInteger const kAttachmentYPadding				= 10;
NSInteger const kURLTagMultipler				= 100;
NSInteger const kPaginationCellHeight			= 60;
NSInteger const kUserViewCellHeight				= 126;
NSInteger const kPlaceViewCellHeight			= 177;
NSString* const kEmptyString					= @"";

@implementation DWConstants

@end
