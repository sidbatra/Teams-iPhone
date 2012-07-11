//
//  DWUserItemsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsDataSource.h"
#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsDataSource

@synthesize usersController = _usersController;
@synthesize user            = _user;
@synthesize userID          = _userID;

@dynamic delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.usersController            = [[DWUsersController alloc] init];
        self.usersController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    [self.user destroy]; 
    
}

//----------------------------------------------------------------------------------------------------
- (void)loadItems {
    [self.itemsController getUserItemsForUserID:_userID
                                         before:_oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self.usersController  getUserWithID:_userID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [super refreshInitiated];
    
    [self loadUser];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)itemsResourceID {
    return _userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsLoaded:(NSMutableArray *)items {  
    [self populateItems:items];
}

//----------------------------------------------------------------------------------------------------
- (void)userItemsError:(NSString *)message {
    NSLog(@"User items error - %@",message);
    [self.delegate displayError:message];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControlelrDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return _userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
    
    self.user = user;
    
    [self.delegate userLoaded:user];
    
    [user startSmallImageDownload];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString*)error {
    NSLog(@"User load error - %@",error);
    [self.delegate displayError:error];
}

@end
