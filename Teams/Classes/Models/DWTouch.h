//
//  DWTouch.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

@class DWUser;

/**
 * Touch model reprsenting an interaction between an item and a user
 */
@interface DWTouch : DWPoolObject {
    DWUser          *_user;
    
    NSTimeInterval	_createdAtTimestamp;
}

/**
 * User object of the user who created the touch
 */
@property (nonatomic,retain) DWUser *user;

/**
 * Timestamp of the creation of the touch 
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;

@end
