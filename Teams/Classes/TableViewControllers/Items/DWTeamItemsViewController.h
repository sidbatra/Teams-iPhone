//
//  DWTeamItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"

@class DWTeam;
@class DWTeamItemsDataSource;
@protocol DWTeamItemsViewControllerDelegate;


/**
 * Table view for the items crated by a team
 */
@interface DWTeamItemsViewController : DWItemsViewController {
    DWTeamItemsDataSource       *_teamItemsDataSource;
    
    id<DWTeamItemsViewControllerDelegate>    _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamItemsDataSource *teamItemsDataSource;

/**
 * Delegate that receives messages based on the DWTeamViewControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWTeamItemsViewControllerDelegate> delegate;


/**
 * Init with the team whose items are being displayed
 */ 
- (id)initWithTeam:(DWTeam*)team;

@end


/**
 * Protocol for delegates of DWTeamItemsViewController
 */
@protocol DWTeamItemsViewControllerDelegate

/**
 * Fired when the team details view is to be displayed
 */
- (void)teamDetailsSelected:(DWTeam*)team;
@end

