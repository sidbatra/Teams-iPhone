//
//  DWContactsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsController.h"
#import "ABContactsHelper.h"
#import "DWContact.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        //custom initialization
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    NSLog(@"Contacts controller released");    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)getContactsMatching:(NSString*)string {
    
    SEL sel = @selector(contactsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;

    
    NSArray *contacts           = [ABContactsHelper contactsWithPropertiesContaining:string];
    NSMutableArray  *results    = [NSMutableArray arrayWithCapacity:[contacts count]];
    
    for(id contact in contacts) {
        
        DWContact *dWContact    = [[[DWContact alloc] init] autorelease];
        dWContact.firstName     = [contact firstname]; 
        dWContact.lastName      = [contact lastname];
        dWContact.email         = [contact emailaddresses];
        
        if (dWContact.email) 
            [results addObject:dWContact];
    }
    
    [self.delegate performSelector:sel
                        withObject:results];    
}

@end
