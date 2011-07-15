//
//  DWTeamItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamItemsViewController.h"
#import "DWTeamItemsDataSource.h"
#import "DWItem.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamItemsViewController

@synthesize teamItemsDataSource = _teamItemsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithTeam:(DWTeam*)team {
    self =  [super init];
    
    if(self) {
        self.teamItemsDataSource        = [[[DWTeamItemsDataSource alloc] init] autorelease];
        self.teamItemsDataSource.teamID = team.databaseID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleTeamItems]
                                        forKey:[[DWItem class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.teamItemsDataSource = [[[DWTeamItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.teamItemsDataSource  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.teamItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.teamItemsDataSource loadItems];
}

@end
