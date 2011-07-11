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
    UILabel             *_bylineLabel;
	
	UIImage				*_cameraImage;
	NSURL				*_videoURL;
	NSString			*_videoOrientation;
    
	NSInteger			_attachmentType;
    
    DWItemsController   *_itemsController;
}

/**
 * Image selected using mediaPicker
 */
@property (nonatomic,retain) UIImage *cameraImage;

/**
 * URL of the video seleced using mediaPicker
 */
@property (nonatomic,retain) NSURL *videoURL;

/**
 * Orientation of the video selected using mediaPicker
 */ 
@property (nonatomic,copy) NSString *videoOrientation;

/**
 * Interface to the items service on the app server
 */
@property (nonatomic,retain) DWItemsController *itemsController;


/**
 * IBOutlet properties
 */

@property (nonatomic, retain) IBOutlet UIImageView *previewImageView;
@property (nonatomic, retain) IBOutlet UIImageView *transImageView;
@property (nonatomic, retain) IBOutlet KTTextView *dataTextView;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UILabel *coverLabel;
@property (nonatomic, retain) IBOutlet UILabel *bylineLabel;


/**
 * IBActions
 */
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
