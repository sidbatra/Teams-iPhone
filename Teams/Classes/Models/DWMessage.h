//
//  DWMessage.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Message model used to inject a message cell into table views
 */
@interface DWMessage : NSObject {
    NSString    *_message;
}

/**
 * Message held by the object
 */
@property (nonatomic,copy) NSString* message;

@end