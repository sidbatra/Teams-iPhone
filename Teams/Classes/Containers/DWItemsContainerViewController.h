//
//  DWItemsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWContainerViewController.h"
#import "DWSmallProfilePicView.h"
#import "DWPostProgressView.h"

@class DWFollowedItemsViewController;
@class DWNavTitleView;

/**
 * Primary view for the Feed tab and container for followed 
 * items view
 */
@interface DWItemsContainerViewController : DWContainerViewController<DWPostProgressViewDelegate,DWSmallProfilePicViewDelegate> {
    
	DWFollowedItemsViewController	*_followedViewController;
    
	DWPostProgressView				*_postProgressView;
    DWSmallProfilePicView           *_smallProfilePicView;
    DWNavTitleView                  *_navTitleView;
    
    BOOL                            _isProgressBarActive;
}

/**
 * Table view for the items followed by the current user
 */
@property (nonatomic,retain) DWFollowedItemsViewController *followedViewController;

/**
 * Progress bar view for displaying the progress of the creation queue
 */
@property (nonatomic,retain) DWPostProgressView *postProgressView;

/**
 * Subview for displaying small profile picture
 */
@property (nonatomic,retain) DWSmallProfilePicView *smallProfilePicView;

/**
 * Nav bar title view for displaying user name and byline
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;

@end
