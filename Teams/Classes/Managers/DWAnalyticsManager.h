//
//  DWAnalyticsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Interface to store interactions locally and push to the
 * server when appropiate
 */
@interface DWAnalyticsManager : NSObject {
    NSMutableArray  *_interactions;
}

/**
 * Shared sole instance of the class
 */
+ (DWAnalyticsManager *)sharedDWAnalyticsManager;


/**
 * Array of interaction model objects performed by the current user that haven't
 * yet been successfully uploaded to the server
 */
@property (nonatomic,retain) NSMutableArray *interactions;

@end
