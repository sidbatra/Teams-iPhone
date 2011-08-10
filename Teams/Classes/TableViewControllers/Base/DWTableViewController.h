//
//  DWTableViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTableViewDataSource.h"

#import "EGORefreshTableHeaderView.h"

/**
 * Customized version of UITableViewController which forms the base 
 * for every table view controller in the app
 */
@interface DWTableViewController : UITableViewController<DWTableViewDataSourceDelegate,EGORefreshTableHeaderDelegate> {
    
    NSMutableDictionary         *_modelPresentationStyle;
    
    BOOL                        _isPullToRefreshActive;
    
	EGORefreshTableHeaderView   *_refreshHeaderView;
    UIView                      *_loadingView;
    UIView                      *_errorView;
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

/**
 * View displayed when results are being fetched from the server
 */
@property (nonatomic,retain) UIView *loadingView;

/**
 * View displayed when an error occurs
 */
@property (nonatomic,retain) UIView *errorView;


/**
 * Scroll the table view to the top
 */
- (void)scrollToTop;

@end


@interface DWTableViewController ()
/**
 * Pass the newly available resource to all visible cells to check
 * for possible UI updates
 */
- (void)provideResourceToVisibleCells:(NSInteger)resourceType
                             resource:(id)resource
                           resourceID:(NSInteger)resourceID;

/**
 * Return a delegate object for the given class name. Default implementation
 * returns the table view itself.
 */
- (id)getDelegateForClassName:(NSString*)className;

/**
 * Get the data source object for the table view controller
 */
- (DWTableViewDataSource*)getDataSource;

/**
 * Method to disable pull to refresh for certain table views
 */
- (void)disablePullToRefresh;

/**
 * Method to disable scrolling for certain table views
 */
- (void)disableScrolling;

@end
