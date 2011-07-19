//
//  DWContact.m
//  Copyright 2011 Denwen. All rights reserved.
//


#import "DWContact.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContact

@synthesize fullName        = _fullName;
@synthesize email           = _email;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        //Custom initialization
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    NSLog(@"contact released");
    
    self.fullName   = nil;
    self.email      = nil;
    
    [super dealloc];
}

@end
