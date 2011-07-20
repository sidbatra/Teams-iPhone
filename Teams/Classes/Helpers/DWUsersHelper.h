//
//  DWUsersHelper.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;

/**
 * Helper methods for displaying DWUser model objects
 */
@interface DWUsersHelper : NSObject {
    
}

/**
 * Generates a signature for the user with the full team name
 * and first name last name.
 * Eg - Company / Bob Smith
 */
+ (NSString*)signatureWithTeamName:(DWUser*)user;

/**
 * Generates a signature for the user with the full team name and
 * first name.
 * Eg - Company / Bob
 */
+ (NSString*)shortSignatureWithTeamName:(DWUser*)user;

/**
 * <First Name> <Last Name>
 */
+ (NSString*)displayName:(DWUser*)user;

@end
