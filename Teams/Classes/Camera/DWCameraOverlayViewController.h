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
 * Customize the view when the camera is used only for
 * images
 */
- (void)prepareForImageOnlyMode;

/**
 * Properties
 */
@property (nonatomic) IBOutlet NSTimer *timer;

/**
 * IBOutlet properties
 */
@property (nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *flashButton;
@property (nonatomic) IBOutlet UIButton *toggleCameraButton;
@property (nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic) IBOutlet UIButton *cameraCaptureModeButton;
@property (nonatomic) IBOutlet UIButton *timerButton;
@property (nonatomic) IBOutlet UIImageView *letterBoxImage;


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