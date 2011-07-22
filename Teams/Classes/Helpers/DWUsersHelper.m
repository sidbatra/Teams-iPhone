//
//  DWUsersHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersHelper.h"
#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersHelper

+ (NSString*)signatureWithTeamName:(DWUser*)user {
    return [NSString stringWithFormat:@"%@ / %@ %@",
            user.team.name,
            user.firstName,
            user.lastName];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)shortSignatureWithTeamName:(DWUser*)user {
    return [NSString stringWithFormat:@"%@ / %@",
            user.team.name,
            user.firstName];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)displayName:(DWUser*)user {
    return [NSString stringWithFormat:@"%@ %@",
            user.firstName  ? user.firstName    : @"",
            user.lastName   ? user.lastName     : @""];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)currentTeamLine:(DWUser*)user {
    return [NSString stringWithFormat:@"%@ Team",user.team.name];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)watchingTeamsLine:(DWUser*)user {
    
    NSInteger otherCount = user.followingCount - 1;
    
    return [NSString stringWithFormat:@"Watching %d other %@",
            otherCount,
            otherCount == 1 ? @"Team" : @"Teams"];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)createdAtLine:(DWUser*)user {
    NSDate *userCreatedAt       = [NSDate dateWithTimeIntervalSince1970:user.createdAtTimestamp];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    
    return [NSString stringWithFormat:@"Joined %@",[dateFormat stringFromDate:userCreatedAt]];
}


@end
