//
//  DWGUIManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 * Interface for generic GUI related factory and management methods
 */
@interface DWGUIManager : NSObject {
	
}

/**
 * Deprecated. See navBarBackButtonForNavController
 */
+ (UIBarButtonItem*)customBackButton:(id)target;

/**
 * Create a back button for the given navigation controller. Upon click
 * the button pops the given navigation controller. No references are retained.
 */
+ (UIBarButtonItem*)navBarBackButtonForNavController:(UINavigationController*)navController;


@end
