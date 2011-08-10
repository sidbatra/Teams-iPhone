//
//  DWApplicationHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWApplicationHelper.h"

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWApplicationHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)generateOrdinalFrom:(NSInteger)num {
    NSString *ending;
    
    NSInteger ones  = num % 10;
    NSInteger tens  = ((int)floor(num/10)) % 10;
        
    if(tens == 1) {
        ending = @"th";
    }
    else {
        switch (ones) {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }
    return [NSString stringWithFormat:@"%d%@", num, ending];
}

//----------------------------------------------------------------------------------------------------
+ (NSString*)timeAgoInWordsForTimestamp:(NSTimeInterval)timestamp {
	
	NSDate *createdAtDate   = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSInteger ti            = -[createdAtDate timeIntervalSinceNow];
    NSInteger diff          = 0;
    NSString *result        = nil;
    
	if (ti < 60) {
        result  =  (ti <= 1)    ? @"1 sec ago"   : [NSString stringWithFormat:@"%d secs ago", ti];
    } 
	else if (ti < 3600) {
        diff    = round(ti/60);
        result  = (diff == 1)   ? @"1 min ago"   : [NSString stringWithFormat:@"%d mins ago", diff];
    } 
	else if (ti < 86400) {
        diff    = round(ti/3600);		
        result  = (diff == 1)   ? @"1 hour ago"     : [NSString stringWithFormat:@"%d hours ago", diff];
    } 
    else if (ti < 518400) {
        diff    = round(ti/86400);        
        result  = (diff == 1)   ? @"Yesterday"      : [NSString stringWithFormat:@"%d days ago", diff];
    }
	else {
		NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[outputFormatter setDateFormat:@"d MMM"];
		
		result = [NSString stringWithString:[outputFormatter stringFromDate:createdAtDate]];		
    }
    
    return result;
}


@end
