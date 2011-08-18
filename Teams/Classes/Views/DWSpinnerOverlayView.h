//
//  DWSpinnerOverlayView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Transparent view that blocks any interaction with the underlying
 * screen and displays an animating spinner with a text message
 */
@interface DWSpinnerOverlayView : UIView {
    UILabel *messageLabel;
    UIActivityIndicatorView *spinner;
}

/**
 * Custom init with spinner origin and message text
 */
- (id)initWithSpinnerOrigin:(CGPoint)origin 
             andMessageText:(NSString*)text;

/**
 * Custom init with spinner origin, style and message text
 */
- (id)initWithSpinnerOrigin:(CGPoint)origin 
               spinnerStyle:(NSInteger)spinnerStyle 
             andMessageText:(NSString*)text;

/**
 * Shows the view and enables all interaction
 */
- (void)enable;

/**
 * Hides the view and disables all interaction
 */
- (void)disable;

/**
 * Set the text for the message label
 */
- (void)setMessageText:(NSString*)text;

@end
