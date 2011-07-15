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
@property (nonatomic,retain) DWTeamsController *teamsController;

@end
