//
//  DWContact.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A model object to hold address book contact properties
 */
@interface DWContact : NSObject {
    
    NSString    *_fullName;    
    NSString    *_email;
}

/**
 * Full name of the contact
 */
@property (nonatomic,copy) NSString *fullName;

/**
 * Email of the contact
 */
@property (nonatomic,copy) NSString *email;

@end
