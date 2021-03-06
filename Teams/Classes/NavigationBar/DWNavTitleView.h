//
//  DWNavTitleView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWNavTitleViewDelegate;


/**
 * Generic title view for the navigation bar
 */
@interface DWNavTitleView : UIView {
    UILabel                     *titleLabel;
    UILabel                     *subtitleLabel;
    UILabel                     *standaloneTitleLabel;
    UIButton                    *underlayButton;
    UIActivityIndicatorView     *spinner;
    
    id <DWNavTitleViewDelegate>  _delegate;
}

/**
 * Custom init with delegate
 */
- (id)initWithFrame:(CGRect)frame 
        andDelegate:(id)delegate;


/**
 * Display single line vertically centered title
 */
- (void)displayTitle:(NSString*)title;

/**
 * Display title and subtitle
 */ 
- (void)displayTitle:(NSString*)title 
         andSubTitle:(NSString*)subTitle;

/**
 * Display title subtitle with a visually active button in the background
 * Enabled state controls the enabled state of the underlying button
 */
- (void)displayActiveButtonWithTitle:(NSString*)title 
                         andSubTitle:(NSString*)subTitle
                    withEnabledState:(BOOL)enabledState;

/**
 * Display title and subtitle with a visually dull button in the background
 * Enabled state controls the enabled state of the underlying button
 *
 */
- (void)displayPassiveButtonWithTitle:(NSString*)title
                          andSubTitle:(NSString*)subTitle
                     withEnabledState:(BOOL)enabledState;

/**
 * Display a centered spinner with or without an underlay
 */
- (void)displaySpinnerWithUnderlay:(BOOL)useUnderlay;

@end


/**
 * Delegate protocol to receive updates when the titleview is tapped
 */
@protocol DWNavTitleViewDelegate 

@optional

/**
 * Fired when the title view is touched
 */
-(void)didTapTitleView;

@end
