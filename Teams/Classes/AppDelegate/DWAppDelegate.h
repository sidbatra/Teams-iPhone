//
//  DWAppDelegate.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBarController.h"

/**
 * Application delegate
 */
@interface DWAppDelegate : NSObject <UIApplicationDelegate,DWTabBarControllerDelegate> {
    UIWindow				*_window;
	
	DWTabBarController		*_tabBarController;
	
	
	UINavigationController	*_teamsNavController;
	UINavigationController	*_itemsNavController;
	UINavigationController	*_onboardingNavController;    
}


/**
 * UI Properties
 */

@property (nonatomic,retain) DWTabBarController *tabBarController;

/**
 * IBOutlet properties
 */
@property (nonatomic,retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UINavigationController *teamsNavController;
@property (nonatomic,retain) IBOutlet UINavigationController *itemsNavController;
@property (nonatomic,retain) IBOutlet UINavigationController *onboardingNavController;

@end


/**
 * Private method declarations
 */
@interface DWAppDelegate(Private)

/**
 * Init and position the UI elements that form the foundation
 * of the application.
 */
- (void)setupApplication;

/**
 * Init and position the custom tab bar controller and its children
 */
- (void)setupTabBarController;

@end

