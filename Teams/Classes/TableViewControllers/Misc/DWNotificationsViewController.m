//
//  DWNotificationsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsViewController.h"
#import "DWNotificationsDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsViewController

@synthesize notificationsDataSource = _notificationsDataSource;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.notificationsDataSource    = [[[DWNotificationsDataSource alloc] init] autorelease];

    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.notificationsDataSource    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.notificationsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.notificationsDataSource loadNotifications];
}


@end
