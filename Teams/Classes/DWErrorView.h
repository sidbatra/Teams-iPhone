//
//  DWErrorView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Plain view for displaying error messages
 */
@interface DWErrorView : UIView {
    UILabel         *_messageLabel;
    id<NSObject>    _delegate;
}

/**
 * Protocol less delegate allowing error view to
 * be easily interchaged throughout the app
 */
@property (nonatomic,assign) id<NSObject> delegate;

/**
 * Apply a custom error message
 */
- (void)setErrorMessage:(NSString*)message;

@end
