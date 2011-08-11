//
//  DWTouch.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTouch.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTouch

@synthesize createdAtTimestamp  = _createdAtTimestamp;
@synthesize user                = _user;

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
    
    [self.user destroy];
    self.user = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary *)touch {
    [super update:touch];

    NSString *timestamp    = [touch objectForKey:kKeyTimestamp];
    NSDictionary *user     = [touch objectForKey:kKeyUser];
    
    
    if(timestamp)
        _createdAtTimestamp = [timestamp integerValue];
    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
}

@end
