//
//  DWRequestHelper.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRequestHelper.h"
#import "DWConstants.h"

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRequestHelper

//----------------------------------------------------------------------------------------------------
+ (NSString*)generateErrorMessageFrom:(NSArray*)errors {

    NSMutableString *errorMsg = [[[NSMutableString alloc] initWithString:kEmptyString] autorelease];
    
    for(id error in errors) {
        for (id e in error) {
            [errorMsg appendString:[NSString stringWithFormat:@"%@ ",e]];
        }
        [errorMsg appendString:@"\n"];
    }
    
    return [errorMsg capitalizedString];
}

@end
