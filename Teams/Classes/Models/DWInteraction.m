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
@property (nonatomic,copy) NSString *viewName;

/**
 * Name of the action taking place
 */
@property (nonatomic,copy) NSString* actionName;

/**
 * Extra information about the interaction
 */
@property (nonatomic,copy) NSString* extra;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInteraction

@synthesize viewName    = _viewName;
@synthesize actionName  = _actionName;
@synthesize extra       = _extra;

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
    self.extra      = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createInteractionForViewNamed:(NSString*)viewName
                           withViewID:(NSInteger)viewID
                       withActionName:(NSString*)actionName
                         andExtraInfo:(NSString*)extra {
    
    self.viewName       = viewName;
    _viewID             = viewID;
    
    self.actionName     = actionName;
    self.extra          = extra;
}

//----------------------------------------------------------------------------------------------------
- (NSString*)toJSON {
    NSString *jsonFormat = @"{"
                            "\"created_at\":\"%d\","
                            "\"view_name\":\"%@\","
                            "\"view_id\":\"%d\","
                            "\"action\":\"%@\","
                            "\"extra\":\"%@\""
                            "}";
    
    return [NSString stringWithFormat:jsonFormat,
            (NSInteger)_createdAt,
            self.viewName,
            _viewID,
            self.actionName,
            self.extra];
}

@end




