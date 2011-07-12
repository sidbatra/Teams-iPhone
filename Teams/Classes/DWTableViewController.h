//
//  DWTableViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"

/**
 * Customized version of UITableViewController which forms the base 
 * for every table view controller in the app
 */
@interface DWTableViewController : UITableViewController<EGORefreshTableHeaderDelegate> {
    
    NSMutableDictionary         *_modelPresentationStyle;
    
	EGORefreshTableHeaderView   *_refreshHeaderView;
}

/**
 * Holds a mapping of preesntation styles for the model objects that the table view
 * renders. It starts of empty, which means the default style for all models.
 */
@property (nonatomic,retain) NSMutableDictionary *modelPresentationStyle;

/**
 * View for pull to refresh added above the table view
 */
@property (nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;


@end


