//
//  DWNavBarNotificationsView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DWNavBarCountViewDelegate;

/**
 * Display a count with an count controlled active in-active state
 */
@interface DWNavBarCountView : UIView {
    UIButton    *backgroundButton;
    UILabel     *countLabel;
    
    id<DWNavBarCountViewDelegate>   __unsafe_unretained _delegate;
}

/**
 * Delegate receives events based on the DWNavBarCountViewDelegate
 */
@property (nonatomic,unsafe_unretained) id<DWNavBarCountViewDelegate> delegate;


/**
 * Change the displayed count
 */
- (void)setCount:(NSInteger)count;

@end


/**
 * Protocol for delegates of DWNavBarCountView instances
 */
@protocol DWNavBarCountViewDelegate

/**
 * Fired when the background button is clicked
 */
- (void)countButtonClicked;

@end