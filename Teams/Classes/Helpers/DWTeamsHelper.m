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

@end
