//
//  DWRequestHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRequestHelper.h"

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequestHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)generateErrorMessageFromJSON:(NSArray*)errors {

    NSMutableString *errorMsg = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    for(id error in errors) {
        for (id e in error) {
            [errorMsg appendString:[NSString stringWithFormat:@"%@ ",e]];
        }
        [errorMsg appendString:@"\n"];
    }
    
    return [errorMsg capitalizedString];
}

@end