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
    
    self.firstName      = nil;
    self.lastName       = nil;
    self.email          = nil;
    
    [super dealloc];
}

//---------------------------------------------------------------------------------------------------
- (NSString*)fullName {
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

//---------------------------------------------------------------------------------------------------
- (NSString*)debugString {
    
    return [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@",
            self.firstName,
            self.lastName,
            self.email];    
}

@end
