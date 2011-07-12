//
//  DWItemsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "DWContainerViewController.h"
#import "DWSmallProfilePicView.h"
#import "DWProfilePicManager.h"
#import "DWPostProgressView.h"
#import "DWUserTitleView.h"

@class DWFollowedItemsViewController;

/**
 * Primary view for the Feed tab and container for followed 
 * items view
 */
@interface DWItemsContainerViewController : DWContainerViewController<DWPostProgressViewDelegate> {
	DWFollowedItemsViewController	*_followedViewController;
	DWPostProgressView				*postProgressView;
    DWSmallProfilePicView           *_smallProfilePicView;
    DWUserTitleView                 *_userTitleView;
    
    BOOL                            _isProgressBarActive;
}

/**
 * Table view for the items followed by the current user
 */
@property (nonatomic,retain) DWFollowedItemsViewController *followedViewController;

/**
 * Subview for displaying small profile picture
 */
@property (nonatomic,retain) DWSmallProfilePicView *smallProfilePicView;

/**
 * Subview for displaying username and following count
 */
@property (nonatomic,retain) DWUserTitleView *userTitleView;

@end


/**
 * Private method declarations
 */
@interface DWItemsContainerViewController(Private)

@end
