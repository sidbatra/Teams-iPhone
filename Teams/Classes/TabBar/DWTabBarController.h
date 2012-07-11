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
    UIImageView         *_backgroundView;
	NSArray				*_subControllers;
    	
	id<DWTabBarControllerDelegate> __unsafe_unretained _delegate;
}

/**
 * Delegate receives updates about tab bar selection changes
 */
@property (nonatomic,unsafe_unretained) id<DWTabBarControllerDelegate> delegate;


/**
 * Init with frame for drawing the tab bar
 * and tab bar info for creating the buttons in the tab bar
 */
- (id)initWithTabBarFrame:(CGRect)tabBarFrame
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

/**
 * Hide the top show shadow image
 */
- (void)hideTopShadowView;

/**
 * Display the top shadow image
 */
- (void)showTopShadowView;

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
