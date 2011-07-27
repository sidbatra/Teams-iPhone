//
//  DWInteraction.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInteraction.h"


/**
 * Private method and property declarations
 */
@interface DWInteraction()

/**
 * Name of the view where the interaction took place
 */
@property (nonatomic,retain) NSString *viewName;

/**
 * Optional name of the action taking place
 */
@property (nonatomic,retain) NSString* actionName;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInteraction

@synthesize viewName    = _viewName;
@synthesize actionName  = _actionName;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        _createdAt          = [[NSDate date] timeIntervalSince1970];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    NSLog(@"interaction released");
    
    self.viewName   = nil;
    self.actionName = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createPageviewForViewNamed:(NSString*)viewName
                    withResourceID:(NSInteger)viewResourceID
                    withActionName:(NSString*)actionName
               withActionResoureID:(NSInteger)actionResourceID {
    
    _type               = kInteractionTypePageview;
    
    self.viewName       = viewName;
    _viewResourceID     = viewResourceID;
    
    self.actionName     = actionName;
    _actionResourceID   = actionResourceID;
}


@end




