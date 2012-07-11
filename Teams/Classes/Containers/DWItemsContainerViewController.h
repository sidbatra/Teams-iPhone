//
//  DWItemsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWContainerViewController.h"
#import "DWUsersController.h"
#import "DWSmallProfilePicView.h"
#import "DWPostProgressView.h"
#import "DWNavBarCountView.h"


@class DWFollowedItemsViewController;
@class DWNavTitleView;

/**
 * Primary view for the Feed tab and container for followed 
 * items view
 */
@interface DWItemsContainerViewController : DWContainerViewController<DWPostProgressViewDelegate,DWSmallProfilePicViewDelegate,DWNavBarCountViewDelegate,DWUsersControllerDelegate> {
    
	DWFollowedItemsViewController	*_followedViewController;
    DWUsersController               *_usersController;
    
	DWPostProgressView				*_postProgressView;
    DWSmallProfilePicView           *_smallProfilePicView;
    DWNavTitleView                  *_navTitleView;
    DWNavBarCountView               *_navBarNotificationsView;
    
    BOOL                            _isProgressBarActive;
}

/**
 * Table view for the items followed by the current user
 */
@property (nonatomic) DWFollowedItemsViewController *followedViewController;

/**
 * Interface to the users service
 */
@property (nonatomic) DWUsersController *usersController;

/**
 * Progress bar view for displaying the progress of the creation queue
 */
@property (nonatomic) DWPostProgressView *postProgressView;

/**
 * Subview for displaying small profile picture
 */
@property (nonatomic) DWSmallProfilePicView *smallProfilePicView;

/**
 * Notifications view displaying the number of unread notifications
 */
@property (nonatomic) DWNavBarCountView *navBarNotificationsView;

/**
 * Nav bar title view for displaying user name and byline
 */
@property (nonatomic) DWNavTitleView *navTitleView;

@end
