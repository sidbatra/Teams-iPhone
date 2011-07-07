//
//  DWSession.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSession.h"
#import "DWMemoryPool.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"

static NSString* const kDiskKeyLastReadItemID   = @"last_read_item_id";
static NSString* const kDiskKeyFirstTimeUser    = @"first_time_user";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSession

@synthesize currentUser				= _currentUser;
@synthesize firstTimeUser           = _firstTimeUser;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWSession);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		[self read];
        [self readFirstTimeUser];
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
    /*
	DWUser *user = [[DWUser alloc] init];
	
	if([user readFromDisk]) {
		self.currentUser = user;
        
        //[[DWMemoryPool sharedDWMemoryPool] setObject:self.currentUser
        //                                       atRow:kMPUsersIndex];
	}
	else {
		[user release];
	}
     */
}

//----------------------------------------------------------------------------------------------------
- (void)create:(DWUser*)newUser {
	self.currentUser = newUser;
	//[self.currentUser saveToDisk];
}

//----------------------------------------------------------------------------------------------------
- (void)destroy {
	//[self.currentUser removeFromDisk];
    
    //[[DWMemoryPool sharedDWMemoryPool] removeObject:self.currentUser
    //                                          atRow:kMPUsersIndex];
	self.currentUser = nil;
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications



@end
