//
//  DWRecentTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWRecentTeamsViewController.h"
#import "DWRecentTeamsDataSource.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWRecentTeamsViewController

@synthesize recentTeamsDataSource   = _recentTeamsDataSource;
@synthesize teamsViewController     = _teamsViewController;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.recentTeamsDataSource = [[[DWRecentTeamsDataSource alloc] init] autorelease];
        
        self.teamsViewController    = [[[DWTeamsViewController alloc] init] autorelease];
        self.teamsViewController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.recentTeamsDataSource      = nil;
    self.teamsViewController        = nil;

    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setDelegate:(id<DWTeamsViewControllerDelegate>)delegate {
    self.teamsViewController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWTeam class] className]])
        delegate = self.teamsViewController;
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.recentTeamsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.recentTeamsDataSource loadTeams];
}

@end
