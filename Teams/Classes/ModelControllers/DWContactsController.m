//
//  DWContactsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsController.h"
#import "ABContactsHelper.h"
#import "DWContact.h"
#import "DWConstants.h"


static NSString* const kContactsQuery   = @"email contains[cd] %@ OR lastName contains[cd] %@ OR firstName contains[cd] %@";

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSArray*)getAllContacts {

    NSArray *contacts               = [ABContactsHelper contacts];
    NSMutableArray  *dWContacts     = [NSMutableArray arrayWithCapacity:[contacts count]];    
    
    for(id contact in contacts) {
        for(id email in [contact emailArray]) {
            DWContact *dWContact    = [[[DWContact alloc] init] autorelease];
            
            dWContact.firstName     = [[contact firstname] length] == 0         ?   @"" : [contact firstname] ;
            dWContact.lastName      = [[contact lastname] length] == 0          ?   @"" : [contact lastname]; 
            dWContact.email         = email;

            [dWContacts addObject:dWContact];
        }
    }
    
    return dWContacts;
}


//----------------------------------------------------------------------------------------------------
- (void)getContactsForQuery:(NSString*)query withCache:(NSArray*)contacts {
    
    SEL sel = @selector(contactsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSPredicate *pred       = [NSPredicate predicateWithFormat:kContactsQuery,query,query,query];
	NSMutableArray *results = [NSMutableArray arrayWithArray:[contacts filteredArrayUsingPredicate:pred]];

    [self.delegate performSelector:sel
                        withObject:results]; 
}

@end
