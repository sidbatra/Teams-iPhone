//
//  DWTeamItemsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsViewController.h"


@class DWTeam;
@class DWTeamItemsDataSource;

/**
 * Table view for the items crated by a team
 */
@interface DWTeamItemsViewController : DWItemsViewController {
    DWTeamItemsDataSource   *_teamItemsDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamItemsDataSource *teamItemsDataSource;


/**
 * Init with the team whose items are being displayed
 */ 
- (id)initWithTeam:(DWTeam*)team;

@end
