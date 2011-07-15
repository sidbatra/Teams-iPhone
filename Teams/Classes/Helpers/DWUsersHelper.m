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

@end