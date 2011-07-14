//
//  DWContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Base class for containers which form the root views for
 * each of the tabs
 */
@interface DWContainerViewController : UIViewController <UINavigationControllerDelegate> {
    
	UIViewController    *_customTabBarController;
}

/**
 * Non-retained reference to the custom tab bar controller
 */
@property (nonatomic,assign) UIViewController *customTabBarController;


/**
 * Indicates if the container child is on the currently
 * selected tab
 */
- (BOOL)isSelectedTab;

@end


/**
 * Declarations for private methods
 */
@interface DWContainerViewController(Private)

/**
 * Parse the launch URL and perform the appropiate action
 */
- (void)processLaunchURL:(NSString*)url;

/**
 * Test for the presence launch url in the session
 */
- (void)testLaunchURL;
@end
