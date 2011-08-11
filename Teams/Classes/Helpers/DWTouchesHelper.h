//
//  DWTouchesHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTouch;

/**
 * Helper method for displaying touch model instances
 */
@interface DWTouchesHelper : NSObject

/**
 * Generate subtitle for displaying the touch
 */
+ (NSString*)subtitleForTouch:(DWTouch*)touch;

@end
