//
//  DWTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWTeam;
@class DWTeamViewDataSource;
@class DWTeamsLogicController;
@protocol DWTeamsLogicControllerDelegate;

/**
 * Table view for displaying details about a team
 */
@interface DWTeamViewController : DWTableViewController {
    DWTeamViewDataSource        *_teamViewDataSource;
    DWTeamsLogicController      *_teamsLogicController;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamViewDataSource *teamViewDataSource;

/**
 * Encapsulates functionality to display one or more teams
 */
@property (nonatomic,retain) DWTeamsLogicController *teamsLogicController;


/**
 * Init with the team whose details are being displayed
 */
- (id)initWithTeam:(DWTeam*)team;

/**
 * Set a delegate that responds to the DWTeamsLogicControllerDelegate protocol
 */
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate;

@end
