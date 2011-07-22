//
//  DWTeamsHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsHelper.h"
#import "DWTeam.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)createdAtLineForTeam:(DWTeam*)team {
    NSDate *teamCreatedAt       = [NSDate dateWithTimeIntervalSince1970:team.createdAtTimestamp];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    
    return [NSString stringWithFormat:@"Team started %@",[dateFormat stringFromDate:teamCreatedAt]];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)totalWatchersLineForTeam:(DWTeam*)team {
    return [NSString stringWithFormat:@"%d Watching this Team",team.followingsCount];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)totalMembersLineForTeam:(DWTeam*)team {
    
    return [NSString stringWithFormat:@"%d %@ on the Team",
            team.membersCount,
            team.membersCount == 1 ? @"Person" : @"People"];    
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)watchersOfTeam:(DWTeam*)team {
    return [NSString stringWithFormat:@"Watching %@",team.name];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)membersOfTeam:(DWTeam*)team {
    return [NSString stringWithFormat:@"Team %@",team.name];
}

@end
