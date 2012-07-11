//
//  DWContact.m
//  Copyright 2011 Denwen. All rights reserved.
//


#import "DWContact.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContact

@synthesize firstName       = _firstName;
@synthesize lastName        = _lastName;
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

//---------------------------------------------------------------------------------------------------
- (NSString*)debugString {
    
    return [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@",
            self.firstName,
            self.lastName,
            self.email];    
}

@end
