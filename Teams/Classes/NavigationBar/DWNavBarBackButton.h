//
//  DWNavBarBackButton.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Custom back button for navigation controllers. It holds
 * a non retained reference to the navigation controller for
 * automatic popping
 */
@interface DWNavBarBackButton : UIView {
    UINavigationController  *__unsafe_unretained _navController;
}

/**
 * Non-retained reference to the navigation controller which will be
 * popped when the back button is clicked
 */
@property (nonatomic,unsafe_unretained) UINavigationController *navController;

@end
