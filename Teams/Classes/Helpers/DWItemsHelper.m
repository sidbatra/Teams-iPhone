//
//  DWItemsHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsHelper.h"
#import "DWItem.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)createdAgoInWordsForItem:(DWItem*)item {
	
	NSDate *createdAtDate   = [NSDate dateWithTimeIntervalSince1970:item.createdAtTimestamp];
    NSInteger ti            = -[createdAtDate timeIntervalSinceNow];
    NSInteger diff          = 0;
    NSString *result        = nil;
    
	if (ti < 60) {
        result  =  (ti <= 1)    ? @"1 second ago"   : [NSString stringWithFormat:@"%d seconds ago", ti];
    } 
	else if (ti < 3600) {
        diff    = round(ti/60);
        result  = (diff == 1)   ? @"1 minute ago"   : [NSString stringWithFormat:@"%d minutes ago", diff];
    } 
	else if (ti < 86400) {
        diff    = round(ti/3600);		
        result  = (diff == 1)   ? @"1 hour ago"     : [NSString stringWithFormat:@"%d hours ago", diff];
    } 
    else if (ti < 518400) {
        diff    = round(ti/86400);        
        result  = (diff == 1)   ? @"1 day ago"      : [NSString stringWithFormat:@"%d days ago", diff];
    }
	else {
		NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[outputFormatter setDateFormat:@"d MMM"];
		
		result = [NSString stringWithString:[outputFormatter stringFromDate:createdAtDate]];		
    }
    
    return result;
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)itemViewTitle:(DWItem*)item 
      belongsToCurrentUser:(BOOL)currentUsersItem {
    
    return currentUsersItem ? 
            @"Your Post" : 
            [NSString stringWithFormat:@"%@'s Post",item.user.firstName];
}


@end
