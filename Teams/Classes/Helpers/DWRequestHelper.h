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
 * Generates an error message from JSON
 */
+ (NSString*)generateErrorMessageFromJSON:(NSArray*)errors;


@end
