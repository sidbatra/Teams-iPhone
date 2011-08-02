//
//  DWItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWItemsLogicController;
@protocol DWItemsLogicControllerDelegate;

/**
 * Base controller for all table views that display only a list of items
 */
@interface DWItemsViewController : DWTableViewController<UIActionSheetDelegate> {
    DWItemsLogicController      *_itemsLogicController;
    UIViewController            *_shellViewController;
}


/**
 * Items logic controller encapsulates all the functionality for display and interaction
 * of a list of items
 */
@property (nonatomic,retain) DWItemsLogicController *itemsLogicController;

/**
 * Shell view controller for displaying modal UI elements
 */
@property (nonatomic,assign) UIViewController *shellViewController;


/**
 * Set a items logic controller delegate
 */
- (void)setItemsDelegate:(id<DWItemsLogicControllerDelegate>)delegate;

@end
