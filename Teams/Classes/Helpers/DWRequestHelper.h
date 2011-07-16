//
//  DWRequestHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Helper methods for DWRequest
 */
@interface DWRequestHelper : NSObject {
    
}


/**
 * Generates an error message from the JSON returned
 * from a DWDenwenRequest
 */
+ (NSString*)generateErrorMessageFrom:(NSArray*)errors;


@end
