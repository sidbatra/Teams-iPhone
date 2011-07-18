//
//  DWTeamFollowersDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersDataSource.h"

/**
 * Data source for the team followers table view
 */
@interface DWTeamFollowersDataSource : DWUsersDataSource {
    NSInteger   _teamID;
}

/**
 * teamID for the team whose followers are being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

@end
