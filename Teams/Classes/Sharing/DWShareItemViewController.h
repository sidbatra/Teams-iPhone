//
//  DWShareItemViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWFacebookConnect.h"
#import "DWTwitterConnect.h"
#import "MBProgressHUD.h"

@class DWItem;
@protocol DWShareItemViewControllerDelegate;

/**
 * Enum sharing destinations
 */
enum DWSharingDestination {
    kSharingDestinationFacebook,
    kSharingDestinationTwitter
};

typedef enum DWSharingDestination DWSharingDestination;

/**
 * View for sharing items to Facebook and Twiiter
 */
@interface DWShareItemViewController : UIViewController<DWFacebookConnectDelegate,DWTwitterConnectDelegate> {
    DWItem                  *_item;
    DWSharingDestination    _sharingDestination;
    
    DWFacebookConnect       *_facebookConnect;
    DWTwitterConnect        *_twitterConnect;
    
    MBProgressHUD           *mbProgressIndicator;
    
	UIImageView             *_previewImageView;
	UIImageView             *_transImageView;
	UITextView              *_dataTextView;
	UIButton                *_cancelButton;
	UIButton                *_doneButton;
	UILabel                 *_coverLabel;
    UILabel                 *_topCoverLabel;
    
    id<DWShareItemViewControllerDelegate>   _delegate;
}

/**
 * The item being shared
 */
@property (nonatomic,retain) DWItem *item;

/**
 * Instance of the facebook connect wrapper
 */
@property (nonatomic,retain) DWFacebookConnect *facebookConnect;

/**
 * Instance of the twitter connect wrapper
 */
@property (nonatomic,retain) DWTwitterConnect *twitterConnect;

/**
 * Delegate to receive events about the sharing lifecycle
 */
@property (nonatomic,assign) id<DWShareItemViewControllerDelegate> delegate;

/**
 * IBOutlet properties
 */
@property (nonatomic,retain) IBOutlet UIImageView *previewImageView;
@property (nonatomic,retain) IBOutlet UIImageView *transImageView;
@property (nonatomic,retain) IBOutlet UITextView *dataTextView;
@property (nonatomic,retain) IBOutlet UIButton *cancelButton;
@property (nonatomic,retain) IBOutlet UIButton *doneButton;
@property (nonatomic,retain) IBOutlet UILabel *coverLabel;
@property (nonatomic,retain) IBOutlet UILabel *topCoverLabel;


/**
 * Init with the item to be shared
 */
- (id)initWithItem:(DWItem*)theItem;

/**
 * Prepare UI and flow for sharing to facebook
 */
- (void)prepareForFacebook;

/**
 * Prepare UI and flow for sharing to twitter
 */
- (void)prepareForTwitter;

/**
 * IBActions
 */
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end

/**
 * Declarations for private methods
 */
@interface DWShareItemViewController(Private)
- (void)displayTextUI;
@end

/**
 * Delegate to send events about the item sharing lifecycle
 */
@protocol DWShareItemViewControllerDelegate
- (NSString*)sharingFBText;
- (NSString*)sharingTWText;
- (NSString*)sharingItemURL;
- (void)sharingCancelled;
- (void)sharingFinishedWithText:(NSString*)text;
@end