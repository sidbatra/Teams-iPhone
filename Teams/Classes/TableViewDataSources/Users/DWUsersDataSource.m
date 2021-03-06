//
//  DWUsersDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersDataSource

@synthesize usersController = _usersController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[[DWUsersController alloc] init] autorelease];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.usersController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)populateUsers:(NSMutableArray*)users {
    
    [self clean];
    self.objects = users;
    
    [self.delegate reloadTableView];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadUsers {
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUsers];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}

@end
