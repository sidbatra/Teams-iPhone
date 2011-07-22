//
//  DWUserViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewDataSource.h"
#import "DWUser.h"
#import "DWMessage.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewDataSource

@synthesize usersController = _usersController;
@synthesize userID          = _userID;

@dynamic delegate;

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadUser {
    [self.usersController getUserWithID:self.userID];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadUser];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUsersControllerDelegate

//----------------------------------------------------------------------------------------------------
- (NSInteger)usersResourceID {
    return self.userID;
}

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
    
    [self clean];
    self.objects = [NSMutableArray array];
    
    DWMessage *message  = [[[DWMessage alloc] init] autorelease];
    message.interactive = YES;
    message.content     = [NSString stringWithFormat:@"%@ Team",user.team.name];
    [self.objects addObject:message];
    
    [self.delegate userLoaded:user];
    [user destroy];
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSString*)error {
    NSLog(@"User load error - %@",error);
    [self.delegate displayError:error];
}

@end


