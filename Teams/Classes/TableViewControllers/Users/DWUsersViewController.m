//
//  DWUsersViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersViewController.h"
#import "DWUsersLogicController.h"
#import "DWUser.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersViewController

@synthesize usersLogicController = _usersLogicController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.usersLogicController    = [[[DWUsersLogicController alloc] init] autorelease];
        self.usersLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.usersLogicController        = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate {
    self.usersLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWUser class] className]])
        delegate = self.usersLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
