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
@synthesize invitesController       = _invitesController;
@dynamic delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.contactsController             = [[[DWContactsController alloc] init] autorelease];
        self.contactsController.delegate    = self;
        
        self.invitesController              = [[[DWInvitesController alloc] init] autorelease];
        self.invitesController.delegate     = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.contactsController     = nil;
    self.invitesController      = nil;
    
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
- (void)triggerInvites {
    [self.invitesController createInvitesFrom:self.objects];
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWInvitesController Delegate

//----------------------------------------------------------------------------------------------------
- (void)invitesCreated {
    [self.delegate invitesCreated];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreationError:(NSString *)error {
    [self.delegate displayError:error];
}


@end
