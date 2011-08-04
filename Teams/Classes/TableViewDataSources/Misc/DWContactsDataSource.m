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

@synthesize allContacts             = _allContacts;
@synthesize latestQuery             = _latestQuery;

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
        
        self.allContacts = [self.contactsController getAllContacts];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.allContacts            = nil;
    self.latestQuery            = nil;
    
    self.contactsController     = nil;
    self.invitesController      = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    self.allContacts = [self.contactsController getAllContacts];
}

//----------------------------------------------------------------------------------------------------
- (void)loadContactsMatching:(NSString*)string {
    self.latestQuery = string;
    [self.contactsController getContactsForQuery:string withCache:self.allContacts];
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
- (void)contactsLoaded:(NSMutableArray *)contacts fromQuery:(NSString*)query {    
    
    if (query == self.latestQuery) {
        
        [self clean];
        self.objects = contacts;
        
        [self.delegate contactsLoaded];
    }
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
