//
//  DWItemsHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsHelper.h"
#import "DWApplicationHelper.h"
#import "DWItem.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)createdAgoInWordsForItem:(DWItem*)item {
    return [DWApplicationHelper timeAgoInWordsForTimestamp:item.createdAtTimestamp];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)itemViewTitle:(DWItem*)item 
      belongsToCurrentUser:(BOOL)currentUsersItem {
    
    return currentUsersItem ? 
            @"Your Post" : 
            [NSString stringWithFormat:@"%@'s Post",item.user.firstName];
}


@end
