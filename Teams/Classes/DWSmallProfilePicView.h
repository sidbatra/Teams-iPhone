//
//  DWSmallProfilePicView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWSmallProfilePicViewDelegate;

/**
 * Custom small user image view for userviewcontroller nav bar
 */
@interface DWSmallProfilePicView : UIView {
    UIButton                    *profilePicButton;
    UIImageView                 *profilePicOverlay;
    UIActivityIndicatorView     *spinner;
    
    id<DWSmallProfilePicViewDelegate> _delegate;
}

/**
 * Delegate to receive events about user interactions
 */
@property (nonatomic,assign) id<DWSmallProfilePicViewDelegate> delegate;


/**
 * Custom init to specify the target for button events
 */
- (id)initWithFrame:(CGRect)frame;

/**
 * Set the background image for the user image button
 */
-(void)setProfilePicButtonBackgroundImage:(UIImage*)image;

/**
 * Enable the profile pic button when user is loaded and
 * has a picture
 */
-(void)enableProfilePicButton;

/**
 * Show the spinner when the image is being uploaded
 */
- (void)showProcessingState;

/**
 * Show the normal state on image upload
 */
- (void)showNormalState;

@end


/**
 * Delegate protocol for replaying user interaction events 
 */
@protocol DWSmallProfilePicViewDelegate

/**
 * Fired when the user clicks the profile picture
 */
- (void)profilePictureTouched;
@end
