//
//  DWNavBarNotificationsView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWNavBarNotificationsViewDelegate;

/**
 * Display number of unread notifications
 */
@interface DWNavBarNotificationsView : UIView {
    UIButton    *backgroundButton;
    UILabel     *unreadCountLabel;
    
    id<DWNavBarNotificationsViewDelegate>   _delegate;
}

/**
 * Delegate receives events based on the DWNavBarNotificationsViewDelegate
 */
@property (nonatomic,assign) id<DWNavBarNotificationsViewDelegate> delegate;


/**
 * Change the displayed unread count
 */
- (void)setUnreadCount:(NSInteger)unreadCount;

@end


/**
 * Protocol for delegates of DWNavBarNotificationView instances
 */
@protocol DWNavBarNotificationsViewDelegate

/**
 * Fired when the background button is clicked
 */
- (void)notificationsButtonClicked;

@end