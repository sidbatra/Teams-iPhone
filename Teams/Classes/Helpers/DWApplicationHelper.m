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

@end
