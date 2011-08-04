//
//  DWSearchViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchViewController.h"
#import "DWUsersLogicController.h"
#import "DWTeamsLogicController.h"

#import "DWSearchDataSource.h"
#import "DWUser.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchViewController

@synthesize usersLogicController    = _usersLogicController;
@synthesize teamsLogicController    = _teamsLogicController;
@synthesize searchDataSource        = _searchDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.usersLogicController       = [[[DWUsersLogicController alloc] init] autorelease];
        self.usersLogicController.tableViewController = self;
        
        self.teamsLogicController       = [[[DWTeamsLogicController alloc] init] autorelease];
        self.teamsLogicController.tableViewController = self;
        
        self.searchDataSource           = [[[DWSearchDataSource alloc] init] autorelease];
        
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:KUserPresenterStyleFullSignature]
                                        forKey:[[DWUser class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.usersLogicController       = nil;
    self.teamsLogicController       = nil;
    self.searchDataSource           = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate {
    self.usersLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate {
    self.teamsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.searchDataSource;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWTeam class] className]])
        delegate = self.teamsLogicController;
    else if([className isEqualToString:[[DWUser class] className]])
        delegate = self.usersLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)search:(NSString*)query {
    [self resetWithSpinnerHidden:NO];
    [self.searchDataSource loadDataForQuery:query];
}

//----------------------------------------------------------------------------------------------------
- (void)resetWithSpinnerHidden:(BOOL)isSpinning {
    [self.searchDataSource clean];
    [self reloadTableView];
    self.loadingView.hidden = isSpinning;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.view.hidden        = YES;
    self.loadingView.hidden = YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
