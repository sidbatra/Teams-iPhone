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
@interface DWItemsContainerViewController : DWContainerViewController<DWPostProgressViewDelegate> {
	DWFollowedItemsViewController	*followedViewController;
	DWPostProgressView				*postProgressView;
    DWSmallProfilePicView           *_smallProfilePicView;
    DWUserTitleView                 *_userTitleView;
    
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

@end


/**
 * Private method declarations
 */
@interface DWItemsContainerViewController(Private)

@end
