//
//  DWAnalyticsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAnalyticsManager.h"
#import "DWInteraction.h"
#import "NSObject+Helpers.h"

#import "SynthesizeSingleton.h"


static NSInteger const kDefaultViewID       = 0;
static NSString* const kDefaultName         = @"";
static NSString* const kDefaultExtra        = @"";


/**
 * Private method and property declarations
 */
@interface DWAnalyticsManager()

/**
 * Convert the interactions array to a JSON string
 */
- (NSString*)toJSON;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAnalyticsManager

@synthesize interactions            = _interactions;
@synthesize interactionsController  = _interactionsController;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWAnalyticsManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.interactions                       = [NSMutableArray array];
        
        self.interactionsController             = [[[DWInteractionsController alloc] init] autorelease];
        self.interactionsController.delegate    = self;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.interactions           = nil;
    self.interactionsController = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)toJSON {
    
    NSMutableString *json       = [NSMutableString stringWithString:@"["];
    NSInteger totalInteractions = [self.interactions count];
    
    /**
     * Create a JSON array string by combining the json string of
     * individual interactions
     */
    for(int i=0 ; i<totalInteractions ; i++) {
        
        DWInteraction *interaction = [self.interactions objectAtIndex:i];
        [json appendString:[interaction toJSON]];
        
        if(i != totalInteractions-1)
            [json appendString:@","];
    }
    
    [json appendString:@"]"];
    
    return [NSString stringWithString:json];
}

//----------------------------------------------------------------------------------------------------
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName
                      withViewID:(NSInteger)viewID
                    andExtraInfo:(NSString*)extra {
    
    DWInteraction *interaction = [[DWInteraction alloc] init];
    
    [interaction createInteractionForViewNamed:[view className]
                                    withViewID:viewID
                                withActionName:actionName
                                  andExtraInfo:extra];
        
     [self.interactions addObject:interaction];
    
    
    NSLog(@"JSON - %@", [self toJSON]);
}

//----------------------------------------------------------------------------------------------------
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName
                    andExtraInfo:(NSString*)extra {
    
    [self createInteractionForView:view
                    withActionName:actionName
                        withViewID:kDefaultViewID
                      andExtraInfo:extra];
}

//----------------------------------------------------------------------------------------------------
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName {
    
    [self createInteractionForView:view
                    withActionName:actionName
                        withViewID:kDefaultViewID
                      andExtraInfo:kDefaultExtra];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWInteractionsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)interactionsCreated:(NSInteger)count {
    [self.interactions removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,count-1)]];
}

//----------------------------------------------------------------------------------------------------
- (void)interactionsCreationError:(NSString *)error {
    NSLog(@"error creating interactions %@",error);
}

@end
