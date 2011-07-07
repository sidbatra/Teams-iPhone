//
//  DWCreateViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import "DWTeam.h"
#import "DWMediaPickerController.h"

#import "KTTextView.h"

/**
 * Facilitates creation of items and places
 */
@interface DWCreateViewController : UIViewController<DWMediaPickerControllerDelegate> {
	
	UILabel					*_atLabel;
	UIImageView				*_previewImageView;
	UIImageView				*_transImageView;
	UITextField				*_placeNameTextField;
	KTTextView				*_dataTextView;
	UIButton				*_mapButton;
	UIButton				*_cancelButton;
	UIButton				*_doneButton;
	UIButton				*_cameraButton;
	UILabel					*_coverLabel;
	UILabel					*_topCoverLabel;
	
	DWTeam					*_selectedPlace;
	CLLocation				*_newPlaceLocation;
	
	UIImage					*_cameraImage;
	NSURL					*_videoURL;
	NSString				*_videoOrientation;
	NSInteger				_attachmentType;
	
	BOOL					_newPlaceMode;
	BOOL					_isMediaSelected;
	
}

/**
 * Reference to an existing place being used to create a post
 */
@property (nonatomic,retain) DWTeam *selectedPlace;

/**
 * Location of a freshly created place
 */
@property (nonatomic,retain) CLLocation *newPlaceLocation;

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
 * IBOutlet properties
 */

@property (nonatomic, retain) IBOutlet UILabel *atLabel;
@property (nonatomic, retain) IBOutlet UIImageView *previewImageView;
@property (nonatomic, retain) IBOutlet UIImageView *transImageView;
@property (nonatomic, retain) IBOutlet UITextField *placeNameTextField;
@property (nonatomic, retain) IBOutlet KTTextView *dataTextView;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UILabel *coverLabel;
@property (nonatomic, retain) IBOutlet UILabel *topCoverLabel;

/**
 * IBActions
 */
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)mapButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)placeNameTextFieldEditingChanged:(id)sender;


@end
