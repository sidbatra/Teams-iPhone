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
- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;


/**
 * Display state for title view
 */
- (void)displayTitle:(NSString*)title;
- (void)displayTitle:(NSString*)title andSubTitle:(NSString*)subTitle;
- (void)displayActiveButtonWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle;
- (void)displayPassiveButtonWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle;
- (void)displaySpinner;

/** 
 * Title view button pressed
 */
- (void)titleViewButtonTapped;

@end


/**
 * Declarations for private methods
 */
@interface DWNavTitleView (Private)

- (void)createUnderlayButton;
- (void)createTitleLabel;
- (void)createSubtitleLabel;
- (void)createStandaloneTitleLabel;
- (void)createSpinner;

@end


/**
 * Delegate protocol to receive updates when
 * the titleview is tapped
 */
@protocol DWNavTitleViewDelegate 

-(void)didTapTitleView;

@end
