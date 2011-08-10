//
//  DWNotificationsHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWNotification;

/**
 * Helper methods for displaying notification model instances
 */
@interface DWNotificationsHelper : NSObject {
    
}

/**
 * Time ago in words for when a notification is created
 */
+ (NSString*)createdAgoInWordsForNotification:(DWNotification*)notification;

@end