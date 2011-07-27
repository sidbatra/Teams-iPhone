//
//  DWAnalyticsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAnalyticsManager.h"
#import "DWInteraction.h"
#import "NSObject+Helpers.h"

#import "SynthesizeSingleton.h"


static NSInteger const kDefaultResourceID   = 0;
static NSString* const kDefaultName         = @"";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAnalyticsManager

@synthesize interactions    = _interactions;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWAnalyticsManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.interactions  = [NSMutableArray array];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.interactions    = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createPageviewForView:(NSObject*)view
               withResourceID:(NSInteger)viewResourceID {
    
    DWInteraction *interaction = [[DWInteraction alloc] init];
    
    [interaction createPageviewForViewNamed:[view className]
                             withResourceID:viewResourceID
                             withActionName:kDefaultName
                        withActionResoureID:kDefaultResourceID];
    
    [self.interactions addObject:interaction];
}

//----------------------------------------------------------------------------------------------------
- (void)createPageviewForView:(NSObject*)view {
    
    [self createPageviewForView:view
                 withResourceID:kDefaultResourceID];
}

@end
