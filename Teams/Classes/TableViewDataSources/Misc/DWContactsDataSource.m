//
//  DWContactsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsDataSource.h"
#import "DWContact.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsDataSource

@synthesize contactsController      = _contactsController;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.contactsController            = [[[DWContactsController alloc] init] autorelease];
        self.contactsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.contactsController   = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)loadContactsMatching:(NSString*)string {
    [self.contactsController getContactsMatching:string];
}

//----------------------------------------------------------------------------------------------------
- (void)addContact:(DWContact*)contact {
    [self.objects addObject:contact];
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)removeContact:(DWContact*)contact {
    [self removeObject:contact withAnimation:UITableViewRowAnimationTop];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)contactsLoaded:(NSMutableArray *)contacts {
    [self clean];
    self.objects = contacts;
    
    [self.delegate reloadTableView];
}


@end
