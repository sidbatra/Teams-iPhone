//
//  DWAnalyticsManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAnalyticsManager.h"

#import "SynthesizeSingleton.h"



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

@end
