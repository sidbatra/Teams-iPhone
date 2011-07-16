//
//  DWTeamViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWTeamsController.h"

/**
 * Datasource for the team view data source
 */
@interface DWTeamViewDataSource : DWTableViewDataSource<DWTeamsControllerDelegate> {
    DWTeamsController   *_teamsController;
    NSInteger           _teamID;
}

/**
 * Interface to the teams service
 */
@property (nonatomic,retain) DWTeamsController *teamsController;

/**
 * TeamID for the team being displayed
 */
@property (nonatomic,assign) NSInteger teamID;


/**
 * Initiate the process to load data for the table view
 */
- (void)loadData;

@end
