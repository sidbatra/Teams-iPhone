//
//  DWContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWTabBarController;

/**
 * Base class for containers which form the root views for
 * each of the tabs
 */
@interface DWContainerViewController : UIViewController <UINavigationControllerDelegate> {
    
	DWTabBarController    *_customTabBarController;
}

/**
 * Non-retained reference to the custom tab bar controller
 */
@property (nonatomic,assign) DWTabBarController *customTabBarController;

@end
