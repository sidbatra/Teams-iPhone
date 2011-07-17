//
//  DWTeamsHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTeam;

/**
 * Helper method for displaying DWTeam objects
 */
@interface DWTeamsHelper : NSObject {
    
}

/**
 * Generate a created at byline showing when the
 * team was created
 */
+ (NSString*)createdAtLineForTeam:(DWTeam*)team;

@end
