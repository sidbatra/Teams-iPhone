//
//  DWTeamsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWTeamsController.h"

/**
 * Datasource for table views that contain a list of teams
 */
@interface DWTeamsDataSource : DWTableViewDataSource<DWTeamsControllerDelegate> {
    DWTeamsController   *_teamsController;
}

/**
 * Interface to the teams service on the app server
 */
@property (nonatomic) DWTeamsController *teamsController;


/**
 * Populate teams into the objects array
 */
- (void)populateTeams:(NSMutableArray*)teams;

/**
 * Stub method overriden by base class to start the loading of teams into the table view
 */
- (void)loadTeams;

@end
