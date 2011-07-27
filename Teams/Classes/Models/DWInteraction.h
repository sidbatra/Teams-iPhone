//
//  DWInteraction.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * enum for the different kinds of interactions
 */
typedef enum {
    kInteractionTypeEvent       = 0,
    kInteractionTypePageview    = 1
}
DWInteractionType;


/**
 * Stores a unit of interaction a user has had with the 
 * application
 */
@interface DWInteraction : NSObject {
    NSInteger           _type;
    NSTimeInterval      _createdAt;
    
    NSString*           _viewName;
    NSInteger           _viewResourceID;
    
    NSString*           _actionName;
    NSInteger           _actionResourceID;
}

/**
 * Create a page view type interaction 
 */
- (void)createPageviewForViewNamed:(NSString*)viewName
                    withResourceID:(NSInteger)viewResourceID
                    withActionName:(NSString*)actionName
               withActionResoureID:(NSInteger)actionResourceID;

@end
