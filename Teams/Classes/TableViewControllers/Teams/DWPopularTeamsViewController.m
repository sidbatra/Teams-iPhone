//
//  DWPopularTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPopularTeamsViewController.h"
#import "DWPopularTeamsDataSource.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPopularTeamsViewController

@synthesize popularTeamsDataSource  = _popularTeamsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.popularTeamsDataSource = [[DWPopularTeamsDataSource alloc] init];
        
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kTeamPresenterStyleEventBased]
                                        forKey:[[DWTeam class] className]];
        
        
        if(&UIApplicationWillEnterForegroundNotification != NULL) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(applicationEnteringForeground:) 
                                                         name:UIApplicationWillEnterForegroundNotification
                                                       object:nil];
        }
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];


    
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)applicationEnteringForeground:(NSNotification*)notification {
    [self.popularTeamsDataSource refreshInitiated];
}


@end
