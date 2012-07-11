//
//  DWCreateViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWMediaPickerController.h"

#import "KTTextView.h"

@class DWItemsController;

/**
 * Facilitates creation of items and places
 */
@interface DWCreateViewController : UIViewController<DWMediaPickerControllerDelegate> {
	
	UIImageView			*_previewImageView;
	UIImageView			*_transImageView;
	KTTextView			*_dataTextView;
	UIButton			*_cancelButton;
	UIButton			*_doneButton;
	UIButton			*_cameraButton;
	UILabel				*_coverLabel;
    UILabel             *_teamNameLabel;
    UILabel             *_userNameLabel;    
	
    BOOL                _inMediaMode;
    NSString            *_data;
    NSString            *_placeholder;
	UIImage				*_cameraImage;
	NSURL				*_videoURL;
	NSString			*_videoOrientation;
    
	NSInteger			_attachmentType;
    
    DWItemsController   *_itemsController;
}

/**
 * Text data entered by the user
 */
@property (nonatomic,copy) NSString *data;

/**
 * Placeholder string when the user hasn't typed a post
 */
@property (nonatomic,copy) NSString *placeholder;

/**
 * Image selected using mediaPicker
 */
@property (nonatomic) UIImage *cameraImage;

/**
 * URL of the video seleced using mediaPicker
 */
@property (nonatomic) NSURL *videoURL;

/**
 * Orientation of the video selected using mediaPicker
 */ 
@property (nonatomic,copy) NSString *videoOrientation;

/**
 * Interface to the items service on the app server
 */
@property (nonatomic) DWItemsController *itemsController;


/**
 * IBOutlet properties
 */

@property (nonatomic) IBOutlet UIImageView *previewImageView;
@property (nonatomic) IBOutlet UIImageView *transImageView;
@property (nonatomic) IBOutlet KTTextView *dataTextView;
@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic) IBOutlet UILabel *coverLabel;
@property (nonatomic) IBOutlet UILabel *teamNameLabel;
@property (nonatomic) IBOutlet UILabel *userNameLabel;


/**
 * IBActions
 */
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
