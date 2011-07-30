//
//  DWNotificationsDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationsDataSource.h"
#import "DWNotification.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationsDataSource

@synthesize notificationsController = _notificationsController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.notificationsController            = [[[DWNotificationsController alloc] init] autorelease];
        self.notificationsController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.notificationsController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)populateNotifications:(NSMutableArray*)notifications {
    
    id lastObject   = [self.objects lastObject];
    BOOL paginate   = NO;
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        paginate = YES;
    }
    
    if(!paginate) {
        [self clean];
        self.objects = notifications;
    }
    else {
        [self.objects removeLastObject];
        [self.objects addObjectsFromArray:notifications];
    }
    
    if([notifications count]) {
        
        _oldestTimestamp            = ((DWNotification*)[notifications lastObject]).createdAtTimestamp;
        
        DWPagination *pagination    = [[[DWPagination alloc] init] autorelease];
        pagination.owner            = self;
        [self.objects addObject:pagination];
    }
    
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadNotifications {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                               andExtraInfo:[NSString stringWithFormat:@"before=%d",
                                                                             (NSInteger)_oldestTimestamp]];
    
    [self.notificationsController getNotificationsForCurrentUserBefore:_oldestTimestamp];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    _oldestTimestamp = 0;
    
    id lastObject   = [self.objects lastObject];
    
    if([lastObject isKindOfClass:[DWPagination class]]) {
        [self.objects removeLastObject];
    }
    
    [self loadNotifications];
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
    [self loadNotifications];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)notificationsLoaded:(NSMutableArray*)notifications {
    [self populateNotifications:notifications];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsError:(NSString*)error {
    NSLog(@"Notifications error - %@",error);
    [self.delegate displayError:error];
}

@end
