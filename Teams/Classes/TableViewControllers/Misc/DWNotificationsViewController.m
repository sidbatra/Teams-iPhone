//
//  DWNotificationsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsViewController.h"
#import "DWNotificationsDataSource.h"
#import "DWPushNotificationsManager.h"
#import "DWNotification.h"
#import "DWUser.h"
#import "DWItem.h"
#import "DWGUIManager.h"
#import "NSObject+Helpers.h"

static NSString* const kTitle               = @"Notifications";
static NSString* const kModelNamePrefix     = @"DW";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsViewController

@synthesize notificationsDataSource = _notificationsDataSource;
@synthesize delegate                = _delegate;


//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.notificationsDataSource    = [[[DWNotificationsDataSource alloc] init] autorelease];

        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageLoaded:) 
													 name:kNImgSmallNotificationLoaded
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    
    self.navigationItem.titleView           = [DWGUIManager navBarTitleViewForText:kTitle];
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];

    [self.notificationsDataSource loadNotifications];
    [[DWPushNotificationsManager sharedDWPushNotificationsManager] resetNotifications]; 
}

//----------------------------------------------------------------------------------------------------
- (void)softRefresh {
    [self.notificationsDataSource refreshInitiated];
    [[DWPushNotificationsManager sharedDWPushNotificationsManager] resetNotifications]; 
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationPresenterDelegate - (implmented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)notificationClicked:(DWNotification*)notification {
    
    NSString *clientClassName = [NSString stringWithFormat:@"%@%@",kModelNamePrefix,notification.resourceType];
    
    if([clientClassName isEqualToString:[DWUser className]]) {
        [self.delegate notificationsUserSelected:notification.resourceID];
    }
    else if([clientClassName isEqualToString:[DWItem className]]) {
        [self.delegate notificationsItemSelected:notification.resourceID];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)imageLoaded:(NSNotification*)notification {
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self provideResourceToVisibleCells:kResourceTypeSmallNotificationImage
                               resource:resource
                             resourceID:resourceID];
}


@end
