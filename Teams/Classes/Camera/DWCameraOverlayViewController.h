//
//  DWCameraOverlayViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@protocol DWCameraOverlayViewControllerDelegate;

/**
 * Camera Overlay View Controller
 */
@interface DWCameraOverlayViewController : UIViewController {
    NSInteger       _cameraFlashMode;
    NSInteger       _cameraCaptureMode;
    NSInteger       _cameraDevice;
    NSInteger       _recordingTime;
    BOOL            _isRecording;
    NSTimer         *_timer;
    
    UIButton        *_cameraButton;
    UIButton        *_cancelButton;
    UIButton        *_flashButton;
    UIButton        *_toggleCameraButton;
    UIButton        *_photoLibraryButton;
    UIButton        *_recordButton;
    UIButton        *_cameraCaptureModeButton;
    UIImageView     *_letterBoxImage;
    UIButton        *_timerButton;
    
    id <DWCameraOverlayViewControllerDelegate>      _overlayDelegate;
}


/**
 * Init with delegate to capture camera action events
 */
- (id)initWithDelegate:(id)theDelegate;

/**
 * Display the recording timer as soon as recording is started 
 */
- (void)displayRecordingTimer;

/**
 * Hide the camera capture mode button when the overlay is used
 * only for images
 */
- (void)hideCameraCaptureModeButtonForPickingImages;

/**
 * Hide the photo library button when the media picker 
 * is used only for images
 */
- (void)hidePhotoLibraryButton;

/**
 * Properties
 */
@property (nonatomic, retain) IBOutlet NSTimer *timer;

/**
 * IBOutlet properties
 */
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *flashButton;
@property (nonatomic, retain) IBOutlet UIButton *toggleCameraButton;
@property (nonatomic, retain) IBOutlet UIButton *photoLibraryButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraCaptureModeButton;
@property (nonatomic, retain) IBOutlet UIButton *timerButton;
@property (nonatomic, retain) IBOutlet UIImageView *letterBoxImage;


/**
 * IBActions
 */
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)flashButtonClicked:(id)sender;
- (IBAction)toggleCameraButtonClicked:(id)sender;
- (IBAction)photoLibraryButtonClicked:(id)sender;
- (IBAction)recordButtonClicked:(id)sender;
- (IBAction)cameraCaptureModeButtonClicked:(id)sender;

@end



/**
 * Delegate protocol to receive updates events
 * from camera overlay view controller
 */
@protocol DWCameraOverlayViewControllerDelegate

- (void)startRecording;
- (void)stopRecording;
- (void)cameraButtonClickedInOverlayView;
- (void)cancelButtonClickedInOverlayView;
- (void)photoLibraryButtonClickedInOverlayView;
- (void)cameraDeviceChangedInOverlayView:(NSInteger)cameraDevie;
- (void)flashModeChangedInOverlayView:(NSInteger)cameraFlashMode;
- (void)cameraCaptureModeChangedInOverlayView:(NSInteger)cameraCaptureMode;

@end