//
//  DWTouch.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTouch.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTouch

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	NSLog(@"touch released - %d",self.databaseID);
    
	[super dealloc];
}

@end
