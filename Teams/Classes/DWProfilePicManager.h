//
//  DWProfilePicManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWMediaPickerController.h"


@protocol DWProfilePicManagerDelegate;


/**
 * Manages all the pictures that taken from the DWMediaPickerController
 */
@interface DWProfilePicManager : NSObject<DWMediaPickerControllerDelegate> {
    id <DWProfilePicManagerDelegate>       _delegate;
    NSInteger                              _initialImagePickerMode;
}

/**
 *  * Init with picker mode and delegate to capture DWMediaPicker events
 */
- (id)initWithDelegate:(id)delegate andPickerMode:(NSInteger)pickerMode;

/**
 * Present the media picker controller for changing profile picture
 */
-(void)presentMediaPickerControllerWithPreview:(BOOL)preview;

@end


/**
 * Delegate protocol to receive updates events
 * during the profile pic manager lifecycle
 */
@protocol DWProfilePicManagerDelegate

/**
 * Get the controller to display the camera on
 */
- (UIViewController*)requestController;

@optional

/**
 * Fired when the user picks a photo
 */
- (void)photoPicked;

@end