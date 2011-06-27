//
//  DWSession.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSession.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "DWPlace.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"

static NSString* const kDiskKeyLastReadItemID   = @"last_read_item_id";
static NSString* const kDiskKeyFirstTimeUser    = @"first_time_user";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSession

@synthesize currentUser				= _currentUser;
@synthesize location				= _location;
@synthesize launchURL               = _launchURL;
@synthesize firstTimeUser           = _firstTimeUser;
@synthesize lastReadItemID          = _lastReadItemID;
@synthesize selectedTabIndex        = _selectedTabIndex;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWSession);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		[self read];
        [self readLastReadItemID];
        [self readFirstTimeUser];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(newLocationAvailable:) 
													 name:kNNewLocationAvailable 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userLogsIn:) 
													 name:kNUserLogsIn
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(tabSelectionChanged:) 
                                                     name:kNTabSelectionChanged
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingCreated:) 
													 name:kNNewFollowingCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingDestroyed:) 
													 name:kNFollowingDestroyed
												   object:nil];
        
        if (&UIApplicationWillEnterForegroundNotification != NULL) {
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(applicationEnteringForeground:) 
														 name:UIApplicationWillEnterForegroundNotification
													   object:nil];
		}
        
        if (&UIApplicationDidEnterBackgroundNotification != NULL) {
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(applicationEnteringBackground:) 
														 name:UIApplicationDidEnterBackgroundNotification
													   object:nil];
		}
		
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)read {
	DWUser *user = [[DWUser alloc] init];
	
	if([user readFromDisk]) {
		self.currentUser = user;
        
        [[DWMemoryPool sharedDWMemoryPool] setObject:self.currentUser
                                               atRow:kMPUsersIndex];
	}
	else {
		[user release];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)create:(DWUser*)newUser {
	self.currentUser = newUser;
	[self.currentUser saveToDisk];
}

//----------------------------------------------------------------------------------------------------
- (void)destroy {
	[self.currentUser removeFromDisk];
    
    [[DWMemoryPool sharedDWMemoryPool] removeObject:self.currentUser
                                              atRow:kMPUsersIndex];
	self.currentUser = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)readLastReadItemID {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        _lastReadItemID = [standardUserDefaults	integerForKey:kDiskKeyLastReadItemID];
        [standardUserDefaults synchronize];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)updateLastReadItemID:(NSInteger)lastItemID {
    
    _lastReadItemID = lastItemID;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        [standardUserDefaults setInteger:_lastReadItemID 
                                  forKey:kDiskKeyLastReadItemID];
        [standardUserDefaults synchronize];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)readFirstTimeUser {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        _firstTimeUser = ![standardUserDefaults	boolForKey:kDiskKeyFirstTimeUser];
        [standardUserDefaults synchronize];
	}
}

//----------------------------------------------------------------------------------------------------
- (void)updateFirstTimeUser {
    _firstTimeUser = NO;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        [standardUserDefaults setBool:!_firstTimeUser
                                  forKey:kDiskKeyFirstTimeUser];
        [standardUserDefaults synchronize];
	}
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isActive {
	return self.currentUser != nil;
}

//----------------------------------------------------------------------------------------------------
- (BOOL)doesCurrentUserHaveID:(NSInteger)userID {
	return [self isActive] && self.currentUser.databaseID == userID;
}

//----------------------------------------------------------------------------------------------------
- (void)createVisit {
    if ([[DWSession sharedDWSession] isActive])
        [[DWRequestsManager sharedDWRequestsManager] createVisit];
}

//----------------------------------------------------------------------------------------------------
- (void)pushNotificationAndUpdateUserFollowingCountBy:(NSInteger)delta {
    
    [self.currentUser updateFollowingCount:delta];
    [self.currentUser saveFollowingCountToDisk];
    
    NSDictionary *info	= [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:self.currentUser.databaseID]	,kKeyResourceID,
                           nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNUserFollowingCountUpdated
                                                        object:nil
                                                      userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)pushNotificationAndUpdatePlaceFollowersBy:(NSInteger)delta
                                    withPlaceInfo:(NSDictionary*)info {
    
    NSInteger placeID = [[info objectForKey:kKeyResourceID] integerValue];
    
    DWPlace *place = (DWPlace*)[[DWMemoryPool sharedDWMemoryPool] getObject:placeID 
                                                                      atRow:kMPPlacesIndex];
    [place updateFollowerCount:delta];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNPlaceFollowersUpdated
                                                        object:nil
                                                      userInfo:info];
}

//----------------------------------------------------------------------------------------------------
- (void)gotoUnreadItemsMode:(NSInteger)newItemID {
    [self updateLastReadItemID:newItemID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNNewFeedItemsLoaded
                                                        object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)gotoReadItemsMode {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNNewFeedItemsRead
                                                        object:nil];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)newLocationAvailable:(NSNotification*)notification {
	
	//if(!_firstVisitRecorded && [self isActive]) {
		//[self createVisit];
	//	_firstVisitRecorded = YES;
	//}
}

//----------------------------------------------------------------------------------------------------
- (void)userLogsIn:(NSNotification*)notification {
	//_firstVisitRecorded = YES;
	//[self createVisit];
}

//----------------------------------------------------------------------------------------------------
- (void)tabSelectionChanged:(NSNotification*)notification {
	
	NSDictionary *info          = [notification userInfo];
    NSInteger selectedIndex     = [[info objectForKey:kKeySelectedIndex] integerValue];
    
    _selectedTabIndex           = selectedIndex;
}

//----------------------------------------------------------------------------------------------------
- (void)applicationEnteringBackground:(NSNotification*)notification {
    [self createVisit];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationEnteringForeground:(NSNotification*)notification {
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreated:(NSNotification*)notification {
	NSDictionary *info = [notification userInfo];
		
	if([[info objectForKey:kKeyStatus] isEqualToString:kKeySuccess]) {
        [self pushNotificationAndUpdateUserFollowingCountBy:1];
        [self pushNotificationAndUpdatePlaceFollowersBy:1 
                                          withPlaceInfo:info];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyed:(NSNotification*)notification {
	NSDictionary *info = [notification userInfo];
    
	if([[info objectForKey:kKeyStatus] isEqualToString:kKeySuccess]) {
        [self pushNotificationAndUpdateUserFollowingCountBy:-1];
        [self pushNotificationAndUpdatePlaceFollowersBy:-1
                                          withPlaceInfo:info];        
    }
}


@end
