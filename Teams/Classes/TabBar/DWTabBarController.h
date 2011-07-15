//
//  DWTabBarController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTabBar.h"

@protocol DWTabBarControllerDelegate;


/**
 * Custom tab bar controller
 */
@interface DWTabBarController : UIViewController<DWTabBarDelegate> {
	DWTabBar			*_tabBar;
    UIImageView         *_topShadowView;
    UIImageView         *_bottomShadowView;
	NSArray				*_subControllers;
    	
	id<DWTabBarControllerDelegate> _delegate;
}



/**
 * Init with delegate to receive events about tab bar clicks,
 * frame for drawing the tab bar
 * and tab bar info for creating the buttons in the tab bar
 */
- (id)initWithDelegate:(id)theDelegate 
	   withTabBarFrame:(CGRect)tabBarFrame
		 andTabBarInfo:(NSArray*)tabBarInfo;

/**
 * Setup the sub controllers on each of the tabs
 */
- (void)setupSubControllers:(NSArray*)controllers;

/**
 * Disables full screen for selected controller
 */
- (void)disableFullScreen;

/**
 * Enables full screen view for selected controller 
 */
- (void)enableFullScreen;

/**
 * Returns the subController corresponding to the
 * currently selected tab bar button
 */
- (UIViewController*)getSelectedController;

/**
 * Highlight the tab at the given index
 */
- (void)highlightTabAtIndex:(NSInteger)index;

/**
 * Dim the tab at the given index
 */
- (void)dimTabAtIndex:(NSInteger)index;

@end


/**
 * Delegate protocol to send events about index changes
 */
@protocol DWTabBarControllerDelegate

/**
 * Fired when the selected tab changes
 */
- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
							 to:(NSInteger)newSelectedIndex;
@end
