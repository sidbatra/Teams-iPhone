//
//  DWItemsHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWItem;

/**
 * View helper methods for displaying item model instances
 */
@interface DWItemsHelper : NSObject {
    
}

/**
 * Converts timestamp to human readable text
 */
+ (NSString*)createdAgoInWordsForItem:(DWItem*)item;

@end
