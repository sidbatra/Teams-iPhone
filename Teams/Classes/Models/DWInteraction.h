//
//  DWInteraction.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Stores a unit of interaction a user has had with the 
 * application
 */
@interface DWInteraction : NSObject {
    
    NSTimeInterval      _createdAt;
    
    NSString*           _viewName;
    NSInteger           _viewID;
    
    NSString*           _actionName;
    NSString*           _extra;
}

/**
 * Create an interaction
 */
- (void)createInteractionForViewNamed:(NSString*)viewName
                           withViewID:(NSInteger)viewID
                       withActionName:(NSString*)actionName
                         andExtraInfo:(NSString*)extra;

/**
 * Convert the interaction object to JSON
 */ 
- (NSString*)toJSON;

@end
