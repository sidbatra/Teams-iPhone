//
//  DWItemsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "DWFollowedItemsViewController.h"
#import "DWContainerViewController.h"
#import "DWSmallProfilePicView.h"
#import "DWProfilePicManager.h"
#import "DWPostProgressView.h"
#import "DWUserTitleView.h"

/**
 * Primary view for the Feed tab and container for followed 
 * items view
 */
@interface DWItemsContainerViewController : DWContainerViewController<DWPostProgressViewDelegate,DWProfilePicManagerDelegate> {
	DWFollowedItemsViewController	*followedViewController;
	DWPostProgressView				*postProgressView;
    DWSmallProfilePicView           *_smallProfilePicView;
    DWUserTitleView                 *_userTitleView;
    DWProfilePicManager             *_profilePicManager;
    
    BOOL                            _isProgressBarActive;
}

/**
 * Subview for displaying small profile picture
 */
@property (nonatomic,retain) DWSmallProfilePicView *smallProfilePicView;

/**
 * Subview for displaying username and following count
 */
@property (nonatomic,retain) DWUserTitleView *userTitleView;

/**
 * Profile pic manager for handling all the DWMediaPicker Events
 */
@property (nonatomic,retain) DWProfilePicManager *profilePicManager;


@end

/**
 * Declarations for select private methods
 */
@interface DWItemsContainerViewController(Private)

/**
 * Resets the badge value on the feeds tab
 * and uses notifications helper to reset count on the server
 * and the application icon
 */
- (void)resetBadgeValue;
@end
