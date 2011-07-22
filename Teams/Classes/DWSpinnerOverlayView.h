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
    
}

/**
 * Custom init with spinner origin and message text
 */
- (id)initWithSpinnerOrigin:(CGPoint)origin 
             andMessageText:(NSString*)text;


/**
 * Shows the view and enables all interaction
 */
- (void)enable;

/**
 * Hides the view and disables all interaction
 */
- (void)disable;

@end
