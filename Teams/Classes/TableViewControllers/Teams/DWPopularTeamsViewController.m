//
//  DWPopularTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPopularTeamsViewController.h"
#import "DWPopularTeamsDataSource.h"
#import "DWteam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPopularTeamsViewController

@synthesize popularTeamsDataSource  = _popularTeamsDataSource;
@synthesize teamsViewController     = _teamsViewController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.popularTeamsDataSource = [[[DWPopularTeamsDataSource alloc] init] autorelease];
        
        self.teamsViewController    = [[[DWTeamsViewController alloc] init] autorelease];
        self.teamsViewController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.popularTeamsDataSource     = nil;
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
    return self.popularTeamsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.popularTeamsDataSource loadTeams];
}


@end
