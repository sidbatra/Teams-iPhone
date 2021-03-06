//
//  DWApplicationHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Helper methods for the entire application
 */
@interface DWApplicationHelper : NSObject {
    
}

/**
 * Generates an ordinal from a number
 */
+ (NSString*)generateOrdinalFrom:(NSInteger)num;

/**
 * Generate human friendly time ago in words from timestamp
 */
+ (NSString*)timeAgoInWordsForTimestamp:(NSTimeInterval)timestamp;

@end
