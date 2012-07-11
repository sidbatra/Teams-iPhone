//
//  DWMembership.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMembership.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMembership

@synthesize createdAtTimestamp  = _createdAtTimestamp;
@synthesize team                = _team;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	NSLog(@"membership released - %d",self.databaseID);
	
    [self.team destroy];
    
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)item {
    [super update:item];
    
    NSString *timestamp         = [item objectForKey:kKeyTimestamp];
    NSDictionary *team          = [item objectForKey:kKeyTeam];
    
    
    if(timestamp)
        _createdAtTimestamp = [timestamp integerValue];
    
    if(team) {
        if(self.team)
            [self.team update:team];
        else
            self.team = [DWTeam create:team];
    }
}


@end
