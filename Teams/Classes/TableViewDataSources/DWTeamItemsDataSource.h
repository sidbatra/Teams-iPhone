//
//  DWTeamItemsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWItemsDataSource.h"

/**
 * Data source for the team items view controller
 */
@interface DWTeamItemsDataSource : DWItemsDataSource {
    NSInteger _teamID;
}

/**
 * teamID for the team whose items are being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

@end
