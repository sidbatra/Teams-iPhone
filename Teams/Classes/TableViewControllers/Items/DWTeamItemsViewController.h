//
//  DWTeamItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"

@class DWTeam;
@class DWTeamItemsDataSource;
@class DWNavTitleView;
@protocol DWTeamItemsViewControllerDelegate;


/**
 * Table view for the items crated by a team
 */
@interface DWTeamItemsViewController : DWItemsViewController<UIActionSheetDelegate> {
    DWTeamItemsDataSource       *_teamItemsDataSource;
    
    DWNavTitleView              *_navTitleView;
    
    id<DWTeamItemsViewControllerDelegate>    __unsafe_unretained _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic) DWTeamItemsDataSource *teamItemsDataSource;

/**
 * Title view for the nav bar
 */
@property (nonatomic) DWNavTitleView *navTitleView;

/**
 * Delegate that receives messages based on the DWTeamViewControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWTeamItemsViewControllerDelegate> delegate;


/**
 * Init with the teamID whose items are being displayed
 */ 
- (id)initWithTeamID:(NSInteger)teamID;

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

