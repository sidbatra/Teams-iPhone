//
//  DWTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsViewController.h"
#import "DWTeamsLogicController.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsViewController

@synthesize teamsLogicController = _teamsLogicController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.teamsLogicController    = [[DWTeamsLogicController alloc] init];
        self.teamsLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate {
    self.teamsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWTeam class] className]])
        delegate = self.teamsLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}

@end
