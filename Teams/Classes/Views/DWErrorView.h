//
//  DWErrorView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Plain view for displaying error messages
 */
@interface DWErrorView : UIView {
    UILabel         *messageLabel;
    UILabel         *refreshLabel;
    
    UIButton        *viewButton;
    
    UIImageView     *refreshImageView;
    
    id<NSObject>    __unsafe_unretained _delegate;
}

/**
 * Protocol less delegate allowing error view to
 * be easily interchaged throughout the app
 */
@property (nonatomic,unsafe_unretained) id<NSObject> delegate;

/**
 * Apply a custom error message
 */
- (void)setErrorMessage:(NSString*)message;

/**
 * Hide the refresh label and image view
 */
- (void)hideRefreshUI;

/**
 * Display the refresh label and image view 
 */
- (void)showRefreshUI;

@end
