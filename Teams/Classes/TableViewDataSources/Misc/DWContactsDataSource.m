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
        self.contactsController             = [[DWContactsController alloc] init];
        self.contactsController.delegate    = self;
        
        self.invitesController              = [[DWInvitesController alloc] init];
        self.invitesController.delegate     = self; 
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    [self.contactsController getAllContacts];
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
- (void)removeContactFromCache:(DWContact*)contact {
    NSUInteger index = [self.allContacts indexOfObject:contact];
    
    if(index == NSNotFound)
        return;
    
    [self.allContacts removeObjectAtIndex:index];
}

//----------------------------------------------------------------------------------------------------
- (void)addContactToCache:(DWContact*)contact {
    [self.allContacts addObject:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)triggerInvitesForTeamID:(NSInteger)teamID {
    [self.invitesController createInvitesFrom:self.objects
                                    andTeamID:teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactsController Delegate

//----------------------------------------------------------------------------------------------------
- (void)allContactsLoaded:(NSMutableArray*)contacts {
    self.allContacts = contacts;
    [self.delegate allContactsLoaded];         
}

//----------------------------------------------------------------------------------------------------
- (void)contactsLoaded:(NSMutableArray*)contacts fromQuery:(NSString*)query {    
    
    if (query == self.latestQuery) {
        
        [self clean];
        self.objects = contacts;
        
        [self.delegate contactsLoadedFromQuery];
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
- (void)invitesCreationError:(NSString*)error {
    [self.delegate invitesCreationError:error];
}


@end
