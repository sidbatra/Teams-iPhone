//
//  DWTeamMembersDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWUsersDataSource.h"

/**
 * Data source for the team members table view
 */
@interface DWTeamMembersDataSource : DWUsersDataSource {
    NSInteger   _teamID;
}

/**
 * teamID for the team whose members are being displayed
 */
@property (nonatomic,assign) NSInteger teamID;

@end
