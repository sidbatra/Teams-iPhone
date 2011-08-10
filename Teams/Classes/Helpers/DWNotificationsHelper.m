//
//  DWNotificationsHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsHelper.h"
#import "DWApplicationHelper.h"
#import "DWNotification.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)createdAgoInWordsForNotification:(DWNotification*)notification {
    return [DWApplicationHelper timeAgoInWordsForTimestamp:notification.createdAtTimestamp];
}

@end
