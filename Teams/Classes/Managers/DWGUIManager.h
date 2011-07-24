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

/**
 * Creates a UIBarButtonItem with a details icon. 
 * Target is the object that receives on click event.
 * sel is the selector sent to the target.
 */
+ (UIBarButtonItem*)navBarDetailsButtonWithTarget:(id)target
                                      andSelector:(SEL)sel;

/**
 * Creates a UILabel to act as the title view for the navigation bar
 */
+ (UILabel*)navBarTitleViewForText:(NSString*)text;

@end
