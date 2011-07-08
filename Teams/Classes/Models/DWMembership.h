//
//  DWMembership.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"
#import "DWTeam.h"

/**
 * Holds memberships between a team and a user
 */
@interface DWMembership : DWPoolObject {
    NSTimeInterval	_createdAtTimestamp;

    DWTeam          *_team;
}

/**
 * Timestamp of the date of creation of the membership
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;

/**
 * The team to which the membership belongs
 */
@property (nonatomic,retain) DWTeam *team;

@end
