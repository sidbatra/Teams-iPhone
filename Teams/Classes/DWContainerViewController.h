//
//  DWContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWItemFeedViewController.h"
#import "DWPlaceListViewController.h"
#import "DWSharingManager.h"

/**
 * Base class for containers which form the root views for
 * each of the tabs
 */
@interface DWContainerViewController : UIViewController <UINavigationControllerDelegate,DWItemFeedViewControllerDelegate,DWPlaceListViewControllerDelegate> {
    
	UIViewController *customTabBarController;
}

/**
 * Non-reained reference to the custom tab bar controller
 */
@property (nonatomic,assign) UIViewController *customTabBarController;


/**
 * Indicates if the container child is on the currently
 * selected tab
 */
- (BOOL)isSelectedTab;

/**
 * Test for the presence launch url in the session
 */
- (void)testLaunchURL;


@end


/**
 * Declarations for private methods
 */
@interface DWContainerViewController(Private)
- (void)processLaunchURL:(NSString*)url;
@end
